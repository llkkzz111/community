//
//  OCJEvaluateVC.m
//  OCJ
//
//  Created by Ray on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJEvaluateVC.h"
#import "OCJEvaluateGoodsTVCell.h"
#import "OCJEvaluateInputTVCell.h"
#import "OCJUploadImageView.h"
#import "OCJEvaluateStarsTVCell.h"
#import "OCJHttp_evaluateAPI.h"
#import "OCJResponseModel_evaluate.h"
#import "OCJRefundGoodsTVCell.h"

@interface OCJEvaluateVC ()<UITableViewDelegate, UITableViewDataSource, OCJEvaluateStarsTVCellDelegate, UITextViewDelegate>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_evaluate; ///<tableView
@property (nonatomic, strong) NSMutableArray *ocjArr_cellHeight;    ///<图片cell高度
@property (nonatomic, strong) NSArray *ocjArr_evaluate;             ///<评价类型数组
@property (nonatomic, strong) NSArray *ocjArr_level;                ///<记录评价信息字典
@property (nonatomic, strong) NSMutableArray *ocjArr_grade;         ///<商品评分数组
@property (nonatomic, strong) NSString *ocjStr_image;               ///<
@property (nonatomic, strong) NSString *ocjStr_data;                ///<

@property (nonatomic, strong) NSArray *ocjArr_order;                ///<订单详情数组
@property (nonatomic, strong) NSString *ocjStr_oederno;             ///<订单编号

@end

@implementation OCJEvaluateVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)

- (NSMutableArray *)ocjArr_grade {
    if (!_ocjArr_grade) {
        _ocjArr_grade = [[NSMutableArray alloc] init];
    }
    return _ocjArr_grade;
}

- (NSMutableArray *)ocjArr_cellHeight {
    if (!_ocjArr_cellHeight) {
        _ocjArr_cellHeight = [[NSMutableArray alloc] init];
    }
    return _ocjArr_cellHeight;
}

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)ocj_requestOrderDetail {
  
  if ([self.ocjDic_router isKindOfClass:[NSDictionary class]]) {
    self.ocjStr_oederno = [self.ocjDic_router objectForKey:@"orderNo"];
    NSString *ocjStr_orderType = [self.ocjDic_router objectForKey:@"ordertype"];
    
    [OCJHttp_evaluateAPI ocjPersonal_getOrderDetailWithOrderNo:self.ocjStr_oederno orderType:ocjStr_orderType c_code:@"2000" completionHandler:^(OCJBaseResponceModel *responseModel) {
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        if ([responseModel.ocjDic_data isKindOfClass:[NSDictionary class]]) {
          self.ocjArr_order = [responseModel.ocjDic_data objectForKey:@"items"];
          //创建评论数组
          for (int i = 0; i < self.ocjArr_order.count; i++) {
            NSDictionary *tempDic = self.ocjArr_order[i];
            
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
            [mDic setValue:[tempDic objectForKey:@"order_g_seq"] forKey:@"order_g_seq"];
            [mDic setValue:self.ocjStr_oederno forKey:@"order_no"];
            [mDic setValue:[tempDic objectForKey:@"order_d_seq"] forKey:@"order_d_seq"];
            [mDic setValue:[tempDic objectForKey:@"order_w_seq"] forKey:@"order_w_seq"];
            [mDic setValue:[tempDic objectForKey:@"item_code"] forKey:@"item_code"];
            [mDic setValue:[tempDic objectForKey:@"unit_code"] forKey:@"retUnitCode"];
            [mDic setValue:[tempDic objectForKey:@"receiver_seq"] forKey:@"receiverSeq"];
            [mDic setValue:@"" forKey:@"evaluate"];
            [mDic setValue:[NSString stringWithFormat:@"%d", 5] forKey:@"score1"];
            [mDic setValue:[NSString stringWithFormat:@"%d", 5] forKey:@"score2"];
            [mDic setValue:[NSString stringWithFormat:@"%d", 5] forKey:@"score3"];
            [mDic setValue:[NSString stringWithFormat:@"%d", 5] forKey:@"score4"];
            [self.ocjArr_grade addObject:mDic];
          }
        }
        [self.ocjTBView_evaluate reloadData];
      }
    }];
  }
  
}

