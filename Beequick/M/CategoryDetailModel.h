//
//  CategoryDetailModel.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/21.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "JSONModel.h"

@protocol GoodsModel;
@interface CategoryDetailModel : JSONModel

@property (nonatomic, strong) NSArray<GoodsModel, Optional> *goods;

@property (nonatomic, copy) NSString<Optional> *category_color;

@property (nonatomic, copy) NSString<Optional> *style;

@property (nonatomic, copy) NSString<Optional> *name;

@property (nonatomic, copy) NSString<Optional> *target_type;

@property (nonatomic, copy) NSString<Optional> *category_id;


@end
@interface GoodsModel : JSONModel

@property (nonatomic, strong) NSNumber<Optional> * partner_price;

@property (nonatomic, strong) NSNumber<Optional> *goods_id;

@property (nonatomic, copy) NSString<Optional> *safe_unit_desc;

@property (nonatomic, strong) NSNumber<Optional> *source_id;

@property (nonatomic, copy) NSString<Optional> *attribute;

@property (nonatomic, copy) NSString<Optional> *pre_img;

@property (nonatomic, copy) NSString<Optional> *long_name;

@property (nonatomic, strong) NSNumber<Optional> *is_xf;

@property (nonatomic, strong) NSNumber<Optional> *brand_id;

@property (nonatomic, copy) NSString<Optional> *sort;

@property (nonatomic, copy) NSString<Optional> *number;

@property (nonatomic, copy) NSString<Optional> *dealer_id;

@property (nonatomic, copy) NSString<Optional> *pm_info;

@property (nonatomic, strong) NSNumber<Optional> * pre_state;

@property (nonatomic, copy) NSString<Optional> *pre_imgs;

@property (nonatomic, copy) NSString<Optional> *brand_name;

@property (nonatomic, strong) NSNumber<Optional> *cart_group_id;

@property (nonatomic, strong) NSNumber<Optional> *goods_type;

@property (nonatomic, strong) NSNumber<Optional> *child_cid;

@property (nonatomic, copy) NSString<Optional> *name;

@property (nonatomic, strong) NSNumber<Optional> *top_sort;

@property (nonatomic, strong) NSNumber<Optional> *safe_day;

@property (nonatomic, strong) NSNumber<Optional> *ismix;

@property (nonatomic, strong) NSNumber<Optional> *pcid;

@property (nonatomic, strong) NSNumber<Optional> *store_nums;

@property (nonatomic, copy) NSString<Optional> *tag_ids;

@property (nonatomic, strong) NSDictionary<Optional> *cids;

@property (nonatomic, strong) NSNumber<Optional> *product_num;

@property (nonatomic, copy) NSString<Optional> *product_id;

@property (nonatomic, strong) NSNumber<Optional> *cid;

@property (nonatomic, strong) NSNumber<Optional> *price;

@property (nonatomic, copy) NSString<Optional> *d_price;

@property (nonatomic, strong) NSNumber<Optional> *market_price;

@property (nonatomic, strong) NSNumber<Optional> * org_source_value;

@property (nonatomic, strong) NSNumber<Optional> * had_pm;

@property (nonatomic, strong) NSDictionary<Optional> *p_cids;

@property (nonatomic, copy) NSString<Optional> *pm_desc;

@property (nonatomic, strong) NSNumber<Optional> * hot_degree;

@property (nonatomic, copy) NSString<Optional> *img;

@property (nonatomic, copy) NSString<Optional> *keywords;

@property (nonatomic, copy) NSString<Optional> *specifics;

@property (nonatomic, strong) NSNumber<Optional> * category_id;

@property (nonatomic, strong) NSNumber<Optional> * c_layer;

@property (nonatomic, strong) NSNumber<Optional> * safe_unit;

@property (nonatomic, strong) NSArray<Optional> *pm_tags;

@end


