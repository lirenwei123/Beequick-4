//
//  CommonViewController.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/19.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "CommonViewController.h"
#import "ScanQRViewController.h"

@interface CommonViewController ()
{
    UIView *_scanQRView;
    UIView *_selectAddressView;
    UIView *_searchView;
    UIBarButtonItem *_rightBarItem;
}

@end

@implementation CommonViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册定位失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFailureResponse:) name:TellCommonLocationFailureNotification object:nil];
    //注册反地理编码成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reverseGeoSuccessNotification:) name:TellCommonReverseSuccessNotification object:nil];
    //注册反地理编码失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reverseGeoFailureNotification:) name:TellCommonReverseFailureNotification object:nil];
    
    [self setUpNavgationItem];
}

#pragma mark -- 设置导航栏样式
- (void)setUpNavgationItem{
    
    _scanQRView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _scanQRBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_scanQRBtn addTarget:self action:@selector(scanQRBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_scanQRBtn setBackgroundColor:[UIColor grayColor]];
    [_scanQRBtn setAlpha:0.9];
    [_scanQRBtn.layer setCornerRadius:16];
    [_scanQRView addSubview:_scanQRBtn];
    UIImageView *scanQRImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_scanQRBtn.cur_w-20)/2, (_scanQRBtn.cur_h-20)/2, 20, 20)];
    _scanQRImageView = scanQRImageView;
    [scanQRImageView setImage:[UIImage imageNamed:@"icon_black_scancode"]];
    [_scanQRView addSubview:scanQRImageView];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:_scanQRView];
    [self.navigationItem setLeftBarButtonItem:leftBarItem];
    
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_searchBtn.layer setCornerRadius:16];
    [_searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_searchView addSubview:_searchBtn];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_searchBtn.cur_w-20)/2, (_searchBtn.cur_h-20)/2, 20, 20)];
    _searchImageView = searchImageView;
    [searchImageView setImage:[UIImage imageNamed:@"icon_search"]];
    [_searchView addSubview:searchImageView];
    _rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_searchView];
    [self.navigationItem setRightBarButtonItem:_rightBarItem];
    
    _selectAddressView = [[UIView alloc] init];
    _selectAddressBtn = [[UIButton alloc] init];
    [_selectAddressBtn addTarget:self action:@selector(selectAddressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_selectAddressView addSubview:_selectAddressBtn];
    _addressLabel = [[UILabel alloc] init];
    [_addressLabel setTextColor:[UIColor blackColor]];
    [_addressLabel setTextAlignment:NSTextAlignmentCenter];
    [_addressLabel setFont:[UIFont systemFontOfSize:15]];
    [_selectAddressView addSubview:_addressLabel];
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    _arrowImageView = arrowImageView;
    [arrowImageView setImage:[UIImage imageNamed:@"control-down"]];
    [_selectAddressView addSubview:arrowImageView];
    [self.navigationItem setTitleView:_selectAddressView];
    
    
    [_scanQRBtn setBackgroundColor:[UIColor grayColor]];
    [_searchBtn setBackgroundColor:[UIColor grayColor]];
    [_selectAddressBtn setBackgroundColor:[UIColor grayColor]];
    [_scanQRBtn setAlpha:0];
    [_searchBtn setAlpha:0];
    [_selectAddressBtn setAlpha:0];

}

- (void)clearNavigationItem{
    [_scanQRView.subviews[1] setImage:[UIImage imageNamed:@"icon_white_scancode"]];
    [_searchView.subviews[1] setImage:[UIImage imageNamed:@"icon_search_white"]];
    //[_selectAddressBtn.subviews[1] setImage:];
    [_addressLabel setTextColor:[UIColor whiteColor]];
    [_scanQRBtn setAlpha:0.8];
    [_searchBtn setAlpha:0.8];
    [_selectAddressBtn setAlpha:0.8];
}

- (void)unclearNavigationItem{
    [_scanQRView.subviews[1] setImage:[UIImage imageNamed:@"icon_black_scancode"]];
    [_searchView.subviews[1] setImage:[UIImage imageNamed:@"icon_search"]];
        //[_selectAddressBtn.subviews[1] setImage:];
    [_addressLabel setTextColor:[UIColor blackColor]];
    [_scanQRBtn setAlpha:0];
    [_searchBtn setAlpha:0];
    [_selectAddressBtn setAlpha:0];
}

#pragma mark -- 定位失败通知的回调
- (void)locationFailureResponse:(NSNotification *)noti{
    [self.navigationItem setRightBarButtonItem:nil];
    [_addressLabel setFont:[UIFont systemFontOfSize:15]];
    NSString *text = @"定位失败";
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text];
    [self showAddressWithText:text attributeText:attributeText fontSize:15];
}

#pragma mark -- 反地理编码成功通知的回调
- (void)reverseGeoSuccessNotification:(NSNotification *)noti{
    [_addressLabel setFont:[UIFont systemFontOfSize:13]];
    [self.navigationItem setRightBarButtonItem:_rightBarItem];
    NSString *text = [NSString stringWithFormat:@"配送至：%@", noti.userInfo[@"address"]];
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 4)];
    [self showAddressWithText:text attributeText:attributeText fontSize:13];
}

#pragma mark -- 反地理编码失败通知的回调
- (void)reverseGeoFailureNotification:(NSNotification *)noti{
    [_addressLabel setFont:[UIFont systemFontOfSize:15]];
    [self.navigationItem setRightBarButtonItem:nil];
    NSString *text = @"解析失败";
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:text];
    [self showAddressWithText:text attributeText:attributeText fontSize:15];
}

#pragma mark -- 展示定位编码信息
- (void)showAddressWithText:(NSString *)text attributeText:(NSMutableAttributedString *)attributeText fontSize:(CGFloat)fontSize{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    [_addressLabel setFrame:CGRectMake(10, 0, rect.size.width, 30)];
    UIImageView *arrowView = _selectAddressView.subviews[2];
    [arrowView setFrame:CGRectMake(_addressLabel.cur_x_w+2, (30-4)/2, 7, 4)];
    [_selectAddressView setFrame:CGRectMake(0, 0, _addressLabel.cur_w+arrowView.cur_w+22, 30)];
    [_selectAddressBtn setFrame:CGRectMake(0, 0, _addressLabel.cur_w+arrowView.cur_w+22, 30)];
    [_selectAddressBtn.layer setCornerRadius:16];
    [_addressLabel setAttributedText:attributeText];
}

#pragma mark -- 扫描二维码按钮的响应事件
- (void)scanQRBtnClicked{
    ScanQRViewController *scanQRVC = [[ScanQRViewController alloc] init];
    [self.navigationController pushViewController:scanQRVC animated:YES];
}

#pragma mark -- 搜索按钮的响应事件
- (void)searchBtnClicked{

}

#pragma mark -- 选择地址按钮的响应事件
- (void)selectAddressBtnClicked{

}

@end







