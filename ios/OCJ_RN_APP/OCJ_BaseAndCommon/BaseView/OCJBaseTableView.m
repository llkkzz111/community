//
//  OCJBaseTableView.m
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseTableView.h"
#import "MJRefresh.h"

@interface OCJBaseTableView()
//@property (nonatomic,strong) UIImageView    *ocjImageView_noData;

@end;

@implementation OCJBaseTableView

#pragma mark - public method


-(void)ocj_prepareRefreshing{
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.mj_header.automaticallyChangeAlpha = YES;
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.mj_footer.automaticallyHidden = YES;
    
}

- (void)ocj_footRefreshing {
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.mj_footer.automaticallyHidden = YES;
}

-(void)ocj_endHeaderRefreshing{
    
    [self.mj_header endRefreshing];
    
}

-(void)ocj_endFooterRefreshingWithIsHaveMoreData:(BOOL)isHaveMoreData{
    
    [self.mj_footer endRefreshing];
    MJRefreshAutoNormalFooter* footer = (MJRefreshAutoNormalFooter*)self.mj_footer;
    if (isHaveMoreData) {
        
        [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
        
    }else{
        [footer setTitle:@"无更多数据" forState:MJRefreshStateIdle];
    }
    
}

#pragma mark - loops
-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - private method
-(void)headerRefresh{
    
    if (self.ocjBlock_headerRefreshing) self.ocjBlock_headerRefreshing();
}

-(void)footerRefresh{
        
    if (self.ocjBlock_footerRefreshing) self.ocjBlock_footerRefreshing();
}






@end
