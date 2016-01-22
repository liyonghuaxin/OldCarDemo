//
//  QYNewsModel.m
//  二手车
//
//  Created by qingyun on 16/1/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYNewsModel.h"

@implementation QYNewsModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _author = dict[@"author"];
        _title = dict[@"title"];
        _newsId = dict[@"id"];
        _title_pic1 = dict[@"title_pic1"];
        _url = dict[@"url"];
        _pub = dict[@"pub"];
    }
    return self;
}

@end
