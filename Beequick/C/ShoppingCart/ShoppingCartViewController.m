//
//  ShoppingCartViewController.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ShoppingCartViewController.h"

@interface ShoppingCartViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_shoppingCartTableView;
}

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:Color_RGB(254, 207, 9, 1)];
    [self.view setBackgroundColor:Color_RGB(244, 244, 244, 1)];
    [self.navigationItem setTitle:@"购物车"];
    
    [self setUpView];
}

#pragma mark -- 配置视图
- (void)setUpView{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _shoppingCartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.view.cur_w, self.view.cur_h-kNavBarHeight)];
    [_shoppingCartTableView setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
//    [_shoppingCartTableView setDelegate:self];
//    [_shoppingCartTableView setDataSource:self];
    [self.view addSubview:_shoppingCartTableView];
}

#pragma mark -- UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//}

#pragma mark -- UITableViewDelegate


@end





