//
//  NSString+WSHHExtension.h
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WSHHExtension)

/*
 计算文本宽度
 
 @param textFont 字体
 @param height 高度
 @return  文本宽度
 */
- (CGFloat)wshh_getWidthWithFont:(UIFont *)textFont
                          height:(CGFloat)height;



@end


/**
 字符串加密
 */
@interface NSString (Encryption)


/**
 MD5 加密

 @return 加密后的字符串
 */
-(NSString*)wshh_stringEncryptionWithMD5;


/**
 安全哈希算法
 
 @return 加密后的字符串
 */
-(NSString*)wshh_stringEncryptionWithSHA1;


/**
 base64位加密字符串解密

 @return 解密后的字符串
 */
- (NSString*)wshh_base64Decode;

@end





