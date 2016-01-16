//
//  QYSortView.m
//  二手车
//
//  Created by qingyun on 16/1/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYSortView.h"

@interface QYSortView ()  <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;
@end
@implementation QYSortView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createAndAddSubivews];
    }
    return self;
}

#pragma mark - 添加tablewView
- (void)createAndAddSubivews {
    UITableView *tablView = [[UITableView alloc] initWithFrame:self.frame];
    [self addSubview:tablView];
    tablView.dataSource = self;
    tablView.delegate = self;
    tablView.rowHeight = 40;
    
    _data = @[@"默认排序",@"价格最高",@"价格最低",@"里程最短",@"车龄最短"];
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
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}




@end
