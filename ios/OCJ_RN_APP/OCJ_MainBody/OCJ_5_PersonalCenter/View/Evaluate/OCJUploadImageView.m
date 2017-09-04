//
//  OCJUploadImageView.m
//  OCJ
//
//  Created by Ray on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJUploadImageView.h"
#import "AppDelegate+OCJExtension.h"
#import "OCJImageBrowseVC.h"

#define ViewWidth (SCREEN_WIDTH - 75)/4.0

@interface OCJUploadImageView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *ocjBtn_upload;///<上传按钮
@property (nonatomic, strong) OCJBaseLabel *ocjLab_tip;///<提示
@property (nonatomic, strong) UIView *ocjView_last;///<
@property (nonatomic, assign) NSInteger ocjInt_count;///<上传图片张数
@property (nonatomic, assign) NSInteger row;///<行
@property (nonatomic, assign) NSInteger col;///<列
@property (nonatomic, assign) CGFloat totalRowWidth;///<总宽度
@property (nonatomic, assign) NSInteger horSpace;///<间距

@end

@implementation OCJUploadImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = OCJ_COLOR_BACKGROUND;
        self.ocjInt_count = 0;
        self.totalRowWidth = 30,self.totalHeight = 30,self.horSpace = 15;
        [self ocj_addUploadBtn];
        [self ocj_addTipLab];
    }
    return self;
}

- (void)ocj_addUploadBtn {
    //上传按钮
    self.ocjBtn_upload = [[UIButton alloc] init];
    [self.ocjBtn_upload setBackgroundImage:[UIImage imageNamed:@"icon_addimg_"] forState:UIControlStateNormal];
    [self.ocjBtn_upload addTarget:self action:@selector(ocj_uploadImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_upload];
    [self.ocjBtn_upload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.width.height.mas_equalTo(ViewWidth);
    }];
}

- (void)ocj_addTipLab {
    //提示文字
    self.ocjLab_tip = [[OCJBaseLabel alloc] init];
    self.ocjLab_tip.text = @"亲，点击可以放大图片哦，快来试试吧!(最多可上传9张)";
    self.ocjLab_tip.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_tip.font = [UIFont systemFontOfSize:13];
    self.ocjLab_tip.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_tip.numberOfLines = 2;
    [self addSubview:self.ocjLab_tip];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_upload.mas_right).offset(15);
        make.top.mas_equalTo(self.ocjBtn_upload);
        make.right.mas_equalTo(self.mas_right).offset(-30);
    }];
}

- (NSMutableArray *)ocjArr_image {
    if (!_ocjArr_image) {
        _ocjArr_image = [[NSMutableArray alloc] init];
    }
    return _ocjArr_image;
}

- (NSMutableArray *)ocjArr_imageData {
    if (!_ocjArr_imageData) {
        _ocjArr_imageData = [[NSMutableArray alloc] init];
    }
    return _ocjArr_imageData;
}

/**
 点击上传按钮
 */
