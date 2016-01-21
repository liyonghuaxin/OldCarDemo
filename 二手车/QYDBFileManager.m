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

    int result = [_dataBase executeUpdate:@"create table if not exists starTable (id text primary key not null, model_name text not null, price text not null, city_name text not null, mile_age text not null, register_date text not null, vpr text not null, pic_url text not null)"];
    if (!result) {
        NSLog(@"create table error -- %@",[_dataBase lastErrorMessage]);
    }
    [_dataBase close];
    return YES;
}

// 浏览历史记录表
- (BOOL)createTableWithWatch {
    if (![self.dataBase open]) {
        NSLog(@"create-- open table error!!%@",[_dataBase lastErrorMessage]);
        return NO;
    }
    
    int result = [_dataBase executeUpdate:@"create table if not exists watchTable (id text primary key not null, model_name text not null, price text not null, city_name text not null, mile_age text not null, register_date text not null, vpr text not null, pic_url text not null)"];
    if (!result) {
        NSLog(@"create table error -- %@",[_dataBase lastErrorMessage]);
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
    
    int result = [_dataBase executeUpdate:@"create table if not exists carTable (id text primary key not null, model_name text not null, price text not null, city_name text not null, mile_age text not null, register_date text not null, vpr text not null, pic_url text not null)"];
    if (!result) {
        NSLog(@"create table error -- %@",[_dataBase lastErrorMessage]);
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
    
    int result;
    
    if ([name isEqualToString:kWatchTable]) {
        // 浏览
       result = [_dataBase executeUpdate:@"insert into watchTable values (?,?,?,?,?,?,?,?)", model.carID, model.carName, model.price, model.cityName, model.mileage, model.registerDate, model.vpr, model.iconUrl];
    }else if ([name isEqualToString:kStarTable]) {
        // 收藏
        result = [_dataBase executeUpdate:@"insert into starTable values (?,?,?,?,?,?,?,?)", model.carID, model.carName, model.price, model.cityName, model.mileage, model.registerDate, model.vpr, model.iconUrl];
    }else if ([name isEqualToString:kCarTable]) {
        // 首页列表
        result = [_dataBase executeUpdate:@"insert into carTable values (?,?,?,?,?,?,?,?)", model.carID, model.carName, model.price, model.cityName, model.mileage, model.registerDate, model.vpr, model.iconUrl];
    }

    if (!result) {
        NSLog(@"insert error --%@",[_dataBase lastErrorMessage]);
        [_dataBase close];
        return NO;
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
        set = [_dataBase executeQuery:@"select *from watchTable where id = %@", carId];
    }else if ([name isEqualToString:kStarTable]) {
        // 收藏
        set = [_dataBase executeQuery:@"select *from starTable where id = %@", carId];
    }else if ([name isEqualToString:kCarTable]) {
        // 首页列表
        set = [_dataBase executeQuery:@"select *from carTable where id = %@", carId];
    }
    
    QYCarModel *carModel;
    while ([set next]) {
        QYCarModel *model = [[QYCarModel alloc] initWithDict:[set resultDictionary]];
        carModel = model;
    }
    
    [_dataBase close];
    if (carModel) {
        return carModel;
    }
    return nil;
}

#pragma mark - 删除
// 删除所有
- (BOOL)deleteLocalAllData:(NSString *)tableName {
    if (![self.dataBase open]) {
        return NO;
    }
    
    int result;
    if ([tableName isEqualToString:kWatchTable]) {
        // 浏览
        result = [_dataBase executeUpdate:@"delete from watchTable"];
    }else if ([tableName isEqualToString:kStarTable]) {
        // 收藏
        result = [_dataBase executeUpdate:@"delete from starTable"];
    }else if ([tableName isEqualToString:kCarTable]) {
        // 首页列表
        result = [_dataBase executeUpdate:@"delete from carTable"];
    }
    
    if (!result) {
        NSLog(@"delete error --%@",[_dataBase lastErrorMessage]);
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}

// 根据id删除
- (BOOL)deleteLocalFromCarId:(NSString *)carId tableName:(NSString *)tableName {
    if (![self.dataBase open]) {
        return NO;
    }
    
    int result;
    if ([tableName isEqualToString:kWatchTable]) {
        result = [_dataBase executeUpdate:@"delete from watchTable where id = ?", carId];
    }else if ([tableName isEqualToString:kStarTable]) {
        result = [_dataBase executeUpdate:@"delete from starTable where id = ?", carId];
    }
    
    if (!result) {
        NSLog(@"delete error --%@",[_dataBase lastErrorMessage]);
        [_dataBase close];
        return NO;
    }
    
    [_dataBase close];
    return YES;
}



@end
