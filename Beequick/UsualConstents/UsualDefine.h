//
//  UsualDefine.h
//  Beequick
//
//  Created by 苹果电脑 on 16/9/14.
//  Copyright © 2016年 wyzc. All rights reserved.
//

#ifndef UsualDefine_h
#define UsualDefine_h

#define Sys_version  [UIDevice currentDevice].systemVersion

#define kTabbarHeight 49
#define kNavBarHeight 64

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define Color_RGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define PlaceholderImage @"v2_placeholder_square"

#define Line_Color Color_RGB(217, 217, 217, 1)

#define ProductNumInShoppingCart @"productNumInShoppingCart"  
#define LastProuctNumInStore @"lastProuctNumInStore"

#endif /* UsualDefine_h */
