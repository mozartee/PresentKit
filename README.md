# PresentKit

## 自定义 UIPresentationController 实现转场动画
 
![2022-06-02 18.15.54](assets/2022-06-02%2018.15.54.gif)

### 使用方法

```
SecondViewController *viewController = [[SecondViewController alloc] init];
Presentation *presentation = [[Presentation alloc] initWithPresentedViewController:viewController presentingViewController:self];
viewController.transitioningDelegate = presentation;
[self presentViewController:navController animated:YES completion:NULL];
```

### 自定义实现样式
    
```
// 继承 PresentationDelegate，实现可选方法

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

### 支持`CocoaPods`:

```
pod 'PresentKit'
```



