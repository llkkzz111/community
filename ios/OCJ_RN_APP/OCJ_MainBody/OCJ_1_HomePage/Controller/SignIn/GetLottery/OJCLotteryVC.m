//
//  OJCLotteryVC.m
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OJCLotteryVC.h"
#import "POP.h"
#import "OCJHttp_signInAPI.h"

@interface OJCLotteryVC (){
    UIView *backView;
    NSMutableArray <OCJBaseTextField *>*textFAryM;
}

@end

@implementation OJCLotteryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textFAryM = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWSHHFromHexString:@"#000000" alpha:0.5019f];
    
    [self ocj_setupViews];
    
    [self ocj_customSingBtnAnimation];
    
    [self ocj_regisetKeyBoardNTF];
}

- (void)ocj_regisetKeyBoardNTF{
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(55*0.5);
        make.right.offset(-55*0.5);
        make.bottom.offset(-height);
        make.height.equalTo(@(475*0.5));
    }];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1 animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    __weak typeof(self) weakSelf = self;
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(55*0.5);
        make.right.offset(-55*0.5);
        make.centerY.equalTo(self.view);
        make.height.equalTo(@(475*0.5));
    }];
    [UIView animateWithDuration:1 animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)ocj_setupViews{
    backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(55*0.5);
        make.right.offset(-55*0.5);
        make.centerY.equalTo(self.view);
        make.height.equalTo(@(475*0.5));
    }];
    backView.backgroundColor = [UIColor colorWSHHFromHexString:@"#F65151"];
    backView.layer.cornerRadius = 3;
    backView.clipsToBounds = YES;
    
    OCJBaseLabel *titleLab = [[OCJBaseLabel alloc] init];
    [backView addSubview:titleLab];
    titleLab.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    titleLab.font = [UIFont systemFontOfSize:18];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(21);
    }];
    titleLab.text = @"福彩彩票购买人信息填写";
    
    OCJBaseLabel *leftLabOne = [[OCJBaseLabel alloc] init];
    [self setLeftLab:leftLabOne string:@"购买人："];
    OCJBaseTextField *textF = [[OCJBaseTextField alloc] init];
    [backView addSubview:textF];
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(24);
        make.left.offset(58*0.5);
        make.right.offset(-54*0.5);
    }];
    [self setPlaceHolderTextF:textF string:@"请输入真实姓名"];
    textF.leftView = leftLabOne;
    [self addLineByTextF:textF backView:backView];
    
    
    OCJBaseLabel *leftLabTwo = [[OCJBaseLabel alloc] init];
    [self setLeftLab:leftLabTwo string:@"身份证号码："];
    OCJBaseTextField *textFTwo = [[OCJBaseTextField alloc] init];
    [backView addSubview:textFTwo];
    [textFTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textF.mas_bottom).offset(45*0.5);
        make.left.offset(58*0.5);
        make.right.offset(-54*0.5);
    }];
    [self setPlaceHolderTextF:textFTwo string:@"请输入真实身份证号码"];
    textFTwo.leftView = leftLabTwo;
    [self addLineByTextF:textFTwo backView:backView];
    
    OCJBaseLabel *leftLabThree = [[OCJBaseLabel alloc] init];
    [self setLeftLab:leftLabThree string:@"联系电话："];
    OCJBaseTextField *textFThree = [[OCJBaseTextField alloc] init];
    [backView addSubview:textFThree];
    [textFThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFTwo.mas_bottom).offset(45*0.5);
        make.left.offset(58*0.5);
        make.right.offset(-54*0.5);
    }];
    [self setPlaceHolderTextF:textFThree string:@"请输入有效联系方式"];
    textFThree.leftView = leftLabThree;
    [self addLineByTextF:textFThree backView:backView];
    
    [self setupTwoBtn:backView];
}

#pragma mark - 设置 字体 颜色 占位字符 和 左视图模式
- (void)setPlaceHolderTextF:(OCJBaseTextField *)textF string:(NSString *)str{
    [textFAryM addObject:textF];
    [textF addTarget:self action:@selector(checkSureBtnEnable:) forControlEvents:UIControlEventEditingChanged];
    
    textF.leftViewMode = UITextFieldViewModeAlways;
    textF.textColor = [UIColor lightTextColor];
    textF.font = [UIFont systemFontOfSize:15];
    textF.textColor = [UIColor lightTextColor];
    
    NSMutableAttributedString *strAM = [[NSMutableAttributedString alloc] initWithString:str];
    [strAM addAttribute:NSForegroundColorAttributeName value:[UIColor lightTextColor] range:NSMakeRange(0, strAM.length)];
    [strAM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, strAM.length)];
    textF.attributedPlaceholder = strAM;
}

#pragma mark 添加下划线
- (void)addLineByTextF:(OCJBaseTextField *)textF backView:(UIView *)backView2{
    UIView *oneLine = [[UIView alloc] init];
    [backView2 addSubview:oneLine];
    [oneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(55*0.5);
        make.right.offset(-54*0.5);
        make.height.equalTo(@1);
        make.top.equalTo(textF.mas_bottom).offset(5);
    }];
    oneLine.backgroundColor = [UIColor colorWSHHFromHexString:@"#E50000"];
}

#pragma mark 设置左视图占位lab属性 和 frame
- (void)setLeftLab:(OCJBaseLabel *)lab string:(NSString *)string{
    lab.text = string;
    lab.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    lab.font = [UIFont systemFontOfSize:16];
    
    lab.frame = CGRectMake(0, 0, 16.5*string.length, 18);
}


