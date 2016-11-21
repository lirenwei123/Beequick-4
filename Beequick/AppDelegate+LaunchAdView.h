//
//  AppDelegate+LaunchAdView.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (LaunchAdView)

@property (nonatomic, strong) NSTimer *timer;

- (void)requestAdData;
- (void)showAdViewWithImagePath:(NSString *)imagePath;
- (void)cachesImageWithImagePath:(NSString *)imagePath;

@end
