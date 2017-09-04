//
//  OCJVideoComingVC.m
//  OCJ
//
//  Created by Ray on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVideoComingVC.h"
#import "OCJVideoLiveView.h"
#import "OCJVideoComingTVCell.h"
#import "OCJMoreRecomScrollView.h"
#import "OCJMoreVideoTVCell.h"
#import <AVFoundation/AVFoundation.h>
#import "OCJHttp_videoLiveAPI.h"
#import "OCJResponseModel_videoLive.h"
#import "MJRefresh.h"
#import "OCJChooseGoodsSpecView.h"
#import "AppDelegate.h"
#import "OCJVideoDetailCommonTVCell.h"
#import <AFNetworking.h>
#import "OCJSubMoreVideoTVCell.h"

@interface OCJVideoComingVC ()<UITableViewDelegate, UITableViewDataSource, OCJVideoComingTVCellDelegate, OCJMoreRecomScrollViewDelegate, OCJVideoComingTVCellDelegate, OCJVideoDetailCommonTVCellDelegate>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_video;///<tableView

@property (nonatomic, assign) NSInteger ocjInt_page;             ///< 页码

@property (nonatomic, strong) NSIndexPath *ocjIndexpath;         ///<
@property (nonatomic, strong) OCJVideoLiveView *liveView;        ///< 播放视频的view
@property (nonatomic, strong) UIImageView *ocjImageView_videoEmpty;        ///< 播放地址为空的时候的缺省视图
@property (nonatomic, assign) CGFloat ocjFloat_headerHeight;     ///< tableViewHeader高度
@property (nonatomic, strong) NSMutableArray *ocjArr_dataSource; ///< 数据源
@property (nonatomic, strong) OCJResponceModel_VideoDetailDesc *ocjModel_desc;
@property (nonatomic, strong) NSMutableArray *ocjArr_goods;      ///< 播放视频下方第一个section数据
@property (nonatomic, strong) NSMutableArray *ocjArr_moreVideo;  ///< 更多视频数据
@property (nonatomic, assign) NSInteger ocjInt_pageSize;         ///< 每页多少数据

@property (nonatomic, strong) NSString *ocjStr_videoStatus;      ///< 视频状态
@property (nonatomic, strong) UILabel *ocjLab_countdown;         ///< 倒计时label
@property (nonatomic, strong) NSTimer *ocjTimer_count;           ///< 计时器
@property (nonatomic, assign) NSInteger ocjInt_countTime;        ///< 倒计时

@property (nonatomic, strong) UIButton *ocjBtn_cart;             ///< 进入购物车按钮
@property (nonatomic, strong) UILabel *ocjLab_cartNum;           ///< 购物车数量

@property (nonatomic, strong) NSString *ocjStr_contentCode;      ///< 视频ID
@property (nonatomic, strong) NSString *ocjStr_videoUrl;         ///< 视频播放地址
@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;        ///< 状态栏颜色

@property (nonatomic,copy) NSString* ocjStr_rn_fromPage;  ///< 跳到视频详情的页面，供RN判断来源使用

@end

@implementation OCJVideoComingVC
#pragma mark - 接口方法实现区域（包括setter、getter方法）
- (NSMutableArray *)ocjArr_dataSource {
    if (!_ocjArr_dataSource) {
        _ocjArr_dataSource = [[NSMutableArray alloc] init];
    }
    return _ocjArr_dataSource;
}

- (NSMutableArray *)ocjArr_goods {
    if (!_ocjArr_goods) {
        _ocjArr_goods = [[NSMutableArray alloc] init];
    }
    return _ocjArr_goods;
}

- (NSMutableArray *)ocjArr_moreVideo {
    if (!_ocjArr_moreVideo) {
        _ocjArr_moreVideo = [[NSMutableArray alloc] init];
    }
    return _ocjArr_moreVideo;
}

