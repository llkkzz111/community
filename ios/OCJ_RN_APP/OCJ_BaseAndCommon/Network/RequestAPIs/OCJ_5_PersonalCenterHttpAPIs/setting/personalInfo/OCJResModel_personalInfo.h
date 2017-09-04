//
//  OCJResModel_personalInfo.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@interface OCJResModel_personalInfo : OCJBaseResponceModel

@end

/**
 修改手机号model
 */
@interface OCJPersonalModel_changeMobile : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_result;    ///<修改手机号结果

@end

/**
 修改邮箱model
 */
@interface OCJPersonalModel_changeEmail : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_result;    ///<修改邮箱结果

@end


/**
 会员信息model
 */
@class OCJPersonalModel_memberInfoDesc;
@class OCJPersonalModel_DefaultAdressDesc;
@interface OCJPersonalModel_memberInfo : OCJBaseResponceModel

@property (nonatomic, strong) OCJPersonalModel_memberInfoDesc *ocjModel_memberDesc; ///<会员信息详情
@property (nonatomic, strong) OCJPersonalModel_DefaultAdressDesc  *ocjModel_AdressDesc; ///会员默认分站信息
@property (nonatomic, copy) NSString *ocjStr_headPortrait;                          ///<头像地址

@end

/**
 会员信息详情model
 */
@interface OCJPersonalModel_memberInfoDesc : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_nickName;      ///<昵称
@property (nonatomic, copy) NSString *ocjStr_userName;      ///<用户名
@property (nonatomic, copy) NSString *ocjStr_email1;        ///<邮箱第一段
@property (nonatomic, copy) NSString *ocjStr_email2;        ///<邮箱第二段
@property (nonatomic, copy) NSString *ocjStr_mobile;        ///<手机号
@property (nonatomic, copy) NSString *ocjStr_mobile1;       ///<手机号第一段
@property (nonatomic, copy) NSString *ocjStr_mobile2;       ///<手机号第二段
@property (nonatomic, copy) NSString *ocjStr_mobile3;       ///<手机号第三段
@property (nonatomic, copy) NSString *ocjStr_birthYear;     ///<生日年
@property (nonatomic, copy) NSString *ocjStr_birthMonth;    ///<生日月
@property (nonatomic, copy) NSString *ocjStr_birthDay;      ///<生日日

@end

/**
 会员默认分站model
 */
@interface OCJPersonalModel_DefaultAdressDesc : OCJBaseResponceModel
@property (nonatomic, copy) NSString *ocjStr_placeGb;       ///10 家庭 20 公司
@property (nonatomic, copy) NSString *ocjStr_addr;      ///<
@property (nonatomic, copy) NSString *ocjStr_province;      ///<
@property (nonatomic, copy) NSString *ocjStr_city;      ///<
@property (nonatomic, copy) NSString *ocjStr_area;      ///<
@property (nonatomic, copy) NSString *ocjStr_provinceName;      ///<
@property (nonatomic, copy) NSString *ocjStr_cityName;      ///<
@property (nonatomic, copy) NSString *ocjStr_areaName;      ///<

@end
