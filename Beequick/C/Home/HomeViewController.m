//
//  HomeViewController.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeActivityModel.h"
#import "CategoryDetailModel.h"
#import "BannerView.h"
#import "IconTableViewCell.h"
#import "HeadlineTableViewCell.h"
#import "BrandTableViewCell.h"
#import "SceneTableViewCell.h"
#import "CategoryTableViewCell.h"
#import "HotGoodsCollectionViewCell.h"
#import "UIView+DropToShopCartAnimation.h"
#import "UIScrollView+HeadRefreashing.h"
#import "ProductView.h"

#define HotGoodsCollectionCellIdentifer @"HotGoodsCollectionCellIdentifer"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
{
    BOOL _isLight;
    CGFloat _lastOffSetY;
    UIView *_alphaView;
    UIScrollView *_backScrollView;
    BannerView *_bannerView;
    UITableView *_homeTableView;
    NSArray *_actInfoArray;
    UIView *_speracterView;
    UICollectionView *_hotGoodsCollectView;
    BOOL _isShow;
}

@property (nonatomic,strong) NSMutableArray *dataModelArray;
@property (nonatomic,strong) NSMutableArray *categoryModelArray;
@property (nonatomic,strong) NSMutableArray *hotGoodsModelArray;

@end

@implementation HomeViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _lastOffSetY = 0;
    
    [self.view setBackgroundColor:Color_RGB(235, 235, 235, 1)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addProductToShoppingCart:) name:AddProductToShoppingCartNotification object:nil];
    [self setUpView];
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
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    NSLog(@"%@", [_backScrollView isDragging]?@"正在拖动":@"停止拖动");
    [_backScrollView setIsHaveHeadRefreash:YES];
    [_backScrollView setDelegate:self];
    [_backScrollView setBackgroundColor:Color_RGB(232, 232, 232, 1)];
    //需要修改真是滚动范围
    [_backScrollView setContentSize:CGSizeMake(0, 2*self.view.cur_h)];
    __weak typeof(_backScrollView) weakScrollView = _backScrollView;
    __weak typeof(self) weakSelf = self;
    //模拟数据刷新请求
    [_backScrollView setStartBlock:^{
        [weakSelf requestData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //请求完成
            [weakScrollView finishRefreash];
        });
    }];
    [self.view addSubview:_backScrollView];

    _bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, _backScrollView.cur_w, 175)];
    [_backScrollView addSubview:_bannerView];
    
    _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _bannerView.cur_y_h, _backScrollView.cur_w, 740)];
    [_homeTableView setScrollEnabled:NO];
    [_homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_homeTableView setDelegate:self];
    [_homeTableView setDataSource:self];
    [_backScrollView addSubview:_homeTableView];
    
    _speracterView = [[UIView alloc] initWithFrame:CGRectMake(0, _homeTableView.cur_y_h, _backScrollView.cur_w, 18)];
    [_backScrollView addSubview:_speracterView];
    
    UIView *frontLineView = [[UIView alloc] initWithFrame:CGRectMake(10, (_speracterView.cur_h-0.5)/2, (_speracterView.cur_w-93)/2, 0.5)];
    [frontLineView setBackgroundColor:Line_Color];
    [_speracterView addSubview:frontLineView];
    
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(frontLineView.cur_x_w+10, 0, 53, _speracterView.cur_h)];
    [centerLabel setFont:[UIFont systemFontOfSize:13]];
    [centerLabel setTextColor:Color_RGB(163, 163, 163, 1)];
    [centerLabel setText:@"鲜蜂热卖"];
    [_speracterView addSubview:centerLabel];
    
    UIView *behindLineView = [[UIView alloc] initWithFrame:CGRectMake(centerLabel.cur_x_w+10, frontLineView.cur_y, frontLineView.cur_w, frontLineView.cur_h)];
    [behindLineView setBackgroundColor:Line_Color];
    [_speracterView addSubview:behindLineView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _hotGoodsCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _speracterView.cur_y_h, _backScrollView.cur_w, 0) collectionViewLayout:flowLayout];
    [_hotGoodsCollectView setBackgroundColor:Color_RGB(232, 232, 232, 1)];
    //注册Cell
    [_hotGoodsCollectView registerClass:[HotGoodsCollectionViewCell class] forCellWithReuseIdentifier:HotGoodsCollectionCellIdentifer];
    [_hotGoodsCollectView setScrollEnabled:NO];
    [_hotGoodsCollectView setDataSource:self];
    [_hotGoodsCollectView setDelegate:self];
    [_backScrollView addSubview:_hotGoodsCollectView];
}

- (void)locationFailureResponse:(NSNotification *)noti{
    [super locationFailureResponse:noti];
    [self changeNavgitionItem];
    [self clearNavigationItem];
    [self requestData];
}

- (void)reverseGeoSuccessNotification:(NSNotification *)noti{
    [super reverseGeoSuccessNotification:noti];
    [self changeNavgitionItem];
    [self clearNavigationItem];
    //请求数据
    [self requestData];
}