-(void)setOcjDic_router:(NSDictionary *)ocjDic_router{
  _ocjDic_router = ocjDic_router;
  
  if ([ocjDic_router isKindOfClass:[NSDictionary class]]) {
    self.ocjStr_rn_fromPage = @"";
    NSString* rn_fromPage = [ocjDic_router[@"fromPage"]description];
    if (rn_fromPage.length>0) {
       self.ocjStr_rn_fromPage = rn_fromPage;
    }
    
  }
  
}

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [self ocj_addLiveView];
  if (self.ocjTBView_video) {
    [self ocj_requestCompletion:nil];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
    self.ocjStr_trackPageID = @"AP1706A048";
    [self ocj_monitorNetworkStatus];//检测设备网络状态
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
  
    self.ocjStr_contentCode = [self.ocjDic_router objectForKey:@"id"];
  
    self.ocjFloat_headerHeight = 0;
    self.ocjInt_pageSize = 20;
  
    [self ocj_addTableView];
    [self ocj_addCartBtn];
    [self ocj_requestCartNum];
//    [self ocj_requestCompletion:nil];
  
    [self.ocjTBView_video registerClass:[OCJVideoComingTVCell class] forCellReuseIdentifier:@"OCJVideoComingTVCellIdentifier"];
    [self.ocjTBView_video registerClass:[OCJVideoDetailCommonTVCell class] forCellReuseIdentifier:@"OCJVideoDetailCommonTVCellIdentifier"];
    [self.ocjTBView_video registerClass:[OCJMoreVideoTVCell class] forCellReuseIdentifier:@"OCJMoreVideoTVCellIdentifier"];
    [self.ocjTBView_video registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellIdentifier"];
    [self.ocjTBView_video registerClass:[OCJSubMoreVideoTVCell class] forCellReuseIdentifier:@"OCJSubMoreVideoTVCellIdentifier"];
}

/**
 请求视频详情数据
 */
- (void)ocj_requestCompletion:(void(^)())completion {
  //AP1706A048
    [OCJHttp_videoLiveAPI OCJVideoLive_getVideoLiveDetailWithID:@"AP1706A048" contentCode:self.ocjStr_contentCode completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJResponceModel_VideoLive *model = (OCJResponceModel_VideoLive *)responseModel;
        self.ocjArr_goods = [[NSMutableArray alloc] init];
        self.ocjArr_dataSource = [[NSMutableArray alloc] init];
        if ([model.ocjStr_code isEqualToString:@"200"]) {
            NSArray *tempArr = model.ocjArr_detailList;
            [self.ocjArr_dataSource addObjectsFromArray:tempArr];
            //取视频播放区数据
            NSMutableArray *ocjArr_header = [[NSMutableArray alloc] init];
            self.ocjModel_desc = [[OCJResponceModel_VideoDetailDesc alloc] init];
          
            if (self.ocjArr_dataSource.count > 0) {
              
                OCJResponceModel_VideoDetailList *model = [self.ocjArr_dataSource objectAtIndex:0];
                if ([model.ocjStr_shortNum isEqualToString:@"0"] && [model.ocjStr_packageid isEqualToString:@"36"]) {
                    NSArray *listArr = model.ocjArr_listDesc;
                    [ocjArr_header addObjectsFromArray:listArr];
                    self.ocjModel_desc = [ocjArr_header objectAtIndex:0];
                  
                    //视频数据
                    self.title = self.ocjModel_desc.ocjStr_title;
                    self.ocjStr_videoStatus = self.ocjModel_desc.ocjStr_videoStatus;
                    self.ocjStr_videoUrl = self.ocjModel_desc.ocjStr_videoUrl;
                  
                    if (self.ocjModel_desc.ocjStr_videoUrl.length>0 || [self.ocjStr_videoStatus isEqualToString:@"2"]) {//视频地址不为空、或者视频为即将播出
                    
                      self.liveView.ocjStr_status = self.ocjStr_videoStatus;
                      self.liveView.ocjUrl_video = [NSURL URLWithString:self.ocjStr_videoUrl];
                      self.liveView.ocjModel_desc = self.ocjModel_desc;
                      self.liveView.ocjStr_firstImage = self.ocjModel_desc.ocjStr_firstImgUrl;
                      self.liveView.ocjStr_contentCode = self.ocjStr_contentCode;
                    }else {//视频地址为空
                      [self ocj_addEmptyViewWithImage:self.ocjModel_desc.ocjStr_firstImgUrl];
                    }
                  }
              
                  //商品区数据
                  OCJResponceModel_VideoDetailList *modelFirst = [self.ocjArr_dataSource objectAtIndex:0];
//                if ([modelFirst.ocjStr_shortNum isEqualToString:@"1"] && [modelFirst.ocjStr_packageid isEqualToString:@"37"]) {
                    NSArray *listArr = modelFirst.ocjArr_listDesc;
                    OCJResponceModel_VideoDetailDesc *modelDesc = listArr[0];
                    NSArray *tempArr = modelDesc.ocjArr_detailDesc;
                    [self.ocjArr_goods addObjectsFromArray:tempArr];
//                }
              //更多视频区数据
              OCJResponceModel_VideoDetailList *modelThird = [self.ocjArr_dataSource objectAtIndex:3];
              NSArray *listArr2 = modelThird.ocjArr_listDesc;
              OCJResponceModel_VideoDetailDesc *modelThird2 = listArr2[0];
              self.ocjArr_moreVideo = modelThird2.ocjArr_detailDesc;
              self.ocjInt_countTime = ([self.ocjModel_desc.ocjStr_playTime integerValue] - [self.ocjModel_desc.ocjStr_currentTime integerValue]) / 1000;
              
            }
          
          
            if ([self.ocjStr_videoStatus isEqualToString:@"2"]) {//即将播出
                //添加计时器
                self.ocjTimer_count = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ocj_isCountDown:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.ocjTimer_count forMode:NSRunLoopCommonModes];
            }else if ([self.ocjStr_videoStatus isEqualToString:@"1"]) {//正在直播

            }else {//精彩回放

            }
          
            if (self.ocjArr_dataSource.count > 3) {
                OCJResponceModel_VideoDetailList *modelThird = [self.ocjArr_dataSource objectAtIndex:3];
                if ([modelThird.ocjStr_shortNum isEqualToString:@"3"] && [modelThird.ocjStr_packageid isEqualToString:@"41"]) {
                    NSArray *listArr = modelThird.ocjArr_listDesc;
                    OCJResponceModel_VideoDetailDesc *model = listArr[0];
                    self.ocjArr_moreVideo = model.ocjArr_detailDesc;
                }
            }
          
            [self.ocjTBView_video reloadData];
        }
    }];
}

