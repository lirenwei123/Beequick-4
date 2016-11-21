//
//  ProductView.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/21.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDetailModel.h"

@interface ProductView : UIView

- (void)setGoodsModel:(GoodsModel *)goodsModel productType:(ProductViewType)productType;
@property (nonatomic,assign) NSInteger rowIndex;
@property (nonatomic,copy) void (^addProductBlock)(UIView *contentView, UIButton *addProductBtn);
@property (nonatomic,copy) void (^reduceProductBlock)( UIButton *reduceProductBtn);

- (instancetype)initWithFrame:(CGRect)frame isHaveLine:(BOOL)isHaveLine productViewType:(ProductViewType)productViewType index:(NSInteger)index;

- (void)setFrame:(CGRect)frame goodsModel:(GoodsModel *)goodsModel type:(ProductViewType)type;
- (void)handleProductWithStoreProductNum:(NSInteger)storeProductNum cartProductNum:(NSInteger)cartProductNum;

@end
