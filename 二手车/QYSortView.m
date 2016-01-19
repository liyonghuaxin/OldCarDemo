//
//  QYSortView.m
//  二手车
//
//  Created by qingyun on 16/1/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYSortView.h"

@interface QYSortView ()  <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;// 显示的数组
@property (nonatomic, strong) NSArray *valueArray; // 值
@property (nonatomic, strong) NSArray *keyArray;// 键
@end
@implementation QYSortView

#pragma mark - 初始化 view
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        // 添加子视图
        [self createAndAddSubivews];
    }
    return self;
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
#pragma mark - 懒加载

// 键
- (NSArray *)keyArray {
    if (_keyArray == nil) {
        _keyArray = @[@"postDateSort",@"priceSort",@"priceSort",@"mileSort",@"regDateSort"];
    }
    return _keyArray;
}

// 值
- (NSArray *)valueArray {
    if (_valueArray == nil) {
        _valueArray = @[@"desc",@"desc",@"asc",@"asc",@"desc"];
    }
    return _valueArray;
}

#pragma mark - 添加tablewView
- (void)createAndAddSubivews {
    UITableView *tablView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
    [self addSubview:tablView];
    tablView.dataSource = self;
    tablView.delegate = self;
    tablView.rowHeight = 40;

   
    _data = @[@"默认排序",@"价格最高",@"价格最低",@"里程最短",@"车龄最短"];
    
    // 添加下面的view 用于点击
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.frame.size.width, self.frame.size.height -200)];
    [self addSubview:tempView];
    tempView.backgroundColor = [UIColor blackColor];
    tempView.alpha = 0.5;
    
    
    // 添加手势
    [self createAndAddTap:tempView];
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = _data[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_changeParameterBlock) {
        _changeParameterBlock(self.keyArray[indexPath.row], self.valueArray[indexPath.row], _data[indexPath.row]);
    }
    
}




@end
