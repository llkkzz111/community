//
//  OCJRegisterDetailsView.m
//  OCJ
//
//  Created by 董克楠 on 13/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRegisterDetailsView.h"
#import "OCJHttp_signInAPI.h"

#define maxRegisterDay  20       //最大签到天数

@implementation OCJRegisterDetailsView

-(instancetype)init
{
    if (self == [super init]) {
        [self coj_creatUI];
        [self ocj_creatNavUI];
    }
    return self;
}

-(id)imageWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

-(void)coj_creatUI
{
  UIImageView * ocjImg_backImag =[[UIImageView alloc] init];
  ocjImg_backImag.image = [UIImage imageNamed:@"icon_topbg_"];
  [self addSubview:ocjImg_backImag];
  [ocjImg_backImag mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.bottom.right.top.mas_equalTo(self);
  }];
  
    //鸥点
    self.ocjLabel_ouDianLabel =[[UILabel alloc] init];
    self.ocjLabel_ouDianLabel.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    [self addSubview:self.ocjLabel_ouDianLabel];
    [self.ocjLabel_ouDianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(70);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
    }];
    //签到天数
    self.ocjLabel_regisineDayNumLabel =[[UILabel alloc] init];
    self.ocjLabel_regisineDayNumLabel.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    [self addSubview:self.ocjLabel_regisineDayNumLabel];
    [self.ocjLabel_regisineDayNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLabel_ouDianLabel.mas_left);
        make.top.mas_equalTo(self.ocjLabel_ouDianLabel.mas_bottom);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
    }];
    //签到
    self.ocjBtn_registerBtn =[[UIButton alloc] init];
    self.ocjBtn_registerBtn.layer.cornerRadius = 5;
    self.ocjBtn_registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.ocjBtn_registerBtn addTarget:self action:@selector(ocj_RegisterHaveGift:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_registerBtn];
    [self.ocjBtn_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.top.mas_equalTo(75);
        make.width.mas_equalTo(102);
        make.height.mas_equalTo(35);
    }];
    
    //滑动条
    self.ocjSlider_registerSlider = [[OCJRegisterSlider alloc ] init];
    self.ocjSlider_registerSlider.maximumTrackTintColor = [UIColor whiteColor];
    self.ocjSlider_registerSlider.userInteractionEnabled = NO;
  UIImage *image = [self imageWithColor:[UIColor colorWSHHFromHexString:@"FFFFFF"]];
    [self.ocjSlider_registerSlider setThumbImage:image forState:UIControlStateNormal];
    [self.ocjSlider_registerSlider setMinimumTrackImage:[UIImage imageNamed:@"icon_line"] forState:UIControlStateNormal];
    [self.ocjSlider_registerSlider setMaximumTrackImage:[UIImage imageNamed:@"notRegisterSliderImg"] forState:UIControlStateNormal];
    [self addSubview:self.ocjSlider_registerSlider ];
    [self.ocjSlider_registerSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(43);
        make.top.mas_equalTo(169);
        make.width.mas_equalTo(SCREEN_WIDTH -86);
        make.height.mas_equalTo(4);
    }];
    
    //开始位置控件
    self.ocjImage_sliderBeginImg = [[UIImageView alloc] init];
    self.ocjImage_sliderBeginImg.image = [UIImage imageNamed:@"icon_node_"];
    [self addSubview:self.ocjImage_sliderBeginImg];
    [self.ocjImage_sliderBeginImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjSlider_registerSlider.mas_left);
        make.centerY.mas_equalTo(self.ocjSlider_registerSlider.mas_centerY).offset(.5);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(6);
    }];
    
    UILabel * ocjLabel_firstDayLabel =[[UILabel alloc] init];
    [self addSubview:ocjLabel_firstDayLabel];
    ocjLabel_firstDayLabel.text = @"第1天";
    ocjLabel_firstDayLabel.font = [UIFont systemFontOfSize:14];
    ocjLabel_firstDayLabel.textColor = [UIColor whiteColor];
    [self addSubview:ocjLabel_firstDayLabel];
    [ocjLabel_firstDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjSlider_registerSlider.mas_left).offset(-20);
        make.top.mas_equalTo(self.ocjSlider_registerSlider.mas_bottom).offset(6);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    //末端控件
    self.ocjImage_sliderEndImg = [[UIImageView alloc] init];
    self.ocjImage_sliderEndImg.image = [UIImage imageNamed:@"icon_node_white_"];
    [self addSubview:self.ocjImage_sliderEndImg];
    [self.ocjImage_sliderEndImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjSlider_registerSlider.mas_right);
        make.centerY.mas_equalTo(self.ocjSlider_registerSlider.mas_centerY);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    UILabel * ocjLabel_lastDayLabel =[[UILabel alloc] init];
    ocjLabel_lastDayLabel.text = [NSString stringWithFormat:@"第%d天",maxRegisterDay];
    ocjLabel_lastDayLabel.font = [UIFont systemFontOfSize:14];
    ocjLabel_lastDayLabel.textColor = [UIColor whiteColor];
    [self addSubview:ocjLabel_lastDayLabel];
    [ocjLabel_lastDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjSlider_registerSlider.mas_right).offset(-20);
        make.top.mas_equalTo(self.ocjSlider_registerSlider.mas_bottom).offset(6);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    self.ocjBtn_sliderGiftBtn = [[UIButton alloc] init];
    [self.ocjBtn_sliderGiftBtn addTarget:self action:@selector(receive20DayGift) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_sliderGiftBtn];
    [self.ocjBtn_sliderGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjSlider_registerSlider.mas_right).offset(-18);
        make.bottom.mas_equalTo(self.ocjSlider_registerSlider.mas_top).offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(34);
    }];
    
    //中间变化控件
    self.ocjBtn_sliderRangeBtn = [[UIButton alloc] init];
    [self.ocjBtn_sliderRangeBtn addTarget:self action:@selector(receive15DayLottery) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_sliderRangeBtn];
    [self.ocjBtn_sliderRangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjSlider_registerSlider.mas_left).offset((SCREEN_WIDTH -86) *((CGFloat)15/maxRegisterDay) -1);
        make.bottom.mas_equalTo(self.ocjSlider_registerSlider.mas_top).offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(34);
    }];
  
  //第15天图标
  self.ocjImgage_sliderFifteen = [[UIImageView alloc] init];
  self.ocjImgage_sliderFifteen.image = [UIImage imageNamed:@"icon_node_white_"];
  [self addSubview:self.ocjImgage_sliderFifteen];
  [self.ocjImgage_sliderFifteen mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.ocjBtn_sliderRangeBtn);
    make.centerY.mas_equalTo(self.ocjSlider_registerSlider.mas_centerY);
    make.width.mas_equalTo(8);
    make.height.mas_equalTo(8);
  }];
  
    self.ocjLabel_currentDayLabel =[[UILabel alloc] init];
    self.ocjLabel_currentDayLabel.font = [UIFont systemFontOfSize:14];
    self.ocjLabel_currentDayLabel.textColor = [UIColor whiteColor];
    self.ocjLabel_currentDayLabel.text = @"第15天";
    [self addSubview:self.ocjLabel_currentDayLabel];
    [self.ocjLabel_currentDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjSlider_registerSlider.mas_left).offset((SCREEN_WIDTH -86) *((CGFloat)15/maxRegisterDay) + ((maxRegisterDay-15)/maxRegisterDay)*50);
        make.top.mas_equalTo(self.ocjSlider_registerSlider.mas_bottom).offset(6);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
}

