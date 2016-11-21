//
//  ProductView.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/21.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ProductView.h"
#import "UIImageView+WebCache.h"
#import "UIView+DropToShopCartAnimation.h"
#import "HandleProductNum.h"

@interface ProductView()
{
    BOOL _isHaveLine;
    ProductViewType _type;
    NSInteger _index;
    UIImageView *_productImageView;
    UILabel *_productNameLabel;
    UILabel *_selectedLabel;
    UILabel *_desLabel;
    UILabel *_longNameLabel;
    UILabel *_currentPriceLabel;
    UILabel *_marketPriceLabel;
    UIView *_speratctorLineView;
    UIButton *_increaseBtn;
    UIView *_vorticalLineView;
    UIButton *_decreaseBtn;
    UILabel *_addProductNumLabel;
    UILabel *_replenishentLabel;
    GoodsModel *_goodsModel;
}


@end

@implementation ProductView

- (void)dealloc{
    NSLog(@"dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame isHaveLine:(BOOL)isHaveLine productViewType:(ProductViewType)productViewType index:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self) {
        _isHaveLine = isHaveLine;
        _type = productViewType;
        _index = index;
        [self setUpView];
    }
    return self;
}

#pragma mark -- 配置视图
- (void)setUpView{
    UIImageView *productImageView = [[UIImageView alloc] init];
    [productImageView setTag:500];
    [self addSubview:productImageView];
    _productImageView = productImageView;
    
    UILabel *productNameLabel = [[UILabel alloc] init];
    [productNameLabel setFont:[UIFont systemFontOfSize:13]];
    if (_type == ReverseType) {
        [productNameLabel setNumberOfLines:2];
    }
    [self addSubview:productNameLabel];
    _productNameLabel = productNameLabel;
    
    UILabel *selectedLabel = [[UILabel alloc] init];
    [selectedLabel.layer setCornerRadius:4];
    [selectedLabel.layer setBorderColor:Color_RGB(249, 58, 69, 1).CGColor];
    [selectedLabel.layer setBorderWidth:1];
    [selectedLabel setFont:[UIFont systemFontOfSize:10]];
    [selectedLabel setTextColor:Color_RGB(249, 58, 69, 1)];
    [selectedLabel setText:@"精选"];
    [selectedLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:selectedLabel];
    _selectedLabel = selectedLabel;
    
    UILabel *desLabel = [[UILabel alloc] init];
    [desLabel setBackgroundColor:Color_RGB(249, 58, 69, 1)];
    [desLabel.layer setCornerRadius:4];
    [desLabel.layer setMasksToBounds:YES];
    [desLabel setTextColor:[UIColor whiteColor]];
    [desLabel setFont:[UIFont systemFontOfSize:10]];
    [desLabel setTextAlignment:NSTextAlignmentCenter];
    [desLabel setHidden:YES];
    [self addSubview:desLabel];
    _desLabel = desLabel;
    
    UILabel *longNameLabel = [[UILabel alloc] init];
    [longNameLabel setTextColor:Color_RGB(163, 163, 163, 1)];
    [longNameLabel setFont:[UIFont systemFontOfSize:11]];
    [self addSubview:longNameLabel];
    _longNameLabel = longNameLabel;
    
    UILabel *currentPriceLabel = [[UILabel alloc] init];
    [currentPriceLabel setFont:[UIFont systemFontOfSize:13]];
    [currentPriceLabel setTextColor:[UIColor redColor]];
    [self addSubview:currentPriceLabel];
    _currentPriceLabel = currentPriceLabel;
    
    UILabel *marketPriceLabel = [[UILabel alloc] init];
    [marketPriceLabel setTextColor:Color_RGB(163, 163, 163, 1)];
    [marketPriceLabel setFont:[UIFont systemFontOfSize:11]];
    [self addSubview:marketPriceLabel];
    _marketPriceLabel = marketPriceLabel;
    
    UIView *speratctorLineView = [[UIView alloc] init];
    [speratctorLineView setBackgroundColor:Color_RGB(163, 163, 163, 1)];
    [self addSubview:speratctorLineView];
    _speratctorLineView = speratctorLineView;
    
    UIButton *increaseBtn = [[UIButton alloc] init];
    [increaseBtn setBackgroundImage:[UIImage imageNamed:@"v2_increase"] forState:UIControlStateNormal];
    [increaseBtn setTag:100+_index];
    [increaseBtn addTarget:self action:@selector(increaseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:increaseBtn];
    _increaseBtn = increaseBtn;
    if (_isHaveLine) {
        UIView *vorticalLineView = [[UIView alloc] init];
        [vorticalLineView setBackgroundColor:Line_Color];
        [self addSubview:vorticalLineView];
        _vorticalLineView = vorticalLineView;
    }
    
    _replenishentLabel = [[UILabel alloc] init];
    [_replenishentLabel setHidden:YES];
    [_replenishentLabel setText:@"补货中"];
    [_replenishentLabel setTextAlignment:NSTextAlignmentRight];
    [_replenishentLabel setFont:[UIFont systemFontOfSize:11]];
    [_replenishentLabel setTextColor:Color_RGB(211, 65, 24, 1)];
    [self addSubview:_replenishentLabel];
    
    if (_type == ExistDecreaseType || _type == HorizonRankType) {
        _addProductNumLabel = [[UILabel alloc] init];
        [_addProductNumLabel setTextAlignment:NSTextAlignmentCenter];
        [_addProductNumLabel setFont:[UIFont systemFontOfSize:11]];
        [_addProductNumLabel setTag:501];
        [_addProductNumLabel setHidden:YES];
        [self addSubview:_addProductNumLabel];
        
        _decreaseBtn = [[UIButton alloc] init];
        [_decreaseBtn setHidden:YES];
        [_decreaseBtn setBackgroundImage:[UIImage imageNamed:@"v2_reduced"] forState:UIControlStateNormal];
        [_decreaseBtn setBackgroundImage:[UIImage imageNamed:@"v2_reduced"] forState:UIControlStateHighlighted|UIControlStateSelected];
        [_decreaseBtn setTag:200+_index];
        [_decreaseBtn addTarget:self action:@selector(reduceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_decreaseBtn];
    }
}

- (void)setFrame:(CGRect)frame goodsModel:(GoodsModel *)goodsModel type:(ProductViewType)type{
    [super setFrame:frame];
    _type = type;
    if (_type == NoExistDecreaseType || _type == ExistDecreaseType || _type == ReverseType) {
        [self setVorticalFrameWithGoodsModel:goodsModel];
    }
    else{
        [self setHorizonFrameWithGoodsModel:goodsModel];
    }
}

#pragma mark -- 配置纵向排列frame
- (void)setVorticalFrameWithGoodsModel:(GoodsModel *)goodsModel{
    [_productImageView setFrame:CGRectMake(0, 0, self.cur_w-0.5, self.cur_w-0.5)];
    if (_type == ReverseType) {
        [_productNameLabel setNumberOfLines:2];
        [_productNameLabel setFrame:CGRectMake(5, _productImageView.cur_y_h, self.cur_w-10, 35)];
    }
    else{
        [_productNameLabel setFrame:CGRectMake(5, _productImageView.cur_y_h+5, self.cur_w-10, 15)];
    }
    [_selectedLabel setFrame:CGRectMake(_productNameLabel.cur_x, _productNameLabel.cur_y_h+4, 24, 14)];
    CGRect desRect = [[goodsModel pm_desc] boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil];
    if (_type == ReverseType) {
        [_selectedLabel setHidden:YES];
        [_desLabel setFrame:CGRectMake(_productNameLabel.cur_x, _productNameLabel.cur_y_h, desRect.size.width+2, 14)];
        [_longNameLabel setHidden:YES];
        [_longNameLabel setFrame:CGRectMake(_desLabel.cur_x, _desLabel.cur_y_h, 0, 0)];
    }
    else{
        [_desLabel setFrame:CGRectMake(_selectedLabel.cur_x_w+2, _selectedLabel.cur_y, desRect.size.width+2, _selectedLabel.cur_h)];
        [_longNameLabel setFrame:CGRectMake(_selectedLabel.cur_x, _selectedLabel.cur_y_h+4, self.cur_w-10, 15)];
    }
    CGFloat curPriceNum = [[goodsModel partner_price] doubleValue];
    NSString *curPrice = nil;
    if (curPriceNum == (int)curPriceNum) {
        curPrice = [NSString stringWithFormat:@"￥%d", (int)curPriceNum];
    }
    else{
        curPrice = [NSString stringWithFormat:@"￥%.1f", curPriceNum];
    }
    CGRect curPriceRect = [curPrice boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    [_currentPriceLabel setFrame:CGRectMake(_longNameLabel.cur_x, _longNameLabel.cur_y_h+2, curPriceRect.size.width, 15)];
    CGFloat marketPriceNum = [[goodsModel market_price] doubleValue];
    NSString *maketPrice = nil;
    if (marketPriceNum == (int)marketPriceNum) {
        maketPrice = [NSString stringWithFormat:@"￥%d", (int)marketPriceNum];
    }
    else{
        maketPrice = [NSString stringWithFormat:@"￥%.1f", marketPriceNum];
    }
    CGFloat fontSize;
    NSInteger height;
    if (_type == ReverseType) {
        [_marketPriceLabel setFont:[UIFont systemFontOfSize:8]];
        fontSize = 8;
        height = 5;
    }
    else{
        fontSize = 11;
        height = 2;
    }
    CGRect marketPriceRect = [maketPrice boundingRectWithSize:CGSizeMake(MAXFLOAT, fontSize+2) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    [_marketPriceLabel setFrame:CGRectMake(_currentPriceLabel.cur_x_w+2, _currentPriceLabel.cur_y+height, marketPriceRect.size.width, fontSize+2)];
    [_speratctorLineView setFrame:CGRectMake(_marketPriceLabel.cur_x-1, _marketPriceLabel.cur_y+_marketPriceLabel.cur_h/2-0.5, _marketPriceLabel.cur_w+2, 1)];
    [_replenishentLabel setFrame:CGRectMake(self.cur_w-55, _currentPriceLabel.cur_y, 50, 15)];
    [_increaseBtn setFrame:CGRectMake(self.cur_w-35, self.cur_h-35, 30, 30)];
    if (_isHaveLine) {
        [_vorticalLineView setFrame:CGRectMake(self.cur_w-0.5, 0, 0.5, self.cur_h-10)];
    }
    if (_type == ExistDecreaseType) {
        [_addProductNumLabel setFrame:CGRectMake(self.cur_w-_increaseBtn.cur_w-6-20, _increaseBtn.cur_y, 20, _increaseBtn.cur_h)];
        [_decreaseBtn setFrame:CGRectMake(_addProductNumLabel.cur_x-1-_increaseBtn.cur_w, _increaseBtn.cur_y, _increaseBtn.cur_w, _increaseBtn.cur_h)];
    }
}

#pragma mark -- 配置横向排列frame
- (void)setHorizonFrameWithGoodsModel:(GoodsModel *)goodsModel{
    [_productImageView setFrame:CGRectMake(8, (self.cur_h-65)/2, 65, 65)];
    [_selectedLabel setFrame:CGRectMake(_productImageView.cur_x_w+5, 10, 24, 14)];
    [_productNameLabel setFrame:CGRectMake(_selectedLabel.cur_x_w+2, _selectedLabel.cur_y, self.cur_w-_selectedLabel.cur_x_w-2, 17)];
    CGRect desRect = [[goodsModel pm_desc] boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil];
    [_desLabel setFrame:CGRectMake(_selectedLabel.cur_x, _selectedLabel.cur_y_h+2, desRect.size.width+2, _selectedLabel.cur_h)];
    [_longNameLabel setFrame:CGRectMake(_desLabel.cur_x, _desLabel.cur_y_h+2, self.cur_w-_desLabel.cur_x, 15)];
    [_longNameLabel setTextColor:[UIColor blackColor]];
    CGFloat curPriceNum = [[goodsModel partner_price] doubleValue];
    NSString *curPrice = nil;
    if (curPriceNum == (int)curPriceNum) {
        curPrice = [NSString stringWithFormat:@"￥%d", (int)curPriceNum];
    }
    else{
        curPrice = [NSString stringWithFormat:@"￥%.1f", curPriceNum];
    }
    [_currentPriceLabel setFont:[UIFont boldSystemFontOfSize:13]];
    CGRect curPriceRect = [curPrice boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} context:nil];
    [_currentPriceLabel setFrame:CGRectMake(_longNameLabel.cur_x, _longNameLabel.cur_y_h+3, curPriceRect.size.width, 15)];
    CGFloat marketPriceNum = [[goodsModel market_price] doubleValue];
    NSString *maketPrice = nil;
    if (marketPriceNum == (int)marketPriceNum) {
        maketPrice = [NSString stringWithFormat:@"￥%d", (int)marketPriceNum];
    }
    else{
        maketPrice = [NSString stringWithFormat:@"￥%.1f", marketPriceNum];
    }
    CGRect marketPriceRect = [maketPrice boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
    [_marketPriceLabel setFrame:CGRectMake(_currentPriceLabel.cur_x_w+2, _currentPriceLabel.cur_y+2, marketPriceRect.size.width, 13)];
    [_speratctorLineView setFrame:CGRectMake(_marketPriceLabel.cur_x-1, _marketPriceLabel.cur_y+_currentPriceLabel.cur_h/2-0.5, _marketPriceLabel.cur_w+2, 1)];
    [_replenishentLabel setFrame:CGRectMake(self.cur_w-55, _currentPriceLabel.cur_y, 50, 15)];
    [_increaseBtn setFrame:CGRectMake(self.cur_w-40, self.cur_h-36, 30, 30)];
    if (_type == HorizonRankType) {
        [_addProductNumLabel setFrame:CGRectMake(self.cur_w-_increaseBtn.cur_w-6-20, _increaseBtn.cur_y, 20, _increaseBtn.cur_h)];
        [_decreaseBtn setFrame:CGRectMake(_addProductNumLabel.cur_x-1-_increaseBtn.cur_w, _increaseBtn.cur_y, _increaseBtn.cur_w, _increaseBtn.cur_h)];
    }

}

- (void)setGoodsModel:(GoodsModel *)goodsModel productType:(ProductViewType)productType{
    _goodsModel = goodsModel;
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.img] placeholderImage:[UIImage imageNamed:PlaceholderImage]];
    [_productNameLabel setText:goodsModel.name];
    if ([goodsModel.pm_desc isEqualToString:@""]) {
        [_desLabel setHidden:YES];
    }
    else{
        [_desLabel setHidden:NO];
        [_desLabel setText:goodsModel.pm_desc];
    }
    [_longNameLabel setText:goodsModel.specifics];
    CGFloat curPriceNum = [[goodsModel partner_price] doubleValue];
    NSString *curPrice = nil;
    if (curPriceNum == (int)curPriceNum) {
        curPrice = [NSString stringWithFormat:@"￥%d", (int)curPriceNum];
    }
    else{
        curPrice = [NSString stringWithFormat:@"￥%.1f", curPriceNum];
    }
    [_currentPriceLabel setText:curPrice];
    CGFloat marketPriceNum = [[goodsModel market_price] doubleValue];
    NSString *maketPrice = nil;
    if (marketPriceNum == (int)marketPriceNum) {
        maketPrice = [NSString stringWithFormat:@"￥%d", (int)marketPriceNum];
    }
    else{
        maketPrice = [NSString stringWithFormat:@"￥%.1f", marketPriceNum];
    }
    [_marketPriceLabel setText:maketPrice];
    if ([goodsModel.number integerValue] == 0) {
        [_increaseBtn setHidden:YES];
        [_replenishentLabel setHidden:NO];
    }
    else{
        [_increaseBtn setHidden:NO];
        [_replenishentLabel setHidden:YES];
        NSInteger cartProductNum = [[HandleProductNum sharedHandleProductNum] cartProductNumWithGoodsModel:goodsModel channelType:(productType==ReverseType?ReverseService:QuicklyService)];
        if (cartProductNum != 0) {
            [_decreaseBtn setHidden:NO];
            [_addProductNumLabel setText:[NSString stringWithFormat:@"%ld", cartProductNum]];
            [_addProductNumLabel setHidden:NO];
        }
        else{
            [_decreaseBtn setHidden:YES];
            [_addProductNumLabel setHidden:YES];
        }
    }
    
}

- (void)setRowIndex:(NSInteger)rowIndex{
    [_increaseBtn setTag:100+rowIndex];
    [_decreaseBtn setTag:200+rowIndex];
}

#pragma mark -- 添加商品按钮的响应事件
- (void)increaseBtnClicked:(UIButton *)senderBtn{
    [senderBtn setBackgroundImage:[UIImage imageNamed:@"v2_increased"] forState:UIControlStateNormal];
    UIImageView *productImageView = [[senderBtn superview] viewWithTag:500];
    if (_addProductBlock) {
        _addProductBlock(productImageView, senderBtn);
    }
}

#pragma mark -- 移除商品按钮的响应事件
- (void)reduceBtnClicked:(UIButton *)senderBtn{
    if (_reduceProductBlock) {
        _reduceProductBlock(senderBtn);
    }
}

- (void)handleProductWithStoreProductNum:(NSInteger)storeProductNum cartProductNum:(NSInteger)cartProductNum{
    if (cartProductNum!=0) {
        [_decreaseBtn setHidden:NO];
        [_addProductNumLabel setHidden:NO];
        if (storeProductNum == 0) {
            NSLog(@"商品库存不足");
        }
        else{
            [_addProductNumLabel setText:[NSString stringWithFormat:@"%ld", cartProductNum]];
        }
    }
    else{
        [_addProductNumLabel setHidden:YES];
        [_decreaseBtn setHidden:YES];
        [_increaseBtn setBackgroundImage:[UIImage imageNamed:@"v2_increase"] forState:UIControlStateNormal];

    }
    
}

@end
