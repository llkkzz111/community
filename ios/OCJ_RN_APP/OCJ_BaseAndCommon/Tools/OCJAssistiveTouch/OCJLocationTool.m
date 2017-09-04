//
//  OCJLocationTool.m
//  OCJ_RN_APP
//
//  Created by OCJ on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJLocationTool.h"
#import <CoreLocation/CoreLocation.h>

@interface OCJLocationTool () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation OCJLocationTool

+ (instancetype)shareInstanceAndStartLocation{
  static OCJLocationTool *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[OCJLocationTool alloc] init];
  });
  
  if (instance.locationManager==nil) {
    if ([CLLocationManager locationServicesEnabled]) {
      instance.locationManager = [[CLLocationManager alloc] init];
      instance.locationManager.delegate = instance;
      if ([[[UIDevice currentDevice]systemVersion] doubleValue] >= 8.0)
      {
        // 设置定位权限仅iOS8以上有意义,而且iOS8以上必须添加此行代码
        [instance.locationManager requestWhenInUseAuthorization];//前台定位
      
      }
      instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
      instance.locationManager.distanceFilter = 5.0f;
      [instance.locationManager stopUpdatingLocation];
      [instance.locationManager startUpdatingLocation];
    }
  }else{
    if ([CLLocationManager locationServicesEnabled]) {
      [instance.locationManager stopUpdatingLocation];
      [instance.locationManager startUpdatingLocation];
    }
  }
  return instance;
}

/** 获取到新的位置信息时调用*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  __weak typeof(self) weakSelf = self;
  [self.locationManager stopUpdatingLocation];
  CLLocation *currentLocation = locations.lastObject;
  CLGeocoder *geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
    [weakSelf ocj_dealwithLocation:placemarks location:currentLocation];
  }];
}

- (void)ocj_dealwithLocation:(NSArray *)placemarks location:(CLLocation *)location{
  {
      CLPlacemark *placemark = placemarks.lastObject;
//    __weak typeof(self) __weakSelf = self;
    
      if (placemark) {
        [self.locationManager stopUpdatingLocation];
//        NSString *province = placemark.administrativeArea;
        //获取城市
//        NSString *city = placemark.locality;
//        if (!city) {
//          //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//          city = province;
//        }
//        NSString *area = placemark.subLocality;//区 县
//        if (!area) {
//          area = city;
//        }
//
//        NSMutableString *addressStrM = [NSMutableString string];
//        if (province) {
//          [addressStrM appendString:province];
//        }
//        if (city) {
//          [addressStrM appendString:city];
//        }
//        if (area) {
//          [addressStrM appendString:area];
//        }
//        if (self.ocjBackAddressAndLocation) {
//          self.ocjBackAddressAndLocation(addressStrM.copy, location);
//        }
        if (self.ocjBackAddressAndLocation) {
          self.ocjBackAddressAndLocation(placemark.addressDictionary, @{@"lat":[@(location.coordinate.latitude) stringValue], @"long":[@(location.coordinate.longitude) stringValue]});
          self.ocjBackAddressAndLocation = nil;//仅返回一次
        }
      }else{
//        [WSHHAlert wshh_showHudWithTitle:@"无法获取定位信息" andHideDelay:2];
      }
      
  }
}

/** 不能获取位置信息时调用*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//  [WSHHAlert wshh_showHudWithTitle:@"获取定位失败" andHideDelay:2];
}

@end
