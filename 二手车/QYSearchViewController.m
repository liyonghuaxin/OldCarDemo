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
#import "QYServiceModel.h"
#import "QYSearchHeaderView.h"
#import <AFHTTPSessionManager.h>
#import "QYSearchCarListVC.h"
#import <SVProgressHUD.h>
#import "QYDBFileManager.h"

@interface QYSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) QYSearchHeaderView *HeaderView;// 热门的view
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *recentLookDatas;//最近浏览的数据
@property (nonatomic, strong) NSMutableArray *recentLookKeys;// 最近浏览的数据的id

@property (nonatomic, strong) NSMutableArray *keys;// 品牌的键
@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) NSMutableArray *brandData;//总数据
@property (nonatomic, strong) NSMutableArray *seresData;

@property (nonatomic, strong) NSMutableArray *data;// 显示的数据
@property (nonatomic, strong) NSMutableArray *dataID;

@property (nonatomic, assign) BOOL isLoad;// 是否已经请求过了
@property (nonatomic, assign) NSInteger count;// 表示有多少品牌
@property (nonatomic, assign) BOOL isSearching;

@property (nonatomic, assign) BOOL isError;// 是否已经错误

@end

@implementation QYSearchViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAndAddSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_isLoad) {
        [self loadRecentDataList];
        [self loadBrandList];
        [self downloadSeresList];
        _isLoad = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 加载数据
// 加载品牌数据
- (void)loadBrandList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"brand" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

    _dict = [NSMutableDictionary dictionary];
    _keys = [NSMutableArray array];
    _dict = dict[@"brand"];
    _keys = dict[@"initial"];
}

// 加载最近浏览的品牌或车系
- (void)loadRecentDataList {
    _data = [NSMutableArray array];
    _dataID = [NSMutableArray array];
    // 加载最近浏览的品牌
    NSMutableArray *tempArr1 = [[QYDBFileManager sharedDBManager] selectAllSearchData:kSearchBrandTable];
    _count = tempArr1.count;
    for (QYBrandModel *brandModel in tempArr1) {
        [_data addObject:brandModel.brandName];
        [_dataID addObject:brandModel.brandId];
    }
    
    // 加载最近浏览的车系
    NSMutableArray *tempArr2 = [[QYDBFileManager sharedDBManager] selectAllSearchData:ksearchSeriesTbale];
    for (QYServiceModel *seriesModel in tempArr2) {
        [_data addObject:seriesModel.seriesName];
        [_dataID addObject:seriesModel.series];
    }
}

#pragma mark - 请求车系列表
// 请求车系列表
- (void)downloadSeresList {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    _brandData = [NSMutableArray array];
    _seresData = [NSMutableArray array];
    
    for (NSString *key in _keys) {
        for (NSDictionary *dict in _dict[key]) {
            QYBrandModel *brandModel = [[QYBrandModel alloc] initWithDict:dict];
            [_brandData addObject:brandModel];
            NSDictionary *parameters = @{@"brand":brandModel.brandId};
            [manager POST:kServiceListUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSArray *keys = responseObject[@"keys"];
                NSDictionary *data = responseObject[@"data"];
                // 得到车系的列表
                for (NSString *seresKey in keys) {
                    for (NSDictionary *dic in data[seresKey]) {
                        QYServiceModel *seresModel = [[QYServiceModel alloc] initWithDict:dic];
                        [_seresData addObject:seresModel];
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (!_isError) {
                    _isError = YES;
                }
            }];
        }
    }
}

#pragma mark - 添加视图
- (void)createAndAddSubviews {
    
    self.title = @"返回";
    
    // 添加搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 44)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    
    UIView *topView = searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelBtn = (UIButton *)subView;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            break;
        }
    }
    searchBar.tintColor = [UIColor orangeColor];
    searchBar.placeholder = @"请输入品牌/车系";
    self.navigationItem.titleView = searchBar;
    
    [searchBar becomeFirstResponder];
    _searchBar = searchBar;
    
    // 创建并添加tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 头视图
    _HeaderView = [[QYSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    _tableView.tableHeaderView = _HeaderView;
    MTWeak(self, weakSelf);
    // 热门品牌选择1
    _HeaderView.brandParasBlock = ^(NSString *brandId, NSString *brandName) {
        QYSearchCarListVC *carListVC = [[QYSearchCarListVC alloc] init];
        carListVC.brandId = brandId;
        carListVC.brandName = brandName;
        carListVC.type = 1;
        [weakSelf.navigationController pushViewController:carListVC animated:YES];
    };
    // 删除最近浏览的数据
    MTWeak(_tableView, weakTableView);
    _HeaderView.deleteRecentLooksBlock = ^{
        if ([[QYDBFileManager sharedDBManager] deleteLocalAllSearchData]) {
            [weakSelf loadRecentDataList];
             [weakTableView reloadData];
            [SVProgressHUD showImage:nil status:@"已清空"];
        }else {
            [SVProgressHUD showImage:nil status:@"清除失败"];
        }
    };
}


#pragma mark - table view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
   
    // 最近查询的数据
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.tintColor = [UIColor grayColor];
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}


