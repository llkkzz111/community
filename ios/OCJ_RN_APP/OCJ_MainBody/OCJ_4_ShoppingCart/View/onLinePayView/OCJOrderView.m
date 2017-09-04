//
//  OCJOrderView.m
//  OCJ
//
//  Created by OCJ on 2017/5/22.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOrderView.h"

@implementation OCJOrderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
    self.ocjImgView = [[UIImageView alloc] init];
    self.ocjImgView.layer.borderColor = [UIColor colorWSHHFromHexString:@"f1f1f1"].CGColor;
    self.ocjImgView.layer.borderWidth = 1;
    [self addSubview:self.ocjImgView];
    [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];

}

- (void)ocj_setImgWithUrl:(NSString *)imgUrl{
    
    [self.ocjImgView ocj_setWebImageWithURLString:imgUrl completion:nil];
}
@end
