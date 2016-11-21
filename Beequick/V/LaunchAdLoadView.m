//
//  LaunchAdLoadView.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "LaunchAdLoadView.h"

@implementation LaunchAdLoadView

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    //不能直接调用drawRect，通过drawRect画图时，要获取图形上下文，直接调用，无法获取上下文，要通过调用setNeedsDisplay方法，自动调起drawRect
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //画圆形
    UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(4, 4, rect.size.width-4*2, rect.size.height-4*2) cornerRadius:(rect.size.width-4*2)/2];
    //上色
    [[[UIColor whiteColor] colorWithAlphaComponent:0.7] setFill];
    
    //填充
    [circle fill];
    
    //画圆弧
    //WithArcCenter:圆弧的中心点
    //radius:半径
    //startAngle:起始角度(0是从水平方向开始)
    //endAngle：结束角度
    CGFloat endAngle = M_PI*2*_progress;
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:(rect.size.width-2)/2 startAngle:0 endAngle:endAngle clockwise:YES];
    //沿边上色
    [[[UIColor whiteColor] colorWithAlphaComponent:0.7] setStroke];
    //设置宽度
    [arcPath setLineWidth:2];
    //上色
    [arcPath stroke];
}

@end





