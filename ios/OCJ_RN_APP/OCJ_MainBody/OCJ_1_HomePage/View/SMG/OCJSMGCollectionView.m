//
//  OCJSMGCollectionView.m
//  OCJ
//
//  Created by OCJ on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSMGCollectionView.h"
#import "OCJPayCVCell.h"
#import "OCMSMGCVC.h"
#import "OCJSMGTipView.h"
#import "OCJ_VipAreaHttpAPI.h"
#import "OCJSMGLifeCVCell.h"
#import "OCJResponseModel_SMG.h"

@interface OCJSMGCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableDictionary * cellDic;

@end
@implementation OCJSMGCollectionView

static NSString* cellIdentifyFirst = @"OCMSMGCVCIdentifier";
static NSString* cellIdentifySecond = @"OCJSMGLifeCVCellIdentifier";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate   = self;
        self.ocjInt_currentPage = 0;
      
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[OCMSMGCVC class] forCellWithReuseIdentifier:cellIdentifyFirst];
        [self registerClass:[OCJSMGLifeCVCell class] forCellWithReuseIdentifier:cellIdentifySecond];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ocj_dismissSheet)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)ocj_dismissSheet{
    [AppDelegate ocj_dismissKeyboard];//收起键盘
}

- (NSArray *)ocjArr_dataSource{
    if (!_ocjArr_dataSource) {
        _ocjArr_dataSource = [NSArray array];
    }
    return _ocjArr_dataSource;
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset{
    CGFloat itemWidth = 250; //item宽度
    CGFloat extendWidth = 25; //item漏出的宽度
    CGFloat minimumLineSpacing = (SCREEN_WIDTH - itemWidth - extendWidth*2)/2.0;
    
    CGFloat pageSize = SCREEN_WIDTH - minimumLineSpacing - extendWidth*2;
    NSInteger page = roundf(offset.x / pageSize);
    self.ocjInt_currentPage = page;
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

/**
 调用抽奖接口
 */
- (void)ocj_requestLotteryResultWithDictionary:(NSDictionary *)dic {
  [OCJ_VipAreaHttpAPI ocj_SMG_lottoWithUintNo:[dic objectForKey:@"unitNO"] unitPassword:[dic objectForKey:@"unitPwd"] lifeStyle:[dic objectForKey:@"unitRD"] completionHandler:^(OCJBaseResponceModel *responseModel) {
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        NSString *ocjStr_msg;
        NSString *ocjStr_start;
        NSString *ocjStr_end;
        if ([[dic objectForKey:@"unitNO"] isEqualToString:@"A20170413105255"]) {//生活改造家
            NSArray *ocjArr = [responseModel.ocjDic_data objectForKey:@"prizeinfos"];
            ocjStr_start = [responseModel.ocjDic_data objectForKey:@"start_date"];
            ocjStr_end = [responseModel.ocjDic_data objectForKey:@"end_date"];
            ocjStr_msg = [self ocj_dealWithRewardMsgWithArray:ocjArr];
        }else {
            NSString *str = [responseModel.ocjDic_data objectForKey:@"prizeName"];
            ocjStr_start = @"";
            ocjStr_end = @"";
            ocjStr_msg = [NSString stringWithFormat:@"恭喜您获得%@", str];
        }
        [OCJSMGTipView ocj_popRewardWithMessage:ocjStr_msg srartDate:ocjStr_start endDate:ocjStr_end Completion:^(NSDictionary *dic_address) {
      
        }];
    }else{
        [OCJProgressHUD ocj_showAlertByVC:[AppDelegate ocj_getTopViewController] withAlertType:OCJAlertTypeSuccessSendEmail title:@"" message:@"没中奖~ 但开心最重要" sureButtonTitle:@"我知道了" CancelButtonTitle:@"" action:^(NSInteger clickIndex) {
        
        }];
    }
  }];
}

- (NSString *)ocj_dealWithRewardMsgWithArray:(NSArray *)ocjArr {
  NSString *ocjStr_reward;
  NSDictionary *dic = [ocjArr objectAtIndex:0];
  NSString *type = [dic objectForKey:@"prize_type"];
  NSString *typeName = [dic objectForKey:@"prize_type_name"];
  NSString *rewardName = [dic objectForKey:@"prize_name"];
  if (![type isEqualToString:@"D"]) {
    ocjStr_reward = [NSString stringWithFormat:@"恭喜您获得%@%@", rewardName, typeName];
  }else {
    ocjStr_reward = @"再接再厉";
  }
  
  return ocjStr_reward;
}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ocjArr_dataSource.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak OCJSMGCollectionView * weakSelf = self;
  
    OCJResponseModel_SMGListDetail *model = self.ocjArr_dataSource[indexPath.row];
    NSString *ocjStr = model.ocjStr_destinationUrl;
  
    if ([ocjStr isEqualToString:@"A20170413105255"]) {
        OCJSMGLifeCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifySecond forIndexPath:indexPath];
        cell.tag = indexPath.item + 100;
        cell.ocjModel_listModel = model;
        cell.ocj_rewardHandler = ^(NSDictionary *ocjDic) {
            [weakSelf ocj_requestLotteryResultWithDictionary:ocjDic];
        };
        return cell;
    }
  
    OCMSMGCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifyFirst forIndexPath:indexPath];

    cell.tag = indexPath.item + 100;
    cell.ocjModel_listDetail = model;
    cell.ocj_rewardHandler = ^(NSDictionary *ocjDic) {
        [weakSelf ocj_requestLotteryResultWithDictionary:ocjDic];
    };
    return cell;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
    [self ocj_dismissSheet];
}

@end
