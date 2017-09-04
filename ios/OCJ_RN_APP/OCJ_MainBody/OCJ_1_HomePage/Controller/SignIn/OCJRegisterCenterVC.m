//
//  OCJRegisterCenterVC.m
//  OCJ
//
//  Created by 董克楠 on 9/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRegisterCenterVC.h"
#import "OCJRegisterTableView.h"
#import "OCJRegisterDetailsView.h"
#import "OCJHttp_signInAPI.h"
#import "OCJSignInTipVC.h"
#import "OJCLotteryVC.h"
#import "UITableView+OCJTableView.h"

@interface OCJRegisterCenterVC ()<OCJRegisterDetailsViewDelegate>

@property (nonatomic ,strong) OCJRegisterDetailsView * ocjView_topView;//上部签到信息展示页面

@property (nonatomic ,strong) OCJRegisterTableView * ocjView_dataTableView;//下部展示彩票和礼包的列表view

@property (nonatomic ,strong) OCJRegisterInfoModel * ocjModel_registerInfoModel;//签到信息model

@end

@implementation OCJRegisterCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_creatMainView];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self ocj_upData];
}

-(void)viewWillDisappear:(BOOL)animated
{
     self.navigationController.navigationBarHidden = NO;
}

-(void)ocj_creatMainView
{
    self.ocjView_topView = [[OCJRegisterDetailsView alloc] init];
    self.ocjView_topView.delegate =self;
    [self.view addSubview:self.ocjView_topView];
    [self.ocjView_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(215);
    }];
  
    self.ocjView_dataTableView = [[OCJRegisterTableView alloc] init];
    [self.view addSubview:self.ocjView_dataTableView];
    [self.ocjView_dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.ocjView_topView.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

-(void)ocj_upData
{
    //签到详情数据
    [OCJHttp_signInAPI OCJRegister_getRegisterDetailsSign_fctLoadingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        if (responseModel.ocjStr_code.intValue == 200) {
            self.ocjModel_registerInfoModel = (OCJRegisterInfoModel *)responseModel;
            self.self.ocjView_topView.model = self.ocjModel_registerInfoModel;
        }
    }];
    //  获取彩票信息
    [OCJHttp_signInAPI OCJRegister_getWelfareLotteryInfoCompletionHandler:^(OCJBaseResponceModel *responseModel) {
      if (responseModel.ocjStr_code.intValue == 200) {
        self.ocjView_dataTableView.ocjModel_lotteryModel = (OCJLotteryListModel *)responseModel;
        if (self.ocjView_dataTableView.ocjModel_lotteryModel.ocjArr_lotteryList.count == 0) {
          self.ocjView_dataTableView.ocjTable_dataTableView.ocjDic_NoData = @{@"image":@"img_empty",
                                                                              @"tipStr":@"您还没有记录哦~,我还要孤单多久"};
        }
        self.ocjView_dataTableView.index = 1;
        [self.ocjView_dataTableView.ocjTable_dataTableView reloadData];
      }
    }];
    
    // 获取礼包信息
    [OCJHttp_signInAPI OCJRegister_getWelfareGiftCompletionHandler:^(OCJBaseResponceModel *responseModel) {
      if (responseModel.ocjStr_code.intValue == 200) {
        self.ocjView_dataTableView.ocjModel_giftModel = (OCJGiftListModel *)responseModel;
        if (self.ocjView_dataTableView.ocjModel_giftModel.ocjArr_GiftList.count == 0) {
          self.ocjView_dataTableView.ocjTable_dataTableView.ocjDic_NoData = @{@"image":@"img_empty",
                                                                              @"tipStr":@"您还没有记录哦~,我还要孤单多久"};
        }
        self.ocjView_dataTableView.index = 1;
        [self.ocjView_dataTableView.ocjTable_dataTableView reloadData];
      }
    }];
  
}

/*
 领取15天礼包
 */
-(void)ocj_pushWith15DayLotteryVC{
    __weak typeof(self) weakSelf = self;
    OJCLotteryVC *vc = [[OJCLotteryVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.status = ^(BOOL successOrFail) {
      if (successOrFail) {
        [OCJProgressHUD ocj_showHudWithTitle:@"领取成功" andHideDelay:2];
      }
    };
    [weakSelf presentViewController:vc animated:NO completion:nil];
}

/*
    领取20天礼包
 */
-(void)ocj_pushWith20DayGiftVC
{
    OCJSignInTipVC *oCJSignInTipVC = [[OCJSignInTipVC alloc] init];
    oCJSignInTipVC.signVCType = 20;//签到的类型
    oCJSignInTipVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    oCJSignInTipVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [oCJSignInTipVC setStatus:^(BOOL isYes){
        NSLog(@"%d",isYes);
        if (isYes == YES) {
            //刷新数据
            [self ocj_upData];
        }
    }];
    [self presentViewController:oCJSignInTipVC animated:NO completion:nil];
}

/*
 活动规则
 */
-(void)ocj_pushWithActivityRuleVC
{

}

-(void)ocj_popWithNextVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
