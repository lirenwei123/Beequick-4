//
//  CategoryDetailModel.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/21.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "CategoryDetailModel.h"

@implementation CategoryDetailModel


@end

@implementation GoodsModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"goods_id":@"id"}];
}

@end



