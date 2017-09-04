//
//  OCJScreenAlphabeticSorting.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJScreenAlphabeticSorting.h"

@implementation OCJScreenAlphabeticSorting

+(NSDictionary *)ocj_screnAlphabeticSortingWithServicesArray:(NSArray *)array type:(OCJScreenSortType)sortType;
{
    NSMutableDictionary *dicReturn = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < array.count; i++) {
        NSString *title = @"";
        NSObject* element = array[i];
        switch (sortType) {
          case OCJScreenSortTypeHotArea:{
              OCJGSModel_HotArea* model = (OCJGSModel_HotArea*)element;
              title = model.ocjStr_areaName;
          }break;
          case OCJScreenSortTypeBrand:{
              OCJGSModel_Brand* model = (OCJGSModel_Brand*)element;
              title = model.ocjStr_brandName;
          }break;
          default:
            break;
        }
      
        NSString *strInitials = [self ocj_chChangePin:title];
        NSArray *arrayAllkey = [dicReturn allKeys];
        if ([arrayAllkey indexOfObject:strInitials] != NSNotFound) {
            NSMutableArray *arrayIndic = [dicReturn objectForKey:strInitials];
            [arrayIndic addObject:element];
            [dicReturn setObject:arrayIndic forKey:strInitials];
        }
        else
        {
            NSMutableArray *arrayIndic = [[NSMutableArray alloc] init];
            [arrayIndic addObject:element];
            [dicReturn setObject:arrayIndic forKey:strInitials];
        }
    }
    
    return dicReturn;
}

/**取拼音的首字母*/
+(NSString *)ocj_chChangePin:(NSString *)sourceString
{
    //  把汉字转换成拼音第一种方法
    NSString *str = [[NSString alloc]initWithFormat:@"%@", sourceString];
    // NSString 转换成 CFStringRef 型
    CFStringRef string1 = (CFStringRef)CFBridgingRetain(str);
    //  汉字转换成拼音
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, string1);
    //  拼音（带声调的）
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    //  去掉声调符号
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    //  CFStringRef 转换成 NSString
    NSString *strings = (NSString *)CFBridgingRelease(string);
    //  去掉空格
    NSString *cityString = [strings stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *first = [cityString substringToIndex:1];
    return [first uppercaseString];
}


@end
