//
//  Presentation.m
//  PresentKit
//
//  Created by zengxiang on 2022/6/2.
//

#import "Presentation.h"
#import "DimmingView.h"

typedef NS_ENUM(NSUInteger, PanDirection) {
    none,   //> 默认方向
    horizonal,
    vertical,
};

@interface Presentation ()

@property (nonatomic, strong) UIView *presentationWrapperView;
@property (nonatomic, strong) DimmingView *dimmingView;

// pan 手势滑动方向
@property (nonatomic) PanDirection direction;

@property (nonatomic, weak) id <PresentationDelegate> presentable;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentTransition;

@end

@implementation Presentation

- (DimmingView *)dimmingView {
   if (!_dimmingView) {
       _dimmingView = [[DimmingView alloc] initWithFrame:self.containerView.bounds];
       _dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   }
   return _dimmingView;
}

- (id<PresentationDelegate>)presentable {
   id viewController = (id<PresentationDelegate>)self.presentedViewController;
   if ([viewController isKindOfClass:UINavigationController.class]) {
       id<PresentationDelegate> root = (id<PresentationDelegate>)((UINavigationController *)viewController).topViewController;
       return root;
   }
   return (id <PresentationDelegate>)self.presentedViewController;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
   self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
   if (self) {
       presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
       self.direction = none;
   }
   return self;
}

// 最底层视图，用于过渡中的动画载体，一般指 presented view controller's view. 可自定义
- (UIView *)presentedView {
   return self.presentationWrapperView;
}

#pragma mark - UIPresentationViewControlle func

- (void)presentationTransitionWillBegin {
   
   [self layoutDimmingView];
   [self layoutPresentedView];
   
   id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
   [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
       [self.dimmingView setMax];
   } completion:NULL];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
   if (completed == NO) {
       self.dimmingView = nil;
       self.presentationWrapperView = nil;
   }
}

- (void)dismissalTransitionWillBegin {
   id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
   [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
       [self.dimmingView setOff];
   } completion:NULL];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
   if (completed == YES) {
       self.dimmingView = nil;
       self.presentationWrapperView = nil;
   }
}

#pragma mark - Layer

- (void)layoutDimmingView {
   if (self.presentable.hasDim) {
       self.dimmingView.color = self.presentable.dimColor;
       
       [self.containerView addSubview:self.dimmingView];
       __weak typeof(self) weakSelf = self;
       self.dimmingView.didTap = ^(UIGestureRecognizer * _Nonnull recognizer) {
           if (weakSelf.presentable.dimEnable) {
               [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
           }
       };
   }
}

- (void)layoutPresentedView {
   UIView *presentedViewControllerView = [super presentedView];
   
   UIView *presentationWrapperView = [[UIView alloc] initWithFrame:self.frameOfPresentedViewInContainerView];
   if (self.presentable.hasShadow) {
       presentationWrapperView.layer.shadowOffset = CGSizeMake(0, -3);
       presentationWrapperView.layer.shadowOpacity = 0.3;
   }
   self.presentationWrapperView = presentationWrapperView;
   
   // 圆角视图
   CGFloat cornerRadius = self.presentable.cornerRadius;
   
   UIView *presentationRoundedCornerView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationWrapperView.bounds, UIEdgeInsetsMake(0, 0, -cornerRadius, 0))];
   presentationRoundedCornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   if (cornerRadius > 0.0) {
       presentationRoundedCornerView.layer.cornerRadius = cornerRadius;
       presentationRoundedCornerView.layer.masksToBounds = YES;
   }
   
   presentedViewControllerView.frame = presentationWrapperView.bounds;
   presentedViewControllerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
   [presentationRoundedCornerView addSubview:presentedViewControllerView];
   [presentationWrapperView addSubview:presentationRoundedCornerView];
   
   // UIPanGestureRecognizer
   UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(presentedViewPanned:)];
   [presentedViewControllerView addGestureRecognizer:panGestureRecognizer];
}

