//
//  Presentation.h
//  PresentKit
//
//  Created by zengxiang on 2022/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Presentation : UIPresentationController  <UIViewControllerTransitioningDelegate>

@end


typedef NS_ENUM(NSUInteger, PresentationAnimatorType) {
    presentation,
    dismissal,
};

@interface PresentationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithType:(PresentationAnimatorType)type;

@end

NS_ASSUME_NONNULL_END
