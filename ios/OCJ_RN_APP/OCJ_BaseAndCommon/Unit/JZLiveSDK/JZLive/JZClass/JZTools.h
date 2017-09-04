//
//  JZTools.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/16.
//  Copyright © 2017年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JZTools : NSObject
//过滤图片(加保护)
+ (NSString *)filterHttpImage:(NSString *)imageString;

//提示框在window上显示
+ (void)showMessage:(NSString*)message;//1s
+ (void)showMessage:(NSString*)message time:(float)time;//自定义时间

//判断是否为手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//空值处理
+ (NSString*)convertNull:(id)object;

//是否为空值
+ (BOOL)isInvalid:(id)object;

//提示框
+ (void)showSimpleAlert:(NSString*)titleStr content:(NSString*) content curView:(UIViewController*)curView;

//密码检查,正则匹配用户密码6-16位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;

//验证用户名
+ (BOOL)checkUserName:(NSString *)userName;

//产生随机数
+ (NSString*)getRandomStringNum:(NSInteger)length;

//获取系统指定NSDocumentDirectory的存储路径
+ (NSString *)getDocumentDirectory;

//创建Document文件夹里面的指定文件
+ (NSString*)createDirectory:(NSString*)directory;

//保存用户信息到文件中
+ (void)saveUserInfo:(NSString *)savePath userInfo:(NSString *)userInfo fileName:(NSString *)fileName;

//获取用户信息
+ (NSString*)getUserInfo:(NSString *)savePath fileName:(NSString *)fileName;

//tableView 滚动到底部方法一(适合用于cell高度一样,可以选择哪一个section的底部)
+ (void)scrollTableViewToBottom:(UITableView *)tableView tableViewCellArray:(NSArray *)cellArray inSection:(NSInteger)sectionNum animation:(BOOL)animated;

//tableView 滚动到底部方法一(适合用于cell高度不同,只能是tableView的底部)
+ (void)scrollTableViewToBottom2:(UITableView *)tableView tableViewCellArray:(NSArray *)cellArray animation:(BOOL)animated;
////在view上添加button(默认居中,有图片和title)
//+ (UIButton *)inViewAddButton:(UIView *)view buttonName:(UIButton *)name buttonFrame:(CGRect)buttonFrame buttonBackgroundcolor:(UIColor *)backgroundColor buttonTitle:(NSString *)title titleFont:(NSInteger)fontSize titleColor:(UIColor *)titleColor buttonImage:(NSString *)buttonImage;
//
////在view上添加UILabel
//+ (UILabel *)inViewAddLabel:(UIView *)view name:(UILabel *)name frame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleFont:(NSInteger)fontSize titleColor:(UIColor *)titleColor;
//
////在view上添加view
//+ (UIView *)inViewAddView:(UIView *)view name:(UIView *)name frame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;
//
////在view上添加textView
//+ (UITextView *)inViewAddTextView:(UIView *)view name:(UITextView *)name frame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor font:(NSInteger)fontSize placeholder:(NSString *)placeholder;
////在view上添加imageView
//+ (UIImageView *)inViewAddImageView:(UIView *)view name:(UIImageView *)name frame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;
////在view上添加scrollView
////在view上添加collectionView
//
////计算字符串宽度(默认是系统字体)
//+ (float)computeStringWidth:(NSString *)string stringFont:(CGFloat)font limitHeight:(CGFloat)height;
//
////计算字符串高度(默认是系统字体)
//+ (float)computeStringHeight:(NSString *)string stringFont:(CGFloat)font limitWidth:(CGFloat)width;

@end
