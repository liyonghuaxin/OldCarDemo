//
//  QYBrandModel.h
//  二手车
//
//  Created by qingyun on 16/1/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYBrandModel : NSObject

@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *brandName;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)brandWithDict:(NSDictionary *)dict;

@end
