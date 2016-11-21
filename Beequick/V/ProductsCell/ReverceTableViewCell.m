//
//  ReverceTableViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/27.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ReverceTableViewCell.h"
#import "HotGoodsCollectionViewCell.h"
#import "ReverseActiveModel.h"
#import "UIImageView+WebCache.h"

#define HotGoodsCellIdentifer @"HotGoodsCellIdentifer"
#define OriginalCellIdentifer @"OriginalCellIdentifer"

@interface ReverceTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UIView *_backView;
    UIImageView *_headImageView;
    UICollectionView *_collectionView;
}

@end

@implementation ReverceTableViewCell

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
    
    _headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_headImageView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView registerClass:[HotGoodsCollectionViewCell class] forCellWithReuseIdentifier:HotGoodsCellIdentifer];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:OriginalCellIdentifer];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [self.contentView addSubview:_collectionView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setSubViewFrame];
}

#pragma mark -- 配置视图数据
- (void)setSubViewFrame{
    [_backView setFrame:CGRectMake(0, 0, self.contentView.cur_w, self.contentView.cur_h-10)];
    [_headImageView setFrame:CGRectMake(35, 0, self.contentView.cur_w-70, 35)];
    [_collectionView setFrame:CGRectMake(0, _headImageView.cur_y_h, self.contentView.cur_w, _backView.cur_h-_headImageView.cur_y_h)];
    [_collectionView setContentSize:CGSizeMake(163*([_reverseModel.activ_detail.display_number integerValue]+1), 0)];
    [_collectionView reloadData];
}

- (void)setReverseModel:(ReverseActiveModel *)reverseModel{
    if (reverseModel) {
        _reverseModel = reverseModel;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_reverseModel.banner_img]];
        [self setSubViewFrame];
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_reverseModel.activ_detail.display_number integerValue]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = nil;
    if (indexPath.row != [_reverseModel.activ_detail.display_number integerValue]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:HotGoodsCellIdentifer forIndexPath:indexPath];
        [(HotGoodsCollectionViewCell *)cell setType:ReverseType];
        [(HotGoodsCollectionViewCell *)cell setGoodsModelArray:_reverseModel.activ_detail.goods];
        [(HotGoodsCollectionViewCell *)cell setHotGoodsDataWithGoodsModel:_reverseModel.activ_detail.goods[indexPath.row] rowIndex:indexPath.row];
    }
    else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:OriginalCellIdentifer forIndexPath:indexPath];
        UIImageView *imageView = [cell.contentView viewWithTag:3000];
        if (!imageView) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 163, _collectionView.cur_h)];
            [imageView setTag:3000];
            [cell.contentView addSubview:imageView];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:_reverseModel.more_activity.img] placeholderImage:[UIImage imageNamed:PlaceholderImage]];
    }
    return cell;
}
#pragma mark -- UICollectionViewDelegate
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(163, _collectionView.cur_h);
}

@end
