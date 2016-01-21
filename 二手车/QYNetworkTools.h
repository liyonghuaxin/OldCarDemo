//
//  QYNetworkTools.h
//  二手车
//
//  Created by qingyun on 16/1/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface QYNetworkTools : AFHTTPSessionManager

+ (instancetype)sharedNetworkTools;

@end
