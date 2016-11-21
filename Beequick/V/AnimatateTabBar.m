//
//  AnimatateTabBar.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "AnimatateTabBar.h"

@interface AnimatateTabBar()

@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic,strong) NSMutableArray *titleLabelArray;

@end

@implementation AnimatateTabBar

- (instancetype _Nonnull)initWithFrame:(CGRect)frame childVCCount:(NSInteger)childVCCount{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViewWithCount:childVCCount];
    }
    return self;
}

#pragma mark -- 配置视图
- (void)setUpViewWithCount:(NSInteger)count{
    
//    [self.layer setShadowColor:[UIColor redColor].CGColor];
//    [self.layer setShadowOffset:CGSizeMake(self.cur_w, 0.5)];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    CGPathMoveToPoint(path, &transform, 0, 0);
//    CGPathAddLineToPoint(path, &transform, self.cur_w, 0);
//    [self.layer setShadowPath:path];
    
    _imageViewArray = [NSMutableArray array];
    _titleLabelArray = [NSMutableArray array];
    
    for (NSInteger i=0; i<count; i++) {
        CGFloat btnWidth = self.cur_w/count;
        UIButton *barBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0.5, btnWidth, self.cur_h-0.5)];
        [barBtn setTag:100+i];
        [barBtn addTarget:self action:@selector(selectedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:barBtn];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((btnWidth-25)/2.0, 4, 25, 25)];
        [barBtn addSubview:iconImageView];
        [_imageViewArray addObject:iconImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.cur_y_h+2, btnWidth, 14)];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        [titleLabel setTextColor:Color_RGB(135, 135, 135, 1)];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [barBtn addSubview:titleLabel];
        [_titleLabelArray addObject:titleLabel];
    }
}

#pragma mark -- 配置正常状态下图片
- (void)setImagesArray:(NSArray *)imagesArray{
    if (imagesArray) {
        _imagesArray = imagesArray;
        //__unsafe_unretained AnimatateTabBar *weakSelf = self;
        //__weak AnimatateTabBar *weakSelf = self;
        __weak typeof(self) weakSelf = self;
        [_imagesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.imageViewArray[idx] setImage:obj];
        }];
    }
}

#pragma mark -- 配置正常状态下文本
- (void)setTitlesArray:(NSArray *)titlesArray{
    if (titlesArray) {
        _titlesArray = titlesArray;
        __weak typeof(self) weakSelf = self;
        [_titlesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:obj];
            [weakSelf.titleLabelArray[idx] setAttributedText:titleStr];
        }];
    }
}

#pragma mark -- 配置正常状态下属性字符串
- (void)setTitleAttributesDic:(NSDictionary *)titleAttributesDic{
    if (titleAttributesDic) {
        _titleAttributesDic = titleAttributesDic;
        [self.titleLabelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [(NSMutableAttributedString*)obj.attributedText setAttributes:titleAttributesDic range:NSMakeRange(0, obj.attributedText.length)];
            [obj setAttributedText:obj.attributedText];
        }];
    }
}

#pragma mark -- 按钮的响应事件
- (void)selectedBtnClicked:(UIButton *)sender{
    __unsafe_unretained AnimatateTabBar *weakSelf = self;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == sender) {
            [weakSelf selectedBtnWithObj:obj idx:idx];
        }
        else{
            [weakSelf unSelectedBtnWithObj:obj idx:idx];
        }
    }];
    
    //调起代理方法
    [_delegate selectedWithIndex:sender.tag-100];
}

#pragma mark -- 选中按钮的操作
- (void)selectedBtnWithObj:(UIButton *)obj idx:(NSInteger)idx{
    [obj setSelected:YES];
    if (self.selectedImagesArray && self.selectedImagesArray.count>idx) {
        [self.imageViewArray[idx] setImage:self.selectedImagesArray[idx]];
    }
    if (self.selectedTitlesArray && self.selectedTitlesArray.count>idx) {
        [self.titleLabelArray[idx] setText:self.selectedTitlesArray[idx]];
    }
    if (self.selectedTitleAttributesDic) {
        UILabel *label = self.titleLabelArray[idx];
        [(NSMutableAttributedString*)label.attributedText setAttributes:self.selectedTitleAttributesDic range:NSMakeRange(0, label.attributedText.length)];
        [label setAttributedText:label.attributedText];
    }
    //调起动画执行效果
    [self animatateWithImageView:self.imageViewArray[idx]];
}

#pragma mark -- 未选中按钮的操作
- (void)unSelectedBtnWithObj:(UIButton *)obj idx:(NSInteger)idx{
    [obj setSelected:NO];
    [self.imageViewArray[idx] setImage:self.imagesArray[idx]];
    [self.titleLabelArray[idx] setText:self.titlesArray[idx]];
    if (self.titleAttributesDic) {
        UILabel *label = self.titleLabelArray[idx];
        [(NSMutableAttributedString *)label.attributedText setAttributes:self.titleAttributesDic range:NSMakeRange(0, label.attributedText.length)];
        [label setAttributedText:label.attributedText];
    }
}

#pragma mark -- imageView动画
- (void)animatateWithImageView:(UIImageView *)imageView{
    [UIView animateWithDuration:0.12 animations:^{
        //缩小
        [imageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.12 animations:^{
            //放大
            [imageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2)];

        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.12 animations:^{
                //缩小
                [imageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.12 animations:^{
                    //放大
                    [imageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)];
                } completion:^(BOOL finished) {
                    //回到初始状态
                    [imageView setTransform:CGAffineTransformIdentity];
                }];
                
            }];
            
        }];
        
    }];
}

@end