- (void)setupTwoBtn:(UIView *)backView2{
    OCJBaseButton *giveUpBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [backView2 addSubview:giveUpBtn];
    [giveUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(backView);
        make.height.equalTo(@45);
    }];
    giveUpBtn.backgroundColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    [giveUpBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#FF5136"] forState:UIControlStateNormal];
    giveUpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [giveUpBtn setTitle:@"我放弃" forState:UIControlStateNormal];
    [giveUpBtn addTarget:self action:@selector(disMissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    OCJBaseButton *sureBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [backView2 addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(backView2);
        make.height.equalTo(@45);
        make.left.equalTo(giveUpBtn.mas_right).offset(1);
        make.width.equalTo(giveUpBtn);
    }];
    sureBtn.backgroundColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    NSMutableAttributedString *strAM = [[NSMutableAttributedString alloc] initWithString:@"确认信息无误,去领取"];

    [strAM addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange( 7, 3)];
    [strAM addAttribute:NSForegroundColorAttributeName value:[UIColor colorWSHHFromHexString:@"#FF5136"] range:NSMakeRange( 0, strAM.length)];
//    [strAM addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange( 0, strAM.length)];
    
    [sureBtn setAttributedTitle:strAM forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(getLottery) forControlEvents:UIControlEventTouchUpInside];
    
//    sureBtn.enabled = NO;
}

#pragma mark 自定义模态弹出动画
- (void)ocj_customSingBtnAnimation{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    springAnimation.springSpeed = 20;
    springAnimation.springBounciness = 10;
    springAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)];
    springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake( 1, 1)];
    [backView pop_addAnimation:springAnimation forKey:@"springAnimation"];
}

#pragma mark 每次编辑输入文本调用检测指定文本数值
- (void)checkSureBtnEnable:(OCJBaseTextField *)textF{
    [textFAryM enumerateObjectsUsingBlock:^(OCJBaseTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (textF == obj) {
            switch (idx) {
                case 0:{//购买人姓名
                    
                }break;
                case 1:{//身份证
                    
                }break;
                case 2:{//联系电话
                    
                }break;
                default:
                    break;
            }
        }
    }];
}

#pragma mark 检测所有文本值是否符合要求
- (BOOL)checkTextFileds{
    
    
    __block BOOL shouldSendGetLotter = YES;
    [textFAryM enumerateObjectsUsingBlock:^(OCJBaseTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:{//购买人姓名
                if (! ([WSHHRegex wshh_isChineseWithString:obj.text]) ) {
                    [WSHHAlert wshh_showHudWithTitle:@"姓名输入有误" andHideDelay:2];
                    [obj becomeFirstResponder];
                    shouldSendGetLotter = NO;
                    *stop = YES;
                }
            }break;
            case 1:{//身份证
                if (![WSHHRegex wshh_isIdCard:obj.text]) {
                    [WSHHAlert wshh_showHudWithTitle:@"身份证输入有误" andHideDelay:2];
                    [obj becomeFirstResponder];
                    shouldSendGetLotter = NO;
                    *stop = YES;
                }
            }break;
            case 2:{//联系电话
                if (![WSHHRegex wshh_isTelPhoneNumber:obj.text]) {
                    [WSHHAlert wshh_showHudWithTitle:@"电话输入有误" andHideDelay:2];
                    [obj becomeFirstResponder];
                    shouldSendGetLotter = NO;
                    *stop = YES;
                }
            }break;
            default:
                break;
        }
    }];
    return shouldSendGetLotter;
}

#pragma mark 获取彩票接口
- (void)getLottery{
    if ([self checkTextFileds]) {
        //发送网络请求
//        [WSHHAlert wshh_showHudWithTitle:@"发送签到接口请求" andHideDelay:2];
        NSString *userName = textFAryM[0].text;
        NSString *mobile = textFAryM[2].text;
        NSString *cardId = textFAryM[1].text;
        [OCJHttp_signInAPI sign15Gift_inSignFct:@"" userName:userName mobile:mobile cardId:cardId CompletionHandler:^(OCJBaseResponceModel *responseModel) {
            
            if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
                if (self.status) {
                    self.status(YES);
                }
                [self disMissSelf];
            }else{
                if (self.status) {
                    self.status(NO);
                }
            }
        }];
    }
}

#pragma mark 移除键盘通知 界面模态消失动画
- (void)disMissSelf{
    
    self.editing = NO;
    [textFAryM enumerateObjectsUsingBlock:^(OCJBaseTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isFirstResponder) {
            [obj resignFirstResponder];
        }
    }];
    
    if (backView.pop_animationKeys.count>0) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.view.backgroundColor = [UIColor clearColor];

    
    POPBasicAnimation *baseAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    baseAnimation.duration = 0.5f;
    baseAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake( 1.0, 1.0)];
    baseAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake( 0.5, 0.5)];
    [backView pop_addAnimation:baseAnimation forKey:@"baseAnimation"];
    
    POPBasicAnimation *baseAnimation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    baseAnimation2.duration = 0.5f;
    baseAnimation2.toValue = @0.0;
    [backView pop_addAnimation:baseAnimation2 forKey:@"alphaAnimation"];
    
    [baseAnimation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
        if (finished) {
            [backView pop_removeAllAnimations];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.editing = NO;
    [textFAryM enumerateObjectsUsingBlock:^(OCJBaseTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isFirstResponder) {
            [obj resignFirstResponder];
        }
    }];
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
