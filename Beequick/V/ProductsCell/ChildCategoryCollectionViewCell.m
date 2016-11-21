//
//  ChildCategoryCollectionViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/26.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ChildCategoryCollectionViewCell.h"

@interface ChildCategoryCollectionViewCell()
{
    UILabel *_categoryNameLabel;
}

@end

@implementation ChildCategoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

#pragma mark -- 配置视图
- (void)setUpView{
    _categoryNameLabel = [[UILabel alloc] init];
    [_categoryNameLabel setTextAlignment:NSTextAlignmentCenter];
    [_categoryNameLabel setTextColor:Color_RGB(95, 95, 95, 1)];
    [_categoryNameLabel setFont:[UIFont systemFontOfSize:12]];
    [_categoryNameLabel.layer setBorderColor:Line_Color.CGColor];
    [_categoryNameLabel.layer setBorderWidth:0.5];
    [_categoryNameLabel setBackgroundColor:Color_RGB(244, 244, 244, 1)];
    [_categoryNameLabel.layer setCornerRadius:4];
    [self.contentView addSubview:_categoryNameLabel];
}

- (void)setChildCategoryModel:(ChildCategoryModel *)childCategoryModel{
    if (childCategoryModel) {
        _childCategoryModel = childCategoryModel;
        [_categoryNameLabel setText:childCategoryModel.name];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_categoryNameLabel setFrame:self.contentView.bounds];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [_categoryNameLabel setBackgroundColor:Color_RGB(255, 251, 230, 1)];
        [_categoryNameLabel.layer setBorderColor:Color_RGB(249, 220, 65, 1).CGColor];
        [_categoryNameLabel setTextColor:Color_RGB(253, 121, 12, 1)];
    }
    else{
        [_categoryNameLabel setTextColor:Color_RGB(95, 95, 95, 1)];
        [_categoryNameLabel setBackgroundColor:Color_RGB(244, 244, 244, 1)];
        [_categoryNameLabel.layer setBorderColor:Line_Color.CGColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        [_categoryNameLabel setBackgroundColor:Color_RGB(255, 251, 230, 1)];
        [_categoryNameLabel.layer setBorderColor:Color_RGB(249, 220, 65, 1).CGColor];
        [_categoryNameLabel setTextColor:Color_RGB(253, 121, 12, 1)];
    }
    else{
        [_categoryNameLabel setTextColor:Color_RGB(95, 95, 95, 1)];
        [_categoryNameLabel setBackgroundColor:Color_RGB(244, 244, 244, 1)];
        [_categoryNameLabel.layer setBorderColor:Line_Color.CGColor];
    }
}

@end




