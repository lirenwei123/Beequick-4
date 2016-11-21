//
//  UIView+Layout.m
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (CGFloat)cur_x{
    return self.frame.origin.x;
}

- (CGFloat)cur_y{
    return self.frame.origin.y;
}

- (CGFloat)cur_w{
    return self.frame.size.width;
}

- (CGFloat)cur_h{
    return self.frame.size.height;
}

- (CGFloat)cur_x_w{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)cur_y_h{
    return self.frame.origin.y + self.frame.size.height;
}

@end








