//
//  OCJOverseasRecommendTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOverseasRecommendTableViewCell.h"
#import "OCJOnTheNewButtonViwe.h"

@interface OCJOverseasRecommendTableViewCell()<OOCJOnTheNewButtonViweDelegate>
@property (nonatomic,strong) NSMutableArray      *ocjArray_subData;

@end

@implementation OCJOverseasRecommendTableViewCell

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
        CGFloat x = (i%3)*SCREEN_WIDTH/3;
        CGFloat y = (i/3)*(SCREEN_WIDTH/3);
        OCJOnTheNewButtonViwe *view = [[OCJOnTheNewButtonViwe alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/3, SCREEN_WIDTH/3)];
        view.delegate = self;
        view.ocjInt_btnViewTag = i;
        OCJGSModel_Package14* model = [self.ocjArray_subData objectAtIndex:i];
        [view ocj_setViewDataWith:model];
        [self addSubview:view];
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
    OCJGSModel_Package14* model = self.ocjArray_subData[tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalOverSeasPressed:At:)]) {
        [self.delegate ocj_golbalOverSeasPressed:model At:self];
    }

}

@end
