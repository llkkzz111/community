//
//  JZTools.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/16.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "JZTools.h"
//static NSString * const EXPRESS_URL = @"http://jizhalive.cn:8080";
@implementation JZTools
//过滤头像
+ (NSString *)filterHttpImage:(NSString *)imageString {
    NSString *str1 = imageString;
    NSString *str = @"http://";
    NSString *imageStr = @"";
    if ([str1 rangeOfString:str].location != NSNotFound) {
        //NSLog(@"user.pic1中有http://");
        imageStr = imageString;
    }else{
        //NSLog(@"user.pic1中没有http://");
        imageStr = [NSString stringWithFormat:@"%@%@",@"",imageString];
    }
    return imageStr;
}

//提示框
+ (void)showMessage:(NSString*)message {
    [self showMessage:message time:1.0];
}
+ (void)showMessage:(NSString*)message time:(float)time {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(20, 10, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    label.numberOfLines = 0;
    
    //提示框的位置
    showview.frame = CGRectMake((window.frame.size.width - LabelSize.width - 20)/2, window.frame.size.height/2-20, LabelSize.width+40, LabelSize.height+20);
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0.5f;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188
     * 联通：130,131,132,155,156,185,186,145,176,185
     * 电信：133,153,180,181,189,173,177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|8[23478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56]|45|76)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181,173,177
     22         */
    NSString * CT = @"^1((33|53|8[019]|73|77)[0-9]|34)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }else {
        return NO;
    }
}
//空值处理
+ (NSString*)convertNull:(id)object {
    // 转换空串
    if ([object isEqual:[NSNull null]]) {
        return @"";
    } else if ([object isKindOfClass:[NSNull class]]) {
        return @"";
    } else if (object==nil){
        return @"";
    }
    return object;
}

//是否为空值
+ (BOOL)isInvalid:(id)object {
    if ([object isEqual:[NSNull null]]||[object isKindOfClass:[NSNull class]]||(object==nil)||[object isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
//提示框
+ (void)showSimpleAlert:(NSString*)titleStr content:(NSString*) content curView:(UIViewController*)curView {
    NSString *title = NSLocalizedString(titleStr, nil);
    NSString *message = NSLocalizedString(content, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the action.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The simple alert's cancel action occured.");
        
    }];
    
    // Add the action.
    [alertController addAction:cancelAction];
    
    [curView presentViewController:alertController animated:YES completion:^(void){
        
    }];
}


//正则匹配用户密码6-16位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

//验证用户名
+ (BOOL)checkUserName:(NSString *)userName {
    // 匹配中文，英文字母和数字及_ 同时判断长度
    NSString *pattern = @"[\u4e00-\u9fa5_a-zA-Z0-9_]{2,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}
//产生随机数
+ (NSString*)getRandomStringNum:(NSInteger)length {
    NSArray *num_arr = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
    NSString *retStr = @"";
    for (NSInteger i=0; i<length; i++) {
        NSInteger x = arc4random() % [num_arr count];
        retStr = [retStr stringByAppendingString:[num_arr objectAtIndex:x]];
    }
    return retStr;
}

//获取系统指定NSDocumentDirectory的存储路径
+ (NSString *)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}

//创建Document文件夹里面的指定文件
+ (NSString*)createDirectory:(NSString*)directory {
    NSString *documentsPath =[self getDocumentDirectory];
    NSString *file = [documentsPath stringByAppendingPathComponent:directory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {//不存在指定文件
        // 创建目录
        BOOL res=[[NSFileManager defaultManager] createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            //NSLog(@"文件夹创建成功");
            return  file;
        }else{
            //NSLog(@"文件夹创建失败");
            return nil;
        }
    }
    else{//指定文件已存在
        //NSLog(@"文件夹已经存在");
        return  file;
    }
}

//保存用户信息到文件中
+ (void)saveUserInfo:(NSString *)savePath userInfo:(NSString *)userInfo fileName:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName1]) {//附件存在
        if (![fileManager fileExistsAtPath:savePath]) {
            [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [fileManager createFileAtPath:fileName1 contents:[userInfo dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }else{//附件不存在
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:savePath]) {//存储目录不存在,就创建存储目录
            [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [fileManager createFileAtPath:fileName1 contents:[userInfo dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
}

//获取用户信息
+ (NSString*)getUserInfo:(NSString *)savePath fileName:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    NSString *content = @"";//默认为空(不存在就返回空)
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName1]) {//存在
        content = [NSString stringWithContentsOfFile:fileName1 encoding:NSUTF8StringEncoding error:nil];
    }
    return  content;
}
//tableView 滚动到底部方法一(适合用于cell高度一样,可以选择哪一个section的底部)
+ (void)scrollTableViewToBottom:(UITableView *)tableView tableViewCellArray:(NSArray *)cellArray inSection:(NSInteger)sectionNum animation:(BOOL)animated {
    NSIndexPath *index=[NSIndexPath indexPathForItem:cellArray.count-1 inSection:sectionNum];
    [tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}
//tableView 滚动到底部方法一(适合用于cell高度不同,只能是tableView的底部)
+ (void)scrollTableViewToBottom2:(UITableView *)tableView tableViewCellArray:(NSArray *)cellArray animation:(BOOL)animated {
    if (tableView.contentSize.height > tableView.frame.size.height) {
        CGPoint offset = CGPointMake(0, tableView.contentSize.height - tableView.frame.size.height);
        [tableView setContentOffset:offset animated:animated];
    }
}

////在view上添加button
//+ (UIButton *)inViewAddButton:(UIView *)view buttonName:(UIButton *)name buttonFrame:(CGRect)buttonFrame buttonBackgroundcolor:(UIColor *)backgroundColor buttonTitle:(NSString *)title titleFont:(NSInteger)fontSize titleColor:(UIColor *)titleColor buttonImage:(NSString *)buttonImage {
//    name = [[UIButton alloc] init];
//    name.frame = buttonFrame;
//    name.backgroundColor = backgroundColor;
//    [name setTitle:title forState:UIControlStateNormal];
//    [name setTitleColor:titleColor forState:UIControlStateNormal];
//    [name.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
//    name.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [name setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
//    //[name addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:name];
//    return name;
//}
//
////在view上添加UILabel
//+ (UILabel *)inViewAddLabel:(UIView *)view name:(UILabel *)name frame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleFont:(NSInteger)fontSize titleColor:(UIColor *)titleColor {
//    name = [[UILabel alloc] init];
//    name.frame = frame;
//    name.backgroundColor = backgroundColor;
//    name.text = title;
//    name.font = [UIFont systemFontOfSize:fontSize];
//    name.textColor = titleColor;
//    [view addSubview:name];
//    return name;
//}
//
////在view上添加view
//+ (UIView *)inViewAddView:(UIView *)view name:(UIView *)name frame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor{
//    
//    return name;
//}

//计算字符串宽度(默认是系统字体)
+ (float)computeStringWidth:(NSString *)string stringFont:(CGFloat)font limitHeight:(CGFloat)height {
    CGRect detailSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return detailSize.size.width;
}

//计算字符串高度(默认是系统字体)
+ (float)computeStringHeight:(NSString *)string stringFont:(CGFloat)font limitWidth:(CGFloat)width {
    CGRect detailSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return detailSize.size.height;
}

@end
