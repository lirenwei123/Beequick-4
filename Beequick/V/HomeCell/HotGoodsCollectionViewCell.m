//
//  HotGoodsCollectionViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/22.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "HotGoodsCollectionViewCell.h"
#import "ProductView.h"
#import "HandleProductNum.h"

@interface HotGoodsCollectionViewCell()
{
    ProductView *_productView;
    GoodsModel *_goodsModel;
}

@end

@implementation HotGoodsCollectionViewCell

- (void)dealloc{
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        _productView = [[ProductView alloc] initWithFrame:CGRectZero isHaveLine:NO productViewType:ExistDecreaseType index:0];
        [self.contentView addSubview:_productView];
    }
    return self;
}

- (void)setType:(ProductViewType)type{
    _type = type;
    __weak typeof(self) weakSelf = self;
    //添加商品
    [_productView setAddProductBlock:^(UIView *contentView, UIButton *sender) {
        HandleProductNum *handleProduct = [HandleProductNum sharedHandleProductNum];
        NSInteger storeProductNum = [handleProduct storeProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-100] channelType:(type==ReverseType?ReverseService:QuicklyService)];
        if (storeProductNum == 0) {
            NSInteger currentCartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-100] channelType:(type==ReverseType?ReverseService:QuicklyService)];
            [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:currentCartProductNum];
            return;
        }
        [handleProduct addProductToCartWithGoodsModel:weakSelf.goodsModelArray[sender.tag-100] channelType:(type==ReverseType?ReverseService:QuicklyService)];
        NSInteger cartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-100] channelType:(type==ReverseType?ReverseService:QuicklyService)];
        [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:cartProductNum];
        NSNotification *noti = [NSNotification notificationWithName:AddProductToShoppingCartNotification object:nil userInfo:@{@"contentView":contentView, @"goodsModel":weakSelf.goodsModelArray[sender.tag-100]}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }];
    //减少商品
    [_productView setReduceProductBlock:^(UIButton *sender) {
        HandleProductNum *handleProduct = [HandleProductNum sharedHandleProductNum];
        [handleProduct reduceProductFromCartWithGoodsModel:weakSelf.goodsModelArray[sender.tag-200] channelType:(type==ReverseType?ReverseService:QuicklyService)];
        NSInteger storeProductNum = [handleProduct storeProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-200] channelType:(type==ReverseType?ReverseService:QuicklyService)];
        NSInteger cartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-200] channelType:(type==ReverseType?ReverseService:QuicklyService)];
        [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:cartProductNum];
        NSNotification *noti = [NSNotification notificationWithName:RemoveProductFromShopingCartNotification object:nil userInfo:@{@"goodsModel":weakSelf. goodsModelArray[sender.tag-200]}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_productView setFrame:self.contentView.bounds goodsModel:_goodsModel type:_type];
}

- (void)setHotGoodsDataWithGoodsModel:(GoodsModel *)goodsModel rowIndex:(NSInteger)rowIndex{
    if (goodsModel) {
        _goodsModel = goodsModel;
        [_productView setGoodsModel:goodsModel productType:_type];
        [_productView setFrame:self.contentView.bounds goodsModel:goodsModel type:_type];
        [_productView setRowIndex:rowIndex];
        [[HandleProductNum sharedHandleProductNum] updateStoreProductNumWithGoodsModel:goodsModel channelType:(_type==ReverseType?ReverseService:QuicklyService)];
    }
}

- (void)refreashViewWithGoodsModel:(GoodsModel *)goodsModel{
    NSInteger storeProductNum = [[HandleProductNum sharedHandleProductNum] storeProductNumWithGoodsModel:goodsModel channelType:(_type==ReverseType?ReverseService:QuicklyService)];
    NSInteger cartProductNum = [[HandleProductNum sharedHandleProductNum] cartProductNumWithGoodsModel:goodsModel channelType:(_type==ReverseType?ReverseService:QuicklyService)];
    [_productView handleProductWithStoreProductNum:storeProductNum cartProductNum:cartProductNum];
    
}

@end