- (void)ocj_setSelf {
    self.ocjStr_trackPageID = @"AP1706C002";
  
    self.title = @"写评价送鸥点";
    [self ocj_setRightItemTitles:@[@"发布"] selectorNames:@[@"ocj_issuedAction"]];
    self.ocjArr_cellHeight = [NSMutableArray arrayWithArray:@[@"105",@"105"]];
  
    self.ocjArr_evaluate = @[@"商品质量：",@"商品价格：",@"配送速度：",@"商品服务："];
    
    [self ocj_addTableView];
    [self.ocjTBView_evaluate registerClass:[OCJEvaluateGoodsTVCell class] forCellReuseIdentifier:@"OCJEvaluateGoodsTVCell"];
    [self.ocjTBView_evaluate registerClass:[OCJEvaluateInputTVCell class] forCellReuseIdentifier:@"OCJEvaluateInputTVCell"];
    [self.ocjTBView_evaluate registerClass:[OCJEvaluateStarsTVCell class] forCellReuseIdentifier:@"OCJEvaluateStarsTVCell"];
    [self.ocjTBView_evaluate registerClass:[OCJRefundGoodsBottomTVCell class] forCellReuseIdentifier:@"OCJRefundGoodsBottomTVCell"];
  
    [self ocj_requestOrderDetail];
}

-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C002C005001C003001" parmas:nil];
  
}
/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView_evaluate = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.ocjTBView_evaluate.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    self.ocjTBView_evaluate.delegate = self;
    self.ocjTBView_evaluate.dataSource = self;
    self.ocjTBView_evaluate.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_evaluate];
}

/**
 点击发布按钮
 */
- (void)ocj_issuedAction {
  [self ocj_trackEventID:@"AP1706C002C005001A001002" parmas:nil];
    
  NSMutableArray *array = [[NSMutableArray alloc] init];
  for (int i = 0; i < self.ocjArr_grade.count; i++) {
    NSMutableDictionary *mDic = self.ocjArr_grade[i];
    NSArray *ocjArr_img = [mDic objectForKey:[NSString stringWithFormat:@"imageData%d", i]];
    if (ocjArr_img.count > 0) {
      NSDictionary *dic = @{@"tag":@(i),
                            @"image":ocjArr_img};
      [array addObject:dic];
    }
  }
  if (array.count > 0) {
    for (int i = 0; i < array.count; i++) {
      NSDictionary *tempDic = [array objectAtIndex:i];
      NSInteger index = [[tempDic objectForKey:@"tag"] integerValue];
      NSArray *tempArr = [tempDic objectForKey:@"image"];
      NSMutableDictionary *mDic = self.ocjArr_grade[index];
      [OCJHttp_evaluateAPI ocjPersonal_getImageAddressWithOrderNo:self.ocjStr_oederno goodsNo:[mDic objectForKey:@"order_g_seq"] giftNo:[mDic objectForKey:@"order_d_seq"] operatonNo:[mDic objectForKey:@"order_w_seq"] retItemCode:[mDic objectForKey:@"item_code"] retUnitCode:[mDic objectForKey:@"retUnitCode"] receiverSeq:[mDic objectForKey:@"receiverSeq"] imageArr:tempArr completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          OCJResponceModel_imageAddr *model = (OCJResponceModel_imageAddr *)responseModel;
          NSString *ocjStr_imageAddr = [model.ocjArr_imageList componentsJoinedByString:@","];
          [mDic removeObjectForKey:self.ocjStr_image];
          [mDic setValue:ocjStr_imageAddr forKey:@"src"];
          [mDic removeObjectForKey:self.ocjStr_data];
          [mDic removeObjectForKey:self.ocjStr_image];
          
          NSDictionary *dataDic = @{@"evaluate_list":self.ocjArr_grade};
          if (i == self.ocjArr_grade.count - 1) {
            [self ocj_issuedOrderEvaluateWithDic:dataDic];
          }
        }
      }];
    }
  }else {
    NSDictionary *dataDic = @{@"evaluate_list":self.ocjArr_grade};
    [self ocj_issuedOrderEvaluateWithDic:dataDic];
  }
}

- (void)ocj_issuedOrderEvaluateWithDic:(NSDictionary *)dataDic {
  [OCJHttp_evaluateAPI ocjPersonal_evaluateGoodsWithDictionary:dataDic completionHandler:^(OCJBaseResponceModel *responseModel) {
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      [OCJProgressHUD ocj_showHudWithTitle:@"评论发布成功" andHideDelay:2.0];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.ocjNavigationController.ocjCallback) {
          self.ocjNavigationController.ocjCallback(@{});
          [self.navigationController popViewControllerAnimated:YES];
        }
      });
    }
  }];
}

/**
 判断字符串是否全部为空字符
 */
