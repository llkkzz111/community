//
//  OCJSuggestFeedBackVC.m
//  OCJ
//
//  Created by OCJ on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSuggestFeedBackVC.h"
#import "OCJSugFeedBackTVCell.h"
#import "OCJMySugFeedBackVC.h"

@interface OCJSuggestFeedBackVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView;///<tableView
@property (nonatomic, strong) NSArray *ocjArr_dataSource;///<数据源
@property (nonatomic, strong) OCJBaseButton *ocjBtn_portrait;///<头像

@end

@implementation OCJSuggestFeedBackVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocj_setSelf];
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf{
    self.title = @"意见反馈";
    self.ocjArr_dataSource = @[@"我要给好评",@"我要提意见"];
    [self ocj_addTableView];
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.ocjTBView registerClass:[OCJSugFeedBackTVCell class] forCellReuseIdentifier:@"OCJSugFeedBackTVCellIdentifer"];
    self.ocjTBView.delegate = self;
    self.ocjTBView.dataSource = self;
    self.ocjTBView.scrollEnabled = NO;
    self.ocjTBView.showsVerticalScrollIndicator = NO;
    self.ocjTBView.tableFooterView = [[UIView alloc] init];
    self.ocjTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ocjTBView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    
    [self.view addSubview:self.ocjTBView];
    [self.ocjTBView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
#pragma mark - 协议方法实现区域
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ocjArr_dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCJSugFeedBackTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJSugFeedBackTVCellIdentifer" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.ocjBool_showLine = YES;
    }else{
        cell.ocjBool_showLine = NO;
    }
    cell.ocjLab_title.text = self.ocjArr_dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString * ocjStr_appStoreURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=524637490"];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ocjStr_appStoreURLString]];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:ocjStr_appStoreURLString]]){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ocjStr_appStoreURLString]];
        }else{
            [WSHHAlert wshh_showHudWithTitle:@"无法打开appStore评论页面" andHideDelay:1];
        }
    }else{
        [self ocj_pushVC:[[OCJMySugFeedBackVC alloc]init]];
    }
}                                                                   

@end
