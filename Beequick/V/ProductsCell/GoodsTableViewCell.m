//
//  GoodsTableViewCell.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/26.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "ProductView.h"
#import "HandleProductNum.h"

@interface GoodsTableViewCell()
{
    ProductView *_productView;
    UIView *_lineView;
    GoodsModel *_goodsModel;
}

@property(nonatomic,assign)ChannelType type;

@end

@implementation GoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(ChannelType)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _type = type;
        [self setUpView];
    }
    return self;
}

#pragma mark -- 配置视图
- (void)setUpView{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    _productView = [[ProductView alloc] initWithFrame:CGRectZero isHaveLine:NO productViewType:HorizonRankType index:0];
    [self.contentView addSubview:_productView];
    
    __weak typeof(self) weakSelf = self;
    //添加商品
    [_productView setAddProductBlock:^(UIView *contentView, UIButton *sender) {
        HandleProductNum *handleProduct = [HandleProductNum sharedHandleProductNum];
        NSInteger storeProductNum = [handleProduct storeProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-100] channelType:weakSelf.type];
        if (storeProductNum == 0) {
            NSInteger currentCartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-100] channelType:weakSelf.type];
            [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:currentCartProductNum];
            return;
        }
        [handleProduct addProductToCartWithGoodsModel:weakSelf.goodsModelArray[sender.tag-100] channelType:weakSelf.type];
        NSInteger cartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-100] channelType:weakSelf.type];
        [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:cartProductNum];
        NSNotification *noti = [NSNotification notificationWithName:AddProductToShoppingCartNotification object:nil userInfo:@{@"contentView":contentView, @"goodsModel":weakSelf.goodsModelArray[sender.tag-100]}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }];
    //减少商品
    [_productView setReduceProductBlock:^(UIButton *sender) {
        HandleProductNum *handleProduct = [HandleProductNum sharedHandleProductNum];
        [handleProduct reduceProductFromCartWithGoodsModel:weakSelf.goodsModelArray[sender.tag-200] channelType:weakSelf.type];
        NSInteger storeProductNum = [handleProduct storeProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-200] channelType:weakSelf.type];
        NSInteger cartProductNum = [handleProduct cartProductNumWithGoodsModel:weakSelf.goodsModelArray[sender.tag-200] channelType:weakSelf.type];
        [(ProductView *)[sender superview] handleProductWithStoreProductNum:storeProductNum cartProductNum:cartProductNum];
        NSNotification *noti = [NSNotification notificationWithName:RemoveProductFromShopingCartNotification object:nil userInfo:@{@"goodsModel":weakSelf. goodsModelArray[sender.tag-200]}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }];
    
    _lineView = [[UIView alloc] init];
    [_lineView setBackgroundColor:Line_Color];
    [self.contentView addSubview:_lineView];
}

#pragma mark -- 配置frame
- (void)layoutSubviews{
    [super layoutSubviews];
    [_productView setFrame:CGRectMake(0, 0, self.contentView.cur_w, self.contentView.cur_h-0.5) goodsModel:_goodsModel type:HorizonRankType];
    [_lineView setFrame:CGRectMake(8, self.contentView.cur_h-0.5, self.contentView.cur_w-8, 0.5)];
}

- (void)setGoodsDataWithGoodsModel:(GoodsModel *)goodsModel rowIndex:(NSInteger)rowIndex{
    if (goodsModel) {
        _goodsModel = goodsModel;
        [_productView setGoodsModel:goodsModel productType:HorizonRankType];
        [_productView setFrame:CGRectMake(0, 0, self.contentView.cur_w, self.contentView.cur_h-0.5) goodsModel:goodsModel type:HorizonRankType];
        [_productView setRowIndex:rowIndex];
        [[HandleProductNum sharedHandleProductNum] updateStoreProductNumWithGoodsModel:goodsModel channelType:self.type];
    }
}

- (void)refreashViewWithGoodsModel:(GoodsModel *)goodsModel{
    NSInteger storeProductNum = [[HandleProductNum sharedHandleProductNum] storeProductNumWithGoodsModel:goodsModel channelType:self.type];
    NSInteger cartProductNum = [[HandleProductNum sharedHandleProductNum] cartProductNumWithGoodsModel:goodsModel channelType:self.type];
    [_productView handleProductWithStoreProductNum:storeProductNum cartProductNum:cartProductNum];
    
}


@end
