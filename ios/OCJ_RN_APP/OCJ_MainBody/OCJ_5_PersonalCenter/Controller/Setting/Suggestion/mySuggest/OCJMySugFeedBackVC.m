//
//  OCJMySugFeedBackVC.m
//  OCJ
//
//  Created by OCJ on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJMySugFeedBackVC.h"
#import "OCJSelectedView.h"
#import "OCJPlaceholderTextView.h"
#import "OCJHttp_personalInfoAPI.h"
#import "OCJFeedBackSuccessVC.h"

typedef NS_ENUM(NSInteger, OCJEnumSuggestionType) {
    OCJEnumSugTypeLoginRegister = 1,     ///<登录注册
    OCJEnumSugTypeOrder,                 ///<订单问题
    OCJEnumSugTypePayment,               ///<支付体验
    OCJEnumSugTypeOthers                 ///<其他问题
};

@interface OCJMySugFeedBackVC ()<UITextViewDelegate>
@property (nonatomic,strong) UIView * ocjView_top;

@property (nonatomic,strong) OCJPlaceholderTextView * ocjTF_suggest;///<输入框
@property (nonatomic,strong) OCJSelectedView * ocjView_selected;///<问题类型展示view
@property (nonatomic,strong) OCJBaseButton * ocjBtn_submit;///<提交按钮

@property (nonatomic) OCJEnumSuggestionType ocjEnumSuggestionType;///<反馈类型

@end

@implementation OCJMySugFeedBackVC

#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocj_setSelf];
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf{
    self.title = @"反馈问题类型";
    self.ocjStr_trackPageID = @"AP1706C068";
    [self setUI];
}
- (void)setUI{
    self.ocjEnumSuggestionType = OCJEnumSugTypeLoginRegister;
    self.view.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    UITapGestureRecognizer * ocj_gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ocjSwitch:)];
    
    self.ocjView_top = [[UIView alloc]init];
    self.ocjView_top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ocjView_top];
    [self.ocjView_top addGestureRecognizer:ocj_gesture];

    
    [self.ocjView_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(250);
    }];
    

    UILabel * ocjLab_tip = [[UILabel alloc]init];
    ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    ocjLab_tip.text = @"反馈问题类型";
    ocjLab_tip.font = [UIFont systemFontOfSize:14];
    [self.ocjView_top addSubview:ocjLab_tip];
    [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_top).offset(14.5);
        make.top.mas_equalTo(self.ocjView_top).offset(14.5);
        make.height.mas_equalTo(20);
    }];
    
    self.ocjView_selected=  [[OCJSelectedView alloc]initWithTitleArray:[NSMutableArray arrayWithObjects:@"登录注册",@"订单问题",@"支付体验",@"其他问题", nil] andIndex:0];
    __weak OCJMySugFeedBackVC *weakSelf = self;
    self.ocjView_selected.ocj_handler = ^(UIButton *currentBtn) {
        switch (currentBtn.tag) {
          case 0:{
            weakSelf.ocjEnumSuggestionType = OCJEnumSugTypeLoginRegister;
            [weakSelf ocj_trackEventID:@"AP1706C068F012001O006001" parmas:nil];
          }break;
          case 1:{
            weakSelf.ocjEnumSuggestionType = OCJEnumSugTypeOrder;
            [weakSelf ocj_trackEventID:@"AP1706C068F012001O006002" parmas:nil];
          }break;
          case 2:{
            weakSelf.ocjEnumSuggestionType = OCJEnumSugTypePayment;
            [weakSelf ocj_trackEventID:@"AP1706C068F012001O006003" parmas:nil];
          }break;
          case 3:{
            weakSelf.ocjEnumSuggestionType = OCJEnumSugTypeOthers;
            [weakSelf ocj_trackEventID:@"AP1706C068F012001O006004" parmas:nil];
          }break;
            default:
                break;
        }
    };
    [self.ocjView_top addSubview:self.ocjView_selected];
    [self.ocjView_selected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_top);
        make.right.mas_equalTo(self.ocjView_top);
        make.top.mas_equalTo(ocjLab_tip.mas_bottom).offset(15);
        make.height.mas_equalTo(25);
    }];
    
    self.ocjTF_suggest = [[OCJPlaceholderTextView alloc]initWithFrame:CGRectMake(15,self.ocjView_selected.frame.size.height + self.ocjView_selected.frame.origin.y + 15, SCREEN_WIDTH - 30, 145)];
    self.ocjTF_suggest.font = [UIFont systemFontOfSize:12];
    self.ocjTF_suggest.placeholder = @"请输入建议，帮助我们进步！";
    self.ocjTF_suggest.layer.borderColor =[UIColor colorWSHHFromHexString:@"DDDDDD"].CGColor;
    self.ocjTF_suggest.layer.borderWidth = 1;
    self.ocjTF_suggest.delegate = self;
    self.ocjTF_suggest.returnKeyType = UIReturnKeyDone;
    self.ocjTF_suggest.tintColor =[UIColor redColor];
    [self.ocjView_top addSubview:self.ocjTF_suggest];
    [self.ocjTF_suggest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_top).offset(15);
        make.right.mas_equalTo(self.ocjView_top).offset(-15);
        make.top.mas_equalTo(self.ocjView_selected.mas_bottom).offset(15);
        make.height.mas_equalTo(145);
    }];
    
    
    self.ocjBtn_submit  =[[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 250 + 20, SCREEN_WIDTH - 40, 45)];
    [self.ocjBtn_submit setTitle:@"提交" forState:UIControlStateNormal];
    [self.ocjBtn_submit ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.ocjBtn_submit setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    self.ocjBtn_submit.backgroundColor = [UIColor redColor];
    self.ocjBtn_submit.layer.masksToBounds = YES;
    self.ocjBtn_submit.layer.cornerRadius = 2;
    [self.ocjBtn_submit addTarget:self action:@selector(ocj_submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_submit];
    
}
- (void)ocjSwitch:(UITapGestureRecognizer *)tap{
    [self.ocjTF_suggest resignFirstResponder];
}

- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C068D003001C003001" parmas:nil];
  [super ocj_back];
}

/**
 点击提交按钮
 */
- (void)ocj_submitAction {
    
    if (!([self.ocjTF_suggest.text length] > 0) || [self ocj_isEmptyString:self.ocjTF_suggest.text]) {
        [OCJProgressHUD ocj_showHudWithTitle:@"请输入反馈内容" andHideDelay:2.0];
        return;
    }
  
    [self ocj_trackEventID:@"AP1706C068F008001O008001" parmas:nil];
    [OCJHttp_personalInfoAPI ocjPersonal_suggestionFeedBackWithType:self.ocjEnumSuggestionType detail:self.ocjTF_suggest.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          OCJFeedBackSuccessVC *successVC = [[OCJFeedBackSuccessVC alloc] init];
          [self ocj_pushVC:successVC];
          /*
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
           */
        }
    }];
}

/**
 判断字符串是否全部为空字符
 */
- (BOOL) ocj_isEmptyString:(NSString *)str {
    if (!str) {
        return YES;
    }else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedStr = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedStr length] == 0) {
            return YES;
        }else {
            return NO;
        }
    }
}

#pragma mark - 协议方法实现区域
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if(range.location >= 200){
        [OCJProgressHUD ocj_showHudWithTitle:@"输入的自字符数不能超过200" andHideDelay:2];
        return NO;
    }else{
        return YES;
    }
}
@end
