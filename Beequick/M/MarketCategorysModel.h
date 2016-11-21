//
//  MarketCategorysModel.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/25.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "JSONModel.h"

@protocol ChildCategoryModel;
@interface MarketCategorysModel : JSONModel


@property (nonatomic, strong) NSArray<ChildCategoryModel, Optional> *cids;

@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, assign) NSInteger pcid;

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString<Optional> *icon;

@property (nonatomic, assign) NSInteger is_open;

@property (nonatomic, copy) NSString<Optional> *flag;

@property (nonatomic, assign) NSInteger disabled_show;

@property (nonatomic, copy) NSString<Optional> *name;

@property (nonatomic, assign) NSInteger visibility;


@end
@interface ChildCategoryModel : JSONModel

@property (nonatomic, assign) NSInteger childId;

@property (nonatomic, copy) NSString<Optional> *name;

@property (nonatomic, assign) NSInteger sort;

@property(nonatomic, assign) NSNumber<Optional> *highlighted;

@property(nonatomic, assign) NSNumber<Optional> *pcid;

@end