// 当 presented view controller's preferredContentSize 改变时，会走此方法
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
   [super preferredContentSizeDidChangeForChildContentContainer:container];
   
   if (container == self.presentedViewController) {
       [self.containerView setNeedsLayout];
   }
}

// 呈现视图的位置，readOnly属性，可返回自定义大小
- (CGRect)frameOfPresentedViewInContainerView {
   CGRect containerViewBounds = self.containerView.bounds;
   CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
   
   CGRect presentedViewControllerFrame = containerViewBounds;
   presentedViewControllerFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height;
   presentedViewControllerFrame.size.height = presentedViewContentSize.height;
   
   return presentedViewControllerFrame;
}

// 返回 presentedViewController size
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
   if (container == self.presentedViewController) {
       return CGSizeMake(CGRectGetWidth(self.containerView.frame), self.presentable.presentedViewHeight);
   }
   return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

- (void)containerViewWillLayoutSubviews {
   [super containerViewWillLayoutSubviews];
   
   self.dimmingView.bounds = self.containerView.bounds;
   
   [UIView animateWithDuration:self.presentable.transitionDuration animations:^{
       self.presentationWrapperView.frame = self.frameOfPresentedViewInContainerView;
   }];
}

#pragma mark - Gesture

- (void)presentedViewPanned:(UIPanGestureRecognizer *)panGestureRecognizer {
   CGPoint offset = [panGestureRecognizer translationInView:self.presentedView];
   
   // 获取滑动百分比
   CGFloat percent;
   if (self.direction == horizonal) {
       percent = offset.x / CGRectGetWidth(panGestureRecognizer.view.bounds);
   }else {
       percent = offset.y / CGRectGetHeight(panGestureRecognizer.view.bounds);
   }
   
   if (self.presentable.percentDrivenEnable) {
       if (!self.presentable.slideDismissEnable) {
           percent = 0.0;
       }
       [self percentDrivenInteractiveTransition:panGestureRecognizer offset:offset percent:percent];
       return;
   }
   
   [self panGestureRecognizer:panGestureRecognizer offset:offset percent:percent];
}

