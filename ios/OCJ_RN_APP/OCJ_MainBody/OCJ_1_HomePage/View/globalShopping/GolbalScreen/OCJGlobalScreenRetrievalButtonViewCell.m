//
//  OCJGlobalScreenRetrievalButtonViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalScreenRetrievalButtonViewCell.h"
#import "OCJGlobalScreenRetrievalButtonView.h"

@interface OCJGlobalScreenRetrievalButtonViewCell()<OCJGlobalScreenRetrievalButtonViewDelegate>

@end

@implementation OCJGlobalScreenRetrievalButtonViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    CGFloat cellW = SCREEN_WIDTH*320/375;
    CGFloat btnW = (cellW - 50)/3;
    for (int i = 0; i < 3; i ++) {
        OCJGlobalScreenRetrievalButtonView * btn = [[OCJGlobalScreenRetrievalButtonView alloc] initWithFrame:CGRectMake(15 + (btnW + 10) * i, 10, btnW, 30)];
        [self addSubview:btn];
    }
}

- (void)ocj_setTitleArray:(NSArray *)array SelectArray:(NSArray *)select;
{
    for (UIView *views in [self subviews]) {
        if ([views isKindOfClass:[OCJGlobalScreenRetrievalButtonView class]]) {
            [views removeFromSuperview];
        }
    }
    
    CGFloat cellW = SCREEN_WIDTH*320/375;
    CGFloat btnW = (cellW - 50)/3;
    CGFloat benH = btnW*28/92;
    for (int i = 0; i < [array count]; i ++) {
        OCJGlobalScreenRetrievalButtonView * btn = [[OCJGlobalScreenRetrievalButtonView alloc] initWithFrame:CGRectMake(15 + (btnW + 10) * i, 5, btnW, benH)];
        btn.delegate = self;
        btn.ocjInt_btnViewTag = i;
        id element = [array objectAtIndex:i];
        if ([element isKindOfClass:[NSDictionary class]]) {
            NSArray *arraytitle = [element objectForKey:@"propertyValue"];
            [btn ocj_setTitl:arraytitle[0]];
        }
        else if ([element isKindOfClass:[NSString class]])
        {
            [btn ocj_setTitl:element];
        }
        
        if ([select indexOfObject:element] != NSNotFound) {
            [btn ocj_setButtonSelected:YES];
        }
        else
        {
            [btn ocj_setButtonSelected:NO];
        }
        
        [self addSubview:btn];
    }
}

- (void)ocj_onScreenRetrievalButtonPressed:(NSInteger)tag
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalScreenRetrievalPressed:At:)]) {
        [self.delegate ocj_golbalScreenRetrievalPressed:tag At:self];
    }
}



@end
