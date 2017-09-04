//
//  OCJBaseRequestModel.m
//  OCJ
//
//  Created by yangyang on 2017/4/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseRequestModel.h"
#import <objc/runtime.h>

@implementation OCJBaseRequestModel

-(NSDictionary *)ocj_getRequestDicFromSelf{
    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
    
    //获取类的所有属性名称，比对名称并赋值
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
//    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        NSString* propertyKey = [NSString stringWithUTF8String: propertyName];
        
        NSObject* value = [self valueForKey:propertyKey];
        
        if (value && ![value isKindOfClass:[NSNull class]]) {
            [mDic setValue:value forKey:propertyKey];
        }else if([propertyKey containsString:@"1"]){
            
            //必填项参数为空
            NSAssert(0, @"%@类的%@必填项参数为空,请修改",NSStringFromClass([self class]),propertyKey);
        }else{
            
            
        }
    }
    
    return [mDic copy];
}


@end