#pragma mark -- 设置导航栏
- (void)changeNavgitionItem{
    //设置导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //处理渐变效果
    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.cur_w, 64)];
    [_alphaView setBackgroundColor:Color_RGB(254, 207, 9, 1)];
    [_alphaView setAlpha:0];
    [self.navigationController.navigationBar insertSubview:_alphaView atIndex:0];
}

#pragma mark -- 请求数据
- (void)requestData{
    NSString *homeFilePath = [[NSBundle mainBundle] pathForResource:@"home.json" ofType:nil];
    NSData *homeData = [NSData dataWithContentsOfFile:homeFilePath];
    NSDictionary *homeDic = [NSJSONSerialization JSONObjectWithData:homeData options:NSJSONReadingMutableContainers error:nil];
    NSArray *act_infoArray = [homeDic[@"data"] valueForKey:@"act_info"];
    _actInfoArray = act_infoArray;
    
    NSString *homeHotFilePath = [[NSBundle mainBundle] pathForResource:@"homeHot.json" ofType:nil];
    NSData *homeHotData = [NSData dataWithContentsOfFile:homeHotFilePath];
    NSDictionary *homeHotDic = [NSJSONSerialization  JSONObjectWithData:homeHotData options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = homeHotDic[@"data"];
    
    [self handleUpadateViewWithHomeDataArray:act_infoArray homeHotDataArray:dataArray];
}

- (NSMutableArray *)dataModelArray{
    if (_dataModelArray == nil) {
        _dataModelArray = [NSMutableArray array];
    }
    return _dataModelArray;
}

- (NSMutableArray *)categoryModelArray{
    if (!_categoryModelArray) {
        _categoryModelArray = [NSMutableArray array];
    }
    return _categoryModelArray;
}

- (NSMutableArray *)hotGoodsModelArray{
    if (!_hotGoodsModelArray) {
        _hotGoodsModelArray = [NSMutableArray array];
    }
    return _hotGoodsModelArray;
}

#pragma mark -- 更新视图数据
- (void)handleUpadateViewWithHomeDataArray:(NSArray *)homeDataArray homeHotDataArray:(NSArray *)homeHotDataArray{
    
    [self.dataModelArray removeAllObjects];
    [self.categoryModelArray removeAllObjects];
    [self.hotGoodsModelArray removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [homeDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *modelArray = [NSMutableArray array];
        [[obj valueForKey:@"act_rows"] enumerateObjectsUsingBlock:^(id  _Nonnull dic, NSUInteger dicIdx, BOOL * _Nonnull stop) {
            HomeActivityModel *activityModel = [[HomeActivityModel alloc] initWithDictionary:[dic valueForKey:@"activity"] error:nil];
            [modelArray addObject:activityModel];
            if ([[obj valueForKey:@"type"] isEqualToString:@"category"]) {
                CategoryDetailModel *categoryDetailModel = [[CategoryDetailModel alloc] initWithDictionary:[dic valueForKey:@"category_detail"] error:nil];
                
                [weakSelf.categoryModelArray addObject:categoryDetailModel];
                
            }
        }];
        
        [weakSelf.dataModelArray addObject:modelArray];
    }];
    
    [homeHotDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GoodsModel *goodsModel = [[GoodsModel alloc] initWithDictionary:obj error:nil];
        [weakSelf.hotGoodsModelArray addObject:goodsModel];
    }];
    
    __block CGFloat height;
    [_categoryModelArray enumerateObjectsUsingBlock:^(CategoryDetailModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        height += [obj goods].count/3*(_homeTableView.cur_w/3+97)+147;
    }];
    [_homeTableView setFrame:CGRectMake(_homeTableView.cur_x, _homeTableView.cur_y, _homeTableView.cur_w, ([_dataModelArray[1] count]/4*76)+height+379)];
    [_speracterView setFrame:CGRectMake(_speracterView.cur_x, _homeTableView.cur_y_h, _speracterView.cur_w, _speracterView.cur_h)];
    [_hotGoodsCollectView setFrame:CGRectMake(_hotGoodsCollectView.cur_x, _speracterView.cur_y_h, _hotGoodsCollectView.cur_w, (87+(_hotGoodsCollectView.cur_w-30)/2+10)*(self.hotGoodsModelArray.count/2+self.hotGoodsModelArray.count%2)+10)];
    [_backScrollView setContentSize:CGSizeMake(0, 175+_homeTableView.cur_h+_speracterView.cur_h+49+_hotGoodsCollectView.cur_h)];
    [_bannerView setBannerDataArray:[self.dataModelArray firstObject]];
    [_homeTableView reloadData];
    
}

