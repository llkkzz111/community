//
//  JZLiveEndViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "JZLiveEndViewController.h"
//#import "JZConstants.h"
@interface JZLiveEndViewController ()

@end

@implementation JZLiveEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播结束";
    self.view.backgroundColor = MAINBACKGROUNDCOLOR;
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"JZ_Btn_back@2x"] forState:0];
    [leftBtn addTarget:self action:@selector(backRootView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *finishButton = [[UIButton alloc] init];
    finishButton.frame = CGRectMake(self.view.frame.size.width/2-50, (self.view.frame.size.height-64-49)/2-50, 100, 100);
    finishButton.backgroundColor = MAINCOLOR;
    [finishButton setTitle:NSLocalizedString(@"JZFinish", nil) forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE52]];
    [finishButton addTarget:self action:@selector(backRootView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
}

- (void)backRootView {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
