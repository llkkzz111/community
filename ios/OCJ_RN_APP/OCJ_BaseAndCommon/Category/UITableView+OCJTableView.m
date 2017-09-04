//
//  UITableView+OCJTableView.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "UITableView+OCJTableView.h"
#import <objc/runtime.h>
@interface UITableView ()

@property (nonatomic,strong) UIImageView *ocjImageView_noData; /**< 占位文字label */
@property (nonatomic, strong) NSString *ocjStr_tipData;

@end


@implementation UITableView(OCJTableView)

+(void)load
{
    //交换reloadData方法
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(reloadData)), class_getInstanceMethod(self, @selector(ocj_reloadData)));
    
    //交换insertSections方法
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(insertSections:withRowAnimation:)),class_getInstanceMethod(self,@selector(ocj_insertSections:withRowAnimation:)));
    
    //交换insertRowsAtIndexPaths方法
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(insertRowsAtIndexPaths:withRowAnimation:)),  class_getInstanceMethod(self, @selector(ocj_insertRowsAtIndexPaths:withRowAnimation:)));
    
    //交换deleteSections方法
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(deleteSections:withRowAnimation:)),class_getInstanceMethod(self,@selector(ocj_deleteSections:withRowAnimation:)));
    
    //交换deleteRowsAtIndexPaths方法
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(deleteRowsAtIndexPaths:withRowAnimation:)),class_getInstanceMethod(self,@selector(ocj_deleteRowsAtIndexPaths:withRowAnimation:)));
}

//reloadData
-(void)ocj_reloadData
{
    [self ocj_reloadData];
    
    [self ocj_reloadIsNOData];
}

//insert
-(void)ocj_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self ocj_insertSections:sections withRowAnimation:animation];
    [self ocj_reloadIsNOData];
}

-(void)ocj_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self ocj_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self ocj_reloadIsNOData];
}

//delete
-(void)ocj_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self ocj_deleteSections:sections withRowAnimation:animation];
    [self ocj_reloadIsNOData];
}

-(void)ocj_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self ocj_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self ocj_reloadIsNOData];
}

#pragma mark -- 重新设置数据
-(void)ocj_reloadIsNOData
{
    [self.ocjImageView_noData removeFromSuperview];
    
    //计算行数
    NSInteger rows = 0;
    for (int i = 0; i <  self.numberOfSections; i ++) {
        
        rows += [self numberOfRowsInSection:i];
    }
    
    //如果没有数据 或者字符串为空 就不显示
    if (rows > 0 || !self.ocjDic_NoData) {
        
        return;
    }
    
    //是否有偏移
    CGFloat height = self.contentInset.top;
    
    //判断是否有头
    if ([[self.ocjDic_NoData objectForKey:@"header"] isEqualToString:@"YES"]) {
      height += 0;
    }else {
      self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
      height += 0;
    }
    
    if (height < self.bounds.size.height/2.0-100) {
        height = self.bounds.size.height/2.0-100;
    }else {
        height += 30;
    }
  
  UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.ocjDic_NoData objectForKey:@"image"]]];
    //显示提示内容的label
    self.ocjImageView_noData = [[UIImageView alloc] init];
    [self.ocjImageView_noData setImage:image];
    [self addSubview:self.ocjImageView_noData];
    [self.ocjImageView_noData mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self);
      make.top.mas_equalTo(self.mas_top).offset(height);
      make.height.mas_equalTo(118);
      make.width.mas_equalTo(@185);
  }];
  //
  NSString *ocjStr_tip = [self.ocjDic_NoData objectForKey:@"tipStr"];
  NSArray *ocjArr = [ocjStr_tip componentsSeparatedByString:@","];
  UILabel *ocjLab_tip = [[UILabel alloc] init];
  ocjLab_tip.text = [NSString stringWithFormat:@"%@", ocjArr[0]];
  ocjLab_tip.font = [UIFont systemFontOfSize:16];
  ocjLab_tip.textColor = OCJ_COLOR_DARK;
  ocjLab_tip.textAlignment = NSTextAlignmentCenter;
  [self addSubview:ocjLab_tip];
  [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.mas_centerX).mas_offset(3);
    make.top.mas_equalTo(self.ocjImageView_noData.mas_bottom).offset(20);
  }];
  
  UILabel *ocjLab_tip2 = [[UILabel alloc] init];
  ocjLab_tip2.text = [NSString stringWithFormat:@"%@", ocjArr[1]];
  ocjLab_tip2.font = [UIFont systemFontOfSize:13];
  ocjLab_tip2.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_tip2.textAlignment = NSTextAlignmentCenter;
  [self addSubview:ocjLab_tip2];
  [ocjLab_tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.mas_centerX).mas_offset(3);
    make.top.mas_equalTo(ocjLab_tip.mas_bottom).offset(10);
  }];
}

#pragma mark -- getter & setter
//-(UIImage *)ocjImage_NoData
//{
//    return objc_getAssociatedObject(self, @selector(ocjImage_NoData));
//}

- (NSDictionary *)ocjDic_NoData {
  return objc_getAssociatedObject(self, @selector(ocjDic_NoData));
}

- (void)setOcjDic_NoData:(NSDictionary *)ocjDic_NoData {
  objc_setAssociatedObject(self, @selector(ocjDic_NoData), ocjDic_NoData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  
  [self ocj_reloadIsNOData];
}

//-(void)setOcjImage_NoData:(UIImage *)ocjImage_NoData
//{
//    objc_setAssociatedObject(self, @selector(ocjImage_NoData), ocjImage_NoData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//    [self ocj_reloadIsNOData];
//}

-(UIImageView *)ocjImageView_noData
{
    return objc_getAssociatedObject(self, @selector(ocjImageView_noData));
}

-(void)setOcjImageView_noData:(UILabel *)ocjImageView_noData
{
    objc_setAssociatedObject(self, @selector(ocjImageView_noData), ocjImageView_noData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
