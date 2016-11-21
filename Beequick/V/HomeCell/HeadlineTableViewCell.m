//
//  HeadlineTableViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/20.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "HeadlineTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface HeadlineTableViewCell()
{
    UIView *_backView;
    UIView *_horizonLineView;
    UIView *_verticalLineView;
    UIImageView *_headImageView;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
}

@end

@implementation HeadlineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

#pragma mark -- 配置视图
- (void)setUpView{
    [self.contentView setBackgroundColor:Color_RGB(232, 232, 232, 1)];
    
    _backView = [[UIView alloc] init];
    [_backView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_backView];
    
    _horizonLineView = [[UIView alloc] init];
    [_horizonLineView setBackgroundColor:Line_Color];
    [_backView addSubview:_horizonLineView];
    
    _headImageView = [[UIImageView alloc] init];
    [_backView addSubview:_headImageView];
    
    _verticalLineView = [[UIView alloc] init];
    [_verticalLineView setBackgroundColor:Line_Color];
    [_backView addSubview:_verticalLineView];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor redColor]];
    [_titleLabel.layer setCornerRadius:4];
    [_titleLabel.layer setBorderColor:[UIColor redColor].CGColor];
    [_titleLabel.layer setBorderWidth:1];
    [_backView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] init];
    [_contentLabel setTextColor:Color_RGB(163, 163, 163, 1)];
    [_contentLabel setFont:[UIFont systemFontOfSize:12]];
    [_backView addSubview:_contentLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setSubViewFrame];
    
}

- (void)setSubViewFrame{
    [_backView setFrame:CGRectMake(0, 0, self.cur_w, self.cur_h-10)];
    [_horizonLineView setFrame:CGRectMake(0, 0, self.cur_w, 0.5)];
    [_headImageView setFrame:CGRectMake(5, (_backView.cur_h-20)/2, 70, 20)];
    [_verticalLineView setFrame:CGRectMake(_headImageView.cur_x_w+5, 5, 0.5, _backView.cur_h-10)];
}

- (void)setHeadLineCellDataWithTilte:(NSString *)title contents:(NSString *)contents headImage:(NSString *)headImage{
    [self setSubViewFrame];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:headImage]];
    [_titleLabel setText:title];
    CGRect labelRect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    [_titleLabel setFrame:CGRectMake(_verticalLineView.cur_x_w+5, (_backView.cur_h-15)/2, labelRect.size.width+4, 15)];
    [_contentLabel setText:contents];
    [_contentLabel setFrame:CGRectMake(_titleLabel.cur_x_w+5, _titleLabel.cur_y, _backView.cur_w-_titleLabel.cur_x_w-10, _titleLabel.cur_h)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end








