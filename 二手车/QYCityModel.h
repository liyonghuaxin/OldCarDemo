//
//  QYCityModel.h
//  二手车
//
//  Created by qingyun on 16/1/10.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYCityModel : NSObject

@property (nonatomic, strong) NSString *initial;
@property (nonatomic, strong) NSString *prov_name;//省份名
@property (nonatomic, strong) NSString *city_name;//城市名
@property (nonatomic, strong) NSString *city_id;//城市id
@property (nonatomic, strong) NSString *prov_id;//省份id

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cityModelWithDict:(NSDictionary *)dict;

@end
