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
        _name = dict[@"name"];
        _price = dict[@"price"];
        _eval_price = dict[@"eval_price"];
        _model_price = dict[@"model_price"];
        _next_year_eval_price = dict[@"next_year_eval_price"];
        _gear_type = dict[@"gear_type"];
        _discharge_standard = dict[@"discharge_standard"];
        _register_date = dict[@"register_date"];
        _mile_age = dict[@"mile_age"];
        _liter = dict[@"liter"];
        _color = dict[@"color"];
        
        
    }
    return self;
}

+ (instancetype)carInfoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
