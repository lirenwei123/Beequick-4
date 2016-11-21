//
//  HomeActivityModel.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/20.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "JSONModel.h"

@class ParamsModel;
@interface HomeActivityModel : JSONModel


@property (nonatomic, copy) NSString<Optional> *topimg;

@property (nonatomic, copy) NSString<Optional> *img;

@property (nonatomic, copy) NSString<Optional> *jptype;

@property (nonatomic, copy) NSString<Optional> *activity_id;

@property (nonatomic, copy) NSString<Optional> *sort;

@property (nonatomic, strong) ParamsModel<Optional> *ext_params;

@property (nonatomic, copy) NSString<Optional> *hide_cart;

@property (nonatomic, copy) NSString<Optional> *trackid;

@property (nonatomic, copy) NSString<Optional> *show_reload;

@property (nonatomic, copy) NSString<Optional> *name;


@end

@interface ParamsModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *activitygroup;

@property (nonatomic, copy) NSString<Optional> *trackid;

@property (nonatomic, copy) NSString<Optional> *bigids;

@property (nonatomic, copy) NSString<Optional> *cityid;

@end

