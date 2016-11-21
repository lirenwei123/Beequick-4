//
//  UIScrollView+HeadRefreashing.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/23.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "UIScrollView+HeadRefreashing.h"
#import "HeadRefreashView.h"
#import <objc/runtime.h>

@implementation UIScrollView (HeadRefreashing)

- (void)setStartBlock:(StartBlock)startBlock{
    objc_setAssociatedObject(self, @"startBlock", startBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (StartBlock)startBlock{
    return objc_getAssociatedObject(self, @"startBlock");
}

- (void)setIsHaveHeadRefreash:(BOOL)haveHeadRefreash{
    if (haveHeadRefreash) {
        [self setHeadView];
    }
}

#pragma mark -- 配置顶部视图
- (void)setHeadView{
    HeadRefreashView *headView = [[HeadRefreashView alloc] initWithFrame:CGRectMake(0, -60, self.cur_w, 60)];
    __weak HeadRefreashView *weakView = headView;
    __weak typeof(self) weakSelf = self;
    [headView setStartRefreashBlock:^{
        [weakSelf setContentInset:UIEdgeInsetsMake(weakView.cur_h, 0, 0, 0)];
        weakSelf.startBlock();
    }];
    [self insertSubview:headView atIndex:0];
    [self addObserver:headView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:headView forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)finishRefreash{
    [UIView animateWithDuration:0.5 animations:^{
        [self setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }];
    [self.subviews[0] finishRefreash];
}

@end






