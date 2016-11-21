//
//  HomeActivityModel.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/20.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "HomeActivityModel.h"

@implementation HomeActivityModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"activity_id":@"id"}];
}

@end

@implementation ParamsModel


@end