- (void)percentDrivenInteractiveTransition:(UIPanGestureRecognizer *)panGestureRecognizer offset:(CGPoint)offset percent:(CGFloat)percent {
   switch (panGestureRecognizer.state) {
       case UIGestureRecognizerStateBegan:
       {
           [self gestureDirection:offset];
           self.percentTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
           [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
       }
           break;
           
       case UIGestureRecognizerStateChanged:
           [self.percentTransition updateInteractiveTransition:percent];
           break;
           
       case UIGestureRecognizerStateEnded:
       case UIGestureRecognizerStateCancelled:
       {
           if (percent > 0.5) {
               [self.percentTransition finishInteractiveTransition];
           }else {
               [self.percentTransition cancelInteractiveTransition];
           }
           self.percentTransition = nil;
           
           // 重置滑动方向
           self.direction = none;
       }
           
       default:
           break;
   }
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer offset:(CGPoint)offset percent:(CGFloat)percent {
   switch (panGestureRecognizer.state) {
       case UIGestureRecognizerStateBegan:
           [self gestureDirection:offset];
           break;
           
       case UIGestureRecognizerStateChanged:
           [self layoutPresentedViewPosition:offset percent:percent panGestureRecognizer:panGestureRecognizer];
           break;
           
       case UIGestureRecognizerStateEnded:
       case UIGestureRecognizerStateCancelled:
       {
           if (percent > 0.5) {
               [self transitionAnimate];
           }else {
               [self recoverAnimate];
           }
           
           // 重置滑动方向
           self.direction = none;
       }
           
       default:
           break;
   }
}

- (void)gestureDirection:(CGPoint)offset {
   // 如果当前手势没有暂停，则不切换方向
   if (self.direction == none) {
       // 判断当前是横向滑动还是纵向滑动
       CGFloat x = offset.x;
       CGFloat y = offset.y;
       if (x > y) {
           self.direction = horizonal;
       }else {
           self.direction = vertical;
       }
   }
}

- (void)layoutPresentedViewPosition:(CGPoint)offset percent:(CGFloat)percent panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
   CGFloat xPosition = 0;
   CGFloat yPosition = CGRectGetMaxY(self.containerView.frame) - CGRectGetMaxY(panGestureRecognizer.view.frame);

   if (self.direction == horizonal) {
       if (offset.x <= 0) { return; }
       if (!self.presentable.slideDismissEnable) { return; }
       
       if (self.presentable.slideToDown) {
           yPosition += offset.x;
       }else {
           xPosition += offset.x;
       }
   }else {
       if (offset.y <= 0) { return; }
       if (!self.presentable.slideDismissEnable) { return; }

       yPosition += offset.y;
   }
   
   CGRect presentedViewFrame = self.presentedView.frame;
   presentedViewFrame.origin.x = xPosition;
   presentedViewFrame.origin.y = yPosition;
   self.presentedView.frame = presentedViewFrame;
   
   [self.dimmingView setPercent:(1.0 - percent)];
}

// 右滑页面消失的动画
- (void)transitionAnimate {
   // 如果是下滑，则 dismiss
   if (self.direction == vertical) {
       if (!self.presentable.dropDismissEnable) { return; }
       
       [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
       return;
   }

   if (!self.presentable.slideDismissEnable) { return; }

   if (self.presentable.slideToDown) {
       [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
       return;
   }
   
   // 如果是右滑，则 pop 消失
   [UIView animateWithDuration:self.presentable.transitionDuration animations:^{
       CGRect presentedViewFrame = self.presentedView.frame;
       presentedViewFrame.origin.x = CGRectGetWidth(self.presentedView.frame);
       self.presentedView.frame = presentedViewFrame;
       
       [self.dimmingView setOff];
   } completion:^(BOOL finished) {
       // 完成后，需要将页面弹出
       if (finished) {
           [self.presentedViewController dismissViewControllerAnimated:NO completion:NULL];
       }
   }];
}

// presentedView 恢复原本状态
- (void)recoverAnimate {
   [UIView animateWithDuration:self.presentable.transitionDuration animations:^{
       self.presentedView.frame = self.frameOfPresentedViewInContainerView;
       
       [self.dimmingView setMax];
   }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
   return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
   PresentationAnimator *animatedTransitioning = [[PresentationAnimator alloc] initWithType:presentation];
   return animatedTransitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
   PresentationAnimator *animatedTransitioning = [[PresentationAnimator alloc] initWithType:dismissal];
   return animatedTransitioning;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
   return self.percentTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
   return self.percentTransition;
}
@end


@interface PresentationAnimator ()

@property (nonatomic) PresentationAnimatorType type;
@property (nonatomic, weak) id<PresentationDelegate> presentable;

@end

@implementation PresentationAnimator

- (id<PresentationDelegate>)presentationController:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.type == presentation)
        return (id<PresentationDelegate>)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    else
        return (id<PresentationDelegate>)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
}

- (instancetype)initWithType:(PresentationAnimatorType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.presentable = [self presentationController:transitionContext];
    return self.presentable.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    BOOL isPresenting = self.type == presentation;
    
    if (isPresenting) {
        [containerView addSubview:toView];
    }
    
    CGRect __unused fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    if (isPresenting) {
        // 防止动画异常，需要先设置好 to view initial frame
        toViewInitialFrame.origin = CGPointMake(CGRectGetMinX(containerView.frame), CGRectGetMaxY(containerView.bounds));
        toViewInitialFrame.size = toViewFinalFrame.size;
        toView.frame = toViewInitialFrame;
    }else {
        // 此时 presentingView 是 fromView
        fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        if (isPresenting) {
            toView.frame = toViewFinalFrame;
        }else {
            fromView.frame = fromViewFinalFrame;
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
