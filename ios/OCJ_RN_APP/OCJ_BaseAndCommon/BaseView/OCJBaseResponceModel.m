//
//  OCJBaseResponceModel.m
//  OCJ
//
//  Created by yangyang on 2017/5/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"
#import <objc/runtime.h>

@implementation OCJBaseResponceModel

- (instancetype)initOCJSubResponceModelSetValuesWithBaseResponceModel:(OCJBaseResponceModel *)baseModel{
    self = [super init];
    if (self) {
        self.ocjStr_code = baseModel.ocjStr_code;
        self.ocjStr_message = baseModel.ocjStr_message;
        [self ocj_dealWithNullProperty];
        [self setValuesForKeysWithDictionary:baseModel.ocjDic_data];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    
    if (self) {
        [self ocj_dealWithNullProperty];
    }
    return self;
    
}

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        
        if ([key isEqualToString:@"code"]) {
            self.ocjStr_code = [NSString stringWithFormat:@"%@",[value description]];
            
        }else if ([key isEqualToString:@"message"]){
            
            self.ocjStr_message = [value description];
        }else if ([key isEqualToString:@"data"] && [value isKindOfClass:[NSDictionary class]]){
            
            self.ocjDic_data = value;
        }else if ([key isEqualToString:@"data"] && [value isKindOfClass:[NSArray class]]){
            
            self.ocjDic_data = @{@"result":value};
        }
    }
}

/**
 处理网络请求model的属性
 */
- (void)ocj_dealWithNullProperty{
    //获取类的所有属性名称，比对名称并赋值
    u_int count;
    Ivar * ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++)
    {
        Ivar ivar = ivars[i];
        NSMutableString* propertyKey = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
        
        NSString* propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        propertyType = [propertyType stringByReplacingOccurrencesOfString:@"@\"" withString:@""];
        propertyType = [propertyType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        NSObject* value = [self valueForKey:propertyKey];
        Class propertyClass = NSClassFromString(propertyType);

        if ([value isKindOfClass:[NSNull class]] || value ==nil) {
            if ([propertyType isEqualToString:@"NSString"]) {
                [self setValue:@"" forKey:propertyKey];
                
            }else if( [propertyType isEqualToString:@"NSDictionary"]){
                
                [self setValue:@{} forKey:propertyKey];
            }else if( [propertyType isEqualToString:@"NSArray"]){
                
                [self setValue:@[] forKey:propertyKey];
            }else if ([propertyClass isSubclassOfClass:[OCJBaseResponceModel class]]){
                
                OCJBaseResponceModel* model = [[propertyClass alloc]init];
                [self setValue:model forKey:propertyKey];
            }
        }
        
    }
}







@end
