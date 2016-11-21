//
//  LocationAPI.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/18.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface LocationAPI : NSObject<BMKLocationServiceDelegate>

+ (LocationAPI *)sharedLocation;

- (void)startLoction;

@end




