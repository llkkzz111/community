//
//  OCJGlobalHotTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalHotTableViewCell.h"
#import "OCJOnTheNewButtonViwe.h"

@interface OCJGlobalHotTableViewCell()<OOCJOnTheNewButtonViweDelegate>
@property (nonatomic,strong) NSMutableArray      *ocjArray_subData;

@end

@implementation OCJGlobalHotTableViewCell

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
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    for (int i = 0; i < 5; i++) {
        if (i == 0 || i == 1) {
            CGFloat x = i*SCREEN_WIDTH/2;
            CGFloat y = 0;
            OCJOnTheNewButtonViwe *view = [[OCJOnTheNewButtonViwe alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/2, (SCREEN_WIDTH/2)*(121.5/187.5))];
            [self addSubview:view];
        }
        else
        {
            CGFloat x = (i-2)*SCREEN_WIDTH/3;
            CGFloat y = (SCREEN_WIDTH/2)*(121.5/187.5);
            OCJOnTheNewButtonViwe *view = [[OCJOnTheNewButtonViwe alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/3, SCREEN_WIDTH/3)];
            [self addSubview:view];

        }
    }
}

- (void)ocj_setShowDataWithArray:(NSArray *)array
{
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[OCJOnTheNewButtonViwe class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self.ocjArray_subData removeAllObjects];
    [self.ocjArray_subData addObjectsFromArray:array];
    
    for (int i = 0; i < [array count]; i++) {
        
        if (i == 0 || i == 1) {
            CGFloat x = i*SCREEN_WIDTH/2;
            CGFloat y = 0;
            OCJOnTheNewButtonViwe *view = [[OCJOnTheNewButtonViwe alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/2, SCREEN_WIDTH/3)];
            view.ocjInt_btnViewTag = i;
            view.delegate = self;
            OCJGSModel_Package14* model = [self.ocjArray_subData objectAtIndex:i];
            [view ocj_setViewDataWith:model];
            [self addSubview:view];
        }
        else
        {
            CGFloat x = (i-2)*SCREEN_WIDTH/3;
            CGFloat y = SCREEN_WIDTH/3;
            OCJOnTheNewButtonViwe *view = [[OCJOnTheNewButtonViwe alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/3, SCREEN_WIDTH/3)];
            view.ocjInt_btnViewTag = i;
            view.delegate = self;
            OCJGSModel_Package14* model = [self.ocjArray_subData objectAtIndex:i];
            [view ocj_setViewDataWith:model];
            [self addSubview:view];
            
        }
        
    }
}


#pragma mark - getter
- (NSMutableArray *)ocjArray_subData{
    if (!_ocjArray_subData) {
        _ocjArray_subData = [[NSMutableArray alloc] init];
    }
    return _ocjArray_subData;
}


- (void)ocj_onTheNewButtonPressed:(NSInteger)tag
{
    OCJGSModel_Package14* model = [self.ocjArray_subData objectAtIndex:tag];
    if ( [self.delegate respondsToSelector:@selector(ocj_golbalHotPressed:At:)]) {
        [self.delegate ocj_golbalHotPressed:model At:self];
    }
    
}

@end
