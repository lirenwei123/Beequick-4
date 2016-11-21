//
//  ScanQRViewController.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/23.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "ScanQRViewController.h"
#import <AVFoundation/AVFoundation.h>

/*
 AVCaptureSession:管理输入流(AVCaptureInput)和输出流(AVCaptureOutput),包含启动停止会话操作
 AVCaptureDeviceInput:是AVCaptureInput的子类，作为输入流捕获会话
 AVCaptureMetadataOutput:AVCaptureOutput的子类。处理输出捕获会话
 AVCaptureDevice:代表物理设备
 */


@interface ScanQRViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_layer;
    UIImageView *_lineView;
}

@end

@implementation ScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"店铺二维码"];
    
    [self startScanQR];
    
    [self setUpView];
}

#pragma mark -- 配置视图
- (void)setUpView{
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"v2_goback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backPrevious)];
    [self.navigationItem setLeftBarButtonItem:backBarItem];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake((self.view.cur_w-300)/2, (self.view.cur_h-300)/2-kNavBarHeight, 300, 300)];
    [centerView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [centerView.layer setBorderWidth:1];
    [_layer addSublayer:centerView.layer];
    
    _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, centerView.cur_w-10, 30)];
    [_lineView setImage:[UIImage imageNamed:@"yellowlight"]];
    [centerView addSubview:_lineView];
    
    
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        [_lineView setFrame:CGRectMake(_lineView.cur_x, centerView.cur_h-15, _lineView.cur_w, _lineView.cur_h)];
    } completion:^(BOOL finished) {
        [_lineView setFrame:CGRectMake(5, 15, centerView.cur_w-10, 30)];
    }];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.cur_w, (self.view.cur_h-300)/2-kNavBarHeight)];
    [topView setBackgroundColor:[UIColor grayColor]];
    [topView setAlpha:0.6];
    [_layer addSublayer:topView.layer];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, centerView.cur_y_h, self.view.cur_w, (self.view.cur_h-300)/2)];
    [bottomView setBackgroundColor:[UIColor grayColor]];
    [bottomView setAlpha:0.6];
    [_layer addSublayer:bottomView.layer];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.cur_y_h, (self.view.cur_w-300)/2, centerView.cur_h)];
    [leftView setBackgroundColor:[UIColor grayColor]];
    [leftView setAlpha:0.6];
    [_layer addSublayer:leftView.layer];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(centerView.cur_x_w, centerView.cur_y, leftView.cur_w, leftView.cur_h)];
    [rightView setBackgroundColor:[UIColor grayColor]];
    [rightView setAlpha:0.6];
    [_layer addSublayer:rightView.layer];
}

- (void)startScanQR{
    //通过媒体类型创建设备
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建设备输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    //创建会话
    _session = [[AVCaptureSession alloc] init];
    //添加输入流
    [_session addInput:input];
    //创建输出流
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
    //限定扫描区域:设置比例x\y、w\h都相反设置比例
    [outPut setRectOfInterest:CGRectMake((self.view.cur_h-300)/2/self.view.cur_h, (self.view.cur_w-300)/2/self.view.cur_w, 300/self.view.cur_h, 300/self.view.cur_w)];
    //添加输出流
    [_session addOutput:outPut];
    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
    [outPut setMetadataObjectsDelegate:self queue:queue];
    [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _layer = layer;
    [layer setVideoGravity:AVLayerVideoGravityResize];
    [layer setFrame:CGRectMake(0, kNavBarHeight, self.view.cur_w, self.view.cur_h-kNavBarHeight)];
    [self.view.layer addSublayer:layer];
    //开始会话
    [_session startRunning];
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //停止会话
        [_session stopRunning];
        [_lineView removeFromSuperview];
        [_layer removeAllAnimations];
        //获取扫描结果
        AVMetadataMachineReadableCodeObject *medataObject = [metadataObjects lastObject];
        //获取二维码内容
        NSString *stringValue = [medataObject stringValue];
        NSLog(@"stringValue:%@", stringValue);
    }
}

#pragma mark -- 返回item的响应事件
- (void)backPrevious{
    [self.navigationController popViewControllerAnimated:YES];;
}

@end
