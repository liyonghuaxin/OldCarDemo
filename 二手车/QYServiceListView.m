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
        // 添加子视图
        [self createAndAddSubviews];
    }
    return self;
}

#pragma mark - 子视图
- (void)createAndAddSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
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
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}



@end
