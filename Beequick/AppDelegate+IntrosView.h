//
//  AppDelegate+IntrosView.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (IntrosView)<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *basicView;

- (void)showIntrosView;

@end
