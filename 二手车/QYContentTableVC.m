//
//  QYContentTableVC.m
//  二手车
//
//  Created by qingyun on 16/1/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYContentTableVC.h"
#import "QYNetworkTools.h"
#import "Header.h"
#import "QYNewsModel.h"
#import "QYCustomNewCell.h"
#import "QYDetailNewsVC.h"
#import <MJRefresh.h>

@interface QYContentTableVC ()

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation QYContentTableVC
static NSString *Identifier = @"cell";

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAndSubviews];
}

- (void)createAndSubviews {
    self.tableView.rowHeight = 90;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshData)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshData)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QYCustomNewCell" bundle:nil] forCellReuseIdentifier:Identifier];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_index == 0) {
        [self initParameters];
//         [_parameters setObject:@"xinche" forKey:@"tpye"];
        [self loadDataWithParameters:_parameters andType:1];
    }else if (_index == 1) {
        [self initParameters];
//        [_parameters setObject:@"xinche" forKey:@"tpye"];
        [self loadDataWithParameters:_parameters andType:1];
    }
}

- (void)initParameters {
    _pageIndex = 1;
    _parameters = [NSMutableDictionary dictionary];
    [_parameters setObject:@"0" forKey:@"flash"];
    [_parameters setObject:@"10" forKey:@"num"];
    [_parameters setObject:@"0" forKey:@"start"];
}

#pragma mark - 方法
// 下拉刷新
- (void)headerRefreshData {
    _pageIndex = 1;
    [_parameters setObject:@((_pageIndex-1) * 10) forKey:@"start"];
    [self loadDataWithParameters:_parameters andType:1];
}

// 上拉加载
- (void)footerRefreshData {
    _pageIndex++;
    [_parameters setObject:@((_pageIndex-1) * 10) forKey:@"start"];
    [self loadDataWithParameters:_parameters andType:2];
}

#pragma mark - 请求数据
- (void)loadDataWithParameters:(NSMutableDictionary *)parameters andType:(int)type {
    [[[QYNetworkTools sharedNetworkTools] POST:kGuideBaseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (type == 1) {
            _data = [NSMutableArray array];
            for (NSDictionary *dict in responseObject) {
                QYNewsModel *newsModel = [[QYNewsModel alloc] initWithDict:dict];
                [_data addObject:newsModel];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }
        }else if (type == 2) {
            for (NSDictionary *dict in responseObject) {
                QYNewsModel *newsModel = [[QYNewsModel alloc] initWithDict:dict];
                [_data addObject:newsModel];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@", error);
    }] resume];

}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYCustomNewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    QYNewsModel *newsModel = _data[indexPath.row];
    cell.newsModel = newsModel;
    return cell;
}

#pragma mark - table view delegae
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QYDetailNewsVC *detailVC = [[QYDetailNewsVC alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    QYNewsModel *model = _data[indexPath.row];
    detailVC.url = model.url;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
