//
//  ReverseGeoAPIs.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/20.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReverseGeoAPIs : NSObject

/**
 *  反地理编码
 *
 *  @param latitude  纬度
 *  @param longitude 经度
 */
- (void)reverseGeoWithLatitude:(CGFloat)latitude longitute:(CGFloat)longitude;

@end






