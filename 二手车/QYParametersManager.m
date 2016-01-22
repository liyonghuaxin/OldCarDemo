//
//  QYParametersManager.m
//  二手车
//
//  Created by qingyun on 16/1/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYParametersManager.h"
#import "Header.h"

@implementation QYParametersManager

+ (instancetype)shaerdParameters {
    static QYParametersManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSMutableDictionary *)fristLoadParameters {
    // 加载保存的城市
    NSDictionary *cityModel = [[NSUserDefaults standardUserDefaults] objectForKey:kcityModel];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 判断程序是否是第一次加载
    if (cityModel) {
        // 城市
        [parameters setValue:cityModel[kCityId] forKey:kCityId];
        [parameters setValue:cityModel[kProvId] forKey:kProvId];
        [parameters setValue:cityModel[kCityName] forKey:kCityName];
        
        //保存的价格参数
        NSString *pricePara = [[NSUserDefaults standardUserDefaults] stringForKey:kPrice];
        if (pricePara) {
            [parameters setValue:pricePara forKey:kPrice];
        }
        // 品牌
        NSString *brandId = [[NSUserDefaults standardUserDefaults] stringForKey:kBrandId];
        if (brandId) {
            NSString *brandName = [[NSUserDefaults standardUserDefaults] stringForKey:kBrandName];
            [parameters setObject:brandName forKey:kBrandName];
            [parameters setObject:brandId forKey:kBrandId];
            
            NSString *seresId = [[NSUserDefaults standardUserDefaults] stringForKey:kSeriesId];
            if (seresId) {
                NSString *seresName = [[NSUserDefaults standardUserDefaults] stringForKey:kSeriesName];
                [parameters setObject:seresName forKey:kSeriesName];
                [parameters setObject:seresId forKey:kSeriesId];
                
            }
        }
        
    }else {
        // 默认的选择的区域 (北京)
        [parameters setValue:@"1" forKey:kCityId];
        [parameters setValue:@"1" forKey:kProvId];
        [parameters setValue:@"北京" forKey:kCityName];
    }
    return parameters;
}


@end