#pragma mark -- 商品加入到购物车通知
- (void)addProductToShoppingCart:(NSNotification *)noti{
    if (_isShow) {
        UIView *contentView = noti.userInfo[@"contentView"];
        [contentView dropToShopCartWithSubView:self.view contentText:nil dropPoint:CGPointMake(self.view.cur_w-(self.view.cur_w/5)*1.5, self.view.cur_h-25)];
    }
    GoodsModel *goodsModel = noti.userInfo[@"goodsModel"];
    HotGoodsCollectionViewCell *cell = [_hotGoodsCollectView viewWithTag:[goodsModel.goods_id integerValue]];
    [cell refreashViewWithGoodsModel:goodsModel];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (_isLight) {
        return UIStatusBarStyleLightContent;
    }
    else{
        return UIStatusBarStyleDefault;
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=(175-64) && scrollView.contentOffset.y>=0) {
        CGFloat alpha = scrollView.contentOffset.y/111;
        [_alphaView setAlpha:alpha];
        [_scanQRBtn setAlpha:0.8-alpha];
        [_selectAddressBtn setAlpha:0.8-alpha];
        [_searchBtn setAlpha:0.8-alpha];
    }
    
    if (_lastOffSetY>=100 && scrollView.contentOffset.y<100) {
        _isLight = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [_addressLabel setTextColor:[UIColor whiteColor]];
        [_scanQRImageView setImage:[UIImage imageNamed:@"icon_white_scancode"]];
        [_searchImageView setImage:[UIImage imageNamed:@"icon_search_white"]];
    }
    else if (_lastOffSetY<100 && scrollView.contentOffset.y>=100){
        _isLight = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        [_addressLabel setTextColor:[UIColor blackColor]];
        [_scanQRImageView setImage:[UIImage imageNamed:@"icon_black_scancode"]];
        [_searchImageView setImage:[UIImage imageNamed:@"icon_search"]];
    }
    
    if(_lastOffSetY < (175-64) && scrollView.contentOffset.y > (175-64)){
        [self unclearNavigationItem];
    }
    
    _lastOffSetY = scrollView.contentOffset.y;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4+self.categoryModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iconCellIdentifer = @"iconCellIdentifer";
    static NSString *headlineCellIdentifer = @"headlineCellIdentifer";
    static NSString *brandCellIdentifer = @"brandCellIdentifer";
    static NSString *sceneCellIdentifer = @"sceneCellIdentifer";
    static NSString *categoryCellIdentifer = @"categoryCellIdentifer";
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:iconCellIdentifer];
        if (!cell) {
            cell = [[IconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iconCellIdentifer type:UnExistSperactorLine];
        }
        [(IconTableViewCell *)cell setIconDataArray:_dataModelArray[indexPath.row+1]];
    }
    else if (indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:headlineCellIdentifer];
        if (!cell) {
            cell = [[HeadlineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headlineCellIdentifer];
        }
        NSDictionary *headlineDetailDic = [[[_actInfoArray[indexPath.row+1] valueForKey:@"act_rows"] firstObject] valueForKey:@"headline_detail"];
        NSString *headImageUrl = [_actInfoArray[indexPath.row+1] valueForKey:@"head_img"];
        [(HeadlineTableViewCell *)cell setHeadLineCellDataWithTilte:headlineDetailDic[@"title"] contents:headlineDetailDic[@"content"] headImage:headImageUrl];
    }
    else if (indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:brandCellIdentifer];
        if (!cell) {
            cell = [[BrandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:brandCellIdentifer];
        }
        [(BrandTableViewCell *)cell setBrandDataArray:_dataModelArray[indexPath.row+1]];
    }
    else if (indexPath.row == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:sceneCellIdentifer];
        if (!cell) {
            cell = [[SceneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sceneCellIdentifer];
        }
        [(SceneTableViewCell *)cell setSceneDataArray:_dataModelArray[indexPath.row+1]];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifer];
        if (!cell) {
            cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellIdentifer];
        }
        [(CategoryTableViewCell *)cell categoryDataWithActivityModel:[_dataModelArray[5] objectAtIndex:indexPath.row-4] categoryModel:_categoryModelArray[indexPath.row-4]];
    }
    //设置cell无选中效果
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [_dataModelArray[indexPath.row+1] count]/4*76;
    }
    else if (indexPath.row == 1){
        return 45;
    }
    else if (indexPath.row == 2){
        return 162;
    }
    else if (indexPath.row == 3){
        return 172;
    }
    else{
        return 147+(_homeTableView.cur_w/3+97)*[_categoryModelArray[indexPath.row-4] goods].count/3;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _hotGoodsModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotGoodsCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:HotGoodsCollectionCellIdentifer forIndexPath:indexPath];
    [cell setType:ExistDecreaseType];
    [cell setTag:[[_hotGoodsModelArray[indexPath.row] goods_id] integerValue]];
    [cell setGoodsModelArray:_hotGoodsModelArray];
    [cell setHotGoodsDataWithGoodsModel:_hotGoodsModelArray[indexPath.row] rowIndex:indexPath.row];
    return cell;
}

#pragma mark -- UICollectionViewDelegate
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((_hotGoodsCollectView.cur_w-30)/2, 87+(_hotGoodsCollectView.cur_w-30)/2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

@end





