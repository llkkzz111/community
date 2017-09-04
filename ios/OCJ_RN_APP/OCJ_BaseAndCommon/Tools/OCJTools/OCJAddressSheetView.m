//
//  OCJAddressSheetView.m
//  testTwo
//
//  Created by yangyang on 2017/4/20.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJAddressSheetView.h"
#import <objc/runtime.h>
#import "YYSqliteTool.h"


NSString* const dBName = @"OCJAppAddress.sqlite3";

NSString* const tableNameP = @"province";
NSString* const tableNameC = @"city";
NSString* const tableNameD = @"district";

@interface OCJAddressSheetView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIView* ocjView_desk; ///< 选择器背景视图

@property (nonatomic,strong) UIPickerView* ocjPickerView; ///< 选择器主体视图

@property (nonatomic) sqlite3* ocjSQLite3; ///< 数据库句柄

@property (nonatomic,strong) NSArray* ocjArr_provinces; ///< 省数据集合
@property (nonatomic,strong) NSArray* ocjArr_citys; ///< 市数据集合
@property (nonatomic,strong) NSArray* ocjArr_districts; ///< 区数据集合
@end


static char actionKey; ///< handler暂存地址

@implementation OCJAddressSheetView

#pragma mark - 接口方法实现区域（包括setter、getter方法）
+(void)ocj_popAddressSheetCompletion:(OCJAddressSheetHandler)handler{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    OCJAddressSheetView* deskView = [[OCJAddressSheetView alloc]initWithFrame:window.bounds];
    deskView.userInteractionEnabled = YES;
    deskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    deskView.alpha = 1;
    [window addSubview:deskView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:deskView action:@selector(ocj_dismissSheet)];
    [deskView addGestureRecognizer:tap];
    
    UIView* bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200)];
    bottomView.backgroundColor = [UIColor colorWSHHFromHexString:@"#EAF0FD"];
    bottomView.userInteractionEnabled = NO;
    [deskView addSubview:bottomView];
    
    deskView.ocjPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 170)];
    deskView.ocjPickerView.backgroundColor = OCJ_COLOR_BACKGROUND;
    deskView.ocjPickerView.showsSelectionIndicator = YES;
    deskView.ocjPickerView.delegate = deskView;
    deskView.ocjPickerView.dataSource = deskView;
    [bottomView addSubview:deskView.ocjPickerView];
    
    OCJBaseButton* cancelBtn = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(16, 0, 60, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.ocjFont = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    [cancelBtn addTarget:deskView action:@selector(ocj_dismissSheet) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBtn];
    
    OCJBaseButton* sureBtn = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(SCREEN_WIDTH-76, 0, 60, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.ocjFont = [UIFont systemFontOfSize:14];
    [sureBtn addTarget:deskView action:@selector(ocj_getAddressDate) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
    
    objc_setAssociatedObject(deskView, &actionKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //视图弹出动画
    [UIView animateWithDuration:0.25 animations:^{
        
        deskView.alpha = 1;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            bottomView.mj_y = deskView.mj_h-200;
        } completion:^(BOOL finished) {
            
            bottomView.userInteractionEnabled = YES;
        }];
    }];


}

#pragma mark - 生命周期方法区域
-(void)dealloc{
    
    OCJLog(@"pickerView 已释放");
}

#pragma mark - 私有方法区域
-(void)ocj_dismissSheet{
    
    //视图关闭动画
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        sqlite3_close(self.ocjSQLite3);//关闭数据库
        self.ocjSQLite3 = nil;
    }];
}



-(void)ocj_getAddressDate{
    [self.ocjPickerView reloadAllComponents];
    
    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
    NSInteger row = [self.ocjPickerView selectedRowInComponent:0];
    NSDictionary* provenice = self.ocjArr_provinces[row];
    [mDic setObject:provenice[@"name"] forKey:@"provenice"];
    [mDic setObject:provenice[@"code"] forKey:@"proveniceCode"];
    
    row = [self.ocjPickerView selectedRowInComponent:1];
    NSDictionary* city = self.ocjArr_citys[row];
    [mDic setObject:city[@"name"] forKey:@"city"];
    [mDic setObject:city[@"code"] forKey:@"cityCode"];
    
    row = [self.ocjPickerView selectedRowInComponent:2];
    NSDictionary* district = self.ocjArr_districts[row];
    [mDic setObject:district[@"name"] forKey:@"district"];
    [mDic setObject:district[@"code"] forKey:@"districtCode"];
    
    OCJAddressSheetHandler handler = objc_getAssociatedObject(self, &actionKey);
    if (handler) {
        handler([mDic copy]);//传输选择地址数据
    }
    
    [self ocj_dismissSheet];
}

