//
//  QYNewsModel.h
//  二手车
//
//  Created by qingyun on 16/1/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYNewsModel : NSObject

@property (nonatomic, strong) NSString *author;// 作者
@property (nonatomic, strong) NSString *newsId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *title_pic1;
@property (nonatomic, strong) NSString *pub;
@property (nonatomic, strong) NSString *url;


- (instancetype)initWithDict:(NSDictionary *)dict;


@end