-(void)ocj_creatNavUI
{
  
    UIView * ocjView_navView = [[UIView alloc] init];
    [self addSubview:ocjView_navView];
    [ocjView_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(44);
    }];
    
    UILabel * ocjLabel_titleLabel = [[UILabel alloc] init];
    ocjLabel_titleLabel.text =@"签到中心";
    ocjLabel_titleLabel.textAlignment = NSTextAlignmentCenter;
    ocjLabel_titleLabel.font = [UIFont systemFontOfSize:17];
    ocjLabel_titleLabel.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    [ocjView_navView addSubview:ocjLabel_titleLabel];
    [ocjLabel_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ocjView_navView.mas_centerX);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
    }];
    
    UIButton * ocjBtn_rightBtn = [[UIButton alloc] init];
    [ocjBtn_rightBtn setImage:[UIImage imageNamed:@"icon_question_"] forState:UIControlStateNormal];
    [ocjBtn_rightBtn setTitle:@"活动规则" forState:UIControlStateNormal];
    [ocjBtn_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ocjBtn_rightBtn addTarget:self action:@selector(ocj_pushWithActivityRule) forControlEvents:UIControlEventTouchUpInside];
    ocjBtn_rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [ocjView_navView addSubview:ocjBtn_rightBtn];
    [ocjBtn_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ocjView_navView.mas_right).offset(-15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(63);
        make.height.mas_equalTo(17);
    }];
  ocjBtn_rightBtn.hidden = YES;
    
    UIButton * ocjBtn_leftBtn = [[UIButton alloc] init];
    [ocjBtn_leftBtn addTarget:self action:@selector(gobackNext) forControlEvents:UIControlEventTouchUpInside];
    [ocjView_navView addSubview:ocjBtn_leftBtn];
    [ocjBtn_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(31);
    }];
  
    UIImageView * ocjImg_leftImg = [[UIImageView alloc] init];
    ocjImg_leftImg.image = [UIImage imageNamed:@"icon_left"];
    [ocjBtn_leftBtn addSubview:ocjImg_leftImg];
    [ocjImg_leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(15);
      make.top.mas_equalTo(16);
      make.width.mas_equalTo(8);
      make.height.mas_equalTo(12);
    }];
}

