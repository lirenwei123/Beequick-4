//
//  SceneTableViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/21.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "SceneTableViewCell.h"
#import "HomeActivityModel.h"
#import "UIImageView+WebCache.h"

@interface SceneTableViewCell()
{
    UIView *_backView;
}

@end

@implementation SceneTableViewCell

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
    [self.contentView addSubview:_backView];
    
    for (NSInteger i=0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [_backView addSubview:imageView];
    }
}

- (void)setSubviewFrame{
    [_backView setFrame:CGRectMake(0, 0, self.contentView.cur_w, self.contentView.cur_h-10)];
    [_backView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        [obj setFrame:CGRectMake(i%2*((_backView.cur_w-0.5)/2+0.5), i/2*((_backView.cur_h-0.5)/2+0.5), (_backView.cur_w-0.5)/2, (_backView.cur_h-0.5)/2)];
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setSubviewFrame];
}

- (void)setSceneDataArray:(NSArray *)sceneDataArray{
    if (sceneDataArray) {
        _sceneDataArray = sceneDataArray;
        [_backView.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj sd_setImageWithURL:[NSURL URLWithString:[(HomeActivityModel*)sceneDataArray[idx] img]] placeholderImage:[UIImage imageNamed:PlaceholderImage]];
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
