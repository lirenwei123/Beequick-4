//
//  UIView+DropToShopCartAnimation.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/22.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "UIView+DropToShopCartAnimation.h"
#import <objc/runtime.h>

@implementation UIView (DropToShopCartAnimation)

- (void)setTextLayerArray:(NSMutableArray *)textLayerArray{
    objc_setAssociatedObject(self, @"textLayerArray", textLayerArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)textLayerArray{
    return objc_getAssociatedObject(self, @"textLayerArray");
}

- (void)dropToShopCartWithSubView:(UIView *)subView contentText:(NSString *)contentText dropPoint:(CGPoint)dropPoint{
    if (!self.textLayerArray) {
        self.textLayerArray = [NSMutableArray array];
    }
    CALayer *textLayer = [[CALayer alloc] init];
    CGRect frame = [self convertRect:self.bounds toView:subView];
    textLayer.frame = frame;
    //设置layer上的内容（该属性只能是图片）
    textLayer.contents = self.layer.contents;
    [subView.layer addSublayer:textLayer];
    [self.textLayerArray addObject:textLayer];
    
    CAKeyframeAnimation *positionAnination = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint textLayerPoint = textLayer.position;
    CGPathMoveToPoint(path, nil, textLayerPoint.x, textLayerPoint.y);
    //绘制掉落抛物线
    CGPathAddCurveToPoint(path, nil, textLayerPoint.x, textLayerPoint.y, textLayerPoint.x, textLayerPoint.y, dropPoint.x, dropPoint.y);
    positionAnination.path = path;
    
    //设置透明动画
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation setFromValue:@1];
    [opacityAnimation setToValue:@(0.8)];
    
    //设置缩放动画
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [transformAnimation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [transformAnimation setToValue:[NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1)]];
    
    //设置动画组
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:@[positionAnination, opacityAnimation, transformAnimation]];
    [animationGroup setDuration:0.8];
    [animationGroup setDelegate:self];
    [animationGroup setRemovedOnCompletion:NO];
    [animationGroup setFillMode:kCAFillModeForwards];
    [textLayer addAnimation:animationGroup forKey:@"AddProductAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CATextLayer *layer = [self.textLayerArray firstObject];
    [[layer superlayer] removeAnimationForKey:@"AddProductAnimation"];
    [layer removeFromSuperlayer];
    [self.textLayerArray removeObjectAtIndex:0];
}

@end
