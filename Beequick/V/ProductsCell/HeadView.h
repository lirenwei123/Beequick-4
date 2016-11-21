//
//  HeadView.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/26.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadViewDelegate;
@interface HeadView : UIView

@property(nonatomic,weak) id<HeadViewDelegate> delegate;
- (void)sortBtnClicked:(UIButton *)senderBtn;
@end

@protocol HeadViewDelegate <NSObject>

@optional
- (void)sortByConditionWithBtn:(UIButton *)senderBtn;

@end