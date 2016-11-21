//
//  HandleProductNum.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/25.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryDetailModel.h"

@class FMDatabase;
@interface HandleProductNum : NSObject

@property (nonatomic,strong) FMDatabase *dataBase;

+ (HandleProductNum *)sharedHandleProductNum;

- (NSMutableArray *)arrayOfTableInDataBaseWithChannelType:(ChannelType)channelType;

- (NSInteger)storeProductNumWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType;
- (NSInteger)cartProductNumWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType;

- (void)updateStoreProductNumWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType;
- (void)addProductToCartWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType;
- (void)reduceProductFromCartWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType;


@end






