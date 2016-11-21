//
//  HandleProductNum.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/25.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "HandleProductNum.h"
#import "FMDatabase.h"

@interface HandleProductNum()
{
    NSMutableDictionary *_goodModelDic;
}

@end

@implementation HandleProductNum

+ (HandleProductNum *)sharedHandleProductNum{
    static HandleProductNum *handleProduct = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handleProduct = [[HandleProductNum alloc] init];
    });
    return handleProduct;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _goodModelDic = [NSMutableDictionary dictionary];
        //获取documents路径
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        //拼接数据库路径
        NSString *dataBasePath = [documentsPath stringByAppendingPathComponent:@"dataBase.db"];
        //创建数据库(相当于一个单例，持久化存储之后只创建一次)
        _dataBase = [FMDatabase databaseWithPath:dataBasePath];
        //在操作数据库之前，要保证数据库一定处于打开状态。
        [_dataBase open];
        [_dataBase executeUpdate:@"create table if not exists Product(id integer primary key not NULL, lastProuctNumInStore integer, productNumInShoppingCart integer)"];
        [_dataBase executeUpdate:@"create table if not exists Reverse(id integer primary key not NULL, lastProuctNumInStore integer, productNumInShoppingCart integer)"];
        [_dataBase close];
    }
    return self;
}

#pragma mark -- 获取表中数据调试
- (NSMutableArray *)arrayOfTableInDataBaseWithChannelType:(ChannelType)channelType{
    NSMutableArray *productInCartArray = [NSMutableArray array];
    FMResultSet *resultSet;
    if (channelType == QuicklyService) {
        resultSet = [_dataBase executeQuery:@"select * from Product"];
    }
    else{
        resultSet = [_dataBase executeQuery:@"select * from Reverse"];
    }
    while ([resultSet next]) {
        if ([resultSet longForColumn:@"productNumInShoppingCart"] != 0) {
            NSNumber *goodsId = [resultSet objectForColumnName:@"id"];
            [productInCartArray addObject:[_goodModelDic valueForKey:[NSString stringWithFormat:@"%ld", [goodsId integerValue]]]];
        }
    }
    return productInCartArray;
}

#pragma mark -- 获取对应商品库存数量
- (NSInteger)storeProductNumWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType{
    [_dataBase open];
    [_goodModelDic setValue:goodsModel forKey:[NSString stringWithFormat:@"%ld", [goodsModel.goods_id integerValue]]];
    FMResultSet *result = nil;
    if (channelType == QuicklyService) {
        result = [_dataBase executeQuery:@"select lastProuctNumInStore from Product where id = ?", goodsModel.goods_id];
    }
    else{
        result = [_dataBase executeQuery:@"select lastProuctNumInStore from Reverse where id = ?", goodsModel.goods_id];
    }
    NSInteger storeProductNum;
    if([result next]){
        storeProductNum = [result longForColumn:LastProuctNumInStore];
    }
    else{
        storeProductNum = 0;
    }
    [_dataBase close];
    return storeProductNum;
}

#pragma mark -- 获取对应商品添加到购物车的数量
- (NSInteger)cartProductNumWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType{
    [_dataBase open];
    [_goodModelDic setValue:goodsModel forKey:[NSString stringWithFormat:@"%ld", [goodsModel.goods_id integerValue]]];
    FMResultSet *result = nil;
    if (channelType == QuicklyService) {
        result = [_dataBase executeQuery:@"select productNumInShoppingCart from Product where id = ?", goodsModel.goods_id];
    }
    else{
        result = [_dataBase executeQuery:@"select productNumInShoppingCart from Reverse where id = ?", goodsModel.goods_id];
    }
    NSInteger cartProductNum;
    if([result next]){
        cartProductNum = [result longForColumn:ProductNumInShoppingCart];
    }
    else{
        cartProductNum = 0;
    }
    [_dataBase close];
    
    return cartProductNum;
}

#pragma mark -- 更新商品库存
- (void)updateStoreProductNumWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType{
    [_goodModelDic setValue:goodsModel forKey:[NSString stringWithFormat:@"%ld", [goodsModel.goods_id integerValue]]];
    NSInteger cartProductNum = [self cartProductNumWithGoodsModel:goodsModel channelType:channelType];
    [_dataBase open];
    FMResultSet *result = nil;
    if (channelType == QuicklyService) {
        result = [_dataBase executeQuery:@"select lastProuctNumInStore from Product where id = ?", goodsModel.goods_id];
    }
    else{
        result = [_dataBase executeQuery:@"select lastProuctNumInStore from Reverse where id = ?", goodsModel.goods_id];
    }
    NSInteger currentStoreNum = [goodsModel.number integerValue]-cartProductNum;
    if ([result next]) {
        if(channelType == QuicklyService) {
             [_dataBase executeUpdate:@"update Product set lastProuctNumInStore = ? where id = ?", @(currentStoreNum>=0?currentStoreNum:0), goodsModel.goods_id];
        }
        else{
            [_dataBase executeUpdate:@"update Reverse set lastProuctNumInStore = ? where id = ?", @(currentStoreNum>=0?currentStoreNum:0), goodsModel.goods_id];
        }
    }
    else{
        if(channelType == QuicklyService) {
            [_dataBase executeUpdate:@"insert into Product(id, lastProuctNumInStore, productNumInShoppingCart) values(?, ?, ?)", goodsModel.goods_id, @(currentStoreNum>=0?currentStoreNum:0), @(cartProductNum)];

        }
        else{
            [_dataBase executeUpdate:@"insert into Reverse(id, lastProuctNumInStore, productNumInShoppingCart) values(?, ?, ?)", goodsModel.goods_id, @(currentStoreNum>=0?currentStoreNum:0), @(cartProductNum)];
        }
    }
    [_dataBase close];
}

