//
//  QYPriceView.m
//  二手车
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYPriceView.h"

#define Kprice @"price"

@interface QYPriceView ()
@property (nonatomic, strong) NSArray *dataArray;// 显示的数组
@property (nonatomic, strong) NSArray *priceArray;// 用于传递的数组

@property (nonatomic, strong) UITextField *lowTextField;// 低价格
@property (nonatomic, strong) UITextField *highTextField;// 高价格
@end

@implementation QYPriceView
#pragma mark - 初始化 view
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dataArray = @[@"不限",@"3万以下",@"3-5万",@"5-10万",@"10-15万",@"15-20万",@"20-25万",@"25-30万",@"30-50万",@"50万以上",@"50-100万",@"100万以上"];
        
        // 添加子视图
        [self createAndAddSubviews];
    }
    return self;
}

#pragma mark - 懒加载
- (NSArray *)priceArray {
    if (_priceArray == nil) {
        _priceArray = @[@{Kprice:@"0"},@{Kprice:@"0-3"},@{Kprice:@"3-5"},@{Kprice:@"5-10",},@{Kprice:@"10-15"},@{Kprice:@"15-20"},@{Kprice:@"20-25"},@{Kprice:@"25-30"},@{Kprice:@"30-50"},@{Kprice:@"50-100"},@{Kprice:@"100"}];
    }
    return _priceArray;
}

#pragma mark - 添加手势
- (void)createAndAddTap:(UIView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromVC)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
}

// 移除视图
- (void)removeFromVC {
    if (_isCloseBlock) {
        _isCloseBlock();
    }
}

#pragma mark - 创建并添加子视图
- (void)createAndAddSubviews {
    // 价格区域视图
    [self createAndAddPriceView];
    
    // 添加下面的view 用于点击
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.frame.size.width, self.frame.size.height)];
    [self addSubview:tempView];
    tempView.backgroundColor = [UIColor blackColor];
    tempView.alpha = 0.5;
    // 添加手势
    [self createAndAddTap:tempView];
    
}

#pragma mark - 价格区域的视图
- (void)createAndAddPriceView {
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 300)];
    [self addSubview:priceView];
    priceView.backgroundColor = [UIColor whiteColor];
    
    UILabel *guideLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 100, 20)];
    [priceView addSubview:guideLabel];
    guideLabel.text = @"自定义价格(万)";
    guideLabel.font = [UIFont systemFontOfSize:12];
    guideLabel.textColor = [UIColor lightGrayColor];
    
    CGFloat marginX = 8;
    CGFloat spaceX = 15;
    CGFloat spaceY = 10;
    CGFloat btnW = (self.frame.size.width - 2 * (marginX + spaceX)) / 3.0;
    CGFloat btnH = 40;

    //创建两个textField 用于输入自定义价格
    _lowTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX, 40, btnW, btnH)];
    [priceView addSubview:_lowTextField];
    _lowTextField.placeholder = @"最低";
    _lowTextField.textAlignment = NSTextAlignmentCenter;
    _lowTextField.font = [UIFont systemFontOfSize:14];
    [self addLayer:_lowTextField];
    
    _highTextField = [[UITextField alloc] initWithFrame:CGRectMake(marginX+btnW+spaceX, 40, btnW, btnH)];
    [priceView addSubview:_highTextField];
    _highTextField.placeholder = @"最高";
    _highTextField.textAlignment = NSTextAlignmentCenter;
    _highTextField.font = [UIFont systemFontOfSize:14];
    [self addLayer:_highTextField];
    
    //确定按钮
    UIButton *choseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceView addSubview:choseBtn];
    choseBtn.frame = CGRectMake(marginX+(btnW+spaceX)*2, 40, btnW, btnH);
    [choseBtn setBackgroundColor:[UIColor orangeColor]];
    choseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [choseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [choseBtn setTitle:@"确定" forState:UIControlStateNormal];
    [choseBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    // 添加图层属性
    CALayer *layer = [choseBtn layer];
    layer.cornerRadius = 5;
    
    // 固定可选择价格的区域
    for (int i = 0; i < _dataArray.count; i++) {
        CGFloat btnX = (i % 3) * (spaceX + btnW) + marginX;
        CGFloat btnY = (i / 3) * (spaceY + btnH) + 90;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [priceView addSubview:btn];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitle:_dataArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(choseFixPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addLayer:btn];
    }
}

// 添加图层属性
- (void)addLayer:(id)sender {
    CALayer *layer = [sender layer];
    layer.cornerRadius = 5;
    layer.borderWidth = 1;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - 点击事件
- (void)btnClick {
    
}

- (void)choseFixPriceBtn:(UIButton *)sender {
    if (_changePriceBlock) {
        
//        _changePriceBlock()
    }
}






@end
