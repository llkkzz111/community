//
//  OCJTBC.m
//  ProjectName
//
//  Created by DHY on 2017/4/10.
//  Copyright © 2017年 DHY. All rights reserved.
//

#import "OCJTBC.h"
#import "OCJBaseNC.h"

@interface OCJTBC ()

@end

@implementation OCJTBC

+ (instancetype)controllerOCJWithTitles:(NSArray *)titles
                        controllerNames:(NSArray *)names
                                 images:(NSArray *)images
                         selectedImages:(NSArray *)selectedImages
{
    return [[OCJTBC alloc]initOCJWithTitles:titles
                            controllerNames:names
                                     images:images
                             selectedImages:selectedImages];
}

- (instancetype)initOCJWithTitles:(NSArray *)titles
                  controllerNames:(NSArray *)names
                           images:(NSArray *)images
                   selectedImages:(NSArray *)selectedImages
{
    self = [super init];
    if (self) {
        //是否传空参数
        if(titles == nil || names ==nil || images == nil || selectedImages == nil)
        {
            [NSException raise:@"Invalid params!" format:@"OCJTBC check params nil"];
            
        }else if([titles count] != [names count] || [titles count]!=[images count] || [titles count] != [selectedImages count]){//参数个数是否一致
            [NSException raise:@"Invalid params!" format:@"OCJTBC check params invalid"];
        }
        
        [self ocj_configTBCWithTitles:titles
                      controllerNames:names
                               images:images
                       selectedImages:selectedImages];
    }
    return self;
}

/**
 初始化控制器具体内容

 @param titles 有序标题数组
 @param names 有序控制器类名数组
 @param images 有序item未选中图片数组
 @param selectedImages 有序item选中图片数组
 */
- (void)ocj_configTBCWithTitles:(NSArray *)titles
                controllerNames:(NSArray *)names
                         images:(NSArray *)images
                 selectedImages:(NSArray *)selectedImages
{
    NSMutableArray *marray = [NSMutableArray array];
    for (int i=0; i<[titles count]; i++) {
        //创建视图控制器对象
        NSString *clsName = names[i];
        
        Class cls = NSClassFromString(clsName);
        UIViewController *vc = [[cls alloc] init];
        if (!vc || ![vc isKindOfClass:[UIViewController class]])
        {
            [NSException raise:@"Class unavailable!" format:@"OCJTBC init ViewController with '%@' is unavailable",clsName];
        }

        //标题
        vc.tabBarItem.title = titles[i];
        //图片
        vc.tabBarItem.image =[UIImage imageNamed:images[i]];
        //选中图片
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置导航标题
//        vc.navigationItem.title = titles[i];
      
        //导航
        OCJBaseNC *nvc = [[OCJBaseNC alloc] initWithRootViewController:vc];
        
        [marray addObject:nvc];
    }
    self.viewControllers = marray;
}



@end
