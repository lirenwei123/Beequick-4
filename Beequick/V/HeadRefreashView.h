//
//  HeadRefreashView.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/23.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadRefreashView : UIView

@property (nonatomic, copy) void (^startRefreashBlock)(void);
- (void)finishRefreash;

@end