/**
 请求更多视频数据
 */
- (void)ocj_requestMoreVideoCompletion:(void(^)())completion {
    OCJResponceModel_VideoDetailDesc *model1;
    if (self.ocjArr_moreVideo.count > 0) {
        model1 = self.ocjArr_moreVideo[0];
    }
    
    //6277718264386682880
    [OCJHttp_videoLiveAPI OCJVideoLive_getMoreVideoWithID:model1.ocjStr_id pageNum:self.ocjInt_page pageSize:@"" completionhandler:^(OCJBaseResponceModel *responseModel) {
        OCJResponceModel_MoreVideo *model = (OCJResponceModel_MoreVideo *)responseModel;
        
        NSArray *tempArr = model.ocjArr_list;
      
        NSInteger moreCount = self.ocjArr_moreVideo.count % self.ocjInt_pageSize;//不满页数据的数量
        
        if (moreCount == 0) {
            [self.ocjArr_moreVideo addObjectsFromArray:tempArr];
        }else {
            [self.ocjArr_moreVideo replaceObjectsInRange:NSMakeRange((self.ocjInt_page - 1)*self.ocjInt_pageSize, moreCount) withObjectsFromArray:tempArr];
        }
        
        if (tempArr.count == self.ocjInt_pageSize) {
            self.ocjInt_page++;//下一页
        }
      
        [self.ocjTBView_video reloadData];
      
        if (completion) {
            completion();
        }
    }];
}

/**
 请求购物车数量
 */
- (void)ocj_requestCartNum {
  [OCJHttp_videoLiveAPI OCJVideoLive_getCartNumCompletionHandler:^(OCJBaseResponceModel *responseModel) {
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      NSString *cartNum = [responseModel.ocjDic_data objectForKey:@"carts_num"];
      if ([cartNum integerValue] > 99) {
        self.ocjLab_cartNum.text = @"99+";
      }else {
        self.ocjLab_cartNum.text = [NSString stringWithFormat:@"%ld", (long)[cartNum integerValue]];
      }
    }
  }];
}

/**
 视频播放控件
 */
- (void)ocj_addLiveView {
  self.liveView = [[OCJVideoLiveView alloc] initWithFrame:CGRectZero tableView:nil indexPath:nil];
  
  [self.view addSubview:self.liveView];
  [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.right.mas_equalTo(self.view);
    make.height.mas_equalTo(SCREEN_WIDTH * 9 / 16.0);
  }];
}


/**
 当视频为空时
 */
