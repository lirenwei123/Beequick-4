//
//  IconTableViewCell.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/20.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ExistSperactorLine,
    UnExistSperactorLine
}IconCellType;

@interface IconTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(IconCellType)type;

@property (nonatomic, strong) NSArray *iconDataArray;

@end
