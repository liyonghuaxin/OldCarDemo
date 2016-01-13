//
//  QYCarInfoModel.h
//  二手车
//
//  Created by qingyun on 16/1/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYCarInfoModel : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *carId;

@property (nonatomic, strong) NSArray *picUrls;//图片数组
@property (nonatomic, strong) NSString *title;//名字
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) NSString *eval_price;//现车估价
@property (nonatomic, strong) NSString *model_price;//新车价格
@property (nonatomic, strong) NSString *next_year_eval_price;//下一年的估价
@property (nonatomic, strong) NSString *vpr;


@property (nonatomic, strong) NSString *gear_type;//汽车档位类型
@property (nonatomic, strong) NSString *register_date;//注册日期
@property (nonatomic, strong) NSString *mile_age;//公里
@property (nonatomic, strong) NSString *liter;//排量(升)
@property (nonatomic, strong) NSString *source_name;//来源
@property (nonatomic, strong) NSString *brand_name;

@property (nonatomic, strong) NSString *car_desc;//描述

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)carInfoWithDict:(NSDictionary *)dict;


@end
