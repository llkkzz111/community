//
//  TextfeildViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/15.
//  Copyright © 2017年 jz. All rights reserved.
//

#define MAX_NUMS 20
#import "TextfeildViewController.h"

#import <JZLiveSDK/JZLiveSDK.h>
@interface TextfeildViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textString;
@property (nonatomic, strong) UILabel     *cueText;
@end

@implementation TextfeildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _textTitleString;
    self.view.backgroundColor = RGB(233, 248, 253, 1);
    
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-113);
    cover.backgroundColor = [UIColor clearColor];
    [cover addTarget:self action:@selector(clickCover) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"JZ_Btn_back@2x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZENAVGATIONRIGHT]];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveChange:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    UITextView *textString = [[UITextView alloc] init];
    textString.backgroundColor = [UIColor whiteColor];
    textString.editable = YES;
    textString.delegate = self;
    textString.layer.masksToBounds = YES;
    textString.layer.cornerRadius = 5;
    textString.font = [UIFont systemFontOfSize:15];
    textString.scrollEnabled = NO;
    //[textString addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textString];
    self.textString = textString;
    
    UILabel *cueText = [[UILabel alloc] init];
    cueText.textColor = [UIColor grayColor];
    cueText.font = [UIFont systemFontOfSize:15];
    cueText.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:cueText];
    self.cueText = cueText;
    if ([_textTitleString isEqualToString: @"修改昵称"]){
        self.textString.text = _name;
        self.textString.frame = CGRectMake(20, 20, SCREEN_WIDTH-40, 60);
        self.cueText.frame = CGRectMake(20, CGRectGetMaxY(textString.frame)+20, SCREEN_WIDTH-40, 20);
        self.cueText.text = @"昵称最多为20个字";
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)clickCover{
    //退出键盘
    [self.textString resignFirstResponder];
}
-(void)backView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveChange:(UIButton *)sender{
    sender.enabled = NO;
    if ([_textTitleString isEqualToString: @"修改昵称"]){
        NSString *textstring = [NSString stringWithFormat:@"%@",self.textString.text];
        JZCustomer *customer = [JZCustomer getUserdataInstance];
        customer.nickname = textstring;
        [self.delegate changePersonalInfor:customer];
    }    [self performSelector:@selector(backView) withObject:nil afterDelay:1.5];
    sender.enabled = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < MAX_NUMS) {
            return YES;
        }
        else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_NUMS - comcatstr.length;
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //labLimitNum.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_NUMS];
        }
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > MAX_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_NUMS];
        [textView setText:s];
    }
}
@end
