//
//  CategoryTableViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/21.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HomeActivityModel.h"
#import "CategoryDetailModel.h"
#import "ProductView.h"
#import "HandleProductNum.h"
#import "ReverceCategoryModel.h"

@interface CategoryTableViewCell()
{
    UIView *_backView;
    UIView *_frontLineView;
    UILabel *_nameLabel;
    UILabel *_moreLabel;
    UIImageView *_arrawImageView;
    UIImageView *_headImageView;
    NSMutableArray *_bottomViewsArray;
}

@property (nonatomic, strong) HomeActivityModel *activityModel;
@property (nonatomic,strong) CategoryDetailModel *categryModel;

@end

@implementation CategoryTableViewCell

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
    
    _frontLineView = [[UIView alloc] init];
    [_backView addSubview:_frontLineView];
    
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setFont:[UIFont systemFontOfSize:16]];
    [_backView addSubview:_nameLabel];
    
    _moreLabel = [[UILabel alloc] init];
    [_moreLabel setUserInteractionEnabled:YES];
    [_moreLabel setText:@"更多"];
    [_moreLabel setFont:[UIFont systemFontOfSize:13]];
    [_moreLabel setTextColor:Color_RGB(163, 163, 163, 1)];
    [_backView addSubview:_moreLabel];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTapGestureResponse)];
    [_moreLabel addGestureRecognizer:tapGesture];
    
    _arrawImageView = [[UIImageView alloc] init];
    [_arrawImageView setImage:[UIImage imageNamed:@"icon_go"]];
    [_backView addSubview:_arrawImageView];
    
    _headImageView = [[UIImageView alloc] init];
    [_backView addSubview:_headImageView];
    
    _bottomViewsArray = [NSMutableArray array];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setSubviewFrame];
}

- (void)setSubviewFrame{
    [_backView setFrame:CGRectMake(0, 0, self.contentView.cur_w, self.contentView.cur_h-10)];
    [_frontLineView setFrame:CGRectMake(10, 10, 3, 16)];
    [_nameLabel setFrame:CGRectMake(_frontLineView.cur_x_w+5, _frontLineView.cur_y-2, 200, _frontLineView.cur_h+4)];
    [_moreLabel setFrame:CGRectMake(_backView.cur_w-50, 0, 50, 30)];
    [_arrawImageView setFrame:CGRectMake(_backView.cur_w-15, 10, 5, 10)];
    [_headImageView setFrame:CGRectMake(_frontLineView.cur_x, _frontLineView.cur_y_h+10, _backView.cur_w-20, 100)];
    for (NSInteger i=0; i<_categryModel.goods.count; i++) {
        ProductView *bottomView = [_bottomViewsArray objectAtIndex:i];
        [bottomView setFrame:CGRectMake(i%3*_backView.cur_w/3, i/3*(87+_backView.cur_w/3)+_headImageView.cur_y_h+10, _backView.cur_w/3, 87+_backView.cur_w/3) goodsModel:_categryModel.goods[i] type:NO];
    }
}

- (void)categoryDataWithActivityModel:(HomeActivityModel *)activityModel categoryModel:(CategoryDetailModel *)categoryModel{
    [_bottomViewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    _activityModel = activityModel;
    _categryModel = categoryModel;
    [_frontLineView setBackgroundColor:[UIColor orangeColor]];
    [_nameLabel setText:categoryModel.name];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:activityModel.img] placeholderImage:[UIImage imageNamed:@"v2_placeholder_full_size"]];
    __weak typeof(self) weakSelf = self;
    for (NSInteger i=0; i<_categryModel.goods.count; i++) {
        BOOL isHaveLine = (i!=2)?YES:NO;
        ProductView *bottomView = [[ProductView alloc] initWithFrame:CGRectZero isHaveLine:isHaveLine productViewType:NoExistDecreaseType index:i];
        //添加商品
        [bottomView setAddProductBlock:^(UIView *contentView, UIButton *sender) {
            HandleProductNum *handleProduct = [HandleProductNum sharedHandleProductNum];
            NSInteger storeProductNum = [handleProduct storeProductNumWithGoodsModel:weakSelf.categryModel.goods[sender.tag-100] channelType:QuicklyService];
            if (storeProductNum == 0) {
                NSInteger currentCartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.categryModel.goods[sender.tag-100] channelType:QuicklyService];
                [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:currentCartProductNum];
                return;
            }
            [handleProduct addProductToCartWithGoodsModel:weakSelf.categryModel.goods[sender.tag-100] channelType:QuicklyService];
            NSInteger cartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.categryModel.goods[sender.tag-100] channelType:QuicklyService];
            [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:cartProductNum];
            NSNotification *noti = [NSNotification notificationWithName:AddProductToShoppingCartNotification object:nil userInfo:@{@"contentView":contentView, @"goodsModel":weakSelf.categryModel.goods[sender.tag-100]}];
            [[NSNotificationCenter defaultCenter] postNotification:noti];
            
        }];
        [bottomView setFrame:CGRectMake(i*_backView.cur_w/3, i/3*(87+_backView.cur_w/3)+_headImageView.cur_y_h+10, _backView.cur_w/3, 87+_backView.cur_w/3) goodsModel:_categryModel.goods[i] type:NoExistDecreaseType];
        GoodsModel *goodsModel = _categryModel.goods[i];
        [[HandleProductNum sharedHandleProductNum] updateStoreProductNumWithGoodsModel:goodsModel channelType:QuicklyService];
        [_backView addSubview:bottomView];
        [_bottomViewsArray addObject:bottomView];
    }
    [_bottomViewsArray enumerateObjectsUsingBlock:^(ProductView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setGoodsModel:categoryModel.goods[idx] productType:ExistDecreaseType];
    }];
    [self setSubviewFrame];
}

