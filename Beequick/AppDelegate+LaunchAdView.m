//
//  AppDelegate+LaunchAdView.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "AppDelegate+LaunchAdView.h"
#import "LaunchAdLoadView.h"
#import <objc/runtime.h>
#import "UIImageView+WebCache.h"

@implementation AppDelegate (LaunchAdView)

- (void)setTimer:(NSTimer *)timer{
    objc_setAssociatedObject(self, @"timer", timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)timer{
    return objc_getAssociatedObject(self, @"timer");
}

#pragma mark -- 请求广告页数据
- (void)requestAdData{
    __weak typeof(self) weakSelf = self;
    [NetTool get_foucsWithSuccess:^(id responseData) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (jsonDic[@"code"] == 0) {
            NSDictionary *dataDic = jsonDic[@"data"];
            NSString *imagePath = dataDic[@"img_name"];
            [weakSelf cachesImageWithImagePath:imagePath];
        }
        else{
            NSLog(@"%@", jsonDic[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

//缓存图片，有更新或没有就移除旧的缓存新的，

- (void)cachesImageWithImagePath:(NSString *)imagePath{
    NSMutableString *imageUrl =[imagePath mutableCopy];
//    NSMutableString *imageUrl = [NSMutableString stringWithString:imagePath];
    imagePath = [imageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@""];
     NSArray *imageArray = [imagePath componentsSeparatedByString:@"/"];
    //获取沙盒缓存路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageCachesPath = [cachesPath stringByAppendingPathComponent:[imageArray lastObject]];
    
    //以上时为了获取根据图片名字命名的沙河路径
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
        UIImage *image = [UIImage imageWithData:imageData];
        //从系统数据存持久化力去取图片名字
        NSString *oldImageName = [userDefaults objectForKey:@"imageName"];
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (!oldImageName || ![oldImageName isEqualToString:[imageArray lastObject]]) {
            //此时是新的数据
            //移除旧的数据文件
            if (oldImageName) {
                [fileManager removeItemAtPath:[cachesPath stringByAppendingPathComponent:oldImageName] error:nil];
            }
           [fileManager createFileAtPath:imageCachesPath contents:UIImageJPEGRepresentation(image, 1.0) attributes:nil];
            [userDefaults setObject:[imageArray lastObject] forKey:@"imageName"];
        }
        
    });

}


- (void)showAdViewWithImagePath:(NSString *)imagePath{

    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:self.rootVC.view.bounds];
    [adImageView setUserInteractionEnabled:YES];
    [adImageView setTag:30];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    [adImageView setImage:image];
    [self.rootVC.view addSubview:adImageView];
    
    LaunchAdLoadView *launchAdView = [[LaunchAdLoadView alloc] initWithFrame:CGRectMake(adImageView.cur_w-65, 15, 50, 50)];
    [launchAdView addTarget:self action:@selector(launchAdViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [adImageView addSubview:launchAdView];
    
    UILabel *timeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [timeTextLabel setText:@"跳过\n3s"];
    [timeTextLabel setNumberOfLines:2];
    [timeTextLabel setFont:[UIFont systemFontOfSize:12]];
    [timeTextLabel setTextAlignment:NSTextAlignmentCenter];
    [launchAdView addSubview:timeTextLabel];
    
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerResponse) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

#pragma mark -- 倒计时按钮的响应事件
- (void)launchAdViewClicked{
    [self imageViewAnimation];
    [self.timer invalidate];
}

#pragma mark -- 计时器的响应事件
- (void)timerResponse{
    static CGFloat seconds = 3.0;
    
    seconds -= 0.1;
    
    LaunchAdLoadView *loadView = [[[self.rootVC.view viewWithTag:30] subviews] objectAtIndex:0];
    UILabel *textLabel = [[loadView subviews] objectAtIndex:0];
    //设置进度
    [loadView setProgress:(3.0 - seconds)/3.0];
    if (seconds < 0){
        [textLabel setText:@"跳过\n0s"];
        //移除imageView
        [self imageViewAnimation];
        //关闭销毁计时器
        [self.timer invalidate];
    }
    else{
        [textLabel setText:[NSString stringWithFormat:@"跳过\n%lds",(NSInteger)seconds+1]];
    }
}

#pragma mark -- 广告页消失动画
- (void)imageViewAnimation{
    __weak typeof(self) weakSelf = self;
    UIImageView * adImageView = [self.rootVC.view viewWithTag:30];
    [UIView animateWithDuration:0.8 animations:^{
        [adImageView setTransform:CGAffineTransformMakeScale(1.1, 1.2)];
        [adImageView setAlpha:0];
    } completion:^(BOOL finished) {
        [adImageView removeFromSuperview];
        [weakSelf.rootVC setNeedsStatusBarAppearanceUpdate];
    }];
}

@end






