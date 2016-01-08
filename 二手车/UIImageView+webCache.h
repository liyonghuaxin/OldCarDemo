//
//  UIImageView+webCache.h
//  二手车
//
//  Created by qingyun on 16/1/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
@interface UIImageView (webCache)

- (void)loadImageFormNetWork:(NSString *)imageUrl;
@end