- (void)setReverceCategoryModel:(ReverceCategoryModel *)reverceCategoryModel{
    if (reverceCategoryModel) {
        _reverceCategoryModel = reverceCategoryModel;
        _categryModel = reverceCategoryModel.category_detail;
        CategoryDetailModel *categoryModel = _categryModel;
        [_bottomViewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_bottomViewsArray removeAllObjects];
        [_frontLineView setBackgroundColor:[UIColor orangeColor]];
        [_nameLabel setText:categoryModel.name];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:reverceCategoryModel.banner_img] placeholderImage:[UIImage imageNamed:@"v2_placeholder_full_size"]];
        __weak typeof(self) weakSelf = self;
        for (NSInteger i=0; i<_categryModel.goods.count; i++) {
            BOOL isHaveLine = (i!=2)?YES:NO;
            ProductView *bottomView = [[ProductView alloc] initWithFrame:CGRectZero isHaveLine:isHaveLine productViewType:NoExistDecreaseType index:i];
            //添加商品
            [bottomView setAddProductBlock:^(UIView *contentView, UIButton *sender) {
                HandleProductNum *handleProduct = [HandleProductNum sharedHandleProductNum];
                NSInteger storeProductNum = [handleProduct storeProductNumWithGoodsModel:weakSelf.categryModel.goods[sender.tag-100] channelType:ReverseService];
                if (storeProductNum == 0) {
                    NSInteger currentCartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.categryModel.goods[sender.tag-100] channelType:ReverseService];
                    [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:currentCartProductNum];
                    return;
                }
                [handleProduct addProductToCartWithGoodsModel:weakSelf.categryModel.goods[sender.tag-100] channelType:ReverseService];
                NSInteger cartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.categryModel.goods[sender.tag-100] channelType:ReverseService];
                [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:cartProductNum];
                NSNotification *noti = [NSNotification notificationWithName:AddProductToShoppingCartNotification object:nil userInfo:@{@"contentView":contentView, @"goodsModel":weakSelf.categryModel.goods[sender.tag-100]}];
                [[NSNotificationCenter defaultCenter] postNotification:noti];
                
            }];
            [bottomView setFrame:CGRectMake(i*_backView.cur_w/3, i/3*(87+_backView.cur_w/3)+_headImageView.cur_y_h+10, _backView.cur_w/3, 87+_backView.cur_w/3) goodsModel:_categryModel.goods[i] type:NoExistDecreaseType];
            GoodsModel *goodsModel = _categryModel.goods[i];
            [[HandleProductNum sharedHandleProductNum] updateStoreProductNumWithGoodsModel:goodsModel channelType:ReverseService];
            [_backView addSubview:bottomView];
            [_bottomViewsArray addObject:bottomView];
        }
        [_bottomViewsArray enumerateObjectsUsingBlock:^(ProductView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setGoodsModel:categoryModel.goods[idx] productType:ReverseType];
        }];
        [self setSubviewFrame];
    }
}

#pragma mark -- 更多的响应事件
- (void)moreTapGestureResponse{

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
