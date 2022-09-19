//
//  PresentationDelegate.h
//  PresentKit
//
//  Created by zengxiang on 2022/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PresentationDelegate <NSObject>

@optional

/// presentedView 高度
@property (nonatomic, readonly) CGFloat presentedViewHeight;
/// dimming view background color
@property (nonatomic, strong, readonly) UIColor *dimColor;
/// 是否显示 dimming view
@property (nonatomic, readonly) BOOL hasDim;
/// 点击dimming view 是否退出，默认YES
@property (nonatomic, readonly) BOOL dimEnable;
/// 是否显示阴影
@property (nonatomic, readonly) BOOL hasShadow;
/// 顶部圆角，默认 10.0
@property (nonatomic, readonly) CGFloat cornerRadius;
/// 动画时长，默认 0.35
@property (nonatomic, readonly) NSTimeInterval transitionDuration;
/// 是否支持手势下滑退出，默认 YES， 若设为 NO，则 其他手势也不会响应
@property (nonatomic, readonly) BOOL dropDismissEnable;
/// 是否支持手势右滑退出，默认 YES
@property (nonatomic, readonly) BOOL slideDismissEnable;
/// 手势右滑是否是向下退出，否则是向右，默认 YES
@property (nonatomic, readonly) BOOL slideToDown;
/// 是否采用 UIPercentDrivenInteractiveTransition 执行手势，否则 UIPanGestureRecognizer，默认否
@property (nonatomic, readonly) BOOL percentDrivenEnable;

@end

NS_ASSUME_NONNULL_END
