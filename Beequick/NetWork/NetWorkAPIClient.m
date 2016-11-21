//
//  NetWorkAPIClient.m
//  AFNetworking-使用
//
//  Created by 苹果电脑 on 16/9/8.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "NetWorkAPIClient.h"

static NSString * baseUrl = @"";

@implementation NetWorkAPIClient

+ (NetWorkAPIClient *)sharedAPIClient{
    static NetWorkAPIClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //创建单例对象
        client = [[NetWorkAPIClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        //设置安全策略
         client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //设置返回数据类型。默认AFNetworking内部会对数据进行json解析，返回解析完成的数据，如果数据不是json格式，则会崩溃
        /*
         AFHTTPResponseSerializer：原生数据格式(NSData)
         AFJSONResponseSerializer：返回解析完成的json数据
         AFXMLParserResponseSerializer：返回以SAX方式解析完成的XML数据
         AFImageResponseSerializer:返回图片(UIImage)
         */
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return client;
}

@end




