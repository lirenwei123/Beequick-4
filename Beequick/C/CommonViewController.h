//
//  CommonViewController.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/19.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonViewController : UIViewController
{
    UIButton *_scanQRBtn;
    UIButton *_selectAddressBtn;
    UIButton *_searchBtn;
    UILabel *_addressLabel;
    UIImageView *_searchImageView;
    UIImageView *_scanQRImageView;
    UIImageView *_arrowImageView;
}

- (void)clearNavigationItem;
- (void)unclearNavigationItem;
- (void)locationFailureResponse:(NSNotification *)noti;
- (void)reverseGeoSuccessNotification:(NSNotification *)noti;

@end