#pragma mark ------编辑富文本方法
-(NSMutableAttributedString *)ocj_creatAttributedStringBeforeStr:(NSString *)beforeStr centerStr:(NSString *)centerStr afterStr:(NSString *)afterStr
{
  NSString * str = [NSString stringWithFormat:@"%@ %@ %@",beforeStr,centerStr,afterStr];
  
  NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
  
  [AttributedStr addAttribute:NSFontAttributeName
   
                        value:[UIFont systemFontOfSize:12]
   
                        range:[str rangeOfString:beforeStr]];
  
  [AttributedStr addAttribute:NSFontAttributeName
   
                        value:[UIFont systemFontOfSize:17.0]
   
                        range:[str rangeOfString:centerStr]];
  
  [AttributedStr addAttribute:NSFontAttributeName
   
                        value:[UIFont systemFontOfSize:12]
   
                        range:[str rangeOfString:afterStr]];
  return AttributedStr;
}

#pragma mark  --------btn event
//领取彩票
-(void)receive15DayLottery
{
  if ([self.delegate respondsToSelector:@selector(ocj_pushWith15DayLotteryVC)]) {
    [self.delegate ocj_pushWith15DayLotteryVC];
  }
  self.ocjBtn_sliderRangeBtn.hidden = NO;
}

//领取礼包
-(void)receive20DayGift
{
  if ([self.delegate respondsToSelector:@selector(ocj_pushWith20DayGiftVC)]) {
    [self.delegate ocj_pushWith20DayGiftVC];
  }
}

//活动规则
-(void)ocj_pushWithActivityRule
{
  if ([self.delegate respondsToSelector:@selector(ocj_pushWithActivityRuleVC)]) {
    [self.delegate ocj_pushWithActivityRuleVC];
  }
}

