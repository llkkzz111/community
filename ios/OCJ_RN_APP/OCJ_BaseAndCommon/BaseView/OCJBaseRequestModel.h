//
//  OCJBaseRequestModel.h
//  OCJ
//
//  Created by yangyang on 2017/4/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCJBaseRequestModel : NSObject



/**
 将本类所有属性组合成字典形式

 @return 字典
 */
-(NSDictionary*)ocj_getRequestDicFromSelf;

@end
