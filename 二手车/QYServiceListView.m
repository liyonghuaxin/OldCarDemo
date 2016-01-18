//
//  QYServiceListView.m
//  二手车
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYServiceListView.h"
#import "QYServiceModel.h"

@interface QYServiceListView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation QYServiceListView
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 添加子视图
        [self createAndAddSubviews];
    }
    return self;
}

#pragma mark - 子视图
- (void)createAndAddSubviews {
    // 添加tableView
    [self createAndAddTableView];
    
    // 添加返回视图
    [self createAndAddTableViewHeaderView];
    
    //添加横线
    [self createAndAddSingleLineView];
}

- (void)createAndAddTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-100)];
    [self addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    
}

- (void)createAndAddSingleLineView {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor blackColor];
}

//添加返回键视图
- (void)createAndAddTableViewHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
     [self addSubview:headerView];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 40, 20)];
    [headerView addSubview:titleLabel];
    titleLabel.text = @"收起";
    titleLabel.font = [UIFont systemFontOfSize:14];
   
    // 添加手势
    [self addTap2HeaerView:headerView];
}

#pragma mark - 添加移除视图的手势
- (void)addTap2HeaerView:(UIView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelfView)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
}

#pragma mark - 手势事件
// 移除当前的视图
- (void)removeSelfView {
    if (_serviceBlcok) {
        _serviceBlcok(nil);
    }
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _data[_keys[section]];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSArray *array = _data[_keys[indexPath.section]];
    QYServiceModel *model = [[QYServiceModel alloc] initWithDict:array[indexPath.row]];
    cell.textLabel.text = model.seriesName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _keys[section];
}

// 自定义section 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 100, 20)];
    [view addSubview:title];
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = [UIColor blackColor];
    title.text = _keys[section];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = _data[_keys[indexPath.section]];
    QYServiceModel *model = [[QYServiceModel alloc] initWithDict:array[indexPath.row]];
    if (_serviceBlcok) {
        _serviceBlcok(model);
    }
   
}



@end
