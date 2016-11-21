//
//  ReverseActiveModel.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/28.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "JSONModel.h"
#import "CategoryDetailModel.h"

@class MoreActivityModel,ExtParamsModel,ActivDetailModel;
@protocol GoodsModel;
@interface ReverseActiveModel : JSONModel


@property (nonatomic, strong) ActivDetailModel<Optional> *activ_detail;

@property (nonatomic, strong) MoreActivityModel<Optional> *more_activity;

@property (nonatomic, copy) NSString<Optional> *target_type;

@property (nonatomic, copy) NSString<Optional> *sort;

@property (nonatomic, copy) NSString<Optional> *banner_img;


@end
@interface MoreActivityModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *topimg;

@property (nonatomic, copy) NSString<Optional> *img;

@property (nonatomic, copy) NSString<Optional> *jptype;

@property (nonatomic, copy) NSString<Optional> *moreActivityId;

@property (nonatomic, copy) NSString<Optional> *sort;

@property (nonatomic, strong) ExtParamsModel<Optional> *ext_params;

@property (nonatomic, copy) NSString<Optional> *hide_cart;

@property (nonatomic, copy) NSString<Optional> *trackid;

@property (nonatomic, copy) NSString<Optional> *show_reload;

@property (nonatomic, copy) NSString<Optional> *name;

@end

@interface ExtParamsModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *activitygroup;

@property (nonatomic, copy) NSString<Optional> *trackid;

@property (nonatomic, copy) NSString<Optional> *bigids;

@property (nonatomic, copy) NSString<Optional> *cityid;

@end

@interface ActivDetailModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *more_name;

@property (nonatomic, copy) NSString<Optional> *activity_img_v34;

@property (nonatomic, copy) NSString<Optional> *more_img;

@property (nonatomic, copy) NSString<Optional> *target_type;

@property (nonatomic, strong) NSArray<GoodsModel, Optional> *goods;

@property (nonatomic, copy) NSString<Optional> *display_number;

@property (nonatomic, copy) NSString<Optional> *name;

@end


