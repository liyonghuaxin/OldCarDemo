//
//  QYCarModel.h
//  二手车
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYCarModel : NSObject
@property (nonatomic, strong) NSString *carName;//名称
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) NSString *cityName;//城市名
@property (nonatomic, strong) NSString *iconUrl;//图片的url
@property (nonatomic, strong) NSString *registerDate;//上牌时间
@property (nonatomic, strong) NSString *mileage;//里程
@property (nonatomic, strong) NSString *carID;
@property (nonatomic, strong) NSString *vpr;//推荐指数


- (instancetype)initWithDict:(NSDictionary *)dict;


- (NSMutableArray *)objectArrayWithKeyValuesArray:(NSArray *)array;



@end
