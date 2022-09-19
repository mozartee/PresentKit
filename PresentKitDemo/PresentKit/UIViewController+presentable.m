//
//  UIViewController+presentable.m
//  PresentKit
//
//  Created by zengxiang on 2022/6/2.
//

#import "UIViewController+presentable.h"

@implementation UIViewController (presentable)

- (CGFloat)presentedViewHeight {
    return [UIScreen mainScreen].bounds.size.height * 1/2;
}

- (UIColor *)dimColor {
    return [UIColor.blackColor colorWithAlphaComponent:0.7f];
}

- (BOOL)hasDim {
    return YES;
}

- (BOOL)dimEnable {
    return YES;
}

- (BOOL)hasShadow {
    return NO;
}

- (CGFloat)cornerRadius {
    return 10.0f;
}

- (NSTimeInterval)transitionDuration {
    return 0.35;
}

- (BOOL)dropDismissEnable {
    return YES;
}

- (BOOL)slideDismissEnable {
    return YES;
}

- (BOOL)slideToDown {
    return YES;
}

- (BOOL)percentDrivenEnable {
    return NO;
}

@end
