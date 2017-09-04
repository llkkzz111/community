//
//  JZLiveViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//
#import "JZLiveViewController.h"
#import "JZPushViewController.h"
#import <JZLiveSDK/JZLiveSDK.h>

#import "JZPersonalViewController.h"
#import "JZTools.h"
static  NSString* const ALI_RECORD_HEADER=@"flive.51star.com";
static  NSString* const ALI_VIDEO_PACKAGE=@"livevideo";
@interface JZLiveViewController ()
@property (nonatomic, strong) JZCustomer *host;
@end

@implementation JZLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *pushLiveVideoButton = [[UIButton alloc] init];
    pushLiveVideoButton.frame = CGRectMake(self.view.frame.size.width/2-60, (self.view.frame.size.height-64-49)/2-85, 120, 50);
    pushLiveVideoButton.backgroundColor = RGB(227, 40, 98, 1);
    pushLiveVideoButton.tag = 10000;
    [pushLiveVideoButton setTitle:@"首次横屏推流" forState:UIControlStateNormal];
    [pushLiveVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushLiveVideoButton.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE4445]];
    [pushLiveVideoButton addTarget:self action:@selector(pushLiveVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushLiveVideoButton];
    
    
    UIButton *pushLiveVideoButton2 = [[UIButton alloc] init];
    pushLiveVideoButton2.tag = 10001;
    pushLiveVideoButton2.frame = CGRectMake(self.view.frame.size.width/2-60, CGRectGetMaxY(pushLiveVideoButton.frame)+10, 120, 50);
    pushLiveVideoButton2.backgroundColor = RGB(227, 40, 98, 1);
    [pushLiveVideoButton2 setTitle:@"首次竖屏推流" forState:UIControlStateNormal];
    [pushLiveVideoButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushLiveVideoButton2.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE4445]];
    [pushLiveVideoButton2 addTarget:self action:@selector(pushLiveVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushLiveVideoButton2];
    
    UIButton *continuePushLiveVideoButton = [[UIButton alloc] init];
    continuePushLiveVideoButton.frame = CGRectMake(self.view.frame.size.width/2-60, CGRectGetMaxY(pushLiveVideoButton2.frame)+10, 120, 50);
    continuePushLiveVideoButton.backgroundColor = RGB(227, 40, 98, 1);
    [continuePushLiveVideoButton setTitle:@"继续上次推流" forState:UIControlStateNormal];
    [continuePushLiveVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [continuePushLiveVideoButton.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE4445 ]];
    [continuePushLiveVideoButton addTarget:self action:@selector(continuePushLiveVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continuePushLiveVideoButton];
    self.host = [JZCustomer getUserdataInstance];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.view.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.view.hidden = YES;
}
- (void)pushLiveVideo:(UIButton *)button {
    if ([JZGeneralApi getLoginStatus]) {
        button.enabled = NO;
        NSDictionary * getUserInfo = @{@"hostID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],
                                       @"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],
                                       @"accountType":@"ios",
                                       @"start":@"0",
                                       @"offset":@"50",
                                       @"isTester":[NSString stringWithFormat:@"%ld",(long)1]};
        [JZGeneralApi getDetailUserBlock:getUserInfo getDetailBlock:^(JZCustomer *user, NSArray *records, NSInteger allcounts, NSError *error) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"png"];
            //生成roomid 随机10位
            NSString *roomNo = [JZTools getRandomStringNum:10];
            NSString *stream = [NSString stringWithFormat:@"%@%@",@"13185286687",roomNo];
            NSDate *date = [NSDate date];//获取当前时间
            NSTimeInterval timeStamp= [date timeIntervalSince1970];
            NSString *selectTimeStr = [NSString stringWithFormat:@"%f",timeStamp];
            /*!
             * param videoDirection   设置录播视频方向0是横屏,1为竖屏
             * param action  insert or update
             * param id  可选，action是insert时 需不要传入，action 是update时 必须传入，id是活动的唯一id
             * param userID  主播用户的id
             * param iconURL  活动封面 主页
             * param title   主题
             * param content 活动内容
             * param stream 流名称 生成逻辑=手机号+roomNo
             * param app 固定值
             * param domain 固定值
             * param roomNo  十位随机数字
             * param planStartTime 开始时间  整数 秒为单位
             * param activityType 活动类型 0 公开 1 付费 2 密码查看
             * param payFee 付费的金额
             * param code  密码
             * param shopEnable 是否提供购物
             * param wenjuanEnable 是否提供问卷调查
             * param baibanEnable  是否提供白板
             * param type  类型如电商,运动,教育等(getActivityCategoryWithBlock获取类型)
             */
            NSDictionary *test = @{@"videoDirection":button.tag==10000 ? @"0" : @"1",
                                   @"action":@"insert",
                                   @"id":@"0",
                                   @"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],
                                   @"iconURL":path,
                                   @"title":[NSString stringWithFormat:@"%@%@",@"测试",roomNo],
                                   @"content":@"测试直播",
                                   @"stream":stream,
                                   @"app":@"livevideo",
                                   @"domain":ALI_RECORD_HEADER,
                                   @"roomNo":roomNo,
                                   @"planStartTime":selectTimeStr,
                                   @"activityType":@"0",
                                   @"payFee":@"0",
                                   @"code":@"0",
                                   @"shopEnable":@"0",
                                   @"wenjuanEnable":@"0",
                                   @"baibanEnable":@"0",
                                   @"type":@"电商",
                                   @"isTest":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].isTester]};
            [JZGeneralApi uploadActivityImageToServer:path mParams:test completeHandler:^(NSInteger activityID, NSError *error) {
                if (error) {
                    [JZTools showMessage:@"获取数据失败"];
                }else{
                    JZLiveRecord *record1 = [[JZLiveRecord alloc] init];
                    record1.videoDirection = button.tag==10000 ? 0 : 1;
                    record1.activityID = activityID;
                    record1.userID = [JZCustomer getUserdataInstance].id;
                    record1.iconURL = path;
                    record1.title = @"测试";
                    record1.content = @"测试直播";
                    record1.stream = stream;
                    record1.app = ALI_VIDEO_PACKAGE;
                    //record1.domain = ALI_RECORD_HEADER;
                    record1.roomNo = roomNo;
                    record1.planStartTime = timeStamp;
                    record1.activityType = 0;
                    record1.payFee = 0;
                    record1.code = 0;
                    record1.shopEnable = 0;
                    record1.wenjuanEnable = 0;
                    record1.baibanEnable = 0;
                    record1.type = 0;
                    JZPushViewController *pushVC = [[JZPushViewController alloc] init];
                    pushVC.record = record1;
                    pushVC.user = user;
                    [self.navigationController pushViewController:pushVC animated:YES];
                }
                button.enabled = YES;
            }];
        }];
    }else {
        [self loginAccount];
    }
    
}
- (void)continuePushLiveVideo:(UIButton *)button {
    if ([JZGeneralApi getLoginStatus]) {
        button.enabled = NO;
        NSDictionary * getUserInfo = @{@"hostID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],
                                       @"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],
                                       @"accountType":@"ios",
                                       @"start":@"0",
                                       @"offset":@"50",
                                       @"isTester":[NSString stringWithFormat:@"%ld",(long)1]};
        //获取将要观看的用户信息和活动信息
        [JZGeneralApi getDetailUserBlock:getUserInfo getDetailBlock:^(JZCustomer *user, NSArray *records, NSInteger allcounts, NSError *error) {
            if (error) {
                [JZTools showMessage:@"获取数据失败"];
            } else {
                JZLiveRecord *record = records[0];
                JZPushViewController *pushVC = [[JZPushViewController alloc] init];
                pushVC.record = record;
                pushVC.user = user;
                [self.navigationController pushViewController:pushVC animated:YES];
            }
            button.enabled = YES;
        }];
    }else {
        [self loginAccount];
    }
}
//提醒登录
- (void)loginAccount {
    //    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"JZPrompt", nil) message:(NSLocalizedString(@"JZNotLoggedIn", nil)) delegate:self cancelButtonTitle:(NSLocalizedString(@"JZCancel", nil)) otherButtonTitles:(NSLocalizedString(@"JZOk", nil)), nil];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"您尚未登录账号,请您前去登录账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setTag:loginTag1];
    [alert show];
}
//alertview代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == loginTag1) {
        if (buttonIndex == 0) {
            nil;
        }else if (buttonIndex == 1) {
            //去登陆
            JZPersonalViewController *vc = [[JZPersonalViewController alloc]init];
            [vc setRedirect1Block:^(BOOL flag, NSError *error) {
                if (flag)
                {
                    [self.navigationController popToViewController:self animated:YES];
                }
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
