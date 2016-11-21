//
//  NetTool.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/18.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkAPIClient.h"

@interface NetTool : NSObject

/**
 *  请求启动广告页
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)get_foucsWithSuccess:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure;

/**
 *  请求首页数据
 *
 *  @param g_phone  用户手机号
 *  @param location 定位位置
 *  @param success  请求成功的回调
 *  @param failure  请求失败的回调
 */
+ (void)post_HomeWithG_phone:(NSString *)g_phone location:(NSString *)location success:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure;

@end




