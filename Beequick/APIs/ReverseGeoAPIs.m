//
//  ReverseGeoAPIs.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/20.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ReverseGeoAPIs.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface ReverseGeoAPIs()<BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch* _geocodesearch;
    bool isGeoSearch;
}

@end

@implementation ReverseGeoAPIs

- (void)dealloc{
    _geocodesearch.delegate = nil;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

    }
    return self;
}

- (void)reverseGeoWithLatitude:(CGFloat)latitude longitute:(CGFloat)longitude{
    isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        //反geo检索发送成功
    }
    else
    {
        //反geo检索发送失败
        NSNotification *noti = [NSNotification notificationWithName:ReverseGeoFailureNotification object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    
}

#pragma mark -- BMKGeoCodeSearchDelegate
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //搜索成功
        NSNotification *successNoti = [NSNotification notificationWithName:ReverseGeoSuccessNotification object:nil userInfo:@{@"address":result.address}];
        [[NSNotificationCenter defaultCenter] postNotification:successNoti];
    }
    else{
        //搜索失败
        NSNotification *failureNoti = [NSNotification notificationWithName:ReverseGeoFailureNotification object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:failureNoti];
    }
}

@end








