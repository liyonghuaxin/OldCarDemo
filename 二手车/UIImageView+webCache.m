//
//  UIImageView+webCache.m
//  二手车
//
//  Created by qingyun on 16/1/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "UIImageView+webCache.h"

@implementation UIImageView (webCache)


- (void)loadImageFormNetWork:(NSString *)imageUrl {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    [manager GET:imageUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.image = responseObject;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"下载图片失败----%@",error);
    }];
}

@end
