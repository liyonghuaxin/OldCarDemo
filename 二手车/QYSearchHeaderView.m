//
//  QYSearchHeaderView.m
//  二手车
//
//  Created by qingyun on 16/1/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYSearchHeaderView.h"

@implementation QYSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self createAndaAddSubviews];
    }
    return self;
}

#pragma mark - 添加视图
- (void)createAndaAddSubviews {
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)];
    [self addSubview:titleLable];
    titleLable.text = @"热门搜索";
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.textColor = [UIColor orangeColor];
}

@end
