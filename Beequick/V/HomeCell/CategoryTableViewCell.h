//
//  CategoryTableViewCell.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/21.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReverceCategoryModel;
@class HomeActivityModel;
@class CategoryDetailModel;
@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic,strong) ReverceCategoryModel *reverceCategoryModel;

- (void)categoryDataWithActivityModel:(HomeActivityModel *)activityModel categoryModel:(CategoryDetailModel *)categoryModel;

@end
