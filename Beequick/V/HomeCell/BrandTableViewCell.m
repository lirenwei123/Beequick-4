//
//  BrandTableViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/21.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "BrandTableViewCell.h"
#import "HomeActivityModel.h"
#import "UIImageView+WebCache.h"

@interface BrandTableViewCell()
{
    UIScrollView *_scrollView;
}

@property (nonatomic,strong) NSMutableArray *imageViewsArray;

@end

@implementation BrandTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

#pragma mark --  配置视图
- (void)setUpView{
    [self.contentView setBackgroundColor:Color_RGB(232, 232, 232, 1)];
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self.contentView addSubview:_scrollView];
}

- (NSMutableArray *)imageViewsArray{
    if (_imageViewsArray == nil) {
        _imageViewsArray = [NSMutableArray array];
    }
    return _imageViewsArray;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_scrollView setFrame:CGRectMake(0, 0, self.contentView.cur_w, self.contentView.cur_h-10)];
    [self.imageViewsArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx%2 == 0) {
            //imageView
            [obj setFrame:CGRectMake(idx/2*117.5, 0, 117, _scrollView.cur_h)];
        }
        else{
            //lineView
            [obj setFrame:CGRectMake((idx/2+1)*117+idx/2*0.5, 0, 0.5, _scrollView.cur_h)];
        }
    }];
}

- (void)setBrandDataArray:(NSArray *)brandDataArray{
    if (brandDataArray) {
        for (UIView *subView in self.imageViewsArray) {
            [subView removeFromSuperview];
        }
        [self.imageViewsArray removeAllObjects];
        [_scrollView setFrame:CGRectMake(0, 0, self.contentView.cur_w, self.contentView.cur_h-10)];
        [_scrollView setContentSize:CGSizeMake(117.5*brandDataArray.count, 0)];
        _brandDataArray = brandDataArray;
        for (NSInteger i=0; i<brandDataArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*117.5, 0, 117, _scrollView.cur_h)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[(HomeActivityModel *)brandDataArray[i] img]] placeholderImage:[UIImage imageNamed:PlaceholderImage]];
            [_scrollView addSubview:imageView];
            [self.imageViewsArray addObject:imageView];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((i+1)*117+i*0.5, 0, 0.5, _scrollView.cur_h)];
            [lineView setBackgroundColor:Line_Color];
            [_scrollView addSubview:lineView];
            [self.imageViewsArray addObject:lineView];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
