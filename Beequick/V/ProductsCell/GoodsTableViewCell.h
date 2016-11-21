//
//  GoodsTableViewCell.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/26.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDetailModel.h"

@interface GoodsTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(ChannelType)type;

@property (nonatomic, strong) NSArray *goodsModelArray;
- (void)setGoodsDataWithGoodsModel:(GoodsModel *)goodsModel rowIndex:(NSInteger)rowIndex;

- (void)refreashViewWithGoodsModel:(GoodsModel *)goodsModel;

@end
