//
//  QYTitleLable.m
//  二手车
//
//  Created by qingyun on 16/1/3.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYTitleLable.h"

@implementation QYTitleLable

- (instancetype)init {
    if (self = [super init]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
        self.scale = 0.0;
    }
    return self;
}


/** 通过scale的大小改变多种参数 */
- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1];
    
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1 - minScale) * scale;
//    CGFloat trueScale = 1.0;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end
