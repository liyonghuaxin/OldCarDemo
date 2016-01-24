//
//  QYFMDBManger.m
//  二手车
//
//  Created by qingyun on 16/1/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYDBFileManager.h"
#import <FMDB.h>
#import "Header.h"
#import <AFHTTPSessionManager.h>
#import "QYCarModel.h"
#import "QYNewsModel.h"
#import "QYBrandModel.h"
#import "QYServiceModel.h"

@interface QYDBFileManager ()

@property (nonatomic, strong) FMDatabase *dataBase;
@property (nonatomic, strong) UIImage *image;
@end

@implementation QYDBFileManager

+ (instancetype)sharedDBManager {
    static QYDBFileManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
        [manager createTableWithStar];
        [manager createTableWithWatch];
        [manager createTableWithCarlist];
        [manager createTableWithGuide];
        
        [manager createTableWithSearchWithSeries];
        [manager createTableWithSearchWithBrands];
    });
    return manager;
}

- (FMDatabase *)dataBase {
    if (_dataBase == nil) {
        NSString *libaryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [libaryPath stringByAppendingPathComponent:DBNAME];
        _dataBase = [FMDatabase databaseWithPath:dbPath];
    }
    return _dataBase;
}

#pragma mark - 创建表
// 收藏表
- (BOOL)createTableWithStar {
    if (![self.dataBase open]) {
        NSLog(@"create-- open table error!!%@",[_dataBase lastErrorMessage]);
        return NO;
    }

    if (![_dataBase executeUpdate:@"create table if not exists starTable (id text primary key not null, model_name text not null, price text not null, city_name text not null, mile_age text not null, register_date text not null, vpr text not null, pic_url text not null)"]) {
        [_dataBase close];
        return NO;
    }
 
    [_dataBase close];
    return YES;
}

