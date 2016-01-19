//
//  QYRearchResultViewController.m
//  二手车
//
//  Created by qingyun on 16/1/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYSearchResultViewController.h"

@interface QYSearchResultViewController ()

@property (nonatomic, strong) NSArray *dataArray; // 查询的数据源
@property (nonatomic, strong) NSArray *searchList;// 搜索结果

@end

@implementation QYSearchResultViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - UISearchResultsUpdating


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if ([searchController.searchBar.text isEqualToString:@""]) {
 
        return;
    }

//     创建谓词
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.brandName CONTAINS[CD] %@",searchController.searchBar.text];
//    
//    NSMutableArray *filterArray  = [NSMutableArray array];
//    for (QYBrandModel *model in _sourceArray) {
//        [filterArray addObject:model];
//    }
//    _searchList = [filterArray filteredArrayUsingPredicate:predicate];
//    [_tableView reloadData];

}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"222";
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}



@end