- (void)ocj_addEmptyViewWithImage:(NSString*)imageUrl{
  self.ocjImageView_videoEmpty = [[UIImageView alloc]init];
  [self.ocjImageView_videoEmpty ocj_setWebImageWithURLString:imageUrl completion:nil];
  self.ocjImageView_videoEmpty.backgroundColor = [UIColor blackColor];
  [self.view addSubview:self.ocjImageView_videoEmpty];
  [self.ocjImageView_videoEmpty mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.right.mas_equalTo(self.view);
    make.height.mas_equalTo(SCREEN_WIDTH * 9 / 16.0);
  }];
  
  UIView* overView = [[UIView alloc]init];
  overView.backgroundColor = [UIColor blackColor];
  overView.alpha = 0.6;
  [self.ocjImageView_videoEmpty addSubview:overView];
  [overView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(self.ocjImageView_videoEmpty);
  }];
  
  UIImageView* imageView = [[UIImageView alloc]init];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.image = [UIImage imageNamed:@"video_emptyIcon"];
  [overView addSubview:imageView];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(overView);
    make.height.width.mas_equalTo(@41);
  }];
  
  UIImageView* imageViewBG = [[UIImageView alloc]init];
  imageViewBG.contentMode = UIViewContentModeScaleAspectFit;
  imageViewBG.image = [UIImage imageNamed:@"video_emptyIconBG"];
  [overView addSubview:imageViewBG];
  [imageViewBG mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(overView);
    make.height.width.mas_equalTo(@55);
  }];
  
  CABasicAnimation* rotationAnimation;
  rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
  rotationAnimation.duration = 1;
  rotationAnimation.cumulative = YES;
  rotationAnimation.repeatCount = MAXFLOAT;
  [imageViewBG.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
  
  UILabel* label = [[UILabel alloc]init];
  label.text = @"视频火爆到不行，先看看别的吧";
  label.font = [UIFont boldSystemFontOfSize:12];
  label.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
  label.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
  label.textAlignment = NSTextAlignmentCenter;
  [overView addSubview:label];
  [label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(imageViewBG.mas_bottom);
    make.left.right.mas_equalTo(overView);
    make.height.mas_equalTo(@30);
  }];
  
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView_video = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.ocjTBView_video.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    self.ocjTBView_video.delegate = self;
    self.ocjTBView_video.dataSource = self;
    self.ocjTBView_video.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_video];
  [self.ocjTBView_video mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.mas_equalTo(self.view);
    make.top.mas_equalTo(self.view.mas_top).offset(SCREEN_WIDTH * 9 / 16.0);
  }];
    
    //上拉加载更多视频
    [self.ocjTBView_video ocj_footRefreshing];
    
    self.ocjInt_page = 2;
    
    __weak OCJVideoComingVC *weakSelf = self;
    
    self.ocjTBView_video.ocjBlock_footerRefreshing = ^{
        OCJLog(@"上拉加载");
        
        [weakSelf ocj_requestMoreVideoCompletion:^{
            BOOL isHaveMoreData = (weakSelf.ocjArr_moreVideo.count%weakSelf.ocjInt_pageSize==0);
            [weakSelf.ocjTBView_video ocj_endFooterRefreshingWithIsHaveMoreData:isHaveMoreData];
        }];
    };
}
//进入购物车按钮
- (void)ocj_addCartBtn {
  //按钮
  self.ocjBtn_cart = [[UIButton alloc] init];
  [self.ocjBtn_cart setBackgroundImage:[UIImage imageNamed:@"Icon_cart"] forState:UIControlStateNormal];
  [self.ocjBtn_cart addTarget:self action:@selector(ocj_gotoCart) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.ocjBtn_cart];
  [self.ocjBtn_cart mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.view.mas_right).offset(-20);
    make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-40);
    make.width.mas_equalTo(@40);
    make.height.mas_equalTo(@40);
  }];
  //数量
  self.ocjLab_cartNum = [[UILabel alloc] init];
  self.ocjLab_cartNum.text = @"0";
  self.ocjLab_cartNum.textColor = OCJ_COLOR_BACKGROUND;
  self.ocjLab_cartNum.backgroundColor = [UIColor redColor];
  self.ocjLab_cartNum.textAlignment = NSTextAlignmentCenter;
  self.ocjLab_cartNum.font = [UIFont systemFontOfSize:7];
  self.ocjLab_cartNum.layer.cornerRadius = 8;
  self.ocjLab_cartNum.layer.masksToBounds = YES;
  [self.ocjBtn_cart addSubview:self.ocjLab_cartNum];
  [self.ocjLab_cartNum mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjBtn_cart.mas_right).offset(1);
    make.top.mas_equalTo(self.ocjBtn_cart.mas_top).offset(2);
    make.width.height.mas_equalTo(@16);
  }];
}

/**
 视频下方sectionHeader(视频描述)
 */
- (UIView *)ocj_addSectionHeadView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headerView.backgroundColor = OCJ_COLOR_BACKGROUND;
    
    UIView *ocjView_top = [[UIView alloc] init];
    ocjView_top.backgroundColor = OCJ_COLOR_BACKGROUND;
    [headerView addSubview:ocjView_top];
    [ocjView_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(headerView);
        make.height.mas_equalTo(@35);
    }];
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [ocjView_top addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(ocjView_top);
        make.height.mas_equalTo(@0.5);
    }];
    //title
    OCJBaseLabel *ocjLab_title = [[OCJBaseLabel alloc] init];
    ocjLab_title.text = [NSString stringWithFormat:@"%@", self.ocjModel_desc.ocjStr_title];
    ocjLab_title.font = [UIFont systemFontOfSize:12];
    ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [ocjView_top addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ocjView_top);
        make.left.mas_equalTo(ocjView_top.mas_left).offset(15);
      make.right.mas_equalTo(ocjView_top.mas_right).offset(-15);
    }];
  
    //添加标签 最新设计图上没有，暂时隐藏
//    [self ocj_addLabelTagsWithArray:self.ocjModel_desc.ocjArr_labelName view:headerView label:ocjLab_title];
  
    //视频描述
    UILabel *ocjLab_desc = [[UILabel alloc] init];
    ocjLab_desc.backgroundColor = OCJ_COLOR_BACKGROUND;
    ocjLab_desc.text = [NSString stringWithFormat:@"%@", self.ocjModel_desc.ocjStr_description];
    ocjLab_desc.font = [UIFont systemFontOfSize:12];
    ocjLab_desc.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_desc.textAlignment = NSTextAlignmentLeft;
    ocjLab_desc.numberOfLines = 0;
    [headerView addSubview:ocjLab_desc];
    [ocjLab_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(15);
        make.right.mas_equalTo(headerView.mas_right).offset(-15);
        make.top.mas_equalTo(ocjView_top.mas_bottom).offset(5);
    }];
  
  if ([self.ocjStr_videoStatus isEqualToString:@"2"]) {
    [self ocj_addGameAndCountDownViewWithLabel:ocjLab_desc view:headerView];
  }
  
    
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.ocjFloat_headerHeight);
    
    return headerView;
}

/**
 添加标签
 */
