//
//  OCJBaseNC.m
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseNC.h"
#import "UIImage+WSHHExtension.h"

@interface OCJBaseNC ()

@end

@implementation OCJBaseNC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageWSHHWithColor:[UIColor colorWSHHFromHexString:@"#FFFFFF"]] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:OCJ_COLOR_DARK,NSFontAttributeName:[UIFont systemFontOfSize:17]};
    self.navigationBar.tintColor = OCJ_COLOR_DARK_GRAY;
}

@end
