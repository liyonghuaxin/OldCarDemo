//
//  QYSearchViewController.m
//  二手车
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYSearchViewController.h"
#import "Header.h"
#import "QYBrandModel.h"
#import "QYSearchHeaderCell.h"
#import "QYSearchHeaderView.h"

@interface QYSearchViewController () <UISearchBarDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, assign) BOOL isSearching;//是否在搜索
@property (nonatomic, strong) NSMutableArray *recentLooks;//最近浏览的数据


@property (nonatomic, strong) NSArray *searchList;//搜索的结果
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sourceArray;//搜索的数据源
@property (nonatomic, strong) UIBarButtonItem *backBarBtnItem;//返回键

@end

@implementation QYSearchViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createAndAddSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadBrandList];
    [_searchController.searchBar canBecomeFirstResponder];
    _isSearching = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 加载品牌数据
- (void)loadBrandList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"brand" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // 最近看过的品牌
    _recentLooks = dict[@"recent"];

    NSDictionary *sourceDict = dict[@"brand"];
    NSArray *keys = [dict[@"initial"] sortedArrayUsingSelector:@selector(compare:)];
    
    // 查询的数据
    _sourceArray = [NSMutableArray array];
    for (NSString *keyStr in keys) {
        for (NSDictionary *dict in sourceDict[keyStr]) {
            QYBrandModel *model = [[QYBrandModel alloc] initWithDict:dict];
            [_sourceArray addObject:model];
        }
    }
}

#pragma mark - 添加视图
- (void)createAndAddSubviews {
//    [self.navigationController.navigationBar setTranslucent:NO];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    // 添加搜索框
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.navigationItem.titleView = _searchController.searchBar;
    _searchController.searchBar.frame = CGRectMake(0, 0, kScreenWidth-200, 44);
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.showsCancelButton = YES;
    _searchController.searchBar.placeholder = @"请输入品牌/车系";
    
    
    // 创建并添加tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (!_isSearching) {
        QYSearchHeaderView *headerView = [[QYSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _tableView.tableHeaderView = headerView;
    }
}

#pragma mark - 点击事件
- (void)backToSuperViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - table view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearching) {
        return _searchList.count;
    }
    return _recentLooks.count + 1;//加自定义的cell
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    //自定义的cell
    if (!_isSearching && indexPath.row == 0) {
        QYSearchHeaderCell *cell = [[QYSearchHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnIndexBlock = ^(NSInteger index){
            
        };
        return cell;
    }
    
    //搜索时
    if (_isSearching) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        QYBrandModel *model = _searchList[indexPath.row];
        cell.textLabel.text = model.brandName;
        return cell;
    }
    
    //没有搜索时的第二个section
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    QYBrandModel *model = _recentLooks[indexPath.row];
    cell.textLabel.text = model.brandName;
    return cell;
}

#pragma mark - table view delegate
// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
   
}

// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isSearching && indexPath.row == 0) {
        return 160;
    }
    return 40;
}

#pragma mark - UISearchBar delegate 
// 点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchResultsUpdating


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if ([searchController.searchBar.text isEqualToString:@""]) {
        _isSearching = NO;
        [_tableView reloadData];
        return;
    }
    
    _isSearching = YES;
    // 创建谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.brandName CONTAINS[CD] %@",searchController.searchBar.text];
    
    NSMutableArray *filterArray  = [NSMutableArray array];
    for (QYBrandModel *model in _sourceArray) {
        [filterArray addObject:model];
    }
    _searchList = [filterArray filteredArrayUsingPredicate:predicate]; 
    [_tableView reloadData];
 
}



@end