- (void)ocj_addLabelTagsWithArray:(NSArray *)ocjArr_tag view:(UIView *)headView label:(UILabel *)label {
    //标签
    UIImageView *ocjImgView_last;
    CGFloat labelWidth,labelHeight;
    for (int i = 0; i < ocjArr_tag.count; i++) {
        UILabel *ocjLab_tag = [[UILabel alloc] init];
        
        CGRect rect = [self ocj_calculateLabelHeightWithString:ocjArr_tag[i]];
        labelWidth = ceilf(rect.size.width) + 12;
        labelHeight = 14;
        UIImageView *imgView =[[ UIImageView alloc] init];
        [imgView setImage:[UIImage imageNamed:@"Icon_tag_bg_"]];
        [headView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!ocjImgView_last) {
                make.right.mas_equalTo(headView.mas_right).offset(-15);
            }else {
                make.right.mas_equalTo(ocjImgView_last.mas_left).offset(-5);
            }
            make.centerY.mas_equalTo(label);
            make.width.mas_equalTo(labelWidth);
            make.height.mas_equalTo(labelHeight);
        }];
        
        ocjLab_tag.text = ocjArr_tag[i];
        ocjLab_tag.textColor = OCJ_COLOR_LIGHT_GRAY;
        ocjLab_tag.font = [UIFont systemFontOfSize:12];
        ocjLab_tag.textAlignment = NSTextAlignmentCenter;
        [ocjLab_tag.layer setCornerRadius:7.0];
        [ocjLab_tag.layer setBorderColor:[UIColor colorWSHHFromHexString:@""].CGColor];
        [ocjLab_tag.layer setBorderWidth:1];
        [headView addSubview:ocjLab_tag];
        
        [ocjLab_tag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(imgView);
        }];
        ocjImgView_last = imgView;
    }
}

/**
 添加小游戏入口和直播倒计时
 */
- (void)ocj_addGameAndCountDownViewWithLabel:(UILabel *)label view:(UIView *)headView {
  /*
    UIView *ocjView_game = [[UIView alloc] init];
    ocjView_game.backgroundColor = OCJ_COLOR_BACKGROUND;
    [headView addSubview:ocjView_game];
    [ocjView_game mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left);
        make.top.mas_equalTo(label.mas_bottom).offset(9);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(headView.mas_right).offset(-15);
    }];
    
    UIImageView *ocjImgView_game = [[UIImageView alloc] init];
    [ocjImgView_game setImage:[UIImage imageNamed:@"Icon_tag_bg2_"]];
    [ocjView_game addSubview:ocjImgView_game];
    [ocjImgView_game mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(ocjView_game);
        make.width.mas_equalTo(@50);
    }];
    //小游戏
    UILabel *ocjLab_game = [[UILabel alloc] init];
    ocjLab_game.text = @"小游戏";
    ocjLab_game.font = [UIFont systemFontOfSize:11];
    ocjLab_game.textColor = OCJ_COLOR_BACKGROUND;
    ocjLab_game.textAlignment = NSTextAlignmentCenter;
    [ocjView_game addSubview:ocjLab_game];
    [ocjLab_game mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(ocjImgView_game);
    }];
    //tips
    UILabel *ocjLab_tips = [[UILabel alloc] init];
    ocjLab_tips.text = @"这是一个很好玩儿的小游戏喔~";
    ocjLab_tips.font = [UIFont systemFontOfSize:12];
    ocjLab_tips.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_tips.textAlignment = NSTextAlignmentLeft;
    [ocjView_game addSubview:ocjLab_tips];
    [ocjLab_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjImgView_game.mas_right).offset(2);
        make.centerY.mas_equalTo(ocjView_game);
    }];
    //点击进入游戏按钮
    UIButton *ocjBtn_game = [[UIButton alloc] init];
    [ocjBtn_game setTitle:@"点我进入游戏" forState:UIControlStateNormal];
    [ocjBtn_game setTitleColor:[UIColor colorWSHHFromHexString:@"#FF0000"] forState:UIControlStateNormal];
    ocjBtn_game.titleLabel.font = [UIFont systemFontOfSize:11];
    [ocjBtn_game addTarget:self action:@selector(ocj_playGame) forControlEvents:UIControlEventTouchUpInside];
    [ocjView_game addSubview:ocjBtn_game];
    [ocjBtn_game mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(ocjView_game);
        make.width.mas_equalTo(@70);
    }];
  */
    //直播倒计时
    UIView *ocjView_count = [[UIView alloc] init];
    ocjView_count.backgroundColor = [UIColor colorWSHHFromHexString:@"EDEDED"];
    [headView addSubview:ocjView_count];
    [ocjView_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headView);
        make.bottom.mas_equalTo(headView);
        make.top.mas_equalTo(label.mas_bottom).offset(9);
    }];
    //倒计时label
    self.ocjLab_countdown = [[UILabel alloc] init];
    self.ocjLab_countdown.textColor = OCJ_COLOR_DARK;
    self.ocjLab_countdown.font = [UIFont systemFontOfSize:13];
    [self ocj_isCountDown:YES];
    self.ocjLab_countdown.textAlignment = NSTextAlignmentCenter;
    [ocjView_count addSubview:self.ocjLab_countdown];
    [self.ocjLab_countdown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.mas_equalTo(ocjView_count);
    }];
    
}

/**
 销毁timer
 */
- (void)ocj_stopTimer {
    [self.ocjTimer_count invalidate];
    self.ocjTimer_count = nil;
}

/**
 计时
 */
