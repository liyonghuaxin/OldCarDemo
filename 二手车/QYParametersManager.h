//
//  QYParametersManager.h
//  二手车
//
//  Created by qingyun on 16/1/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYParametersManager : NSObject

+ (instancetype)shaerdParameters;

// 第一次加载页面
- (NSMutableDictionary *)fristLoadParameters;


@end
