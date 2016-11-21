//
//  MarketViewController.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "MarketViewController.h"
#import "MarketCategorysModel.h"
#import "CategoryDetailModel.h"
#import "MarketCategoryTableViewCell.h"
#import "HeadView.h"
#import "ChildCategoryCollectionViewCell.h"
#import "UIScrollView+HeadRefreashing.h"
#import "GoodsTableViewCell.h"
#import "UIView+DropToShopCartAnimation.h"

#define ChildCategoryCellIdentifer  @"ChildCategoryCellIdentifer"

@interface MarketViewController ()<UITableViewDataSource, UITableViewDelegate, HeadViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
{
    UIView *_topView;
    UITableView *_categoryTableView;
    HeadView *_headView;
    UICollectionView *_childCategoryCollectionView;
    MarketCategorysModel *_curretnCategoryModel;
    UIView *_lineView;
    UITableView *_goodsTabelView;
    BOOL _isShow;
    UIView *_dynamicTopView;
    UILabel *_dynamicLabel;
    BOOL _isScrollTop;
    NSString *_sortTypeStr;
    NSString *_childNameStr;
    NSInteger _selectRow;
    NSMutableArray *_lastArray;
    NSIndexPath *_childCellIndexPath;
    UIButton *_senderBtn;
    BOOL _isTap;
}

@property (nonatomic, strong) NSMutableArray *marketCategoryArray;
@property (nonatomic,strong) NSMutableDictionary *productsDic;
@property (nonatomic, strong) NSMutableDictionary *dynamicChangeProductsDic;

@end

@implementation MarketViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isScrollTop = YES;
    [self.view setBackgroundColor:Color_RGB(244, 244, 244, 1)];
    [self.navigationController.navigationBar setBarTintColor:Color_RGB(254, 207, 9, 1)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addProductToShoppingCart:) name:AddProductToShoppingCartNotification object:nil];
    
    [self setUpView];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isShow = YES;
    _sortTypeStr = @"";
    _childNameStr = @"";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isShow = NO;
}

#pragma mark -- 配置视图
- (void)setUpView{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, 100, self.view.cur_h-kNavBarHeight-kTabbarHeight)];
    [_categoryTableView setBackgroundColor:Color_RGB(244, 244, 244, 1)];
    [_categoryTableView setDataSource:self];
    [_categoryTableView setDelegate:self];
    [_categoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_categoryTableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_categoryTableView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(_categoryTableView.cur_x_w, kNavBarHeight, self.view.cur_w-_categoryTableView.cur_x_w, 0)];
    [self.view addSubview:_topView];
    
    _headView  = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, _topView.cur_w, 41)];
    [_headView setDelegate:self];
    [_topView addSubview:_headView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _childCategoryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_childCategoryCollectionView setDataSource:self];
    [_childCategoryCollectionView setDelegate:self];
    [_childCategoryCollectionView setBackgroundColor:[UIColor whiteColor]];
    [_childCategoryCollectionView registerClass:[ChildCategoryCollectionViewCell class] forCellWithReuseIdentifier:ChildCategoryCellIdentifer];
    [_topView addSubview:_childCategoryCollectionView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _childCategoryCollectionView.cur_h-1, _childCategoryCollectionView.cur_w-12, 1)];
    [_lineView setBackgroundColor:Line_Color];
    [_childCategoryCollectionView addSubview:_lineView];
    
    _dynamicTopView = [[UIView alloc] initWithFrame:CGRectMake(_topView.cur_x, kNavBarHeight, _topView.cur_w, 41)];
    [_dynamicTopView setBackgroundColor:[UIColor whiteColor]];
    [_dynamicTopView setHidden:YES];
    [self.view addSubview:_dynamicTopView];
    
    _dynamicLabel = [[UILabel alloc] init];
    [_dynamicLabel setTextColor:[UIColor blackColor]];
    [_dynamicLabel setFont:[UIFont systemFontOfSize:13]];
    [_dynamicLabel setUserInteractionEnabled:YES];
    [_dynamicTopView addSubview:_dynamicLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureResponse)];
    [_dynamicLabel addGestureRecognizer:tapGesture];
    
    UIImageView *dynamicImageView = [[UIImageView alloc] init];
    [dynamicImageView setImage:[UIImage imageNamed:@"classify"]];
    [_dynamicTopView insertSubview:dynamicImageView atIndex:0];
    
    UIView *dynamicLineView = [[UIView alloc] initWithFrame:CGRectMake(10, _dynamicTopView.cur_h-0.5, _dynamicTopView.cur_w-12, 0.5)];
    [dynamicLineView setBackgroundColor:Line_Color];
    [_dynamicTopView addSubview:dynamicLineView];
    
    _goodsTabelView = [[UITableView alloc] initWithFrame:CGRectMake(_categoryTableView.cur_x_w, 0, _topView.cur_w, 0) style:UITableViewStyleGrouped];
    [_goodsTabelView setBackgroundColor:Color_RGB(244, 244, 244, 1)];
    [_goodsTabelView setDelegate:self];
    [_goodsTabelView setDataSource:self];
    [_goodsTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_goodsTabelView setIsHaveHeadRefreash:YES];
    __weak typeof(_goodsTabelView) weakTableView = _goodsTabelView;
    [_goodsTabelView setStartBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakTableView finishRefreash];
        });
    }];
    [self.view addSubview:_goodsTabelView];
    
}

