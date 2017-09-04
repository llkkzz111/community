//
//  OCJLockSliderTVCell.m
//  OCJ
//
//  Created by wb_yangyang on 2017/4/28.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJLockSliderTVCell.h"
#import "OCJLockSliderView.h"

@interface OCJLockSliderTVCell () <OCJLockSliderViewDelegate>
@property (weak, nonatomic) IBOutlet OCJBaseLabel *ocjLabel_tip; ///< 提示文本框
@property (weak, nonatomic) IBOutlet UIImageView *ocjImage_tipIcon; ///< 提示图片

@property (nonatomic,strong) OCJLockSliderView* ocjView_slider; ///< 滑动卡
@property (nonatomic) OCJLockSliderEnum ocjLockSliderEnumType;

@end

@implementation OCJLockSliderTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.ocjLabel_tip.text = @"密码三次输入错误，请通过验证";
    self.ocjLabel_tip.textColor = [UIColor colorWSHHFromHexString:@"#EF7F6E"];
    
    self.ocjImage_tipIcon.image = [UIImage imageNamed:@"auth_tipBell"];
    
    self.ocjView_slider = [[OCJLockSliderView alloc]initWithFrame:CGRectMake(20, 45, SCREEN_WIDTH-40, 44)];
    [self.ocjView_slider ocj_setColorForBackgroud:[UIColor colorWSHHFromHexString:@"#EEEEEE"] foreground:[UIColor colorWSHHFromHexString:@"#FAD4CF"] thumb:[UIColor colorWSHHFromHexString:@"E5290D"] border:nil textColor:OCJ_COLOR_DARK_GRAY];
    [self.ocjView_slider ocj_setThumbBeginImage:[UIImage imageNamed:@"auth_lock"] finishImage:[UIImage imageNamed:@"auth_lock"]];
    self.ocjView_slider.ocjLabel.text = @"向右滑动到底部";
    self.ocjView_slider.ocjDelegate = self;
    [self.contentView addSubview:self.ocjView_slider];
    
    
    
}

#pragma mark - OCJLockSliderViewDelegate
- (void)ocj_sliderValueChanging:(OCJLockSliderView *)slider{
    if (slider.ocjFloat_value==1) {
        slider.ocjLabel.text = @"验证完成";
        slider.thumbBack = NO;
        slider.ocjView_touch.userInteractionEnabled = NO;
        [slider ocj_setSliderValue:1.0 animation:NO completion:nil];
        
        if ([self.ocjDelegate respondsToSelector:@selector(ocj_sliderCheckDone)]) {
            [self.ocjDelegate ocj_sliderCheckDone];
        }
    }else if([slider.ocjLabel.text isEqualToString:@"验证完成"]){
        
        [self ocj_resetSlider:self.ocjLockSliderEnumType];
        if ([self.ocjDelegate respondsToSelector:@selector(ocj_sliderCheckCancel)]) {
            [self.ocjDelegate ocj_sliderCheckCancel];
        }
        
    }
    
}

-(void)ocj_resetSlider:(OCJLockSliderEnum)status {
    self.ocjLockSliderEnumType = status;
    if (status == 0) {
        self.ocjLabel_tip.hidden = NO;
        self.ocjImage_tipIcon.hidden = NO;
    }else {
        self.ocjLabel_tip.hidden = YES;
        self.ocjImage_tipIcon.hidden = YES;
    }
    
    __weak OCJLockSliderTVCell* weakSelf = self;
    [self.ocjView_slider ocj_setSliderValue:0.0 animation:NO completion:^(BOOL finish) {
        weakSelf.ocjView_slider.ocjView_touch.userInteractionEnabled = YES;
        weakSelf.ocjView_slider.thumbBack = YES;
        weakSelf.ocjView_slider.ocjLabel.text = @"向右滑动到底部";
    }];
}

- (void)setOcjLockSliderEnumType:(OCJLockSliderEnum )ocjLockSliderEnumType {
    _ocjLockSliderEnumType = ocjLockSliderEnumType;
}

@end
