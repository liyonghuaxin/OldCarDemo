//
//  QYServiceModel.h
//  二手车
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYServiceModel : NSObject

@property (nonatomic, strong) NSString *series;// 车系id
@property (nonatomic, strong) NSString *seriesName;// 车系名称

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
