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

@interface QYSearchCarListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *parameters;

@property (nonatomic, assign) BOOL isFristLoad;
@end

@implementation QYSearchCarListVC
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_isFristLoad) {
        _parameters =[NSMutableDictionary dictionary];
        // 加载保存的城市
        NSDictionary *cityModel = [[NSUserDefaults standardUserDefaults] objectForKey:kcityModel];
        // 城市
        [_parameters setValue:cityModel[kCityId] forKey:kCityId];
        [_parameters setValue:cityModel[kProvId] forKey:kProvId];
        [_parameters setValue:cityModel[kCityName] forKey:kCityName];
        if (_type == 1) {
            [_parameters setObject:_brandId forKey:kBrandId];
            [_parameters setObject:_brandName forKey:kBrandName];
        }else {
            [_parameters setObject:_seriesId forKey:kSeriesId];
            [_parameters setObject:_seriesName forKey:kSeriesName];
        }
        [self loadDataWithParameters:_parameters];
        _isFristLoad = YES;
    }
}

#pragma mark - subviews
- (void)createAndAddSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 方法
- (void)loadMoreData {
    
}

// 请求数据
- (void)loadDataWithParameters:(NSDictionary *)parameters {
    [[QYNetworkTools sharedNetworkTools] POST:kCarsListUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}


@end
