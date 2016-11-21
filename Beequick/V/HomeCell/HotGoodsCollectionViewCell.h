//
//  HotGoodsCollectionViewCell.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/22.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDetailModel.h"
#import "ProductView.h"

@interface HotGoodsCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) ProductViewType type;
@property (nonatomic, strong) NSArray *goodsModelArray;
- (void)setHotGoodsDataWithGoodsModel:(GoodsModel *)goodsModel rowIndex:(NSInteger)rowIndex;

- (void)refreashViewWithGoodsModel:(GoodsModel *)goodsModel;

@end
