//
//  JZPersonalViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "JZPersonalViewController.h"

#import "JZLoginViewController.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import "UIImageView+WebCache.h"
//#import "UMSocialUIManager.h"
#import "ModifyPersonalInfoTableViewController.h"
#import "JZTools.h"
@interface JZPersonalViewController ()
@property (nonatomic, weak) UIView *loginView;
@property (nonatomic, weak) UIView *personInfoView;
@property (nonatomic, weak) UIImageView *headImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIButton *LogOutButton;
@property (nonatomic, strong) JZCustomer *mine;
@property (nonatomic, assign) BOOL weixinLoginSuccess;
@end

@implementation JZPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAINBACKGROUNDCOLOR;
    [self setHeadView];
    [self setBottomView];
}

- (void)setHeadView {
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.frame = CGRectMake(0, (SCREEN_HEIGHT-113)/4-10, SCREEN_WIDTH, (SCREEN_HEIGHT-113)/5);
    headImageView.backgroundColor = MAINBACKGROUNDCOLOR;
    headImageView.image = [UIImage imageNamed:@""];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:headImageView];
}

- (void)setBottomView {
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-113)/2, SCREEN_WIDTH, (SCREEN_HEIGHT-113)/2)];
    [self.view addSubview:loginView];
    self.loginView = loginView;
    
    UILabel *adText = [[UILabel alloc] init];
    adText.text = @"选择登录方式";
    CGRect adTextSize = [adText.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    adText.textColor = RGB(222, 222, 222, 1);
    adText.font = [UIFont systemFontOfSize:15];
    adText.textAlignment = NSTextAlignmentCenter;
    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake((SCREEN_WIDTH-adTextSize.size.width)/4, (SCREEN_HEIGHT-113)/8+10, (SCREEN_WIDTH-adTextSize.size.width)/4, 1);
    line1.backgroundColor = RGB(222, 222, 222, 1);
    [self.loginView addSubview:line1];
    adText.frame = CGRectMake(CGRectGetMaxX(line1.frame), (SCREEN_HEIGHT-113)/8, adTextSize.size.width, 20);
    [self.loginView addSubview:adText];
    UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(CGRectGetMaxX(adText.frame), (SCREEN_HEIGHT-113)/8+10, (SCREEN_WIDTH-adTextSize.size.width)/4, 1);
    line2.backgroundColor = RGB(222, 222, 222, 1);
    [self.loginView addSubview:line2];
    
    UIView *SelectLoginModeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(adText.frame)+20, SCREEN_WIDTH, 50)];
    SelectLoginModeView.backgroundColor = [UIColor clearColor];
    [self.loginView addSubview:SelectLoginModeView];
    
    UIButton *weixin = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, 0, 50, 50)];
    weixin.backgroundColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.5];
    weixin.layer.cornerRadius = 25;
    weixin.clipsToBounds = YES;
    weixin.tag = 422;
    [weixin setImage:[UIImage imageNamed:@"JZ_Btn_wechat@2x"] forState: UIControlStateNormal];
    [weixin addTarget:self action:@selector(weixinLogin:) forControlEvents:UIControlEventTouchUpInside];
    weixin.adjustsImageWhenHighlighted = NO;
    [SelectLoginModeView addSubview:weixin];
    
    UIButton *phone = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weixin.frame)+10, 0, 50, 50)];
    phone.layer.cornerRadius = 25;
    phone.clipsToBounds = YES;
    phone.tag = 423;
    [phone setImage:[UIImage imageNamed:@"JZ_Btn_phone@2x"] forState:UIControlStateNormal];
    [phone addTarget:self action:@selector(phoneLogin:) forControlEvents:UIControlEventTouchUpInside];
    phone.adjustsImageWhenHighlighted = NO;
    [SelectLoginModeView addSubview:phone];
    
    UIButton *thirdParty = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phone.frame)+10, 0, 50, 50)];
    thirdParty.backgroundColor = MAINCOLOR;
    thirdParty.layer.cornerRadius = 25;
    thirdParty.clipsToBounds = YES;
    thirdParty.tag = 424;
    [thirdParty setTitle:@"三方" forState:UIControlStateNormal];
    [thirdParty setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[thirdParty setImage:[UIImage imageNamed:@"JZ_Btn_phone@2x"] forState:UIControlStateNormal];
    [thirdParty addTarget:self action:@selector(thirdPartyLogin:) forControlEvents:UIControlEventTouchUpInside];
    thirdParty.adjustsImageWhenHighlighted = NO;
    [SelectLoginModeView addSubview:thirdParty];
    
    
    UIView *personInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-113)/2, SCREEN_WIDTH, (SCREEN_HEIGHT-113)/2)];
    personInfoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:personInfoView];
    self.personInfoView = personInfoView;
    
    UIView *informationView = [[UIView alloc] init];
    informationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-113)/4);
    informationView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *editorInfoV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editorInfo)];
    [informationView addGestureRecognizer:editorInfoV];
    [self.personInfoView addSubview:informationView];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    NSInteger imageWidth = (SCREEN_HEIGHT-113)/8-20;
    headImageView.frame = CGRectMake((SCREEN_WIDTH-imageWidth)/2, 10, imageWidth, imageWidth);
    headImageView.layer.cornerRadius = imageWidth/2;
    headImageView.clipsToBounds =YES;
    [informationView addSubview:headImageView];
    self.headImageView = headImageView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, CGRectGetMaxY(headImageView.frame)+10, SCREEN_WIDTH, 30);
    nameLabel.textColor = MAINCOLOR;
    nameLabel.font = [UIFont systemFontOfSize:FONTSIZE38];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [informationView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UIButton *LogOutButton = [[UIButton alloc] init];
    LogOutButton.frame = CGRectMake(10, CGRectGetMaxY(informationView.frame)+(SCREEN_HEIGHT-113)/16+10, SCREEN_WIDTH-20, (SCREEN_HEIGHT-113)/8-20);
    LogOutButton.backgroundColor = MAINCOLOR;
    LogOutButton.clipsToBounds = YES;
    LogOutButton.layer.cornerRadius = 5;
    [LogOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [LogOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LogOutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    LogOutButton.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE52];
    [LogOutButton addTarget:self action:@selector(LogOut) forControlEvents:UIControlEventTouchUpInside];
    [self.personInfoView addSubview:LogOutButton];
    self.LogOutButton = LogOutButton;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([JZGeneralApi getLoginStatus]) {
        _mine = [JZCustomer getUserdataInstance];
        while(!_mine.id) {
            _mine = [JZCustomer getUserdataInstance];
        }
        NSDictionary * params = @{@"hostID":[NSString stringWithFormat:@"%lu",(long)_mine.id],@"userID":[NSString stringWithFormat:@"%lu",(long)_mine.id],@"accountType":@"ios",@"start":@"0",@"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)_mine.isTester]};
        __weak typeof(self) block = self;
        [JZGeneralApi getDetailUserBlock:params getDetailBlock:^(JZCustomer *user, NSArray *records, NSInteger allcounts, NSError *error) {
            block.mine = user;
            [block reloadMineData];
        }];
    }else {
        self.personInfoView.hidden = YES;
        self.loginView.hidden = NO;
    }
}

////微信登录
//- (void)weixinLogin:(UIButton *)sender{
//    sender.enabled = NO;
//    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
//        UMSocialAuthResponse *authresponse = result;
//        if (result == nil) {
//            sender.enabled = YES;
//            nil;
//        }else{
//            //获取名字和图片
//            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
//                UMSocialUserInfoResponse *userinfo =result;
//                //第三方登陆
//                if ([userinfo.gender isEqualToString:@"m"]) {
//                    userinfo.gender = @"men";
//                }else{
//                    userinfo.gender = @"women";
//                }
//                NSDictionary * params = @{@"uid":authresponse.uid,@"loginType":@"weixin",@"nickname":userinfo.name,@"city":@"",@"pic1":userinfo.iconurl,@"sex":userinfo.gender};
//                __weak typeof(self) block = self;
//                [JZGeneralApi thirdPrtyLoginWithBlock:(NSDictionary *) params getDetailBlock:^(JZCustomer *user, NSError *error) {
//                    if (error|| user == nil) {
//                        [block.navigationController popViewControllerAnimated:YES];
//                        [JZTools showMessage:@"登录失败"];
//                        sender.enabled = YES;
//                    }else{
//                        [JZGeneralApi setLoginStatus:1];
//                        //保存用户信息
//                        [[NSUserDefaults standardUserDefaults]setObject:user.nickname forKey:@"userName"];
//                        [[NSUserDefaults standardUserDefaults]setObject:user.externalID forKey:@"password"];
//                        //更新用户信息到数据库中
//                        NSString* dir = [JZTools createDirectory:@"userinfo_cache"];
//                        NSString* filename = @"myinfo";
//                        //添加一个判别账号类别
//                        NSString *accountCategory = @"weixin";
//                        NSString* content = [NSString stringWithFormat:@"%@;%@;%@",userinfo.name,authresponse.uid,accountCategory];
//                        [JZTools saveUserInfo:dir userInfo:content fileName:filename];
//                        [JZTools getUserInfo:dir fileName:filename];
//                        sender.enabled = YES;
//                        block.weixinLoginSuccess = YES;
//                        
//                        [JZTools showMessage:@"登录成功"];
//                        [block.navigationController popViewControllerAnimated:YES];
//                        //显示个人信息页面
//                        block.personInfoView.hidden = NO;
//                        block.loginView.hidden = YES;
//                        NSDictionary * params = @{@"hostID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"accountType":@"ios",@"start":@"0",@"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]};
//                        [JZGeneralApi getDetailUserBlock:params getDetailBlock:^(JZCustomer *user, NSArray *records, NSInteger allcounts, NSError *error) {
//                            if (error) {
//                                nil;
//                            }else{
//                                block.mine = user;
//                                [block reloadMineData];
//                            }
//                        }];
//                        if (block.redirect1Block) {
//                            [block.navigationController popViewControllerAnimated:YES];
//                        }else{
//                            [JZTools showMessage:@"登录成功"];
//                            [block.navigationController popToRootViewControllerAnimated:YES];
//                            //显示个人信息页面
//                            block.personInfoView.hidden = NO;
//                            block.loginView.hidden = YES;
//                            NSDictionary * params = @{@"hostID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"accountType":@"ios",@"start":@"0",@"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]};
//                            [JZGeneralApi getDetailUserBlock:params getDetailBlock:^(JZCustomer *user, NSArray *records, NSInteger allcounts, NSError *error) {
//                                if (error) {
//                                    nil;
//                                }else{
//                                    block.mine = user;
//                                    [block reloadMineData];
//                                }
//                            }];
//                        }
//                    }
//                    
//                }];
//            }];
//        }
//    }];
//}
//手机登录
-(void)phoneLogin:(UIButton *)sender{
    JZLoginViewController *vc = [[JZLoginViewController alloc]init];
    [vc setRedirectBlock:^(BOOL flag, NSError *error) {
        if (flag)
        {
            if (_redirect1Block) {
                _redirect1Block (YES, nil);
            }else{
                [JZTools showMessage:@"登录成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

//第三方登录
- (void)thirdPartyLogin:(UIButton *)sender {
    sender.enabled = NO;
    //先访问第三方应用等第三方应用授权后将第三方服务器返回的值传入下面接口(与微信类似)
    
    /*!
     * param uid   个人id必须是唯一值(必传参数)
     * param loginType  使用SDK的公司名(必传参数)
     * param nickname  昵称(必传参数)
     * param city  所在城市(不是必传参数)
     * param pic1  头像(不是必传参数)
     * param sex   性别(不是必传参数)
     */
    NSDictionary * params = @{@"uid":@"",@"loginType":@"",@"nickname":@"",@"city":@"",@"pic1":@"",@"sex":@""};
    __weak typeof(self) block = self;
    [JZGeneralApi thirdPrtyLoginWithBlock:(NSDictionary *) params getDetailBlock:^(JZCustomer *user, NSError *error) {
        if (error||[JZTools isInvalid:[NSString stringWithFormat:@"%ld",(long)user.id]]) {
            [block.navigationController popViewControllerAnimated:YES];
            [JZTools showMessage:@"登录失败"];
            sender.enabled = YES;
        }else{
            
//            [JZGeneralApi setLoginStatus:1];
//            _mine = user;
//            //保存用户信息
//            [JZTools showMessage:@"登录成功"];
//            [block reloadMineData];
        }
        sender.enabled = YES;
    }];
}
-(void)reloadMineData{
    self.personInfoView.hidden = NO;
    self.loginView.hidden = YES;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[JZTools filterHttpImage:_mine.pic1]] placeholderImage:[UIImage imageNamed:@"JZ_icon_defaultFace_116_116"]];
    if ([JZTools isInvalid:_mine.nickname]) {
        if ([JZTools isInvalid:_mine.mobile]) {
            _nameLabel.text = @"请设置昵称";
        }else {
            _nameLabel.text = _mine.mobile;
        }
    }else {
        _nameLabel.text = _mine.nickname;
    }
}

//返回
- (void)cancelLogin {
    [self.navigationController popViewControllerAnimated:YES];
}
//编辑个人信息页面
-(void)editorInfo{
    ModifyPersonalInfoTableViewController *personInfoVC = [[ModifyPersonalInfoTableViewController alloc] init];
    personInfoVC.user = self.mine;
    [self.navigationController pushViewController:personInfoVC animated:YES];
}
- (void)LogOut {
    if ([JZGeneralApi getLoginStatus]) {
        [JZGeneralApi setLoginStatus:0];//设置为未登录
        [[JZCustomer getUserdataInstance] updateWithDictionaryRepresentation:nil];
        
        NSNotification *notification =[NSNotification notificationWithName:@"QuitAccount" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString* dir = [JZTools createDirectory:@"userinfo_cache"];
        NSString* filename = @"myinfo";
        NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@", dir, filename];
        NSError *err;
        [fileManager removeItemAtPath:fileFullPath error:&err];
        JZCustomer *customer = [JZCustomer getUserdataInstance];
        customer.mobile = @"";
        customer.nickname = @"";
        customer.sex = @"";
        customer.birthday = @"";
        customer.career = @"";
        self.personInfoView.hidden = YES;
        self.loginView.hidden = NO;
    }
    
}
@end
