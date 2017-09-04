//
//  OCJPersonalInformationVC.h
//  OCJ
//
//  Created by Ray on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"
#import "OCJHttp_personalInfoAPI.h"
#import "OCJResModel_personalInfo.h"

/**
 个人信息
 */
@interface OCJPersonalInformationVC : OCJBaseVC

@property (nonatomic, strong) OCJPersonalModel_memberInfo *ocjModel_memberInfo;

@end
