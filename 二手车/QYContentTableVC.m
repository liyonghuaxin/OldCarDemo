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
#import <SVProgressHUD.h>
#import "QYDBFileManager.h"

@interface QYContentTableVC ()

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, assign) BOOL isFristLoad;

@end

@implementation QYContentTableVC
static NSString *Identifier = @"cell";
- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAndSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createAndSubviews {
    self.tableView.rowHeight = 90;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(selectControllerIndex)];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshData)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QYCustomNewCell" bundle:nil] forCellReuseIdentifier:Identifier];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 判断是否第一次
    if (!_isFristLoad) {
        if (_index == 0) {
            NSMutableArray *tempArr = [[QYDBFileManager sharedDBManager] selectAllDataFromGuide];
            if (tempArr.count != 0) {
                self.data = tempArr;
                [self.tableView reloadData];
                _isFristLoad = YES;
            }else {
                [self selectControllerIndex];
                _isFristLoad = YES;
            }
        }else {
            [self selectControllerIndex];
            _isFristLoad = YES;
        }
    }
}

- (void)selectControllerIndex {
    [SVProgressHUD show];
    if (_index == 0) {
        [self initParameters];
        [_parameters setObject:@"tuijian" forKey:@"tpye"];
        [_parameters setObject:@"0" forKey:@"start"];
        [self loadDataWithParameters:_parameters andType:1];
    }else if (_index == 1) {
        [self initParameters];
        [_parameters setObject:@"daogou" forKey:@"tpye"];
        [_parameters setObject:@"100" forKey:@"start"];
        [self loadDataWithParameters:_parameters andType:1];
    }else if (_index == 2) {
        [self initParameters];
        [_parameters setObject:@"hangye" forKey:@"tpye"];
        [_parameters setObject:@"200" forKey:@"start"];
        [self loadDataWithParameters:_parameters andType:1];
    }
}

// 公共参数
- (void)initParameters {
    _parameters = [NSMutableDictionary dictionary];
    [_parameters setObject:@"0" forKey:@"flash"];
    [_parameters setObject:@"10" forKey:@"num"];
}

#pragma mark - 方法
// 上拉加载
- (void)footerRefreshData {
    _pageIndex++;
    [_parameters setObject:@((_pageIndex-1) * 10) forKey:@"start"];
    [self loadDataWithParameters:_parameters andType:2];
}

#pragma mark - 请求数据
- (void)loadDataWithParameters:(NSMutableDictionary *)parameters andType:(int)type {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", @"application/x-www-form-urlencoded", nil];
    manager.requestSerializer.timeoutInterval = 15;
    [manager POST:kGuideBaseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (type == 1) {
            for (NSDictionary *dict in responseObject) {
                QYNewsModel *newsModel = [[QYNewsModel alloc] initWithDict:dict];
                [self.data addObject:newsModel];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [SVProgressHUD dismiss];
            }
            
            if (_index == 0) {
                // 删除
               [[QYDBFileManager sharedDBManager] deleteDataFromGuideTable];
                // 存储
                for (NSDictionary *dict in responseObject) {
                    QYNewsModel *newsModel = [[QYNewsModel alloc] initWithDict:dict];
                    [[QYDBFileManager sharedDBManager] saveData2GuideTable:newsModel];
                }
            }
        }else if (type == 2) {
            for (NSDictionary *dict in responseObject) {
                QYNewsModel *newsModel = [[QYNewsModel alloc] initWithDict:dict];
                [self.data addObject:newsModel];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showImage:nil status:@"网络连接失败!\n请检查网络后重试" duration:2 complete:nil];
    }];
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
