//
//  ViewController.m
//  PresentKitDemo
//
//  Created by zengxiang on 2022/6/2.
//

#import "ViewController.h"
#import "Presentation.h"
#import "SecondViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray *)titles {
    return @[@"微信|抖音",
             @"今日头条",
             @"知乎",
             @"通用",
             @"全屏",];
}

- (NSArray *)describe {
    return @[@"使用 UIPanGestureRecognizer 手势处理下滑消失，并支持右滑向下消失",
             @"使用 UIPanGestureRecognizer 手势处理下滑消失，并支持右滑向右消失",
             @"使用 UIPercentDrivenInteractiveTransition 处理下滑，并支持右滑向下消失",
             @"点击背景不消失，并且也没有手势交互",
             @"全屏展示，增加手势弹出",];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self titles].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reusableIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [self titles][indexPath.row];
    cell.detailTextLabel.text = [self describe][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SecondViewController *viewController = [[SecondViewController alloc] init];
    viewController.appType = indexPath.row;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    Presentation *presentation = [[Presentation alloc] initWithPresentedViewController:navController presentingViewController:self];
    navController.transitioningDelegate = presentation;

    [self presentViewController:navController animated:YES completion:NULL];
}


@end
