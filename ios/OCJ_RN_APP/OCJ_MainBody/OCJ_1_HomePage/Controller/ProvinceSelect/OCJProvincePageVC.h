//
//  OCJProvincePageVC.h
//  OCJ
//
//  Created by 董克楠 on 8/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"
#import "OCJAreaProvinceModel.h"

@class OCJProvincePageVC;
@protocol OCJProvincePageVCDelegate <NSObject>

-(void)ocj_popWithProvniceInfo:(OCJSinglProvinceModel *)model;//选中城市代理

@end


typedef void(^OCJProvinceHandler) (OCJSinglProvinceModel* provinceModel);


/**
 分站省份选择控制器
 */
@interface OCJProvincePageVC : OCJBaseVC

@property(nonatomic,weak) id<OCJProvincePageVCDelegate>OCJProvDelegate;

@property (nonatomic,strong) OCJProvinceHandler ocjBlock_handler;

@property(nonatomic ,strong)OCJAreaProvinceListModel * ocjModel_provinceModel;//省份信息model

@end
