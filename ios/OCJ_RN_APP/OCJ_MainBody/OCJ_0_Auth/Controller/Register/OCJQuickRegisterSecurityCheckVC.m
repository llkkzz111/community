//
//  OCJQuickRegisterSecurityCheckVC.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJQuickRegisterSecurityCheckVC.h"
#import "OCJBaseButton.h"
#import "UIColor+WSHHExtension.h"
#import "OCJBaseButton+OCJExtension.h"
#import "OCJHttp_authAPI.h"

#pragma mark - 固定字符串赋值区域

@interface OCJQuickRegisterSecurityCheckVC ()<UITextFieldDelegate>

@property (nonatomic,strong) OCJBaseTextField * ocjTF_name;
@property (nonatomic,strong) OCJBaseButton * ocjBtn_confirm;
@property (nonatomic,strong) UIView * ocjView_lineView;

@end

@implementation OCJQuickRegisterSecurityCheckVC



#pragma mark - 接口方法实现区域（包括setter、getter方法）

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf{
    self.title  = @"安全校验";
  
    [self initUI];
}

- (void)initUI{
  
    [self.view addSubview:self.ocjTF_name];
    [self.view addSubview:self.ocjView_lineView];
    [self.ocjTF_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.view.mas_top).offset(40);
        make.height.mas_equalTo(24);
    }];
    
    [self.ocjView_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjTF_name);
        make.right.mas_equalTo(self.ocjTF_name);
        make.top.mas_equalTo(self.ocjTF_name.mas_bottom).offset(5);
        make.height.mas_equalTo(1/2.0);
    }];
    
    self.ocjBtn_confirm.frame = CGRectMake(20, 100, self.view.frame.size.width - 40, 45) ;
    [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.view addSubview:self.ocjBtn_confirm];
}

- (OCJBaseTextField *)ocjTF_name{
    if (!_ocjTF_name) {
        _ocjTF_name = [OCJBaseTextField new];
        _ocjTF_name.placeholder     = @"请输入您曾经订购时使用的姓名";
        _ocjTF_name.clearButtonMode = UITextFieldViewModeWhileEditing;
        _ocjTF_name.keyboardType    = UIKeyboardTypeNumberPad;
        _ocjTF_name.tintColor       = [UIColor redColor];
        _ocjTF_name.font            = [UIFont systemFontOfSize:17];
        _ocjTF_name.delegate        = self;
    }
    return _ocjTF_name;
}

- (UIView *)ocjView_lineView{
    if (!_ocjView_lineView) {
        _ocjView_lineView = [UIView new];
        _ocjView_lineView.backgroundColor = [UIColor colorWSHHFromHexString:@"999999"];

    }
    return _ocjView_lineView;
}


- (OCJBaseButton *)ocjBtn_confirm{
    if (!_ocjBtn_confirm) {
        _ocjBtn_confirm = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
        _ocjBtn_confirm.userInteractionEnabled = NO;
        [_ocjBtn_confirm setTitle:@"确认" forState:UIControlStateNormal];
        _ocjBtn_confirm.layer.masksToBounds = YES;
        _ocjBtn_confirm.layer.cornerRadius = 5;
        _ocjBtn_confirm.backgroundColor = [UIColor whiteColor];
        _ocjBtn_confirm.alpha = 0.2;
        [_ocjBtn_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:17];
        [_ocjBtn_confirm addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_confirm;
}
- (void)confirmAction:(id)sender{
    [OCJHttp_authAPI ocjAuth_verifyTVUserWithTelephone:self.ocjStr_userMobile name:self.ocjTF_name.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        
    }];
    NSLog(@"确认");
}

#pragma mark - 协议方法实现区域

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.ocjTF_name){
        if (str.length > 11) {
            return NO;
        }else{
            if ( str.length <= 0 ) {
                self.ocjBtn_confirm.userInteractionEnabled = NO;
                self.ocjBtn_confirm.alpha = 0.2;
            }else{
                self.ocjBtn_confirm.userInteractionEnabled = YES;
                self.ocjBtn_confirm.alpha = 1;
            }
            return YES;
        }
    }else{
        return YES;
    }
}




@end
