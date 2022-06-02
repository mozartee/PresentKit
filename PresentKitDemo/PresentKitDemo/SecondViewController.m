//
//  SecondViewController.m
//  PresentKit
//
//  Created by zengxiang on 2022/6/2.
//

#import "SecondViewController.h"
#import "PresentKit/PresentationDelegate.h"

@interface SecondViewController () <PresentationDelegate>

@end

@implementation SecondViewController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    
    UIImage *image = [UIImage imageNamed:@"image"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.tag = 2;
    [self.view addSubview:imageView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIView *imageView = [self.view viewWithTag:2];
    imageView.center = self.view.center;
}

- (void)dismiss { [self dismissViewControllerAnimated:YES completion:NULL]; }

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

@end
