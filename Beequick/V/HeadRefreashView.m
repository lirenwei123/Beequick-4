//
//  HeadRefreashView.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/23.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "HeadRefreashView.h"

@interface HeadRefreashView()
{
    UIImageView *_iconImageView;
    UILabel *_textLabel;
    NSMutableDictionary *_widthDic;
    BOOL _isRefreashing;
    NSString *_text;
}

@end

@implementation HeadRefreashView

- (void)dealloc{
    [[self superview] removeObserver:self forKeyPath:@"contentOffset"];
    [[self superview] removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        NSArray *textArray = @[@"下拉刷新", @"松开即可刷新", @"正在刷新"];
        _widthDic = [NSMutableDictionary dictionary];
        for (NSString *text in textArray) {
            CGFloat width = [self calculateWidthWithText:text];
            [_widthDic setValue:@(width) forKey:text];
        }
    }
    return self;
}

#pragma mark -- 配置子视图
- (void)setUpView{
    _iconImageView = [[UIImageView alloc] init];
    UIImage *leftImage = [UIImage imageNamed:@"pushlistview_down"];
    UIImage *rightImage = [UIImage imageNamed:@"pushlistview_up"];
    [_iconImageView setAnimationImages:@[leftImage, rightImage]];
    [_iconImageView setAnimationRepeatCount:0];
    [_iconImageView setAnimationDuration:0.5];
    [_iconImageView startAnimating];
    [self addSubview:_iconImageView];
    
    _textLabel = [[UILabel alloc] init];
    [_textLabel setFont:[UIFont systemFontOfSize:13]];
    [_textLabel setTextColor:Color_RGB(97, 97, 97, 1)];
    [_textLabel setText:@"下拉刷新"];
    [self addSubview:_textLabel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffSet = [object contentOffset];
        CGFloat contentOffSetY = contentOffSet.y;
        if (_isRefreashing && (contentOffSetY>-61)) {
            if (_startRefreashBlock) {
                _startRefreashBlock();
            }
            _text = @"正在刷新";
        }
        else{
            //下拉刷新
            if (contentOffSetY > (-self.cur_h)) {
                _text = @"下拉刷新";
            }
            else{
                if (_isRefreashing) {
                    _text = @"正在刷新";
                }
                else{
                    _text = @"松开即可刷新";
                }
            }
        }
        [_textLabel setText:_text];
        [self setSubViewFrameWithWidth:[_widthDic[_text] doubleValue]];
    }
    else if([keyPath isEqualToString:@"panGestureRecognizer.state"]){
        if ([change[@"new"] integerValue] == UIGestureRecognizerStateEnded) {
            if ([_text isEqualToString:@"松开即可刷新"]) {
                _isRefreashing = YES;
            }
        }
    }
}

#pragma mark -- 计算位置
- (CGFloat)calculateWidthWithText:(NSString *)currentText{
    CGRect textRect = [currentText boundingRectWithSize:CGSizeMake(MAXFLOAT, 17) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    return textRect.size.width;
}

- (void)setSubViewFrameWithWidth:(CGFloat)width{
    [_textLabel setFrame:CGRectMake((self.cur_w-width-60)/2+60, (self.cur_h-17)/2, width, 17)];
    [_iconImageView setFrame:CGRectMake(_textLabel.cur_x-60, (self.cur_h-50)/2, 50, 50)];
}

- (void)finishRefreash{
    _isRefreashing = NO;
}

@end






