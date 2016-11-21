//
//  ViewController.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "RootViewController.h"
#import "AnimatateTabBar.h"
#import "HomeViewController.h"
#import "MarketViewController.h"
#import "ShoppingCartViewController.h"
#import "ReserveViewController.h"
#import "UserInfoViewController.h"
#import "NavgationViewController.h"
#import "LocationAPI.h"
#import "ReverseGeoAPIs.h"

@interface RootViewController ()<AnimatateTabBarDelegate>

@property (nonatomic,strong) NSArray *childsArray;
@property (nonatomic,strong) AnimatateTabBar *animatateTabBar;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) ReverseGeoAPIs *reversGeo;

@end

@implementation RootViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //开始定位
    [[LocationAPI sharedLocation] startLoction];
    
    //注册定位成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccessNotification:) name:LocationSuccessNotification object:nil];
    //注册定位失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFailureNotification:) name:LocationFailureNotification object:nil];
    //注册反地理编码成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reverseGeoSuccessNotification:) name:ReverseGeoSuccessNotification object:nil];
    //注册反地理编码失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reverseGeoFailureNotification:) name:ReverseGeoFailureNotification object:nil];
}

#pragma mark -- 定位成功通知的回调事件
- (void)locationSuccessNotification:(NSNotification *)noti{
    _reversGeo = nil;
    NSDictionary *userInfo = noti.userInfo;
    //进行反地理编码
    _reversGeo = [[ReverseGeoAPIs alloc] init];
    [_reversGeo reverseGeoWithLatitude:[userInfo[@"latitude"] doubleValue] longitute:[userInfo[@"longitude"] doubleValue]];
}

#pragma mark -- 反地理编码成功通知的回调事件
- (void)reverseGeoSuccessNotification:(NSNotification *)noti{
    //解码成功则展示五个，否则展示四个
    [self setChildViewControllersWithAddressSuccess:YES];
    NSNotification *successNoti = [NSNotification notificationWithName:TellCommonReverseSuccessNotification object:nil userInfo:noti.userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:successNoti];
}

#pragma mark -- 反地理编码失败通知的回调事件
- (void)reverseGeoFailureNotification:(NSNotification *)noti{
    [self setChildViewControllersWithAddressSuccess:NO];
    NSNotification *failureNoti = [NSNotification notificationWithName:TellCommonReverseFailureNotification object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:failureNoti];
}

#pragma mark -- 定位失败通知的回调事件
- (void)locationFailureNotification:(NSNotification *)noti{
    [self setChildViewControllersWithAddressSuccess:NO];
    NSNotification *notificaiton = [NSNotification notificationWithName:TellCommonLocationFailureNotification object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notificaiton];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位失败" message:@"请确认已打开定位服务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *selectAdrressAction = [UIAlertAction actionWithTitle:@"手动选择地址" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#warning pushToSelectAdressVC
        //跳转到选择地址页面
    }];
    [alert addAction:selectAdrressAction];
    [self presentViewController:alert animated:NO completion:nil];
}

#pragma mark -- 添加子控制器
- (void)setChildViewControllersWithAddressSuccess:(BOOL)success{
    
    for (UIViewController *childController in _childsArray) {
        [childController removeFromParentViewController];
    }
    _childsArray = nil;
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    NavgationViewController *homeNav = [[NavgationViewController alloc] initWithRootViewController:homeVC];
    //添加子控制器
    [self addChildViewController:homeNav];
    
    MarketViewController *marketVC = [[MarketViewController alloc] init];
    NavgationViewController *marketNav = [[NavgationViewController alloc] initWithRootViewController:marketVC];
    [self addChildViewController:marketNav];
    
    NavgationViewController *reserveNav = nil;
    if (success) {
        ReserveViewController *reserveVC  = [[ReserveViewController alloc] init];
        reserveNav = [[NavgationViewController alloc] initWithRootViewController:reserveVC];
        [self addChildViewController:reserveNav];
    }
    
    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc] init];
    NavgationViewController *shoppingCartNav = [[NavgationViewController alloc] initWithRootViewController:shoppingCartVC];
    [self addChildViewController:shoppingCartNav];
    
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    NavgationViewController *userInfoNav = [[NavgationViewController alloc] initWithRootViewController:userInfoVC];
    [self addChildViewController:userInfoNav];
    
    //添加当前展示模块视图
    [marketNav.view addSubview:marketVC.view];
    [homeNav.view addSubview:homeVC.view];
    [self.view addSubview:homeNav.view];
    
    _currentViewController = homeNav;
    
    if (success) {
        _childsArray = @[homeNav, marketNav, reserveNav, shoppingCartNav, userInfoNav];
    }
    else{
         _childsArray = @[homeNav, marketNav, shoppingCartNav, userInfoNav];
    }
    
    [self setAnimatateTabBarWithAddressSuccess:success];

}

