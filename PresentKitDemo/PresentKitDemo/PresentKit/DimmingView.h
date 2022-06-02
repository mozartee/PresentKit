//
//  DimmingView.h
//  PresentKit
//
//  Created by zengxiang on 2022/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^didTapBlock)(UIGestureRecognizer *recognizer);

@interface DimmingView : UIView

@property (nonatomic, copy) didTapBlock didTap;

/// backgroundColor 默认是：[[UIColor blackColor] colorWithAlphaComponent:0.7]
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithColor:(UIColor *)color ;

// 更新 alpha
- (void)setOff;
- (void)setMax;
- (void)setPercent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
