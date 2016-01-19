//
//  QYCityModel.m
//  二手车
//
//  Created by qingyun on 16/1/10.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCityModel.h"

@implementation QYCityModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {

        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)cityModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
