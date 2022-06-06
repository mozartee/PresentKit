//
//  SecondViewController.h
//  PresentKit
//
//  Created by zengxiang on 2022/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AppType) {
    wechat = 0,
    toutiao,
    zhihu,
    def,
    fullscreen,
};

@interface SecondViewController : UIViewController

@property (nonatomic) AppType appType;

@end

NS_ASSUME_NONNULL_END
