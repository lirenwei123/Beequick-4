//
//  MarketCategorysModel.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/25.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "MarketCategorysModel.h"

@implementation MarketCategorysModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"categoryId":@"id"}];
}


@end
@implementation ChildCategoryModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"childId":@"id"}];
}

@end