-(void)gobackNext
{
  if ([self.delegate respondsToSelector:@selector(ocj_popWithNextVC)]) {
    [self.delegate ocj_popWithNextVC];
  }
}

-(void)ocj_RegisterHaveGift:(UIButton *)btn
{
    [OCJHttp_signInAPI OCJRegister_getSigningRecordcheck_inCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjDic_data[@"str_yn"] isEqualToString:@"OK"]) {
          //刷新个人中心
          [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
          //刷新鸥点详情
          [[NSNotificationCenter defaultCenter] postNotificationName:@"OCJReloadEurope" object:nil];
            btn.enabled = NO;
            [btn setTitle:@"已签到" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor =[UIColor clearColor];
            btn.layer.borderWidth =1;
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
  
            self.registerDay = [responseModel.ocjDic_data[@"days"] intValue];
            
            self.ocjSlider_registerSlider.value = ((CGFloat)1/20)*self.registerDay;
  
            //起始点图标
            if (self.registerDay !=0) {
                self.ocjImage_sliderBeginImg.hidden = NO;
            }else{
                self.ocjImage_sliderBeginImg.hidden = YES;
            }
          
            //终点图标是否显示
            if (self.registerDay != maxRegisterDay) {
                self.ocjImage_sliderEndImg.hidden = NO;
            }else{
                self.ocjImage_sliderEndImg.hidden = YES;
            }
          
            self.ocjLabel_regisineDayNumLabel.attributedText = [self ocj_creatAttributedStringBeforeStr:@"本月已签到" centerStr:[NSString stringWithFormat:@"%ld",(long)self.registerDay] afterStr:@"天"];
  
            //进度标注图
            if ([self.model.ocjStr_fctG isEqualToString:@"fctY"]) {
              self.ocjBtn_sliderRangeBtn.hidden = YES;
            }
          
            if (self.registerDay < 15 ) {
              [self.ocjBtn_sliderRangeBtn setBackgroundImage:[UIImage imageNamed:@"icon_reward_white_"] forState:UIControlStateNormal];
              self.ocjBtn_sliderRangeBtn.enabled = NO;
            }else{
              [self.ocjBtn_sliderRangeBtn setBackgroundImage:[UIImage imageNamed:@"icon_reward_"] forState:UIControlStateNormal];
              self.ocjBtn_sliderRangeBtn.enabled = YES;
            }
  
            //20天礼包图
            if (self.registerDay < 20 ) {
              [self.ocjBtn_sliderGiftBtn setBackgroundImage:[UIImage imageNamed:@"icon_gift_"] forState:UIControlStateNormal];
              self.ocjBtn_sliderGiftBtn.enabled = NO;
            }else{
              [self.ocjBtn_sliderGiftBtn setBackgroundImage:[UIImage imageNamed:@"icon_gift_yellow_"] forState:UIControlStateNormal];
              self.ocjBtn_sliderGiftBtn.enabled = YES;
            }
  
        }
    }];
}

