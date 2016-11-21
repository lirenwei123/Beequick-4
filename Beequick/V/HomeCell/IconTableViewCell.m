//
//  IconTableViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/20.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "IconTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HomeActivityModel.h"

@interface IconTableViewCell()
{
    NSMutableArray *_btnArray;
    IconCellType _type;
    UIView *_speractorView;
}

@end

@implementation IconTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(IconCellType)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _type = type;
        _btnArray = [NSMutableArray array];
        [self setUpView];
    }
    return self;
}

#pragma mark -- 配置视图
- (void)setUpView{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    if (_type == ExistSperactorLine) {
        _speractorView = [[UIView alloc] init];
        [_speractorView setBackgroundColor:Color_RGB(244, 244, 244, 1)];
        [self.contentView addSubview:_speractorView];

    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setSubViewFrame];
}

- (void)setSubViewFrame{
    CGFloat width = self.contentView.cur_w/4;
    CGFloat height;
    if (_type == ExistSperactorLine) {
        height = (self.contentView.cur_h-10)/(_iconDataArray.count/4);
    }
    else{
        height = self.contentView.cur_h/(_iconDataArray.count/4);
    }
    [_btnArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setFrame:CGRectMake(idx%4*width, idx/4*height, width, height)];
        [obj.subviews[0] setFrame:CGRectMake((width-70)/2, (height-65)/2, 65, 45)];
        [obj.subviews[1] setFrame:CGRectMake(0,obj.subviews[0].cur_y_h+5, width, 15)];
    }];
    [_speractorView setFrame:CGRectMake(0, self.contentView.cur_h-10, self.contentView.cur_w, 10)];
}

- (void)setIconDataArray:(NSArray *)iconDataArray{
    if (iconDataArray) {
        [_btnArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_btnArray removeAllObjects];
        _iconDataArray = iconDataArray;
        for (NSInteger i=0; i<iconDataArray.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button addTarget:self action:@selector(iconBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:50+i];
            [self.contentView addSubview:button];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [button addSubview:imageView];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            [titleLabel setFont:[UIFont systemFontOfSize:12]];
            [titleLabel setTextColor:[UIColor blackColor]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [button addSubview:titleLabel];
            
            HomeActivityModel *model = iconDataArray[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:PlaceholderImage]];
            [titleLabel setText:model.name];

            [_btnArray addObject:button];
        }
    }
    [self setSubViewFrame];
}

#pragma mark -- 按钮的响应事件
- (void)iconBtnClicked:(UIButton *)sender{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