#pragma mark - table view delegate
// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QYSearchCarListVC *carListVC = [[QYSearchCarListVC alloc] init];
    NSDictionary *dict = @{@"id":_dataID[indexPath.row], @"name":_data[indexPath.row]};
    
    if (indexPath.row < _count) {
        carListVC.brandName = _data[indexPath.row];
        carListVC.brandId = _dataID[indexPath.row];
        carListVC.type = 1;
        // 存到数据库
         [[QYDBFileManager sharedDBManager] saveSearchDataWithbrandTable:[[QYBrandModel alloc] initWithDict:dict]];
    }else {
        carListVC.seriesName = _data[indexPath.row];
        carListVC.seriesId = _dataID[indexPath.row];
        carListVC.type = 2;
        [[QYDBFileManager sharedDBManager] saveSearchDataWithSeriesTable:[[QYServiceModel alloc] initWithDict:dict]]
        ;
    }
    [self.navigationController pushViewController:carListVC animated:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark -  **************  searchBar delegate ***********
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        [searchBar resignFirstResponder];
        _isSearching = NO;
        _tableView.tableHeaderView = _HeaderView;
        [self loadRecentDataList];
        [_tableView reloadData];
        return;
        
    }else {
        // 正在搜索
        [self searchingDataWith:searchBar];
    }
}

//点击搜索按钮的时候调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    // 正在搜索
    [self searchingDataWith:searchBar];
}

- (void)searchingDataWith:(UISearchBar *)searchBar {
    _isSearching = YES;
    // 创建谓词
    NSPredicate *brandPredicate = [NSPredicate predicateWithFormat:@"SELF.brandName CONTAINS[CD] %@",searchBar.text];
    NSPredicate *seriesPredicate = [NSPredicate predicateWithFormat:@"SELF.seriesName CONTAINS[CD] %@", searchBar.text];
    NSMutableArray *filterArray1  = [NSMutableArray array];
    NSMutableArray *filterArray2  = [NSMutableArray array];
    
    for (QYBrandModel *brandModel in _brandData) {
        [filterArray1 addObject:brandModel];
    }
    for (QYServiceModel *seriesModel in _seresData) {
        [filterArray2 addObject:seriesModel];
    }
    
    _data = [NSMutableArray array];
    _dataID = [NSMutableArray array];
    NSArray *arr1 = [filterArray1 filteredArrayUsingPredicate:brandPredicate];
    NSArray *arr2 = [filterArray2 filteredArrayUsingPredicate:seriesPredicate];
    _count = arr1.count;
    
    for (QYBrandModel *model in arr1) {
        [_data addObject:model.brandName];
        [_dataID addObject:model.brandId];
    }
    for (QYServiceModel *model in arr2) {
        [_data addObject:model.seriesName];
        [_dataID addObject:model.series];
    }
    
    _tableView.tableHeaderView = nil;
    [_tableView reloadData];
}

@end
