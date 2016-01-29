//
//  QYCityPositionView.m
//  二手车
//
//  Created by qingyun on 16/1/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCityPositionView.h"
#import "Header.h"

@implementation QYCityPositionView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createAndAddSubviews];
    }
    return self;
}


- (void)createAndAddSubviews {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [self addSubview:headerView];
    headerView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 60, 30)];
    titleLabel.text = @"定位城市";
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [headerView addSubview:titleLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    btn.frame = CGRectMake(18, 45, 90, 35);
    [btn setTitle:@"定位城市" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];

    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


@end
