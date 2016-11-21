//
//  UIView+DropToShopCartAnimation.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/22.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DropToShopCartAnimation)

@property (nonatomic,strong) NSMutableArray *textLayerArray;

/**
 *  商品调入购物车动画
 *
 *  @param subView     展示该视图的基础视图
 *  @param contentText 内容文本(如果要掉落文本则传入)
 *  @param dropPoint   掉落位置
 */
- (void)dropToShopCartWithSubView:(UIView *)subView contentText:(NSString *)contentText dropPoint:(CGPoint)dropPoint;

@end
