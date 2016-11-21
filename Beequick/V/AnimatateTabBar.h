//
//  AnimatateTabBar.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnimatateTabBarDelegate;
@interface AnimatateTabBar : UIView

@property (nullable, nonatomic, strong) NSArray *imagesArray; //未选中状态下图片
@property (nullable, nonatomic,strong) NSArray *selectedImagesArray; //选中状态下图片
@property (nullable, nonatomic,strong) NSArray *titlesArray; //未选中状态下文本
@property (nullable, nonatomic, strong) NSArray *selectedTitlesArray; //选中状态下文本
@property (nullable, nonatomic, strong) NSDictionary *titleAttributesDic; //未选中状态下文本样式
@property (nullable, nonatomic, strong) NSDictionary *selectedTitleAttributesDic; //选中状态下文本样式

@property(nonatomic,weak) id<AnimatateTabBarDelegate> _Nullable delegate;

/**
 *  创建tabBar
 *
 *  @param frame        tabBar的框架
 *  @param childVCCount 子控制器个数
 *
 *  @return tabBar对象
 */
- (instancetype _Nonnull)initWithFrame:(CGRect)frame childVCCount:(NSInteger)childVCCount;

- (void)selectedBtnClicked:(UIButton * _Nonnull)sender;

@end

@protocol AnimatateTabBarDelegate <NSObject>

- (void)selectedWithIndex:(NSInteger)index;

@end









