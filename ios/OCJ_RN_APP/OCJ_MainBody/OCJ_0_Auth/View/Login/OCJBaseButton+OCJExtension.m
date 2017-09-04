//
//  OCJBaseButton+OCJExtension.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseButton+OCJExtension.h"
#import <objc/runtime.h>

NSString const *ocj_enableKey = @"disableKey";

@implementation OCJBaseButton (OCJExtension)
@dynamic ocjBool_enable;

#pragma mark - 开放接口方法区域
- (void)ocj_gradientColorWithColors:(NSArray *)colors ocj_gradientType:(OCJGradientTypeDirection )gradientType{
    UIImage *backImage = [self ocj_gradietImageWithColors:colors ocj_gradientType:gradientType];
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    [self ocj_setCornerAndShadow];
}

-(BOOL)ocjBool_enable{
    NSNumber* num = objc_getAssociatedObject(self, &ocj_enableKey);
    return [num boolValue];
}

-(void)setOcjBool_enable:(BOOL)ocjBool_enable{
    NSNumber* num = [NSNumber numberWithBool:ocjBool_enable];
    objc_setAssociatedObject(self, &ocj_enableKey, num, OBJC_ASSOCIATION_ASSIGN);
    
    if (ocjBool_enable) {
        self.userInteractionEnabled = YES;
        self.alpha = 1;
    }else{
        self.userInteractionEnabled = NO;
        self.alpha = 0.2;
    }
}


#pragma mark - 私有方法区域
- (UIImage*) ocj_gradietImageWithColors:(NSArray*)colors ocj_gradientType:(OCJGradientTypeDirection)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
            case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
            case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, 0.0);
            break;
            case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, self.frame.size.height);
            break;
            case 3:
            start = CGPointMake(self.frame.size.width, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

-(void)ocj_setCornerAndShadow{
    self.layer.cornerRadius = 2;
    [self.layer setMasksToBounds:NO];
    self.clipsToBounds = NO;
    
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity=0.4;
    self.layer.shadowRadius=2;
    self.layer.shadowColor = [UIColor colorWSHHFromHexString:@"#000000"].CGColor;
}


@end