- (void)ocj_isCountDown:(BOOL)countdown {
    if (!countdown) {
        if (self.ocjInt_countTime > 0) {
            self.ocjInt_countTime -= 1;
        }else {
//          [self ocj_endCountDown];//计时结束，直播开始
            [self ocj_stopTimer];
        }
    }
    NSInteger days = self.ocjInt_countTime / 24 / 60 / 60;
    NSInteger hours = self.ocjInt_countTime / 3600 - days * 24;
    NSInteger minutes = self.ocjInt_countTime / 60 - days * 24 * 60 - hours * 60;
    NSInteger seconds = self.ocjInt_countTime % 60;
    
    NSString *ocjStr_count = [NSString stringWithFormat:@"离直播开始还有：%02zd天  %02zd时  %02zd分  %02zd秒", days, hours, minutes, seconds];
    self.ocjLab_countdown.attributedText = [self ocj_changeStringColorWith:ocjStr_count];
}

/**
 计时结束，直播开始
 */
- (void)ocj_endCountDown {
  self.ocjStr_videoStatus = @"1";
  [self.ocjTBView_video reloadData];
}


/**
 改变字符串字符颜色 
 */
- (NSAttributedString *)ocj_changeStringColorWith:(NSString *)ocjStr {
    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:ocjStr];
    for (int i = 0; i < ocjStr.length; i++) {
        unichar c = [ocjStr characterAtIndex:i];
        if ((c >= 48 && c <= 57)) {
            [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWSHHFromHexString:@"#F64537"] range:NSMakeRange(i, 1)];
        }else {
            [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWSHHFromHexString:@"333333"] range:NSMakeRange(i, 1)];
        }
    }
    return newStr;
}

/**
 计算label大小
 */
