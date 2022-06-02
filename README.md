# PresentKit

## 自定义 UIPresentationController 实现转场动画
 
![2022-06-02 18.15.54](assets/2022-06-02%2018.15.54.gif)

###  使用方法
```
// 继承 PresentationDelegate，实现可选方法

#pragma mark - PresentationDelegate

- (CGFloat)presentedViewHeight {
    if (self.appType == fullscreen) {
        return [UIScreen mainScreen].bounds.size.height;
    }
    if (self.appType == def) {
        return [UIScreen mainScreen].bounds.size.height * 1/2;
    }
    return [UIScreen mainScreen].bounds.size.height - 88;
}

- (BOOL)dimEnable{
    return self.appType != def;
}

- (BOOL)slideDismissEnable {
    return self.appType != def;
}

- (BOOL)slideToDown {
    if (self.appType == toutiao) return NO;
    return YES;
}

- (BOOL)percentDrivenEnable {
    if (self.appType == zhihu) return YES;
    return NO;
}

```

### 所有可选方法：
```
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
/// 顶部圆角，默认 16.0
@property (nonatomic, readonly) CGFloat cornerRadius;
/// 动画时长，默认 0.35
@property (nonatomic, readonly) NSTimeInterval transitionDuration;
/// 是否支持手势下滑退出，默认 YES
@property (nonatomic, readonly) BOOL dropDismissEnable;
/// 是否支持手势右滑退出，默认 YES
@property (nonatomic, readonly) BOOL slideDismissEnable;
/// 手势右滑是否是向下退出，否则是向右，默认 YES
@property (nonatomic, readonly) BOOL slideToDown;
/// 是否采用 UIPercentDrivenInteractiveTransition 执行手势，否则 UIPanGestureRecognizer，默认否
@property (nonatomic, readonly) BOOL percentDrivenEnable;

```