#pragma mark -- 请求数据
- (void)requestData{
    //从接口请求数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"products.json" ofType:nil];
    NSData *productsData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:productsData options:NSJSONReadingMutableContainers error:nil];
    
    if ([dataDic[@"code"] integerValue] == 0) {
        //数据下载成功
        NSDictionary *dic = [dataDic valueForKey:@"data"];
        NSArray *categoryArray = [dic valueForKey:@"categories"];
        NSDictionary *productsDic = [dic valueForKey:@"products"];
        [self handleUpdateViewWithCategoryData:categoryArray productsData:productsDic];
    }
    
}

#pragma mark -- 处理数据
- (void)handleUpdateViewWithCategoryData:(NSArray *)categoryData productsData:(NSDictionary *)productsData{
    [self.marketCategoryArray removeAllObjects];
    [self.productsDic removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [categoryData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //创建类别模型
        MarketCategorysModel *model = [[MarketCategorysModel alloc] initWithDictionary:obj error:nil];
        [weakSelf.marketCategoryArray addObject:model];
        
        //通过类别获取对应的商品列表
        NSArray *productsArray = [productsData valueForKey:[NSString stringWithFormat:@"%ld", model.categoryId]];
        NSMutableArray *goodsArray = [NSMutableArray array];
        [productsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GoodsModel *goodsModel = [[GoodsModel alloc] initWithDictionary:obj error:nil];
            [goodsArray addObject:goodsModel];
        }];
        [weakSelf.productsDic setValue:goodsArray forKey:[NSString stringWithFormat:@"%ld", model.categoryId]];
    }];
    _dynamicChangeProductsDic = [[NSMutableDictionary alloc] initWithDictionary:self.productsDic];
    [_categoryTableView reloadData];
    [self tableView:_categoryTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark -- 商品加入到购物车的通知
- (void)addProductToShoppingCart:(NSNotification *)noti{
    if (_isShow) {
        UIView *contentView = noti.userInfo[@"contentView"];
        [contentView dropToShopCartWithSubView:self.view contentText:nil dropPoint:CGPointMake(self.view.cur_w-(self.view.cur_w/5)*1.5, self.view.cur_h-25)];
    }
    
    GoodsModel *goodsModel = noti.userInfo[@"goodsModel"];
    GoodsTableViewCell *cell = [_goodsTabelView viewWithTag:[goodsModel.goods_id integerValue]] ;
    [cell refreashViewWithGoodsModel:goodsModel];
}

- (NSMutableArray *)marketCategoryArray{
    if (!_marketCategoryArray) {
        _marketCategoryArray = [NSMutableArray array];
    }
    return _marketCategoryArray;
}

- (NSMutableDictionary *)productsDic{
    if (!_productsDic) {
        _productsDic = [NSMutableDictionary dictionary];
    }
    return _productsDic;
}

#pragma mark -- 计算动态顶部视图frame
- (void)calculateDynamicFrame{
    if (!_childNameStr) {
        _childNameStr = @"全部分类";
    }
    NSString *title = [NSString stringWithFormat:@"%@·%@", _sortTypeStr, _childNameStr];
    [_dynamicLabel setText:title];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    [_dynamicLabel setFrame:CGRectMake((_dynamicTopView.cur_w-rect.size.width)/2, (_dynamicTopView.cur_h-rect.size.height)/2, rect.size.width, rect.size.height)];
    [_dynamicTopView.subviews[0] setFrame:CGRectMake(_dynamicLabel.cur_x_w+10, (_dynamicTopView.cur_h-6)/2, 12, 6)];
}

#pragma mark -- 更换排序方式刷新商品列表
- (void)refreashGoodsTableViewWithSenderBtn:(UIButton *)senderBtn{
    NSString *key = [NSString stringWithFormat:@"%ld", _curretnCategoryModel.categoryId];
    NSMutableArray *productsArray = [_dynamicChangeProductsDic valueForKey:key];
    if ([senderBtn.currentTitle isEqualToString:@"综合排序"]) {
        [_dynamicChangeProductsDic setValue:[_dynamicChangeProductsDic valueForKey:key] forKey:key];
        
    }
    else if ([senderBtn.currentTitle isEqualToString:@"按价格"]){
        NSArray *prdArray = nil;
        if (senderBtn.tag) {
            //价格从低到高
            prdArray = [productsArray sortedArrayUsingComparator:^NSComparisonResult(GoodsModel *  _Nonnull obj1, GoodsModel *  _Nonnull obj2) {
                return obj1.partner_price>obj2.partner_price;
            }];
        }
        else{
            //价格从高到低
            prdArray = [productsArray sortedArrayUsingComparator:^NSComparisonResult(GoodsModel *  _Nonnull obj1, GoodsModel *  _Nonnull obj2) {
                return obj1.partner_price<obj2.partner_price;
            }];
        }
        [_dynamicChangeProductsDic setValue:prdArray forKey:key];
    }
    else{
        NSArray *sortProductNumArray = [productsArray sortedArrayUsingComparator:^NSComparisonResult(GoodsModel *  _Nonnull obj1, GoodsModel *  _Nonnull obj2) {
            return obj1.product_num<obj2.product_num;
        }];
        [_dynamicChangeProductsDic setValue:sortProductNumArray forKey:key];
    }
}

#pragma mark -- 更新子类类别刷新商品列表
- (void)refreashGoodsTableViewWithChildCategoryFromIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"%ld", _curretnCategoryModel.categoryId];
    NSMutableArray *productsArray = [_productsDic valueForKey:key];
    if ([_curretnCategoryModel.cids[indexPath.row] childId] == 0) {
        [_dynamicChangeProductsDic setValue:[_productsDic valueForKey:key] forKey:key];
    }
    else{
        NSMutableArray *childCategoryProductArray = [NSMutableArray array];
        [productsArray enumerateObjectsUsingBlock:^(GoodsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *childName = obj.cids[[NSString stringWithFormat:@"%ld",[_curretnCategoryModel.cids[indexPath.row] childId]]];
            if (childName) {
                [childCategoryProductArray addObject:obj];
            }
        }];
        [_dynamicChangeProductsDic setValue:childCategoryProductArray forKey:key];
    }
}