#pragma mark -- 添加Tabbar
- (void)setAnimatateTabBarWithAddressSuccess:(BOOL)success{
    AnimatateTabBar *tabBar = [[AnimatateTabBar alloc] initWithFrame:CGRectMake(0, self.view.cur_h-kTabbarHeight, self.view.cur_w, kTabbarHeight) childVCCount:_childsArray.count];
    _animatateTabBar = tabBar;
    [tabBar setDelegate:self];
    if (success) {
        [tabBar setImagesArray:@[[UIImage imageNamed:@"v2_home"], [UIImage imageNamed:@"v2_order"], [UIImage imageNamed:@"freshReservation"], [UIImage imageNamed:@"shopCart"], [UIImage imageNamed:@"v2_my"]]];
        [tabBar setSelectedImagesArray:@[[UIImage imageNamed:@"v2_home_selected"], [UIImage imageNamed:@"v2_order_selected"], [UIImage imageNamed:@"freshReservation_selected"], [UIImage imageNamed:@"shopCart_selected"], [UIImage imageNamed:@"v2_my_selected"]]];
        [tabBar setTitlesArray:@[@"首页", @"闪送超市", @"新鲜预定", @"购物车", @"我的"]];
    }
    else{
        [tabBar setImagesArray:@[[UIImage imageNamed:@"v2_home"], [UIImage imageNamed:@"v2_order"], [UIImage imageNamed:@"shopCart"], [UIImage imageNamed:@"v2_my"]]];
        [tabBar setSelectedImagesArray:@[[UIImage imageNamed:@"v2_home_selected"], [UIImage imageNamed:@"v2_order_selected"], [UIImage imageNamed:@"shopCart_selected"], [UIImage imageNamed:@"v2_my_selected"]]];
        [tabBar setTitlesArray:@[@"首页", @"闪送超市", @"购物车", @"我的"]];
    }
    
    [tabBar setBackgroundColor:Color_RGB(244, 244, 244, 0.9)];
    [self.view addSubview:tabBar];
    //默认选中首页
    [tabBar selectedBtnClicked:tabBar.subviews[0]];
    
    UIImageView *adImageView = [self.view viewWithTag:30];
    if (adImageView) {
        [self.view bringSubviewToFront:adImageView];
    }
    
    UIView *introsView = [self.view viewWithTag:31];
    if (introsView) {
        [self.view bringSubviewToFront:introsView];
    }
}

#pragma mark -- AnimatateTabBarDelegate
- (void)selectedWithIndex:(NSInteger)index{
    //当前控制器和目标控制器不是同一个则切换
    if (_currentViewController != _childsArray[index]) {
        __unsafe_unretained typeof(self) weakSelf = self;
        //切换子控制器
        [self transitionFromViewController:_currentViewController toViewController:_childsArray[index] duration:0 options:UIViewAnimationOptionTransitionNone  animations:nil completion:^(BOOL finished) {
            weakSelf.currentViewController = weakSelf.childsArray[index];
        }];
        [self.view bringSubviewToFront:weakSelf.animatateTabBar];

    }
    
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    UIImageView *adImageView = [self.view viewWithTag:30];
    UIView *introsView = [self.view viewWithTag:31];
    if (adImageView || introsView) {
        return YES;
    }
    else{
        return NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return [_currentViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
