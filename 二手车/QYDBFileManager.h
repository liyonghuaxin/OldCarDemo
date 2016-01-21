//
//  QYFMDBManger.h
//  二手车
//
//  Created by qingyun on 16/1/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QYCarModel;

@interface QYDBFileManager : NSObject

+ (instancetype)sharedDBManager;

// 存储到本地
- (BOOL)saveData2Local:(QYCarModel *)model class:(NSString *)name;

// 查询
- (NSMutableArray *)selectAllData:(NSString *)tableName;
- (QYCarModel *)selectDataFromCarId:(NSString *)carId tableName:(NSString *)name;



// 删除记录
- (BOOL)deleteLocalAllData:(NSString *)tableName;

- (BOOL)deleteLocalFromCarId:(NSString *)carId tableName:(NSString *)tableName;


@end