#pragma mark -- 单击手势的响应事件
- (void)tapGestureResponse{
    _isTap = YES;
    _isScrollTop = YES;
    [_dynamicTopView setHidden:YES];
    CGFloat rate = _goodsTabelView.decelerationRate;
    [_goodsTabelView setDecelerationRate:0];
    [UIView animateWithDuration:0.2 animations:^{
        [_topView setFrame:CGRectMake(_topView.cur_x, kNavBarHeight, _topView.cur_w, _topView.cur_h)];
        [_goodsTabelView setFrame:CGRectMake(_goodsTabelView.cur_x, _topView.cur_y_h, _goodsTabelView.cur_w, self.view.cur_h-kNavBarHeight-_topView.cur_h)];
    } completion:^(BOOL finished) {
        [_goodsTabelView setDecelerationRate:rate];
    }];

}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isTap = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _goodsTabelView) {
        if (_isTap) {
            return;
        }
        if (scrollView.contentOffset.y>0) {
            if (_isScrollTop) {
                _isScrollTop = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    [_topView setFrame:CGRectMake(_topView.cur_x, kNavBarHeight-(_topView.cur_h-41), _topView.cur_w, _topView.cur_h)];
                    [_goodsTabelView setFrame:CGRectMake(_goodsTabelView.cur_x, _dynamicTopView.cur_y_h, _goodsTabelView.cur_w, self.view.cur_h-kNavBarHeight-41)];
                } completion:^(BOOL finished) {
                    [_dynamicTopView setHidden:NO];
                }];
            }
        }
        else if (scrollView.contentOffset.y <= 0){
            if (!_isScrollTop) {
                [_dynamicTopView setHidden:YES];
                [UIView animateWithDuration:0.2 animations:^{
                    [_topView setFrame:CGRectMake(_topView.cur_x, kNavBarHeight, _topView.cur_w, _topView.cur_h)];
                    [_goodsTabelView setFrame:CGRectMake(_goodsTabelView.cur_x, _topView.cur_y_h, _goodsTabelView.cur_w, self.view.cur_h-kNavBarHeight-_topView.cur_h)];
                } completion:^(BOOL finished) {
                }];
            }
            _isScrollTop = YES;
        }
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _categoryTableView) {
        return _marketCategoryArray.count;
    }
    
    return [_dynamicChangeProductsDic[[NSString stringWithFormat:@"%ld", _curretnCategoryModel.categoryId]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *maketCellIdentifer = @"maketCellIdentifer";
    static NSString *goodsCellIdentifer = @"goodsCellIdentifer";
    UITableViewCell *cell;
    if (tableView == _categoryTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:maketCellIdentifer];
        if (!cell) {
            cell = [[MarketCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:maketCellIdentifer];
        }
        [(MarketCategoryTableViewCell *)cell setMarketModel:_marketCategoryArray[indexPath.row]];
        [_categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIdentifer];
        if (!cell) {
            cell = [[GoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:goodsCellIdentifer type:QuicklyService];
        }
        GoodsModel *goodsModel = [_dynamicChangeProductsDic[[NSString stringWithFormat:@"%ld", _curretnCategoryModel.categoryId]] objectAtIndex:indexPath.row];
        [cell setTag:[goodsModel.goods_id integerValue]];
        [(GoodsTableViewCell *)cell setGoodsDataWithGoodsModel:goodsModel rowIndex:indexPath.row];
        [(GoodsTableViewCell *)cell setGoodsModelArray:_productsDic[[NSString stringWithFormat:@"%ld", _curretnCategoryModel.categoryId]]];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _categoryTableView) {
        return 44;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _goodsTabelView) {
        return 0.1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _goodsTabelView) {
        return 99;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _goodsTabelView) {
        static NSString *footerViewIdentifer = @"footerViewIdentifer";
        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerViewIdentifer];
        if (!footerView) {
            footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:footerViewIdentifer];
            UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_goodsTabelView.cur_w-110)/2, 0, 110, 50)];
            [bottomImageView setImage:[UIImage imageNamed:@"v2_common_footer"]];
            [footerView.contentView addSubview:bottomImageView];
        }
        [footerView.contentView setBackgroundColor:Color_RGB(244, 244, 244, 1)];
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _categoryTableView) {
        _selectRow = indexPath.row;
        [_headView sortBtnClicked:_headView.subviews[0]];
        [_goodsTabelView setContentOffset:CGPointZero animated:YES];
        [_dynamicTopView setHidden:YES];
        _curretnCategoryModel = _marketCategoryArray[indexPath.row];
        if (_curretnCategoryModel.cids.count>1) {
            NSInteger count = _curretnCategoryModel.cids.count%3==0?_curretnCategoryModel.cids.count/3:(_curretnCategoryModel.cids.count/3+1);
            [_topView setFrame:CGRectMake(_categoryTableView.cur_x_w, kNavBarHeight, self.view.cur_w-_categoryTableView.cur_x_w, 41+(18+count*40))];
            [_headView setFrame:CGRectMake(0, 0, _topView.cur_w, 41)];
            [_childCategoryCollectionView setFrame:CGRectMake(0, _headView.cur_y_h, _headView.cur_w, 18+count*40)];
            [_lineView setFrame:CGRectMake(10, _childCategoryCollectionView.cur_h-1, _childCategoryCollectionView.cur_w-12, 1)];
            [_goodsTabelView setFrame:CGRectMake(_topView.cur_x, _topView.cur_y_h, _topView.cur_w, self.view.cur_h-_topView.cur_y_h)];
        }
        else{
            [_childCategoryCollectionView setFrame:CGRectZero];
            [_topView setFrame:CGRectMake(_categoryTableView.cur_x_w, kNavBarHeight, self.view.cur_w-_categoryTableView.cur_x_w, 41)];
            [_headView setFrame:CGRectMake(0, 0, _topView.cur_w, 41)];
            [_goodsTabelView setFrame:CGRectMake(_topView.cur_x, _topView.cur_y_h, _topView.cur_w, self.view.cur_h-_topView.cur_y_h)];
        }
        _childCellIndexPath = nil;
        [_childCategoryCollectionView reloadData];
        _childNameStr = nil;
        if (_curretnCategoryModel.cids.count>1) {
            [_childCategoryCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            [self collectionView:_childCategoryCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        }
        
        [_goodsTabelView reloadData];
    }
}

#pragma mark -- HeadViewDelegate
- (void)sortByConditionWithBtn:(UIButton *)senderBtn{
    _sortTypeStr = senderBtn.currentTitle;
    _senderBtn = senderBtn;
    [self calculateDynamicFrame];
    [self refreashGoodsTableViewWithChildCategoryFromIndexPath:_childCellIndexPath];
    [self refreashGoodsTableViewWithSenderBtn:senderBtn];
    [_goodsTabelView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _curretnCategoryModel.cids.count>1?_curretnCategoryModel.cids.count:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChildCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChildCategoryCellIdentifer forIndexPath:indexPath];
    [cell setChildCategoryModel:_curretnCategoryModel.cids[indexPath.row]];
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _childCellIndexPath = indexPath;
    ChildCategoryModel *model = _curretnCategoryModel.cids[indexPath.row];
    _childNameStr = model.name;
    [self calculateDynamicFrame];
    [self refreashGoodsTableViewWithChildCategoryFromIndexPath:indexPath];
    [self refreashGoodsTableViewWithSenderBtn:_senderBtn];
    [_goodsTabelView reloadData];
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((_childCategoryCollectionView.cur_w-40)/3, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(14, 10, 14, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

@end




