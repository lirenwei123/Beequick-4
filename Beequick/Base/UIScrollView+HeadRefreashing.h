//
//  UIScrollView+HeadRefreashing.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/23.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^StartBlock)(void);

@interface UIScrollView (HeadRefreashing)

@property(nonatomic,copy) StartBlock startBlock;
- (void)setIsHaveHeadRefreash:(BOOL)haveHeadRefreash;
- (void)finishRefreash;

@end




