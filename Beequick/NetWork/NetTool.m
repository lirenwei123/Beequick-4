//
//  NetTool.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/18.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NetTool.h"

@implementation NetTool

//请求广告页数据
+ (void)get_foucsWithSuccess:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure{
    [[NetWorkAPIClient sharedAPIClient] GET:FocusUrl parameters:@{@"__v":@"ios5.6"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//请求首页数据
+ (void)post_HomeWithG_phone:(NSString *)g_phone location:(NSString *)location success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    //[[NetWorkAPIClient sharedAPIClient] POST:<#(nonnull NSString *)#> parameters:<#(nullable id)#> constructingBodyWithBlock:<#^(id<AFMultipartFormData>  _Nonnull formData)block#> progress:<#^(NSProgress * _Nonnull uploadProgress)uploadProgress#> success:<#^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)success#> failure:<#^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)failure#>];
}

@end







