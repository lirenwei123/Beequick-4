//
//  LocationAPI.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/18.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "LocationAPI.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationAPI()
{
    BMKLocationService *_locationService;
}

@end

@implementation LocationAPI

+ (LocationAPI *)sharedLocation{
    static LocationAPI *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[super allocWithZone:NULL] init];
    });
    return location;
}

- (instancetype)init{
    self = [super init];
    if (self) {
//        if (Sys_version>=8.0) {
//            [self ];
//        }
        _locationService = [[BMKLocationService alloc] init];
        [_locationService setDelegate:self];
    }
    return self;
}

- (void)startLoction{
    [_locationService startUserLocationService];
}

#pragma mark -- BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CGFloat latitude = userLocation.location.coordinate.latitude;
    CGFloat longitude = userLocation.location.coordinate.longitude;
    NSNotification *notification = [NSNotification notificationWithName:LocationSuccessNotification object:nil userInfo:@{@"latitude":@(latitude), @"longitude":@(longitude)}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [_locationService stopUserLocationService];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSNotification *notification = [NSNotification notificationWithName:LocationFailureNotification object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [_locationService stopUserLocationService];
}



@end


