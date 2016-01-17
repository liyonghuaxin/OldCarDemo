//
//  QYPriceView.m
//  二手车
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYPriceView.h"

@interface QYPriceView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;// 显示的数组
@property (nonatomic, strong) NSArray *priceArray;// 用于传递的数组

@property (nonatomic, strong) UITextField *lowTextField;// 低价格
@property (nonatomic, strong) UITextField *highTextField;// 高价格
@end

@implementation QYPriceView
#pragma mark - 初始化 view
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        // 添加子视图
        [self createAndAddSubviews];
    }
    return self;
}

#pragma mark - 懒加载
- (NSArray *)priceArray {
    if (_priceArray == nil) {
        _priceArray = @[@{@"price":@"0"},@{@"price":@"0-3"},@{@"price":@"3-5"},@{@"price":@"5-10",},@{@"price":@"10-15"},@{@"price":@"15-20"},@{@"price":@"20-30"},@{@"price":@"30-50"},@{@"price":@"50"}];
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
    _dataArray = @[@"不限",@"3万以下",@"3-5万",@"5-10万",@"10-15万",@"15-20万",@"20-30万",@"30-50万",@"50万以上"];
    
    // tableView
    UITableView *tablView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40*_dataArray.count + 50)];
    [self addSubview:tablView];
    tablView.dataSource = self;
    tablView.delegate = self;
    tablView.rowHeight = 40;
    
    // 自定义头视图
    [self createCustomPriceView:tablView];
    
    // 添加下面的view 用于点击
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, tablView.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [self addSubview:tempView];
    tempView.backgroundColor = [UIColor blackColor];
    tempView.alpha = 0.5;
    
    
    // 添加手势
    [self createAndAddTap:tempView];
}

// 自定义头视图
- (void)createCustomPriceView:(UITableView *)tableView {
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    tableView.tableHeaderView = priceView;
    
    //创建两个textField 用于输入自定义价格
    _lowTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, 70, 30)];
    [priceView addSubview:_lowTextField];
    _lowTextField.placeholder = @"最低";
    _lowTextField.textAlignment = NSTextAlignmentCenter;
    _lowTextField.font = [UIFont systemFontOfSize:12];

    _highTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 70, 30)];
    [priceView addSubview:_highTextField];
    _highTextField.placeholder = @"最高";
    _highTextField.textAlignment = NSTextAlignmentCenter;
    _highTextField.font = [UIFont systemFontOfSize:12];
    
    // 添加图层属性
    [self addLayer:_lowTextField];
    [self addLayer:_highTextField];
    
    // 添加确定按钮btn
    [self createAndAddBtn:priceView];
    
    // 添加修饰价格的label
    UILabel *adomLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 10, 15, 30)];
    [priceView addSubview:adomLabel];
    adomLabel.text = @"万";
    adomLabel.font = [UIFont systemFontOfSize:12];
    
    // 添加两条横线
    [self addLinViews:priceView];
}

// 添加 textField的图层属性
- (void)addLayer:(UITextField *)textfield {
    CALayer *layer = [textfield layer];
    layer.cornerRadius = 5;
    layer.borderWidth = 1;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)createAndAddBtn:(UIView *)view {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btn];
    btn.frame = CGRectMake(210, 10, 70, 30);
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    // 添加图层属性
    CALayer *layer = [btn layer];
    layer.cornerRadius = 5;
}

- (void)addLinViews:(UIView *)priceView {
    // 第一条横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(90, 25, 15, 1)];
    [priceView addSubview:lineView];
    lineView.backgroundColor = [UIColor blackColor];
    
    // 第二条
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.frame.size.width, 1)];
    [priceView addSubview:lineView2];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    lineView2.alpha = 0.4;
}

#pragma mark - 点击事件
- (void)btnClick {
    
}


#pragma mark - table view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MTCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

#pragma mark - table view delegate
// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_changePriceBlock) {
        _changePriceBlock(self.priceArray[indexPath.row]);
    }
}


@end
