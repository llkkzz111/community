//
//  OCJScanView.m
//  OCJ
//
//  Created by Ray on 2017/6/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJScanView.h"

@interface OCJScanView ()

@end

@implementation OCJScanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.innerViewRect = CGRectMake(ceilf((SCREEN_WIDTH - 255)/2), ceilf((SCREEN_HEIGHT - 255)/2.5), 255, 255);
    
    [self addOtherLay:self.innerViewRect];
}

- (void)addOtherLay:(CGRect)rect {
    CAShapeLayer* layerTop   = [[CAShapeLayer alloc] init];
    layerTop.fillColor       = [UIColor colorWSHHFromHexString:@"000000"].CGColor;
    layerTop.opacity         = 0.6;
    layerTop.path            = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, rect.origin.y)].CGPath;
    [self.layer addSublayer:layerTop];
  
    CAShapeLayer* layerLeft   = [[CAShapeLayer alloc] init];
    layerLeft.fillColor       = [UIColor colorWSHHFromHexString:@"000000"].CGColor;
    layerLeft.opacity         = 0.6;
    layerLeft.path            = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.origin.y, ceilf((SCREEN_WIDTH - 255)/2), rect.size.height)].CGPath;
    [self.layer addSublayer:layerLeft];
  
    CAShapeLayer* layerRight   = [[CAShapeLayer alloc] init];
    layerRight.fillColor       = [UIColor colorWSHHFromHexString:@"000000"].CGColor;
    layerRight.opacity         = 0.6;
    layerRight.path            = [UIBezierPath bezierPathWithRect:CGRectMake(SCREEN_WIDTH - ceilf((SCREEN_WIDTH - 255)/2), rect.origin.y, ceilf((SCREEN_WIDTH - 255)/2), rect.size.height)].CGPath;
    [self.layer addSublayer:layerRight];
    
    CAShapeLayer* layerBottom   = [[CAShapeLayer alloc] init];
    layerBottom.fillColor       = [UIColor colorWSHHFromHexString:@"000000"].CGColor;
    layerBottom.opacity         = 0.6;
    layerBottom.path            = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.origin.y + rect.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - rect.origin.y - rect.size.height)].CGPath;
    [self.layer addSublayer:layerBottom];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
