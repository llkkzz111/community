//
//  OCJUpdateViewController.m
//  OCJ_RN_APP
//
//  Created by apple on 2017/7/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJUpdateViewController.h"

@interface OCJUpdateViewController (){
  OCJBaseTextView *textView;
  UIView *backView;
}

@end

@implementation OCJUpdateViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self ocjSetupViews];
}

-(void)ocjSetupViews{
  self.view.backgroundColor = [UIColor colorWSHHFromHexString:@"#000000" alpha:0.5019f];
  self.view.alpha = 0.5;
  backView = [[UIView alloc] init];
  [self.view addSubview:backView];
  [backView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.equalTo(@(550*0.5));
    make.height.equalTo(@(350));
    make.centerX.equalTo(self.view);
    make.top.offset(317.0*SCREEN_HEIGHT/1334);
  }];
  backView.backgroundColor = [UIColor whiteColor];
  backView.layer.cornerRadius = 3.f;
  backView.layer.masksToBounds = YES;
  
  UIImageView *topImageV = [[UIImageView alloc] init];
  topImageV.image = [UIImage imageNamed:@"bg_update"];
  [backView addSubview:topImageV];
  [topImageV mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.equalTo(backView);
    make.height.equalTo(@( (250-16.4) *0.5));
  }];
  topImageV.backgroundColor = [UIColor clearColor];
  
  textView = [[OCJBaseTextView alloc] init];
  textView.showsVerticalScrollIndicator = YES;
  textView.backgroundColor = [UIColor clearColor];
  [backView addSubview:textView];
  [textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(backView);
    make.width.equalTo(@221);
    make.top.equalTo(topImageV.mas_bottom).offset(16.4*0.5);
    make.height.equalTo(@140);
  }];
  textView.font = [UIFont systemFontOfSize:14];
  textView.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
  textView.editable = NO;
  
  OCJBaseButton *cancelBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
  [backView addSubview:cancelBtn];
  [cancelBtn setOcjFont:[UIFont systemFontOfSize:18]];
  [cancelBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#FFFFFF"] forState:UIControlStateNormal];
  [cancelBtn setTitle:@"再等等" forState:UIControlStateNormal];
  [cancelBtn addTarget:self action:@selector(ocj_closeUpdateVC) forControlEvents:UIControlEventTouchUpInside];
  cancelBtn.layer.cornerRadius = 3.f;
  cancelBtn.layer.masksToBounds = YES;
  [cancelBtn setBackgroundColor:[UIColor colorWSHHFromHexString:@"#ED1C41"]];
  
  OCJBaseButton *updateBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
  [backView addSubview:updateBtn];
  [updateBtn setOcjFont:[UIFont systemFontOfSize:18]];
  [updateBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#FFFFFF"] forState:UIControlStateNormal];
  [updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
  [updateBtn addTarget:self action:@selector(openAppstore) forControlEvents:UIControlEventTouchUpInside];
  updateBtn.layer.cornerRadius = 3.f;
  updateBtn.layer.masksToBounds = YES;
  [updateBtn setBackgroundColor:[UIColor colorWSHHFromHexString:@"#ED1C41"]];
  
  
  if (self.ocjEnum_updateType == OCJUpdateTypeSoft) {
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(backView.mas_centerX).offset(-10);
      make.bottom.offset(-35);
      make.width.equalTo(@100);
      make.height.equalTo(@35);
    }];
    
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(backView.mas_centerX).offset(10);
      make.bottom.offset(-35);
      make.width.equalTo(@100);
      make.height.equalTo(@35);
    }];
    
    
  }else if (self.ocjEnum_updateType == OCJUpdateTypeHard){
    
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(backView);
      make.bottom.offset(-35);
      make.width.equalTo(@140);
      make.height.equalTo(@35);
    }];
  }
  
  
  
  
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  [self ocjSeperatorItems:self.items];
}

- (void)ocjSeperatorItems:(NSArray *)items{
  NSMutableAttributedString *strAM = [[NSMutableAttributedString alloc] init];
  for (NSString *str in items) {
    NSAttributedString *temStr = [[NSAttributedString alloc] initWithString:[str stringByAppendingString:@"\n"]];
    [strAM appendAttributedString:temStr];
  }
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineSpacing = 8;// 字体的行间距
  NSDictionary *attributes = @{
                               NSFontAttributeName:[UIFont systemFontOfSize:14], //字体大小
                               NSParagraphStyleAttributeName:paragraphStyle,
                               NSForegroundColorAttributeName:[UIColor colorWSHHFromHexString:@"#666666"]
                               };
  
  [strAM setAttributes:attributes range:NSMakeRange(0, strAM.length)];
  textView.attributedText = strAM;
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
//  __weak __typeof(backView) weakBackV = backView;
  [UIView animateWithDuration:1.5 animations:^{
    self.view.alpha = 1;
  }];
}


-(void)ocj_closeUpdateVC{
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)openAppstore{
  if (self.appstoreUrl.length==0) {
//    [WSHHAlert wshh_showHudWithTitle:@"" andHideDelay:2];
  }else{
    NSURL *url = [NSURL URLWithString:self.appstoreUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
      [[UIApplication sharedApplication] openURL:url];
    }
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
