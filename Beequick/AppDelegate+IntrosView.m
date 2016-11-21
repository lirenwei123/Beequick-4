//
//  AppDelegate+IntrosView.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "AppDelegate+IntrosView.h"
#import <objc/runtime.h>

@implementation AppDelegate (IntrosView)

- (void)setBasicView:(UIView *)basicView{
    objc_setAssociatedObject(self, @"basicView", basicView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)basicView{
    return objc_getAssociatedObject(self, @"basicView");
}

- (void)showIntrosView{
    
    self.basicView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.basicView setTag:31];
    [self.rootVC.view addSubview:self.basicView];
    
    UIScrollView *introsView = [[UIScrollView alloc] initWithFrame:self.basicView.bounds];
    [introsView setDelegate:self];
    [introsView setContentSize:CGSizeMake(SCREEN_WIDTH*3, 0)];
    [introsView setBounces:NO];
    [introsView setShowsHorizontalScrollIndicator:NO];
    [introsView setPagingEnabled:YES];
    [self.basicView addSubview:introsView];
    
    for (NSInteger i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*introsView.cur_w, 0, introsView.cur_w, introsView.cur_h)];
        [imageView setBackgroundColor:Color_RGB(arc4random()%256, arc4random()%256, arc4random()%256, 1)];
        [introsView addSubview:imageView];
        
        if (i == 2) {
            [imageView setUserInteractionEnabled:YES];
            
            UIButton *launchBtn = [[UIButton alloc] initWithFrame:CGRectMake((imageView.cur_w-136)/2.0, imageView.cur_h-96, 136, 40)];
            [launchBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [launchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [launchBtn.layer setBorderWidth:1];
            [launchBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
            [launchBtn.layer setCornerRadius:4.0];
            [launchBtn.titleLabel setFont:[UIFont systemFontOfSize:21]];
            [launchBtn addTarget:self action:@selector(launchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:launchBtn];
        }
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setNumberOfPages:3];
    CGSize pageControlSize = [pageControl sizeForNumberOfPages:3];
    [pageControl setFrame:CGRectMake((self.basicView.cur_w-pageControlSize.width)/2, self.basicView.cur_h-pageControlSize.height-10, pageControlSize.width, pageControlSize.height)];
    [self.basicView addSubview:pageControl];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.cur_w;
    [(UIPageControl *)[self.basicView.subviews objectAtIndex:1]  setCurrentPage:currentPage];
    
}

#pragma mark -- 按钮的响应事件
- (void)launchBtnClicked{
    [self.basicView removeFromSuperview];
    self.basicView = nil;
    //保存登入状态
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNotFirstLaunch"];
    [self.rootVC setNeedsStatusBarAppearanceUpdate];
}

@end




