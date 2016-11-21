//
//  BannerView.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/20.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "BannerView.h"
#import "HomeActivityModel.h"
#import "UIImageView+WebCache.h"

@interface BannerView()<UIScrollViewDelegate>
{
    UIScrollView *_bannerScrollView;
    UIPageControl *_pageControll;
    NSTimer *_timer;
}

@property (nonatomic,strong) NSMutableArray *imageViewsArray;

@end

@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _bannerScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_bannerScrollView setPagingEnabled:YES];
        [_bannerScrollView setBounces:NO];
        [_bannerScrollView setDelegate:self];
        [_bannerScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_bannerScrollView];
        
        _pageControll = [[UIPageControl alloc] init];
        [self addSubview:_pageControll];
        
    }
    return self;
}

- (void)setBannerDataArray:(NSMutableArray *)bannerDataArray{
    if (bannerDataArray) {
        [_timer invalidate];
        _bannerDataArray = bannerDataArray;
        for (UIImageView *imageView in self.imageViewsArray) {
            [imageView removeFromSuperview];
        }
        [self.imageViewsArray removeAllObjects];

        
        [_bannerScrollView setContentSize:CGSizeMake((bannerDataArray.count+2)*self.cur_w, 0)];
        [_bannerScrollView setContentOffset:CGPointMake(self.cur_w, 0)];
        [_pageControll setNumberOfPages:bannerDataArray.count];
        CGSize pageSize = [_pageControll sizeForNumberOfPages:bannerDataArray.count];
        [_pageControll setFrame:CGRectMake((self.cur_w-pageSize.width)/2, (self.cur_h-pageSize.height), pageSize.width, pageSize.height)];
        [_pageControll setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
        [_pageControll setPageIndicatorTintColor:Color_RGB(217, 217, 217, 1)];
        
        for (NSInteger i=0; i<bannerDataArray.count+2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_bannerScrollView.cur_w, 0, _bannerScrollView.cur_w, _bannerScrollView.cur_h)];
            [_bannerScrollView addSubview:imageView];
            [self.imageViewsArray addObject:imageView];
            
            if (i!=0 && i!=bannerDataArray.count+1) {
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureResponse:)];
                [imageView setUserInteractionEnabled:YES];
                [imageView addGestureRecognizer:tapGesture];
                [imageView setTag:100+i];
            }
            
            if (i == 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:[(HomeActivityModel *)[bannerDataArray lastObject] img]]];
            }
            else if(i == bannerDataArray.count+1){
                [imageView sd_setImageWithURL:[NSURL URLWithString:[(HomeActivityModel *)[bannerDataArray firstObject] img]]];
            }
            else{
                [imageView sd_setImageWithURL:[NSURL URLWithString:[(HomeActivityModel *)[bannerDataArray objectAtIndex:i-1] img]]];
            }
        }
        
        _timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(timerResponse) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (NSMutableArray *)imageViewsArray{
    if (!_imageViewsArray) {
        _imageViewsArray = [NSMutableArray array];
    }
    return _imageViewsArray;
}

#pragma mark -- 手势的响应事件
- (void)tapGestureResponse:(UITapGestureRecognizer *)tapGesture{

}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.cur_w;
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake(_bannerDataArray.count*scrollView.cur_w, 0)];
        _pageControll.currentPage = _bannerDataArray.count-1;
    }
    else if (currentPage == _bannerDataArray.count+1){
        [scrollView setContentOffset:CGPointMake(scrollView.cur_w, 0)];
        _pageControll.currentPage = 0;
    }
    else{
        _pageControll.currentPage = currentPage-1;
    }
}

#pragma mark -- 计时器的响应事件
- (void)timerResponse{
    NSInteger currentPage = _bannerScrollView.contentOffset.x/_bannerScrollView.cur_w;
    //当前是倒数第二页
    if (currentPage == _bannerDataArray.count) {
        [_pageControll setCurrentPage:0];
        //滚动到倒数第一页
        [_bannerScrollView setContentOffset:CGPointMake((currentPage+1)*_bannerScrollView.cur_w, 0) animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //切到整数第二页
            [_bannerScrollView setContentOffset:CGPointMake(_bannerScrollView.cur_w, 0)];
        });
    }
    else{
        [_bannerScrollView setContentOffset:CGPointMake((currentPage+1)*_bannerScrollView.cur_w, 0) animated:YES];
        [_pageControll setCurrentPage:currentPage];
    }
}

@end




