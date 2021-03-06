//
//  QYSearchHeaderView.m
//  二手车
//
//  Created by qingyun on 16/1/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYSearchHeaderView.h"
#import "Header.h"
#import "QYBrandModel.h"

@interface QYSearchHeaderView ()

@property (nonatomic, strong) NSArray *hotArray;// 热门数据

@end

@implementation QYSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        [self loadBrandList];
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
    
    CGFloat marginX = 10;
    CGFloat marginY = 10;
    CGFloat spaceX = 20;
    CGFloat spaceY = 10;
    CGFloat btnW = (kScreenWidth - marginX * 2 - spaceX) / 2;
    CGFloat btnH = 30;
    
    
    for (int i = 0; i < 6; i++) {
        CGFloat btnX = marginX + (btnW + spaceX) * (i % 2);
        CGFloat btnY = marginY + (btnH + spaceY) * (i / 2) + 20;
        
        QYBrandModel *brandModel = [[QYBrandModel alloc] initWithDict:_hotArray[i]];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setTitle:brandModel.brandName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.tag = 300 + i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
        //添加属性
        [self addLayerProperty:btn];
    }
    
    //添加删除的btn 和 一个lable
    CGFloat lableX = 10;
    CGFloat lableY = 150;
    CGFloat lableW = 80;
    CGFloat lableH = 30;
    UILabel *recentLabel = [[UILabel alloc] initWithFrame:CGRectMake(lableX, lableY, lableW, lableH)];
    [self addSubview:recentLabel];
    recentLabel.text = @"浏览历史";
    recentLabel.textColor = [UIColor orangeColor];
    recentLabel.font = [UIFont systemFontOfSize:14];
    
    CGFloat deleteBtnW = 100;
    CGFloat deleteBtnH = 30;
    CGFloat deleteBtnX = kScreenWidth - marginX - deleteBtnW;
    CGFloat deleteBtnY = 150;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:deleteBtn];
    deleteBtn.frame = CGRectMake(deleteBtnX, deleteBtnY, deleteBtnW, deleteBtnH);
    [deleteBtn setTitle:@"清除浏览历史" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAllRecntLooksData) forControlEvents:UIControlEventTouchUpInside];
    
    //添加一条线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 179, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
}

#pragma mark - 设置图层属性
- (void)addLayerProperty:(UIButton *)sender {
    CALayer *layer = [sender layer];
    layer.cornerRadius = 5;
    layer.borderWidth = 1.0;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

#pragma mark - 加载热门数据
- (void)loadBrandList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"brand" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    // 热门搜索的数据
    _hotArray = dict[@"hot"];
}

#pragma mark - 点击事件

// 选择热门城市
- (void)buttonsClick:(UIButton *)sender {
    //这里的index就是品牌的 id
    NSInteger index = sender.tag - 300;
    NSDictionary *dict = _hotArray[index];
    _brandParasBlock(dict[@"id"], dict[@"name"]);
}

// 删除所有的浏览历史
- (void)deleteAllRecntLooksData {
    if (_deleteRecentLooksBlock) {
        _deleteRecentLooksBlock();
    }
}

@end
