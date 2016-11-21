//
//  ReverceCategoryModel.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/28.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "JSONModel.h"
#import "ReverseActiveModel.h"
#import "CategoryDetailModel.h"

@interface ReverceCategoryModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *target_type;
@property(nonatomic,copy) NSString<Optional> *banner_unio;
@property(nonatomic,copy) NSString<Optional> *sort;
@property(nonatomic,copy) NSString<Optional> *banner_img;
@property (nonatomic,strong) MoreActivityModel<Optional> *more_activity;
@property (nonatomic,strong) GoodsModel<Optional> *goods;
@property (nonatomic,strong) CategoryDetailModel<Optional> *category_detail;

@end
