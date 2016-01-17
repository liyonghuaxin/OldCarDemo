//
//  QYServiceModel.m
//  二手车
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYServiceModel.h"

@implementation QYServiceModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _series = dict[@"id"];
        _seriesName = dict[@"name"];
    }
    return self;
}

@end
