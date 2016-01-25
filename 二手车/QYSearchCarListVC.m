//
//  QYSearchCarListVC.m
//  二手车
//
//  Created by qingyun on 16/1/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYSearchCarListVC.h"
#import "QYCarTableViewCell.h"
#import "Header.h"
#import <MJRefresh.h>
#import "QYNetworkTools.h"
#import "QYCarModel.h"
#import "QYCarDetailsViewController.h"
#import "QYDBFileManager.h"
#import <SVProgressHUD.h>

@interface QYSearchCarListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *parameters;

@property (nonatomic, assign) BOOL isFristLoad;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation QYSearchCarListVC
#pragma mark - 懒加载
- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车源列表";
    [self createAndAddSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 判断是否是第一次
    if (!_isFristLoad) {
        [SVProgressHUD show];
        _parameters =[NSMutableDictionary dictionary];
        // 加载保存的城市
        NSDictionary *cityModel = [[NSUserDefaults standardUserDefaults] objectForKey:kcityModel];
        // 城市
        if (cityModel) {
            [_parameters setValue:cityModel[kCityId] forKey:kCityId];
            [_parameters setValue:cityModel[kProvId] forKey:kProvId];
            [_parameters setValue:cityModel[kCityName] forKey:kCityName];
        }else {
            // 默认的选择的区域 (北京)
            [_parameters setValue:@"1" forKey:kCityId];
            [_parameters setValue:@"1" forKey:kProvId];
            [_parameters setValue:@"北京" forKey:kCityName];
        }
        
        // 品牌还是车系
        if (_type == 1) {
            [_parameters setObject:_brandId forKey:kBrandId];
            [_parameters setObject:_brandName forKey:kBrandName];
        }else {
            [_parameters setObject:_seriesId forKey:kSeriesId];
            [_parameters setObject:_seriesName forKey:kSeriesName];
        }
        [self refreshData];
        _isFristLoad = YES;
    }
}

#pragma mark - subviews
- (void)createAndAddSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 84;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 方法
- (void)refreshData {
    _pageIndex = 1;
    [_parameters setObject:@(_pageIndex) forKey:kPage];
    [self loadDataWithParameters:_parameters withType:1];
}

- (void)loadMoreData {
    _pageIndex ++;
    [_parameters setObject:@(_pageIndex) forKey:kPage];
    [self loadDataWithParameters:_parameters withType:2];
}

// 请求数据
- (void)loadDataWithParameters:(NSDictionary *)parameters withType:(int)type {
    [QYNetworkTools sharedNetworkTools].requestSerializer.timeoutInterval = 5;
    [[QYNetworkTools sharedNetworkTools] POST:kCarsListUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *tempArray = [[QYCarModel alloc] objectArrayWithKeyValuesArray:responseObject];
    
        if (type == 1) {
            if (tempArray.count == 0) {
                [SVProgressHUD showImage:nil status:@"非常抱歉\n没有找到你想要的车" duration:2 complete:nil];
                return;
            }
            self.data = tempArray;
            [_tableView reloadData];
        }else if (type == 2) {
            [self.data addObjectsFromArray:tempArray];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }
        if (type == 1) {
            if (tempArray.count != 0) {
                [SVProgressHUD dismiss];
                self.navigationController.view.userInteractionEnabled = YES;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showImage:nil status:@"网路连接失败!\n请检查网络后重试" duration:2 complete:nil];
    }];
}

#pragma mark - table view dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *cellIdtifier = @"carCell";
    
    QYCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdtifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:nil][0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _data[indexPath.row];
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QYCarDetailsViewController *carVC = [[QYCarDetailsViewController alloc] init];
    carVC.carModel = self.data[indexPath.row];
    carVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:carVC animated:YES];
    
    // 存储到数据库的浏览历史
    [[QYDBFileManager sharedDBManager] saveData2Local:self.data[indexPath.row] class:kWatchTable];
}


@end
