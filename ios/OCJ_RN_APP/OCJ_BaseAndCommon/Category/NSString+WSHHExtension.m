//
//  NSString+WSHHExtension.m
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "NSString+WSHHExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (WSHHExtension)

- (CGFloat)wshh_getWidthWithFont:(UIFont *)textFont height:(CGFloat)height{
    NSDictionary * wshh_textDic = [NSDictionary  dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil];
    CGRect wshh_textRect = [self boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:wshh_textDic context:nil];
    return wshh_textRect.size.width;
}

@end

@implementation NSString (Encryption)

-(NSString *)wshh_stringEncryptionWithMD5{
    
    const char *cStr = [self UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (unsigned int)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    
    
    //简化版本1
    //    NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    //    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
    //        [Mstr appendFormat:@"%02X",result[i]];
    //    }
    //    return Mstr;
    
    //简化版本2
    //    NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    //    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
    //        [Mstr appendFormat:@"%d",(char)result[i]];
    //    }
    //    return Mstr;
}

-(NSString *)wshh_stringEncryptionWithSHA1{
    
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [outputStr appendFormat:@"%02x", digest[i]];
    }
    
    return outputStr;
}

- (NSString*)wshh_base64Decode{
  
  NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
  
  NSString* decodeStr = [data base64EncodedStringWithOptions:0];
  
  return decodeStr;
}

@end
