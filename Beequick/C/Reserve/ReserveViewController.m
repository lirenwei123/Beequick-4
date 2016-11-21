//
//  ReserveViewController.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ReserveViewController.h"
#import "UIScrollView+HeadRefreashing.h"
#import "UIView+DropToShopCartAnimation.h"
#import "BannerView.h"
#import "IconTableViewCell.h"
#import "ReverceTableViewCell.h"
#import "CategoryTableViewCell.h"
#import "HomeActivityModel.h"
#import "ReverseActiveModel.h"
#import "ReverceCategoryModel.h"

@interface ReserveViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    BannerView *_bannerView;
    UITableView *_reverseTableView;
    BOOL _isShow;
}

@property (nonatomic, strong) NSMutableArray *actInfoArray;

@end

@implementation ReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:Color_RGB(254, 207, 9, 1)];
    [self.view setBackgroundColor:Color_RGB(244, 244, 244, 1)];
    [self.navigationItem setTitle:@"新鲜预订🚚次日达"];
    [self setUpView];
    [self refreashData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addProductToShoppingCart:) name:AddProductToShoppingCartNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isShow = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isShow = NO;
}

#pragma mark -- 配置视图
- (void)setUpView{
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchItemResponse)];
    [self.navigationItem setRightBarButtonItem:searchItem];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _reverseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.view.cur_w, self.view.cur_h-kNavBarHeight)];
    [_reverseTableView setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
    [_reverseTableView setIsHaveHeadRefreash:YES];
    [_reverseTableView setDelegate:self];
    [_reverseTableView setDataSource:self];
    [_reverseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    __weak typeof(_reverseTableView) weakTableView = _reverseTableView;
    [_reverseTableView setStartBlock:^{
        //[self refreashData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakTableView finishRefreash];
            [weakTableView setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
        });
    }];
    [self.view addSubview:_reverseTableView];
}

- (void)refreashData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"reverse.json" ofType:nil];
    NSData *reverseData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:reverseData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dataDic = jsonDic[@"data"];
    NSArray *actInfoArray = dataDic[@"act_info"];
    [self handleUpdateViewWithActInfoArray:actInfoArray];
}

- (void)handleUpdateViewWithActInfoArray:(NSArray *)actInfoArray{
    [self.actInfoArray removeAllObjects];
    [actInfoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *actRowsArray = [NSMutableArray array];
        [obj[@"act_rows"] enumerateObjectsUsingBlock:^(id  _Nonnull childObj, NSUInteger childIdx, BOOL * _Nonnull stop) {
            if (idx == 0 || idx == 1) {
                HomeActivityModel *homeActiveModel = [[HomeActivityModel alloc] initWithDictionary:childObj[@"activity"] error:nil];
                [actRowsArray addObject:homeActiveModel];
            }
            else if (idx == 2){
                ReverseActiveModel *reverseActiveModel = [[ReverseActiveModel alloc] initWithDictionary:childObj error:nil];
                [actRowsArray addObject:reverseActiveModel];
            }
            else{
                ReverceCategoryModel *reverceCategoryModel = [[ReverceCategoryModel alloc] initWithDictionary:childObj error:nil];
                [actRowsArray addObject:reverceCategoryModel];
            }
        }];
        [self.actInfoArray addObject:actRowsArray];
    }];
    
    [_reverseTableView reloadData];
}

- (NSMutableArray *)actInfoArray{
    if (!_actInfoArray) {
        _actInfoArray = [NSMutableArray array];
    }
    return _actInfoArray;
}

#pragma mark -- 添加商品到购物车的通知事件
- (void)addProductToShoppingCart:(NSNotification *)noti{
    if (_isShow) {
        UIView *contentView = noti.userInfo[@"contentView"];
        [contentView dropToShopCartWithSubView:self.view contentText:nil dropPoint:CGPointMake(self.view.cur_w-(self.view.cur_w/5)*1.5, self.view.cur_h-25)];
    }
}

#pragma mark -- 搜索item的响应事件
- (void)searchItemResponse{
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }
    return [_actInfoArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bannerCellIdentifer = @"bannerCellIdentifer";
    static NSString *iconCellIdentifer = @"iconCellIdentifer";
    static NSString *reserveCellIdentifer = @"reserveCellIdentifer";
    static NSString *categoryCellIdentifer = @"categoryCellIdentifer";
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:bannerCellIdentifer];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bannerCellIdentifer];
            BannerView *bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, _reverseTableView.cur_w, 153)];
            [bannerView setTag:2000];
            [cell.contentView addSubview:bannerView];
        }
        BannerView *bannerView = [cell.contentView viewWithTag:2000];
        [bannerView setBannerDataArray:_actInfoArray[indexPath.section]];
    }
    else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:iconCellIdentifer];
        if (!cell) {
            cell = [[IconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iconCellIdentifer type:ExistSperactorLine];
        }
        [(IconTableViewCell *)cell setIconDataArray:_actInfoArray[indexPath.section]];
    }
    else if (indexPath.section == 2){
        cell= [tableView dequeueReusableCellWithIdentifier:reserveCellIdentifer];
        if (!cell) {
            cell = [[ReverceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reserveCellIdentifer];
        }
        [(ReverceTableViewCell *)cell setReverseModel:[_actInfoArray[indexPath.section] objectAtIndex:indexPath.row]];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifer];
        if (!cell) {
            cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellIdentifer];
        }
        [(CategoryTableViewCell *)cell setReverceCategoryModel:[_actInfoArray[indexPath.section] objectAtIndex:indexPath.row]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _actInfoArray.count;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 153;
    }
    else if (indexPath.section == 1){
        return ([_actInfoArray[indexPath.section] count]/4)*79+10;
    }
    else if (indexPath.section == 2){
        return 280;
    }
    return 149+((_reverseTableView.cur_w)/3+97)*([[[[_actInfoArray[indexPath.section] objectAtIndex:indexPath.row] category_detail] goods] count]/3);
}

@end
