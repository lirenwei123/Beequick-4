//
//  MarketCategoryTableViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/25.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "MarketCategoryTableViewCell.h"
#import "MarketCategorysModel.h"
#import "UIImageView+WebCache.h"

@interface MarketCategoryTableViewCell()
{
    UIView *_vorticalLineView;
    UIView *_speracterLineView;
    UILabel *_nameLabel;
    UIImageView *_flagImageView;
}

@end

@implementation MarketCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setSubViewFrame];
}

#pragma mark -- 配置视图
- (void)setUpView{
    [self.contentView setBackgroundColor:Color_RGB(244, 244, 244, 1)];
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setTextColor:Color_RGB(95, 95, 95, 1)];
    [_nameLabel setFont:[UIFont systemFontOfSize:12]];
    [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_nameLabel];
    
    _vorticalLineView = [[UIView alloc] init];
    [self.contentView addSubview:_vorticalLineView];
    
    _flagImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_flagImageView];
    
    _speracterLineView = [[UIView alloc] init];
    [_speracterLineView setBackgroundColor:Line_Color];
    [self.contentView addSubview:_speracterLineView];
}

#pragma mark -- 配置数据
- (void)setMarketModel:(MarketCategorysModel *)marketModel{
    if (marketModel) {
        _marketModel = marketModel;
        [_nameLabel setText:marketModel.name];
        [_flagImageView sd_setImageWithURL:[NSURL URLWithString:marketModel.flag]];
    }
}

#pragma mark -- 配置视图frame
- (void)setSubViewFrame{
    [_nameLabel setFrame:self.contentView.bounds];
    [_vorticalLineView setFrame:CGRectMake(0, 4, 5, self.contentView.cur_h-8)];
    [_flagImageView setFrame:CGRectMake(self.contentView.cur_w-28, 0, 28, 28)];
    [_speracterLineView setFrame:CGRectMake(0, self.contentView.cur_h-0.5, self.contentView.cur_w, 0.5)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [_vorticalLineView setBackgroundColor:Color_RGB(238, 183, 11, 1)];
        [_nameLabel setTextColor:[UIColor blackColor]];
    }
    else{
        [self.contentView setBackgroundColor:Color_RGB(244, 244, 244, 1)];
        [_vorticalLineView setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:Color_RGB(95, 95, 95, 1)];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [_vorticalLineView setBackgroundColor:Color_RGB(238, 183, 11, 1)];
        [_nameLabel setTextColor:[UIColor blackColor]];
    }
    else{
        [self.contentView setBackgroundColor:Color_RGB(244, 244, 244, 1)];
        [_vorticalLineView setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:Color_RGB(95, 95, 95, 1)];
    }
}

@end





