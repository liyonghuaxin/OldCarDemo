//
//  QYCarInfoModel.m
//  二手车
//
//  Created by qingyun on 16/1/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCarInfoModel.h"

@implementation QYCarInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _picUrls = dict[@"picUrls"];
        _title = dict[@"title"];
        _price = dict[@"price"];
        _eval_price = dict[@"eval_price"];
        _model_price = dict[@"model_price"];
        _next_year_eval_price = dict[@"next_year_eval_price"];
        _gear_type = dict[@"gear_type"];
        _register_date = dict[@"register_date"];
        _mile_age = dict[@"mile_age"];
        _liter = dict[@"liter"];
        _vpr = dict[@"vpr"];
        _car_desc = dict[@"car_desc"];
        _source_name = dict[@"source_name"];
        _brand_name = dict[@"brand_name"];
        _city = dict[@"city"];
        _carId = dict[@"id"];
    }
    return self;
}

+ (instancetype)carInfoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