#pragma mark -- 添加商品到购物车
- (void)addProductToCartWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType{
    [_goodModelDic setValue:goodsModel forKey:[NSString stringWithFormat:@"%ld", [goodsModel.goods_id integerValue]]];
    NSInteger cartProductNum = [self cartProductNumWithGoodsModel:goodsModel channelType:channelType];
    NSInteger storeProductNum = [self storeProductNumWithGoodsModel:goodsModel channelType:channelType];
    [_dataBase open];
    FMResultSet *result = nil;
    if (channelType == QuicklyService) {
        result = [_dataBase executeQuery:@"select lastProuctNumInStore from Product where id = ?", goodsModel.goods_id];
    }
    else{
        result = [_dataBase executeQuery:@"select lastProuctNumInStore from Reverse where id = ?", goodsModel.goods_id];
    }
    if ([result next]) {
        if (channelType == QuicklyService) {
            [_dataBase executeUpdate:@"update Product set lastProuctNumInStore = ? , productNumInShoppingCart = ? where id = ?", @(storeProductNum-1), @(cartProductNum+1), goodsModel.goods_id];

        }
        else{
            [_dataBase executeUpdate:@"update Reverse set lastProuctNumInStore = ? , productNumInShoppingCart = ? where id = ?", @(storeProductNum-1), @(cartProductNum+1), goodsModel.goods_id];
        }
    }
    else{
        if (channelType == QuicklyService) {
            [_dataBase executeUpdate:@"insert into Product(id, lastProuctNumInStore, productNumInShoppingCart) values(?, ?, ?)", goodsModel.goods_id, @(storeProductNum-1), @(cartProductNum+1)];
        }
        else{
            [_dataBase executeUpdate:@"insert into Reverse(id, lastProuctNumInStore, productNumInShoppingCart) values(?, ?, ?)", goodsModel.goods_id, @(storeProductNum-1), @(cartProductNum+1)];
        }
    }
    NSLog(@"%@", [self arrayOfTableInDataBaseWithChannelType:channelType]);
    [_dataBase close];
}

#pragma mark -- 从购物车减少商品
- (void)reduceProductFromCartWithGoodsModel:(GoodsModel *)goodsModel channelType:(ChannelType)channelType{
    [_goodModelDic setValue:goodsModel forKey:[NSString stringWithFormat:@"%ld", [goodsModel.goods_id integerValue]]];
    NSInteger cartProductNum = [self cartProductNumWithGoodsModel:goodsModel channelType:channelType];
    NSInteger storeProductNum = [self storeProductNumWithGoodsModel:goodsModel channelType:channelType];
    [_dataBase open];
    FMResultSet *result = nil;
    if (channelType == QuicklyService) {
        result = [_dataBase executeQuery:@"select lastProuctNumInStore from Product where id = ?", goodsModel.goods_id];
    }
    else{
        result = [_dataBase executeQuery:@"select lastProuctNumInStore from Reverse where id = ?", goodsModel.goods_id];
    }
    if ([result next]) {
        if (channelType == QuicklyService) {
            [_dataBase executeUpdate:@"update Product set lastProuctNumInStore = ? , productNumInShoppingCart = ? where id = ?", @(storeProductNum+1), @(cartProductNum-1), goodsModel.goods_id];
        }
        else{
            [_dataBase executeUpdate:@"update Reverse set lastProuctNumInStore = ? , productNumInShoppingCart = ? where id = ?", @(storeProductNum+1), @(cartProductNum-1), goodsModel.goods_id];
        }
    }
    else{
        if (channelType == QuicklyService) {
            [_dataBase executeUpdate:@"insert into Product(id, lastProuctNumInStore, productNumInShoppingCart) values(?, ?, ?)", goodsModel.goods_id, @(storeProductNum+1), @(cartProductNum-1)];
        }
        else{
            [_dataBase executeUpdate:@"insert into Reverse(id, lastProuctNumInStore, productNumInShoppingCart) values(?, ?, ?)", goodsModel.goods_id, @(storeProductNum+1), @(cartProductNum-1)];
        }
    }
    [_dataBase close];
}

@end
