//
//  QYCarModel.m
//  二手车
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCarModel.h"

@implementation QYCarModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _carID = dict[@"id"];
        _carName = dict[@"model_name"];
        _price = dict[@"price"];
        _cityName = dict[@"city_name"];
        _mileage = dict[@"mile_age"];
        _registerDate = dict[@"register_date"];
        _iconUrl = dict[@"pic_url"];
        _vpr = dict[@"vpr"];
    }
    return self;
}



//字典转模型
- (NSMutableArray *)objectArrayWithKeyValuesArray:(NSArray *)array {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [dataArr addObject:[[QYCarModel alloc] initWithDict:dict]];
    }
    return dataArr;
}


@end
