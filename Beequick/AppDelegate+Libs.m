//
//  AppDelegate+Libs.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/18.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "AppDelegate+Libs.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

#define BaiduMap_Key @"jaOXuALXAiqRdLVgr2sfBnHTw8vBHr9M"

BMKMapManager* _mapManager;
@implementation AppDelegate (Libs)

- (void)addLibs{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BaiduMap_Key generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