- (void)ocj_uploadImage {
    UIViewController *ocjVC = [AppDelegate ocj_getTopViewController];
    UIAlertController *ocjAlert_ctrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ocjAlert_ctrl addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //允许编辑，即放大裁剪
        pickerImage.allowsEditing = YES;
        pickerImage.delegate = self;
        [ocjVC presentViewController:pickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [ocjAlert_ctrl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        //获取方式:通过相机
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.allowsEditing = YES;
        pickerImage.delegate = self;
        [ocjVC presentViewController:pickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [ocjAlert_ctrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [ocjVC presentViewController:ocjAlert_ctrl animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.ocjLab_tip removeFromSuperview];
    self.ocjInt_count += 1;
    if (self.ocjInt_count == 9) {
        self.ocjBtn_upload.hidden = YES;
    }
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *data = UIImagePNGRepresentation(newPhoto);
    UIImage *newimage = [UIImage imageWithData:data];
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:data forKey:@"data"];
    [mDic setValue:@"files" forKey:@"key"];
    
    [self.ocjArr_imageData addObject:mDic];
    [self.ocjArr_image addObject:newimage];
    [self ocj_cellHeight];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 删除图片
 */
- (void)ocj_deleteImageViewWithBtn:(UIButton *)ocjBtn {
    self.ocjInt_count -= 1;
    if (self.ocjInt_count < 9) {
        self.ocjBtn_upload.hidden = NO;
    }
    [self.ocjArr_imageData removeObjectAtIndex:ocjBtn.tag];
    [self.ocjArr_image removeObjectAtIndex:ocjBtn.tag];
    [self ocj_cellHeight];
}

/**
 点击图片浏览大图
 */
- (void)ocj_tappedImageView:(UITapGestureRecognizer *)tap {
    UIViewController *ocjVC = [AppDelegate ocj_getTopViewController];
    OCJImageBrowseVC *imageBrowseVC = [[OCJImageBrowseVC alloc] init];
    imageBrowseVC.ocjArr_image = self.ocjArr_image;
    imageBrowseVC.ocjInt_index = tap.view.tag;
    [ocjVC.navigationController pushViewController:imageBrowseVC animated:YES];
}

/**
 上传图片布局
 */
- (void)ocj_addUploadImageViewsWithImageArr:(NSArray *)ocjArr_image dataArr:(NSArray *)ocjArr_data {
    self.ocjArr_image = [NSMutableArray arrayWithArray:ocjArr_image];
    self.ocjArr_imageData = [NSMutableArray arrayWithArray:ocjArr_data];
    OCJLog(@"count = %ld", self.ocjArr_image.count);
    self.ocjView_last = nil;
    
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
  
    self.totalRowWidth = 30,self.totalHeight = 30 + ViewWidth;
    for (int i = 0; i < ocjArr_image.count; i++) {
        NSInteger row = i / 4 + 1;
        NSInteger col = i % 4 + 1;
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedImageView:)];
        UIView *view = [[UIView alloc] init];
        view.tag = i;
      [view addGestureRecognizer:tap];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!self.ocjView_last) {
                self.totalRowWidth += ViewWidth;
                make.left.mas_equalTo(self.mas_left).offset(15);
            }else {
                self.totalRowWidth += self.horSpace + ViewWidth;
                if (self.totalRowWidth > SCREEN_WIDTH) {
                    self.totalHeight += self.horSpace + ViewWidth;
                    make.left.mas_equalTo(self.mas_left).offset(15);
                    self.totalRowWidth = 30 + ViewWidth;
                }else {
                    make.left.mas_equalTo(self.mas_left).offset(self.totalRowWidth - ViewWidth - self.horSpace);
                }
            }
            
            make.top.mas_equalTo(self.mas_top).offset(15 * row + (row - 1) * ViewWidth);
            
            make.width.height.mas_equalTo(ViewWidth);
        }];
        self.ocjView_last = view;
        //图片
        UIImageView *ocjImgView_upload = [[UIImageView alloc] init];
        ocjImgView_upload.image = ocjArr_image[i];
        [view addSubview:ocjImgView_upload];
        [ocjImgView_upload mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(view);
        }];
        //重置上传按钮位置
        [self ocj_reSetUploadBtnFrameWithRow:row col:col];
        //删除按钮
        UIButton *ocjBtn_close = [[UIButton alloc] init];
        [ocjBtn_close setImage:[UIImage imageNamed:@"close_"] forState:UIControlStateNormal];
        [ocjBtn_close addTarget:self action:@selector(ocj_deleteImageViewWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        ocjBtn_close.tag = i;
        [view addSubview:ocjBtn_close];
        [ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ocjImgView_upload.mas_right).offset(10);
            make.top.mas_equalTo(ocjImgView_upload.mas_top).offset(-13);
            make.width.height.mas_equalTo(@35);
        }];
    }
    if (self.ocjArr_image.count == 0) {
        [self ocj_addTipLab];
        [self ocj_reSetUploadBtnFrameWithRow:1 col:0];
    }
}

/**
 重置上传按钮位置
 */
- (void)ocj_reSetUploadBtnFrameWithRow:(NSInteger)row col:(NSInteger)col {
    if (self.totalRowWidth < SCREEN_WIDTH) {
        [self.ocjBtn_upload mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(self.horSpace * (col + 1) + ViewWidth * col);
            make.top.mas_equalTo(self.mas_top).offset(self.horSpace * row + ViewWidth * (row - 1));
            make.width.height.mas_equalTo(ViewWidth);
        }];
    }else {
        [self.ocjBtn_upload mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(self.horSpace);
            make.top.mas_equalTo(self.mas_top).offset(self.totalHeight);
            make.width.height.mas_equalTo(ViewWidth);
        }];
    }
}

- (void)ocj_cellHeight {
    self.ocjView_last = nil;
    
    self.totalRowWidth = 30,self.totalHeight = 30 + ViewWidth;
    for (int i = 0; i < self.ocjArr_image.count; i++) {
        NSInteger row = i / 4 + 1;
        UIView *view = [[UIView alloc] init];
        view.tag = i;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!self.ocjView_last) {
                self.totalRowWidth += ViewWidth;
                make.left.mas_equalTo(self.mas_left).offset(15);
            }else {
                self.totalRowWidth += self.horSpace + ViewWidth;
                if (self.totalRowWidth > SCREEN_WIDTH) {
                    self.totalHeight += self.horSpace + ViewWidth;
                    make.left.mas_equalTo(self.mas_left).offset(15);
                    self.totalRowWidth = 30 + ViewWidth;
                }else {
                    make.left.mas_equalTo(self.mas_left).offset(self.totalRowWidth - ViewWidth - self.horSpace);
                }
            }
            
            make.top.mas_equalTo(self.mas_top).offset(15 * row + (row - 1) * ViewWidth);
            
            make.width.height.mas_equalTo(ViewWidth);
        }];
        self.ocjView_last = view;
    }
    if (self.totalRowWidth < SCREEN_WIDTH) {
        if (self.ocjUploadImageBlock) {
            self.ocjUploadImageBlock(self.totalHeight);
        }
    }else {
        if (self.ocjUploadImageBlock) {
            self.ocjUploadImageBlock(self.totalHeight + self.horSpace + ViewWidth);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
