//
//  JZRootViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "JZRootViewController.h"
#import "JZHomeViewController.h"
#import "JZLiveViewController.h"
#import "JZPersonalViewController.h"

@interface JZRootViewController ()

@end

@implementation JZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    JZHomeViewController *home = [[JZHomeViewController alloc] init];
    [self viewController:home title:@"首页" imageNamed:@"homeDefault" selectedImageNamed:@"homeHighlight" barTintColor:MAINCOLOR];
    home.navigationItem.title = @"首页";
    [home.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    home.navigationController.navigationBar.translucent = NO;
    
    JZLiveViewController *live = [[JZLiveViewController alloc] init];
    [self viewController:live title:@"直播" imageNamed:@"liveDefault" selectedImageNamed:@"liveHeighlight" barTintColor:MAINCOLOR];
    live.navigationItem.title = @"直播";
    [live.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    live.navigationController.navigationBar.translucent = NO;
    
    JZPersonalViewController *mine = [[JZPersonalViewController alloc] init];
    [self viewController:mine title:@"我的" imageNamed:@"mineDefault" selectedImageNamed:@"mineHeighlight" barTintColor:MAINCOLOR];
    mine.navigationItem.title = @"我的";
    mine.view.backgroundColor = MAINBACKGROUNDCOLOR;
    [mine.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    mine.navigationController.navigationBar.translucent = NO;
}

-(void)viewController:(UIViewController *)controller title:(NSString *)title imageNamed:(NSString *)imageName selectedImageNamed:(NSString *)selectedImageName barTintColor:(UIColor *)color
{
//    controller.view.backgroundColor = [UIColor whiteColor];
//    controller.title = title;
//    // 设置tabBarItem的普通文字颜色
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = RGB(172, 172, 172, 1);
//    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
//    [controller.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    // 设置tabBarItem的选中文字颜色
//    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
//    selectedTextAttrs[NSForegroundColorAttributeName] = MAINCOLOR;
//    [controller.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
//    //iOS7以后默认会对selectedimage的图片再次渲染为蓝色,若要显示原图就要告诉他不要渲染
//    UIImage *imageN = [UIImage imageNamed:imageName];
//    //声明这张图用原图
//    imageN = [imageN imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    controller.tabBarItem.image = imageN;
//    //controller.tabBarItem.image = [UIImage imageNamed:imageName];
//    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
//    //声明这张图用原图
//    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    controller.tabBarItem.selectedImage = selectedImage;
//    //tabbar背景
//    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    bgView.backgroundColor = [UIColor whiteColor];
//    [self.tabBar insertSubview:bgView atIndex:0];
//    self.tabBar.opaque = YES;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    nav.navigationBar.barTintColor = color;
//    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
