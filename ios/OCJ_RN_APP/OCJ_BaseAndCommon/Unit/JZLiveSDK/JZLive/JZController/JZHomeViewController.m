//
//  JZHomeViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//
//#import "JZConstants.h"
#import "JZHomeViewController.h"
#import "ActivityTableViewCell.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "JZPlayerViewController.h"

@interface JZHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *activitiesArray;
@property (nonatomic, assign) int allcounts;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL refresh;
@end

@implementation JZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activitiesArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self createTableView];
    [self addheader];
    [self addFooter];
    [self getActivitiesArray];
}
- (void)getActivitiesArray {
    __weak typeof(self) block = self;
    NSDictionary * params = @{@"orderType":@"hotest",@"start":@"0", @"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]};
    [JZGeneralApi getKindsRecordsWithBlock:params returnBlock:^(NSArray *records, NSInteger allcounts, NSError *error) {
        if (error) {
             NSLog(@"获取数据失败");
        }else {
            block.activitiesArray = [NSMutableArray arrayWithArray:records];
            block.allcounts = (int)allcounts;
            dispatch_async(dispatch_get_main_queue(), ^{
                [block.tableView reloadData];
            });
        }
    }];
}
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = MAINBACKGROUNDCOLOR;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activitiesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityTableViewCell"];
    if (cell == nil) {
        cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityTableViewCell"];
    }
    cell.record = self.activitiesArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SCREEN_WIDTH-10)*9/16+60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.userInteractionEnabled = NO;
    JZLiveRecord *record =(JZLiveRecord*)self.activitiesArray[indexPath.row];
    NSInteger living = (record.publish||record.publishDone);
    NSDictionary * params = @{@"hostID":[NSString stringWithFormat:@"%lu",(long)record.userID],@"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"accountType":@"ios",@"start":@"0",@"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]};
    __weak typeof(self) block = self;
    [JZGeneralApi getDetailUserBlock:params getDetailBlock:^(JZCustomer *user, NSArray *records, NSInteger allcounts, NSError *error) {
        if (error) {
            nil;
        }else{
            if (living) {
                JZPlayerViewController *pushVc = [[JZPlayerViewController alloc] init];
                pushVc.record = record;
                pushVc.host = user;
                pushVc.user = [JZCustomer getUserdataInstance];
                pushVc.hidesBottomBarWhenPushed = YES;
                [block.navigationController pushViewController:pushVc animated:YES];
            }else {
                nil;
            }
        }
        block.tableView.userInteractionEnabled = YES;
    }];
}

- (void)addheader {
    __weak typeof(self) block = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSDictionary * params = @{@"orderType":@"hotest",@"start":@"0", @"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]};
        [JZGeneralApi getKindsRecordsWithBlock:params returnBlock:^(NSArray *records, NSInteger allcounts, NSError *error) {
            if (error) {
                [block.tableView.mj_header endRefreshing];
            }else {
                block.activitiesArray = [NSMutableArray arrayWithArray:records];
                block.allcounts = (int)allcounts;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [block.tableView reloadData];
                    [block.tableView.mj_header endRefreshing];
                });
            }
        }];
    }];
}

- (void)addFooter {
    __weak typeof(self) block = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ((block.activitiesArray.count == block.allcounts)||(block.activitiesArray.count%50!=0)) {
            block.refresh = NO;
        }else{
            block.refresh = YES;
            block.page = (int)block.activitiesArray.count/50;
        }
        if (block.refresh) {
            NSDictionary * params = @{@"orderType":@"hotest",@"start":[NSString stringWithFormat:@"%d",block.page], @"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]};
            [JZGeneralApi getKindsRecordsWithBlock:params returnBlock:^(NSArray *records, NSInteger allcounts, NSError *error) {
                if (error) {
                    [block.tableView.mj_header endRefreshing];
                }
                else {
                    [block.activitiesArray addObjectsFromArray:records];
                    block.allcounts = (int)allcounts;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [block.tableView reloadData];
                        [block.tableView.mj_footer endRefreshing];
                    });
                }
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [block.tableView.mj_footer endRefreshing];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"兄弟别费劲了,我也是有底线的" delegate:block cancelButtonTitle:@"明白了" otherButtonTitles:nil];
                alert.tag =2202;
                [alert show];
            });
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
