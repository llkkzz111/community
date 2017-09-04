//
//  OCJPlaceholderTextView.m
//  OCJ
//
//  Created by OCJ on 2017/5/24.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPlaceholderTextView.h"


@interface OCJPlaceholderTextView()<UITextViewDelegate>
@property(assign,nonatomic) float placeholdeWidth;

@property(copy,nonatomic) id eventBlock;
@property(copy,nonatomic) id BeginBlock;
@property(copy,nonatomic) id EndBlock;
@end

@implementation OCJPlaceholderTextView

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginNoti:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEndNoti:) name:UITextViewTextDidEndEditingNotification object:self];
    
    float left  = 5,top = 0,hegiht  = 30;
    self.placeholdeWidth            =  CGRectGetWidth(self.frame)-2*left;
    self.placeholderColor           =  [UIColor lightGrayColor];
    _PlaceholderLabel               =  [[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                                , _placeholdeWidth, hegiht)];
    _PlaceholderLabel.font          =  [UIFont systemFontOfSize:12];
    _PlaceholderLabel.numberOfLines =  0;
    _PlaceholderLabel.lineBreakMode =  NSLineBreakByCharWrapping;
    _PlaceholderLabel.textColor     =  self.placeholderColor;
    [self addSubview:_PlaceholderLabel];
    _PlaceholderLabel.text=self.placeholder;
    self.maxTextLength =1000;
}

- (void)resetPlaceHolderFrame{
    CGRect oriFrame = _PlaceholderLabel.frame;
    oriFrame.origin.x = 10;
    oriFrame.size.width = oriFrame.size.width - 10;
    oriFrame.origin.y = oriFrame.origin.y - 64;
    _PlaceholderLabel.frame = oriFrame;
}

-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }else{
        _PlaceholderLabel.text = placeholder;
        _placeholder           = placeholder;
        
        float  height  =  [OCJPlaceholderTextView boundingRectWithSize:CGSizeMake(_placeholdeWidth, MAXFLOAT) withLabel:_placeholder withFont:_PlaceholderLabel.font];
        if (height>CGRectGetHeight(_PlaceholderLabel.frame) && height< CGRectGetHeight(self.frame)) {
            
            CGRect frame            =  _PlaceholderLabel.frame;
            frame.size.height       =   height;
            _PlaceholderLabel.frame =   frame;
        }
      if (height > 15) {
        CGRect frame            =  _PlaceholderLabel.frame;
        frame.origin.y = 5;
        _PlaceholderLabel.frame =   frame;
      }
    }
}
+(float)boundingRectWithSize:(CGSize)size withLabel:(NSString *)label withFont:(UIFont *)font{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    // CGSize retSize;
    CGSize retSize = [label boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    
    return retSize.height;
    
}


-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _PlaceholderLabel.textColor=placeholderColor;
    _placeholderColor=placeholderColor;
}
-(void)setPlaceholderFont:(UIFont *)placeholderFont{
    _PlaceholderLabel.font=placeholderFont;
    _placeholderFont=placeholderFont;
}

-(void)setText:(NSString *)tex{
    if (tex.length>0) {
        _PlaceholderLabel.hidden=YES;
    }
    [super setText:tex];
}

#pragma mark---一些通知
-(void)DidChange:(NSNotification*)noti{
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        _PlaceholderLabel.hidden=YES;
    }
    else{
        _PlaceholderLabel.hidden=NO;
    }
    
    if (_eventBlock && self.text.length > self.maxTextLength) {
        void (^limint)(OCJPlaceholderTextView*text) =_eventBlock;
        limint(self);
    }
}


-(void)textViewBeginNoti:(NSNotification*)noti{
    if (_BeginBlock) {
        void(^begin)(OCJPlaceholderTextView*text)=_BeginBlock;
        begin(self);
    }
}
-(void)textViewEndNoti:(NSNotification*)noti{
    if (_EndBlock) {
        void(^end)(OCJPlaceholderTextView*text)=_EndBlock;
        end(self);
    }
}



#pragma mark----使用block 代理 delegate
-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void (^)(OCJPlaceholderTextView *))limit{
    _maxTextLength=maxLength;
    if (limit) {
        _eventBlock=limit;
    }
}

-(void)addTextViewBeginEvent:(void (^)(OCJPlaceholderTextView *))begin{
    _BeginBlock=begin;
}

-(void)addTextViewEndEvent:(void (^)(OCJPlaceholderTextView *))End{
    _EndBlock=End;
}

-(void)setUpdateHeight:(float)updateHeight{
    CGRect frame      =  self.frame;
    frame.size.height =  updateHeight;
    self.frame        =  frame;
    _updateHeight     =  updateHeight;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_PlaceholderLabel removeFromSuperview];
    
}
@end