- (CGRect)ocj_calculateLabelHeightWithString:(NSString *)ocjStr {
    CGRect rect = [ocjStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
  
    return rect;
}

- (void)ocj_playGame {
    OCJLog(@"小游戏小游戏~");
}


/**
 退出
 */
- (void)ocj_back {
    NSTimeInterval time = CMTimeGetSeconds(self.liveView.ocjPlayer.currentTime);
    NSString *ocjStr_time = [NSString stringWithFormat:@"%f", time];
    NSString *ocjStr_newTime = [ocjStr_time isEqualToString:@"nan"] ? @"0" : ocjStr_time;
    if ([self.ocjStr_contentCode length] > 0) {
      [self ocj_trackEventID:@"AP1706A048" parmas:@{@"type":@"视频回放",@"status":@"停止",@"time":ocjStr_newTime,@"movieid":self.ocjStr_contentCode}];
    }
  
    [self ocj_stopTimer];
    [self.liveView ocj_resetPlayer];
    self.liveView = nil;
    [self.ocjArr_dataSource removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshVideoLiveView" object:nil];
      if (self.navigationController.viewControllers.count>1) {
        
          [self.navigationController popViewControllerAnimated:YES];
      }else if(self.presentingViewController){
        
          [self dismissViewControllerAnimated:YES completion:^{
            
          }];
      }
}

/**
 前往购物车
 */
- (void)ocj_gotoCart {
  __weak OCJVideoComingVC *weakSelf = self;
  if (self.ocjNavigationController.ocjCallback) {
    [self ocj_stopTimer];
    [self.liveView ocj_resetPlayer];
    self.liveView = nil;
    
    self.ocjNavigationController.ocjCallback(@{@"beforepage":@"obj/route/rn/Home/Video/Homeocj_Video",@"targetRNPage":@"CartPage",@"id":weakSelf.ocjStr_contentCode,@"fromPage":weakSelf.ocjStr_rn_fromPage});
    [self ocj_popToNavigationRootVC];
  }
}

/**
 监控网络状态
 */
-(void)ocj_monitorNetworkStatus{
  
  [OCJ_NOTICE_CENTER addObserver:self selector:@selector(ocj_MonitoringNetWorkStautes:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

/**
 监测网络状态变化
 
 @param notice 通知
 */
-(void)ocj_MonitoringNetWorkStautes:(NSNotification*)notice{
  
  OCJLog(@"网络状态改变：%@",notice.userInfo);
  NSInteger status = [notice.userInfo[@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
  switch (status) {
    case 0:{[WSHHAlert wshh_showHudWithTitle:@"网络连接中断，请检查设备网络" andHideDelay:2];}break;
    case 1:{[WSHHAlert wshh_showHudWithTitle:@"设备网络变为运营商网络，请注意" andHideDelay:2];}break;
    case 2:{[WSHHAlert wshh_showHudWithTitle:@"设备网络变为WI-FI网络，请注意" andHideDelay:2];}break;
    default:
      break;
  }
}


#pragma mark - 协议方法区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.ocjArr_dataSource.count > 0) {
    return self.ocjArr_dataSource.count - 1;
  }
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.ocjArr_goods.count;
    }else if (section == 2) {
      NSInteger col = self.ocjArr_moreVideo.count % 2;
      NSInteger row = self.ocjArr_moreVideo.count / 2;
      if (col == 0) {
        return row;
      }else {
        return (row + 1);
      }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak OCJVideoComingVC *weakSelf = self;
//    if (indexPath.section == 0) {
//        self.ocjIndexpath = indexPath;
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//      cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        if (!self.liveView) {
//            self.liveView = [[OCJVideoLiveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16.0) tableView:self.ocjTBView_video indexPath:self.ocjIndexpath];
//          self.liveView.ocjStr_status = self.ocjStr_videoStatus;
//            //@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"
//            self.liveView.ocjUrl_video = [NSURL URLWithString:self.ocjStr_videoUrl];
//            [cell.contentView addSubview:self.liveView];
//        }
////        self.liveView.ocjModel_desc = self.ocjModel_desc;
//        return cell;
//    }else
      if (indexPath.section == 0) {
        
        if ([self.ocjStr_videoStatus isEqualToString:@"2"]) {
          OCJVideoComingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJVideoComingTVCellIdentifier"];
          if (!cell) {
            cell = [[OCJVideoComingTVCell alloc] init];
          }
          cell.ocjModel_desc = self.ocjArr_goods[indexPath.row];
          
          cell.delegate = self;
          return cell;
        }else {
          OCJVideoDetailCommonTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJVideoDetailCommonTVCellIdentifier"];
          if (!cell) {
            cell = [[OCJVideoDetailCommonTVCell alloc] init];
          }
          cell.ocjModel_desc = self.ocjArr_goods[indexPath.row];
          cell.delegate = self;
          return cell;
        }
  
    }else if (indexPath.section == 1) {
      
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        OCJMoreRecomScrollView *recommendView = [[OCJMoreRecomScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 184)];
        
        if (self.ocjArr_dataSource.count > 0) {
            OCJResponceModel_VideoDetailList *modelSecond = [self.ocjArr_dataSource objectAtIndex:2];
            if ([modelSecond.ocjStr_shortNum isEqualToString:@"2"] && [modelSecond.ocjStr_packageid isEqualToString:@"13"]) {
                NSArray *listArr = modelSecond.ocjArr_listDesc;
                OCJResponceModel_VideoDetailDesc *model = listArr[0];
                NSArray *dataArr = model.ocjArr_detailDesc;
                recommendView.ocjArr_data = dataArr;
            }
        }
        recommendView.delegate = self;
        [cell.contentView addSubview:recommendView];
        return cell;
      
    }else if (indexPath.section == 2) {
      
      OCJSubMoreVideoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJSubMoreVideoTVCellIdentifier"];
      
      NSMutableArray *tempArr = [[NSMutableArray alloc] init];
      NSInteger idx = indexPath.row * 2;
      [tempArr addObject:[self.ocjArr_moreVideo objectAtIndex:idx]];
      idx ++;
      if (idx < [self.ocjArr_moreVideo count]) {
        [tempArr addObject:[self.ocjArr_moreVideo objectAtIndex:idx]];
      }
      cell.ocjArr_data = tempArr;
      
      cell.ocjSubMoreVideoBlock = ^(NSString *ocjStr_contentCode) {
        [weakSelf ocj_stopTimer];
        [weakSelf.liveView ocj_resetPlayer];
        weakSelf.liveView = nil;
        [weakSelf ocj_trackEventID:weakSelf.ocjStr_trackPageID parmas:nil];
        OCJVideoComingVC *vc = [[OCJVideoComingVC alloc] init];
        NSString* rn_fromPage = @"";
        if (weakSelf.ocjStr_rn_fromPage.length>0) {
          rn_fromPage = weakSelf.ocjStr_rn_fromPage;
        }
        vc.ocjDic_router = @{@"id":ocjStr_contentCode,@"fromPage":rn_fromPage};
        [weakSelf ocj_pushVC:vc];
      };
      
      return cell;
      /*
      OCJMoreVideoTVCell *cell = [[OCJMoreVideoTVCell alloc] init];
        if (self.ocjArr_dataSource.count > 0) {
            OCJResponceModel_VideoDetailList *modelThird = [self.ocjArr_dataSource objectAtIndex:3];
            if ([modelThird.ocjStr_shortNum isEqualToString:@"3"] && [modelThird.ocjStr_packageid isEqualToString:@"41"]) {
                NSArray *listArr = modelThird.ocjArr_listDesc;
                OCJResponceModel_VideoDetailDesc *model = listArr[0];
                self.ocjArr_moreVideo = model.ocjArr_detailDesc;
                cell.ocjArr_data = self.ocjArr_moreVideo;
            }
        }
        cell.ocjMoreVideoBlock = ^(NSString *ocjStr_contentCode) {
        [weakSelf ocj_stopTimer];
        [weakSelf.liveView ocj_resetPlayer];
        weakSelf.liveView = nil;
        OCJVideoComingVC *vc = [[OCJVideoComingVC alloc] init];
        NSString* rn_fromPage = @"";
        if (self.ocjStr_rn_fromPage.length>0) {
          rn_fromPage = self.ocjStr_rn_fromPage;
        }
        vc.ocjDic_router = @{@"id":ocjStr_contentCode,@"fromPage":rn_fromPage};
        [weakSelf ocj_pushVC:vc];
      };
      self.ocjCell_more = cell;
        return cell;
       */
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
      
        return 140;
    }else if (indexPath.section == 1) {
      
        return 212;
    }else if (indexPath.section == 2) {
      
      return (SCREEN_WIDTH - 30) / 2.0 +50;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [self ocj_addSectionHeadView];
        
        return headerView;
    }else if (section == 2) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        headerView.backgroundColor = OCJ_COLOR_BACKGROUND;
        
        OCJBaseLabel *ocjLab_title = [[OCJBaseLabel alloc] init];
        ocjLab_title.text = @"· 更多视频 ·";
        ocjLab_title.textColor = OCJ_COLOR_DARK;
        ocjLab_title.font = [UIFont systemFontOfSize:16];
        ocjLab_title.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:ocjLab_title];
        [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headerView);
            make.height.mas_equalTo(@44);
        }];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
      if ([self.ocjModel_desc.ocjStr_description length] > 0) {
        CGRect rect = [self ocj_calculateLabelHeightWithString:self.ocjModel_desc.ocjStr_description];
        CGFloat bottomHeight = ceilf(rect.size.height);
        self.ocjFloat_headerHeight = bottomHeight + 8 + 35;
        if ([self.ocjStr_videoStatus isEqualToString:@"2"]) {
          self.ocjFloat_headerHeight = self.ocjFloat_headerHeight + 35;
        }
      }else {
        if ([self.ocjStr_videoStatus isEqualToString:@"2"]) {
          self.ocjFloat_headerHeight = 35 + 35;
        }else {
          self.ocjFloat_headerHeight = 35;
        }
      }
      
        return self.ocjFloat_headerHeight;
    }else if (section == 2) {
        return 44;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        UIView *foorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        foorView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        return foorView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//  if ([self.ocjStr_videoStatus isEqualToString:@"1"]) {
//    if (section == 2) {
//      return 10;
//    }
//    return 0.01;
//  }else {
    if (section == 0 || section == 1) {
      return 10;
    }
    return 0.01;
//  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak OCJVideoComingVC *weakSelf = self;
    if (indexPath.section == 0) {
        OCJResponceModel_VideoDetailDesc *model = weakSelf.ocjArr_goods[indexPath.row];
      NSString *itemCode = model.ocjStr_contentCode;
      
      if (itemCode.length==0) {
        [OCJProgressHUD ocj_showHudWithTitle:@"商品编号为空" andHideDelay:2];
      }
      [weakSelf ocj_trackEventID:weakSelf.ocjStr_trackPageID parmas:nil];
      if (weakSelf.ocjNavigationController.ocjCallback) {
        [weakSelf ocj_stopTimer];
        [weakSelf.liveView ocj_resetPlayer];
        weakSelf.liveView = nil;
        weakSelf.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"obj/route/rn/Home/Video/Homeocj_Video",@"targetRNPage":@"GoodsDetailMain",@"fromPage":weakSelf.ocjStr_rn_fromPage});
        [weakSelf ocj_popToNavigationRootVC];
      }
    }
}

