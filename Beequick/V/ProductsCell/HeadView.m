//
//  HeadView.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/26.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "HeadView.h"

@interface HeadView()

@end

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

#pragma mark -- 配置视图
- (void)setUpView{
    [self setBackgroundColor:[UIColor whiteColor]];
    NSArray *titleArray = @[@"综合排序", @"按价格", @"按销量"];
    for (NSInteger i=0; i<3; i++) {
        UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*self.cur_w/3, 0, self.cur_w/3, self.cur_h-0.5)];
        [sortBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sortBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [sortBtn addTarget:self action:@selector(sortBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sortBtn];
        
        if (i == 1) {
            for (NSInteger j=0; j<2; j++) {
                UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((sortBtn.cur_w-39))/2+41, j*(4+2)+(sortBtn.cur_h-13)/2, 7, 4)];
                if (j == 0) {
                    [arrowImageView setImage:[UIImage imageNamed:@"control-up"]];
                }
                else{
                    [arrowImageView setImage:[UIImage imageNamed:@"control-down"]];
                }
                [sortBtn insertSubview:arrowImageView atIndex:j];
            }
        }
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.cur_h-0.5, self.cur_w-12, 0.5)];
    [lineView setBackgroundColor:Line_Color];
    [self addSubview:lineView];
}

#pragma mark -- 按钮的响应事件
- (void)sortBtnClicked:(UIButton *)senderBtn{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[UIButton class]]) {
            UIButton *btn = obj;
            if (senderBtn == obj) {
                [btn setTitleColor:Color_RGB(234, 163, 61, 1) forState:UIControlStateNormal];
                if ([btn.currentTitle isEqualToString:@"按价格"]) {
                    senderBtn.tag = !senderBtn.tag;
                    if (senderBtn.tag) {
                        [btn.subviews[0] setImage:[UIImage imageNamed:@"control-up-red"]];
                        [btn.subviews[1] setImage:[UIImage imageNamed:@"control-down"]];
                    }
                    else{
                        [btn.subviews[1] setImage:[UIImage imageNamed:@"control-down-red"]];
                         [btn.subviews[0] setImage:[UIImage imageNamed:@"control-up"]];
                    }
                }
                if ([_delegate respondsToSelector:@selector(sortByConditionWithBtn:)]) {
                    [_delegate sortByConditionWithBtn:senderBtn];
                }
            }
            else{
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if ([btn.currentTitle isEqualToString:@"按价格"]) {
                    [btn.subviews[0] setImage:[UIImage imageNamed:@"control-up"]];
                    [btn.subviews[1] setImage:[UIImage imageNamed:@"control-down"]];
                    btn.tag = 0;
                }
            }
        }
    }];
}

@end