- (BOOL) ocj_isEmptyString:(NSString *)str {
    if (!str) {
        return YES;
    }else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedStr = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedStr length] == 0) {
            return YES;
        }else {
            return NO;
        }
    }
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ocjArr_order.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak OCJEvaluateVC *weakSelf = self;
    NSMutableDictionary *mDic = self.ocjArr_grade[indexPath.section];
    if (indexPath.row == 0) {
        OCJEvaluateGoodsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJEvaluateGoodsTVCell" forIndexPath:indexPath];
      cell.ocjDic_order = self.ocjArr_order[indexPath.section];
        return cell;
    }else if (indexPath.row == 5) {
        OCJEvaluateInputTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJEvaluateInputTVCell" forIndexPath:indexPath];
        cell.ocjTF_suggest.tag = indexPath.section;
        cell.ocjTF_suggest.delegate = self;
        if (![[mDic objectForKey:@"evaluate"] isEqualToString:@""]) {
            cell.ocjTF_suggest.text = [mDic objectForKey:@"evaluate"];
        }
        
        return cell;
    }else if (indexPath.row == 6) {
        OCJRefundGoodsBottomTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundGoodsBottomTVCell" forIndexPath:indexPath];
        __weak OCJRefundGoodsBottomTVCell *weakCell = cell;
        
        self.ocjStr_image = [NSString stringWithFormat:@"%ld", indexPath.section];
        self.ocjStr_data = [NSString stringWithFormat:@"imageData%ld", indexPath.section];
        
        NSArray *arr = [mDic objectForKey:self.ocjStr_image];
        NSArray *arr1 = [mDic objectForKey:self.ocjStr_data];
        [cell.ocjView_bottom ocj_addUploadImageViewsWithImageArr:arr dataArr:arr1];
        cell.ocjView_bottom.ocjUploadImageBlock = ^(CGFloat viewHeight) {
            [weakSelf.ocjArr_cellHeight replaceObjectAtIndex:indexPath.section withObject:[NSString stringWithFormat:@"%f", viewHeight]];
            
            weakSelf.ocjStr_image = [NSString stringWithFormat:@"%ld", indexPath.section];
            weakSelf.ocjStr_data = [NSString stringWithFormat:@"imageData%ld", indexPath.section];
            [mDic setValue:weakCell.ocjView_bottom.ocjArr_image forKey:weakSelf.ocjStr_image];
            [mDic setValue:weakCell.ocjView_bottom.ocjArr_imageData forKey:weakSelf.ocjStr_data];
            
            [weakSelf.ocjTBView_evaluate reloadData];
        };
        return cell;
    }else {
        OCJEvaluateStarsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJEvaluateStarsTVCell" forIndexPath:indexPath];
        cell.tag = indexPath.section;
        NSString *ocjStr = [NSString stringWithFormat:@"score%ld", indexPath.row];
      NSInteger ocjStr_rate = [[mDic objectForKey:ocjStr] integerValue];
      [cell ocj_setHighlightedImagePlace:ocjStr_rate];
        cell.ocjLab_title.text = [self.ocjArr_evaluate objectAtIndex:indexPath.row - 1];
        cell.delegate = self;
        if (indexPath.row == self.ocjArr_evaluate.count) {
            cell.ocjView_line.hidden = NO;
        }else {
            cell.ocjView_line.hidden = YES;
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 105;
    }else if (indexPath.row == 5) {
        return 160;
    }else if (indexPath.row == 6) {
        return [self.ocjArr_cellHeight[0] floatValue];
    }else {
        return 40;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!(section == 0)) {
        UIView *ocjView_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        ocjView_header.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        return ocjView_header;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!(section == 0)) {
        return 10;
    }
    return 0.01;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSMutableDictionary *mDic = self.ocjArr_grade[textView.tag];
    if ([textView.text length] > 0) {
        [mDic setValue:textView.text forKey:@"evaluate"];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  return YES;
}

#pragma mark - cellDelegate
- (void)ocj_getEvaluateStarLevelWithCell:(OCJEvaluateStarsTVCell *)cell andLevel:(NSInteger)level {
    NSMutableDictionary *mDic = self.ocjArr_grade[cell.tag];
    if ([cell.ocjLab_title.text isEqualToString:@"商品质量："]) {
        [mDic setValue:[NSString stringWithFormat:@"%ld", level] forKey:@"score1"];
    }else if ([cell.ocjLab_title.text isEqualToString:@"商品价格："]) {
        [mDic setValue:[NSString stringWithFormat:@"%ld", level] forKey:@"score2"];
    }else if ([cell.ocjLab_title.text isEqualToString:@"配送速度："]) {
        [mDic setValue:[NSString stringWithFormat:@"%ld", level] forKey:@"score3"];
    }else if ([cell.ocjLab_title.text isEqualToString:@"商品服务："]) {
        [mDic setValue:[NSString stringWithFormat:@"%ld", level] forKey:@"score4"];
    }
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