#pragma mark ---------刷数据
-(void)setModel:(OCJRegisterInfoModel *)model
{
    _model = model;
    self.registerDay = self.model.ocjStr_monthDay.intValue > 20 ? 20 : self.model.ocjStr_monthDay.intValue;
    //鸥点数
    NSMutableAttributedString * ouDianAttributedStr = [self ocj_creatAttributedStringBeforeStr:@"您有" centerStr:self.model.ocjStr_opoint_money afterStr:@"鸥点"];
    self.ocjLabel_ouDianLabel.attributedText = ouDianAttributedStr;
    //签到天数
    NSMutableAttributedString * registerAttributedStr = [self ocj_creatAttributedStringBeforeStr:@"本月已签到" centerStr:[NSString stringWithFormat:@"%ld",(long)self.registerDay] afterStr:@"天"];
    self.ocjLabel_regisineDayNumLabel.attributedText = registerAttributedStr;
    //是否签到 按钮
    if ([self.model.ocjStr_signYn isEqualToString:@"todayY"]) {
        self.ocjBtn_registerBtn.enabled = NO;
        [self.ocjBtn_registerBtn setTitle:@"已签到" forState:UIControlStateNormal];
        [self.ocjBtn_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.ocjBtn_registerBtn.backgroundColor =[UIColor clearColor];
        self.ocjBtn_registerBtn.layer.borderWidth =1;
        self.ocjBtn_registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        [self.ocjBtn_registerBtn setTitle:@"签到得好礼" forState:UIControlStateNormal];
        [self.ocjBtn_registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.ocjBtn_registerBtn.backgroundColor = [UIColor whiteColor];
    }
    //滑块距离
    self.ocjSlider_registerSlider.value =((CGFloat)1/20)*self.registerDay;//开始默认值
    if (self.registerDay >= 15) {
//        [self.ocjSlider_registerSlider setThumbImage:[UIImage imageNamed:@"icon_node_select_"] forState:UIControlStateNormal];//滑块图
//      [self.ocjSlider_registerSlider setThumbImage:[self imageWithColor:[UIColor colorWSHHFromHexString:@"FFFFFF"]] forState:UIControlStateNormal];//滑块图
      [self.ocjImgage_sliderFifteen setImage:[UIImage imageNamed:@"icon_node_select_"]];
      [self.ocjImgage_sliderFifteen mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@16);
      }];
      [self bringSubviewToFront:self.ocjImgage_sliderFifteen];
    }else{
        [self.ocjSlider_registerSlider setThumbImage:[self imageWithColor:[UIColor colorWSHHFromHexString:@"FFFFFF"]] forState:UIControlStateNormal];//滑块图
    }
    //起始点图标
    if (self.registerDay !=0) {
        self.ocjImage_sliderBeginImg.hidden = NO;
    }else{
        self.ocjImage_sliderBeginImg.hidden = YES;
    }
    [self addSubview:self.ocjImage_sliderBeginImg];
    
    //终点图标是否显示
    if (self.registerDay != maxRegisterDay) {
        self.ocjImage_sliderEndImg.hidden = NO;
    }else{
        self.ocjImage_sliderEndImg.hidden = YES;
    }
    //15天彩票
    if ([self.model.ocjStr_fctG isEqualToString:@"fctY"]) {
      self.ocjBtn_sliderRangeBtn.hidden = YES;
    }
    if (self.registerDay < 15 ) {
      [self.ocjBtn_sliderRangeBtn setBackgroundImage:[UIImage imageNamed:@"icon_reward_white_"] forState:UIControlStateDisabled];
      self.ocjBtn_sliderRangeBtn.enabled = NO;
    }else{
      [self.ocjBtn_sliderRangeBtn setBackgroundImage:[UIImage imageNamed:@"icon_reward_"] forState:UIControlStateNormal];
      self.ocjBtn_sliderRangeBtn.enabled = YES;
    }
    //20天礼包图
  if ([self.model.ocjStr_liBaoYn isEqualToString:@"liBaoY"]) {
    self.ocjBtn_sliderGiftBtn.hidden = YES;
  }
    if (self.registerDay < 20 ) {
        [self.ocjBtn_sliderGiftBtn setBackgroundImage:[UIImage imageNamed:@"icon_gift_"] forState:UIControlStateDisabled];
        self.ocjBtn_sliderGiftBtn.enabled = NO;
    }else{
        [self.ocjBtn_sliderGiftBtn setBackgroundImage:[UIImage imageNamed:@"icon_gift_yellow_"] forState:UIControlStateNormal];
        self.ocjBtn_sliderGiftBtn.enabled = YES;
      self.ocjImage_sliderEndImg.hidden = NO;
      [self.ocjImage_sliderEndImg setImage:[UIImage imageNamed:@"icon_node_select_"]];
      [self.ocjImage_sliderEndImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@16);
      }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