-(sqlite3 *)ocjSQLite3{
    if (!_ocjSQLite3) {
        NSString* dbFilePath = [[NSBundle mainBundle]pathForResource:dBName ofType:@""];
        _ocjSQLite3 = [YYSqliteTool yy_openSqliteFromPath:dbFilePath];
    }
    return _ocjSQLite3;
}

-(NSArray *)ocjArr_provinces{
    if (!_ocjArr_provinces) {
        _ocjArr_provinces = [YYSqliteTool yy_sqlite_fetchDataWithKeys:@[@"code",@"name"] byTable:tableNameP byDataBase:self.ocjSQLite3];
    }
    return _ocjArr_provinces;
}

-(NSArray *)ocjArr_citys{
    if (!_ocjArr_citys) {
        _ocjArr_citys = [self ocj_getCitysByProvince:[self.ocjArr_provinces firstObject]];
    }
    
    return _ocjArr_citys;
}

-(NSArray *)ocjArr_districts{
    
    if (!_ocjArr_districts) {
        _ocjArr_districts = [self ocj_getDistrictsByCity:[self.ocjArr_citys firstObject]];
    }
    
    return _ocjArr_districts;
}



-(NSArray*)ocj_getCitysByProvince:(NSDictionary*)provinceDic{
    
    if (!provinceDic) {
        return nil;
    }
    
    NSString* predicateStr = [NSString stringWithFormat:@"provinceCode = '%@'",provinceDic[@"code"]];
    NSArray* citys = [YYSqliteTool yy_sqlite_fetchDataWithKeys:@[@"code",@"provinceCode",@"name"] byPredicate:@[predicateStr] byTable:tableNameC byDataBase:self.ocjSQLite3];
    
    return citys;
}

-(NSArray*)ocj_getDistrictsByCity:(NSDictionary*)cityDic{
    if (!cityDic) {
        return  nil;
    }
    
    NSString* predicateStr = [NSString stringWithFormat:@"provinceCode = '%@' AND cityCode = '%@'",cityDic[@"provinceCode"],cityDic[@"code"]];
    NSArray* districts = [YYSqliteTool yy_sqlite_fetchDataWithKeys:@[@"code",@"cityCode",@"provinceCode",@"name"] byPredicate:@[predicateStr] byTable:tableNameD byDataBase:self.ocjSQLite3];
    
    return districts;
}


#pragma mark - 协议方法实现区域
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:return self.ocjArr_provinces.count;
        case 1:return self.ocjArr_citys.count;
        case 2:return self.ocjArr_districts.count;
        default:return 0;
    }
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0) {
        NSDictionary* province = self.ocjArr_provinces[row];
        self.ocjArr_citys = [self ocj_getCitysByProvince:province];
        self.ocjArr_districts = [self ocj_getDistrictsByCity:[self.ocjArr_citys firstObject]];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }else if (component==1){
        
        NSDictionary* city = self.ocjArr_citys[row];
        self.ocjArr_districts = [self ocj_getDistrictsByCity:city];
        
        [pickerView reloadComponent:2];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 30.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    OCJBaseLabel* pickerLabel = (OCJBaseLabel*)view;
    if (!pickerLabel){
        pickerLabel = [[OCJBaseLabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    NSString* title;
    switch (component) {
        case 0:title = self.ocjArr_provinces[row][@"name"];break;
        case 1:title =self.ocjArr_citys[row][@"name"];break;
        case 2:title = self.ocjArr_districts[row][@"name"];break;
    }
    pickerLabel.text= title;
    return pickerLabel;
}



@end
