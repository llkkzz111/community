//
//  OCJImageBrowseVC.m
//  OCJ
//
//  Created by Ray on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJImageBrowseVC.h"

@interface OCJImageBrowseVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *ocjScrollView;///<滚动视图
@property (nonatomic, strong) UIPageControl *ocjPageControl;///<分页

@end

@implementation OCJImageBrowseVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
    self.title = @"预览";
    self.view.backgroundColor = [UIColor blackColor];
    [self ocj_addScrollView];
}

/**
 添加scrollView
 */
- (void)ocj_addScrollView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedBGViewAction)];
    [self.view addGestureRecognizer:tap];
    
    self.ocjScrollView = [[UIScrollView alloc] init];
    self.ocjScrollView.pagingEnabled = YES;
    self.ocjScrollView.delegate = self;
    self.ocjScrollView.backgroundColor = [UIColor blackColor];
    self.ocjScrollView.showsHorizontalScrollIndicator = NO;
    self.ocjScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.ocjScrollView];
    [self.ocjScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_WIDTH);
    }];
    
    self.ocjPageControl = [[UIPageControl alloc] init];
    self.ocjPageControl.currentPageIndicatorTintColor = [UIColor colorWSHHFromHexString:@"ff2754"];
    self.ocjPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:self.ocjPageControl];
    [self.ocjPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.height.mas_equalTo(@20);
    }];
    [self ocj_addImages];
}

/**
 添加imageView
 */
- (void)ocj_addImages {
    NSInteger pageCount = self.ocjArr_image.count;
    self.ocjScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * pageCount, SCREEN_WIDTH);
    
    UIView *lastView = nil;
    for (NSInteger i = 0; i < self.ocjArr_image.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedImageViewAction)]];
        [self.ocjScrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right).offset(0);
            }else {
                make.left.mas_equalTo(self.ocjScrollView);
            }
            make.top.mas_equalTo(self.ocjScrollView);
            make.width.height.mas_equalTo(SCREEN_WIDTH);
        }];
        
        imageView.image = (UIImage *)[self.ocjArr_image objectAtIndex:i];
        
        lastView = imageView;
    }
    
    self.ocjPageControl.numberOfPages = self.ocjArr_image.count;
    self.ocjPageControl.currentPage = self.ocjInt_index;
    self.ocjScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * self.ocjInt_index, SCREEN_WIDTH);
}

#pragma mark - 协议方法实现区域
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = round(self.ocjScrollView.contentOffset.x / SCREEN_WIDTH);
    
    self.ocjPageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = round(self.ocjScrollView.contentOffset.x / SCREEN_WIDTH);
    
    [self.ocjScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * page, 0, SCREEN_WIDTH, SCREEN_WIDTH) animated:NO];
}
//点击图片
-(void)ocj_tappedImageViewAction {
    
}
//点击黑色区域
-(void)ocj_tappedBGViewAction {
    
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