// 浏览历史记录表
- (BOOL)createTableWithWatch {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if (![_dataBase executeUpdate:@"create table if not exists watchTable (id text primary key not null, model_name text not null, price text not null, city_name text not null, mile_age text not null, register_date text not null, vpr text not null, pic_url text not null)"]) {
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

// 首页存储的列表
- (BOOL)createTableWithCarlist {
    if (![self.dataBase open]) {
        NSLog(@"create-- open table error!!%@",[_dataBase lastErrorMessage]);
        return NO;
    }
    
    if (![_dataBase executeUpdate:@"create table if not exists carTable (id text primary key not null, model_name text not null, price text not null, city_name text not null, mile_age text not null, register_date text not null, vpr text not null, pic_url text not null)"]) {
        [_dataBase close];
        return NO;
    }
  
    [_dataBase close];
    return YES;
}

#pragma mark - 存储到数据库

- (BOOL)saveData2Local:(QYCarModel *)model class:(NSString *)name {
    if (![self.dataBase open]) {
        NSLog(@"insert-- open table error!!%@",[_dataBase lastErrorMessage]);
        return NO;
    }
    
    if ([name isEqualToString:kWatchTable]) {
        // 浏览
        if (![_dataBase executeUpdate:@"insert into watchTable values (?,?,?,?,?,?,?,?)", model.carID, model.carName, model.price, model.cityName, model.mileage, model.registerDate, model.vpr, model.iconUrl]) {
            [_dataBase close];
            return NO;
        }
    }else if ([name isEqualToString:kStarTable]) {
        // 收藏
        if (![_dataBase executeUpdate:@"insert into starTable values (?,?,?,?,?,?,?,?)", model.carID, model.carName, model.price, model.cityName, model.mileage, model.registerDate, model.vpr, model.iconUrl]) {
            [_dataBase close];
            return NO;
        }
    }else if ([name isEqualToString:kCarTable]) {
        // 首页列表
        if (![_dataBase executeUpdate:@"insert into carTable values (?,?,?,?,?,?,?,?)", model.carID, model.carName, model.price, model.cityName, model.mileage, model.registerDate, model.vpr, model.iconUrl]) {
            [_dataBase close];
            return NO;
        }
    }

    [_dataBase close];
    return YES;
}



#pragma mark - 查询数据
// 查询所有
- (NSMutableArray *)selectAllData:(NSString *)tableName {
    if (![self.dataBase open]) {
        return nil;
    }
    
    FMResultSet *set;
    
    if ([tableName isEqualToString:kWatchTable]) {
        // 浏览历史
        set = [_dataBase executeQuery:@"select *from watchTable"];
    }else if ([tableName isEqualToString:kStarTable]) {
        // 收藏
        set = [_dataBase executeQuery:@"select *from starTable"];
    }else if ([tableName isEqualToString:kCarTable]) {
        // 首页列表
        set = [_dataBase executeQuery:@"select *from carTable"];
    }

    NSMutableArray *tempArr = [NSMutableArray array];
    while ([set next]) {
        QYCarModel *model = [[QYCarModel alloc] initWithDict:[set resultDictionary]];
        [tempArr addObject:model];
    }
    [_dataBase close];
    return tempArr;
}

// 查询单条记录
- (QYCarModel *)selectDataFromCarId:(NSString *)carId tableName:(NSString *)name {
    if (![self.dataBase open]) {
        return nil;
    }
    
    FMResultSet *set;
    if ([name isEqualToString:kWatchTable]) {
        // 浏览历史
        set = [_dataBase executeQueryWithFormat:@"select *from watchTable where id = %@", carId];
    }else if ([name isEqualToString:kStarTable]) {
        // 收藏
        set = [_dataBase executeQueryWithFormat:@"select *from starTable where id = %@", carId];
    }else if ([name isEqualToString:kCarTable]) {
        // 首页列表
        set = [_dataBase executeQueryWithFormat:@"select *from carTable where id = %@", carId];
    }
    
    QYCarModel *carModel;
    while ([set next]) {
        QYCarModel *model = [[QYCarModel alloc] initWithDict:[set resultDictionary]];
        carModel = model;
    }
    
    [_dataBase close];
    return carModel;
}

#pragma mark - 删除
// 删除所有
- (BOOL)deleteLocalAllData:(NSString *)tableName {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if ([tableName isEqualToString:kWatchTable]) {
        // 浏览
        if (![_dataBase executeUpdate:@"delete from watchTable"]) {
            [_dataBase close];
            return NO;
        }
    }else if ([tableName isEqualToString:kStarTable]) {
        // 收藏
        if (![_dataBase executeUpdate:@"delete from starTable"]) {
            [_dataBase close];
            return NO;
        }
    }else if ([tableName isEqualToString:kCarTable]) {
        // 首页列表
        if (![_dataBase executeUpdate:@"delete from carTable"]) {
            [_dataBase close];
            return NO;
        }
    }
    
    [_dataBase close];
    return YES;
}

// 根据id删除
- (BOOL)deleteLocalFromCarId:(NSString *)carId tableName:(NSString *)tableName {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if ([tableName isEqualToString:kWatchTable]) {
        // 浏览表
        if (![_dataBase executeUpdate:@"delete from watchTable where id = ?", carId]) {
            [_dataBase close];
            return NO;
        }
    }else if ([tableName isEqualToString:kStarTable]) {
        // 收藏表
        if (![_dataBase executeUpdate:@"delete from starTable where id = ?", carId]) {
            [_dataBase close];
            return NO;
        }
    }
    
    [_dataBase close];
    return YES;
}

#pragma mark - 最近搜索的品牌和车系

/**
 *  解释一下 为什么不用一个表存这两个数据
 *  因为在请求参数时参数的键对应不一样
 *  必须要判断 不然会发生错误
 */

// 最近查询的品牌
- (BOOL)createTableWithSearchWithBrands {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if (![_dataBase executeUpdate:@"create table if not exists searchBrand (id text primary key not null,name text not null)"]) {
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

// 最近查询的车系
- (BOOL)createTableWithSearchWithSeries {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if (![_dataBase executeUpdate:@"create table if not exists searchSeries (id text primary key not null,name text not null)"]) {
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

// 存储
- (BOOL)saveSearchDataWithbrandTable:(QYBrandModel *)brandModel {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if (![_dataBase executeUpdate:@"insert into searchBrand values (?,?)", brandModel.brandId, brandModel.brandName]) {
        NSLog(@"%@", [_dataBase lastErrorMessage]);
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

- (BOOL)saveSearchDataWithSeriesTable:(QYServiceModel *)seriesModel {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if (![_dataBase executeUpdate:@"insert into searchSeries values (?,?)", seriesModel.series, seriesModel.seriesName]) {
        NSLog(@"%@", [_dataBase lastErrorMessage]);
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

// 查询
- (NSMutableArray *)selectAllSearchData:(NSString *)tableName {
    if (![self.dataBase open]) {
        return nil;
    }
    
    FMResultSet *set;
    NSMutableArray *tempArr = [NSMutableArray array];
    
    if ([tableName isEqualToString:kSearchBrandTable]) {
        set = [_dataBase executeQuery:@"select *from searchBrand"];
        while ([set next]) {
            QYBrandModel *model = [[QYBrandModel alloc] initWithDict:[set resultDictionary]];
            [tempArr addObject:model];
        }
    }else if ([tableName isEqualToString:ksearchSeriesTbale]) {
        set = [_dataBase executeQuery:@"select *from searchSeries"];
        while ([set next]) {
            QYServiceModel *model = [[QYServiceModel alloc] initWithDict:[set resultDictionary]];
            [tempArr addObject:model];
        }
    }
    
    [_dataBase close];
    return tempArr;
}

// 删除
- (BOOL)deleteLocalAllSearchData {
    if (![self.dataBase open]) {
        return NO;
    }
    
    // 删除品牌
    if (![_dataBase executeUpdate:@"delete from searchBrand"]) {
        [_dataBase close];
        return NO;
    }
    
    // 删除车系
    if (![_dataBase executeUpdate:@"delete from searchSeries"]) {
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

#pragma mark - 导航页面
// 指南首页表
- (BOOL)createTableWithGuide {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if (![_dataBase executeUpdate:@"create table if not exists guideTable (id text primary key not null, author text not null, title text not null, title_pic1 text not null, pub text not null, url text not null)"]) {
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

// 存储
- (BOOL)saveData2GuideTable:(QYNewsModel *)newsModel {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if (![_dataBase executeUpdate:@"insert into guideTable values (?,?,?,?,?,?)", newsModel.newsId, newsModel.author, newsModel.title, newsModel.title_pic1, newsModel.pub, newsModel.url]) {
        NSLog(@"%@", [_dataBase lastErrorMessage]);
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

// 删除
- (BOOL)deleteDataFromGuideTable {
    if (![self.dataBase open]) {
        return NO;
    }
    
    if (![_dataBase executeUpdate:@"delete from guideTable"]) {
        NSLog(@"%@", [_dataBase lastErrorMessage]);
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

// 查询
- (NSMutableArray *)selectAllDataFromGuide {
    if (![self.dataBase open]) {
        return nil;
    }
    FMResultSet *set = [_dataBase executeQuery:@"select *from guideTable"];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    while ([set next]) {
        QYNewsModel *model = [[QYNewsModel alloc] initWithDict:[set resultDictionary]];
        [tempArr addObject:model];
    }
    [_dataBase close];
    return tempArr;
}



@end
