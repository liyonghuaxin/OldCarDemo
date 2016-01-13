//
//  QYBrandModel.m
//  二手车
//
//  Created by qingyun on 16/1/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYBrandModel.h"

@implementation QYBrandModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _brandId = dict[@"id"];
        _brandName = dict[@"name"];
    }
    return self;
}

+ (instancetype)brandWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
