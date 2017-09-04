//
//  ModifyPersonalInfoTableViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/15.
//  Copyright © 2017年 jz. All rights reserved.
//
#define kFullPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[@"currentImage" stringByAppendingString:[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id]] stringByAppendingString:@".png"]];
#define kFullPath2 [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[@"currentImage" stringByAppendingString:[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id]] stringByAppendingString:@"2.png"]];
#import "ModifyPersonalInfoTableViewController.h"
#import "UIImageView+AFNetworking.h"

#import "CropImageView.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import "TextfeildViewController.h"
#import "JZTools.h"
@interface ModifyPersonalInfoTableViewController ()<TextfeildViewDelagate,CropImageViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, weak) CropImageView *cropImageV;
@property (nonatomic, strong) UIImageView *headPic;
@end

@implementation ModifyPersonalInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"JZ_Btn_back@2x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.showsVerticalScrollIndicator =NO;
    [self.view addSubview:tableview];
    self.tableView = tableview;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)backView{
    if (self.cropImageV) {
        [self.cropImageV removeFromSuperview];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refuse"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"refuse"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"头像";
        if (!self.headPic) {
            self.headPic = [[UIImageView alloc]init];
            self.headPic.frame = CGRectMake(SCREEN_WIDTH - 60, 5, 40, 40);
            self.headPic.layer.masksToBounds = YES;
            self.headPic.layer.cornerRadius = 20;
            [cell.contentView addSubview:self.headPic];
            self.headPic.backgroundColor = [UIColor lightGrayColor];
            /*点击头像调相机，系统相册*/
            self.headPic.userInteractionEnabled = YES;
        }
        [self.headPic setImageWithURL:[NSURL URLWithString:[JZTools filterHttpImage:_user.pic1]] placeholderImage:[UIImage imageNamed:@"JZ_icon_defaultFace_116_116"]];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refuse1"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"refuse1"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"昵称";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([JZTools isInvalid:_user.nickname]) {
            if ([JZTools isInvalid:_user.mobile]) {
                cell.detailTextLabel.text = @"请设置昵称";
            }else {
                cell.detailTextLabel.text = _user.mobile;
            }
        }else{
            cell.detailTextLabel.text = _user.nickname;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self tap];
    }else{
        TextfeildViewController *pushVC = [[TextfeildViewController alloc] init];
        pushVC.delegate = self;
        pushVC.textTitleString = @"修改昵称";
        if ([JZTools isInvalid:_user.nickname]) {
            if ([JZTools isInvalid:_user.mobile]) {
                pushVC.name = @"请设置昵称";
            }else {
                pushVC.name = _user.mobile;
            }
        }else{
            pushVC.name = _user.nickname;
        }
        [self.navigationController pushViewController:pushVC animated:YES];
    }
}
#pragma mark -  点击修改头像的按钮
- (void)tap{
    //在这里呼出下方菜单按扭项
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    [myActionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}
//开始拍照
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.navigationController.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        [JZTools showMessage:@"您的手机暂不支持该项功能!"];
    }
}
//取消图
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.navigationController.delegate = self;
    picker.allowsEditing = NO;
    //picker.allowsEditing = YES;//设置选择后的图片可被编辑
    //[self.navigationController pushViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}

//保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage PATH:(NSString*)path
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.8);
    //   获取沙盒目录
    NSString *fullPath = path;
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    NSLog(@"fullPath = 本地地址  :%@ ",fullPath);
}
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}
- (UIImage *)scaleFromImage: (UIImage *) image toSize: (CGSize) size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



#pragma mark - 相册回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.title = @"编辑图片";
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CropImageView *cropImageV = [[CropImageView alloc] init];
    cropImageV.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
    cropImageV.delegate = self;
    cropImageV.imageType = 0;
    [cropImageV initImage:image];
    [self.view addSubview:cropImageV];
    self.cropImageV = cropImageV;
}
#pragma mark - CDPImageCropDelegate
//确定(自动将裁剪的图片存入相册)
- (void)confirmClickWithImage:(UIImage *)image {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDictionary * myData = @{@"id":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"operate":@"1"};
    NSString *path = kFullPath;
    //NSLog(@"本地地址  :%@ ",path);
    [self saveImage:image PATH:path];
    [JZGeneralApi uploadUserImageToServer:path mParams:myData completeHandler:^(JZCustomer *user, NSError *error) {
        if (user != nil) {
            _user = user;
            //本地保存图片
            [self.headPic setImage:image];
            [self.tableView reloadData];
            [JZTools showMessage:@"修改头像成功"];
        }
    }];
    self.title = @"编辑个人资料";
    [self.cropImageV removeFromSuperview];
}

//修改个人信息
- (void)changePersonalInfor:(JZCustomer *)changeInfo {
    //上传数据
    __weak typeof(self) block = self;
    [JZGeneralApi updateUserWithBlock:changeInfo getDetailBlock:^(JZCustomer *user, NSError *error) {
        if (user == nil || error) {
        }else {
            block.user = user;
            [block.tableView reloadData];
            [JZTools showMessage:@"更改信息成功"];
        }
    }];
}
//返回
- (void)backClick {
    [self.cropImageV removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