#pragma mark - OCJVideoComingTVCellDelegate
- (void)ocj_addToCartWithCellModel:(OCJResponceModel_VideoDetailDesc *)model {
    OCJLog(@"addtocart");
    __weak OCJVideoComingVC *weakSelf = self;
    OCJChooseGoodsSpecView *view = [[OCJChooseGoodsSpecView alloc] initWithEnumType:OCJEnumGoodsSpecAddToCart andItemCode:model.ocjStr_contentCode];
    view.ocjConfirmBlock = ^(NSString *ocjStr_unitcode, NSString *ocjStr_size, OCJResponceModel_specDetail *ocjModel_specColor) {
        [weakSelf ocj_requestCartNum];
    };
  
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(window);
    }];
}

#pragma mark - OCJMoreRecomScrollViewDelegate
- (void)ocj_seeMoreAction {
    OCJLog(@"查看更多");
}

- (void)ocj_tappedViewToGoodsDetail:(OCJResponceModel_VideoDetailDesc *)model {
  __weak OCJVideoComingVC *weakSelf = self;
  NSString *itemCode = model.ocjStr_contentCode;
  
  if (itemCode.length==0) {
    [OCJProgressHUD ocj_showHudWithTitle:@"商品编号为空" andHideDelay:2];
  }
  
  [weakSelf ocj_trackEventID:weakSelf.ocjStr_trackPageID parmas:nil];
  if (weakSelf.ocjNavigationController.ocjCallback) {
    [weakSelf ocj_stopTimer];
    [weakSelf.liveView ocj_resetPlayer];
    weakSelf.liveView = nil;
    weakSelf.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"obj/route/rn/Home/Video/Homeocj_Video",@"targetRNPage":@"GoodsDetailMain",@"fromPage":weakSelf.ocjStr_rn_fromPage});
    [weakSelf ocj_popToNavigationRootVC];
  }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  
  if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
    
      [self.liveView removeFromSuperview];
      
      [self.view addSubview:self.liveView];
      [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT * 9 / 16.0);
      }];
    
  }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.liveView];
    [self.liveView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.bottom.mas_equalTo(window);
    }];
  }
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
