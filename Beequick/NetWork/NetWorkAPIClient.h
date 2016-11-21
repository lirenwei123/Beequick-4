//
//  NetWorkAPIClient.h
//  AFNetworking-使用
//
//  Created by 苹果电脑 on 16/9/8.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "AFHTTPSessionManager.h"

//对AFNetworking进行二次封装

@interface NetWorkAPIClient : AFHTTPSessionManager

+ (NetWorkAPIClient *)sharedAPIClient;

@end
