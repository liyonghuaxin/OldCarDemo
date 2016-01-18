//
//  QYBrandViewController.m
//  二手车
//
//  Created by qingyun on 16/1/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYBrandViewController.h"
#import "Header.h"
#import "QYBrandModel.h"
#import "QYBrandTableViewCell.h"
#import <AFHTTPSessionManager.h>
#import "QYServiceListView.h"

@interface QYBrandViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) UIView *serviceView;
@end

@implementation QYBrandViewController
static NSString *cellIdentifier = @"brandCell";

#pragma mark - ********** life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加子视图
    [self createAndAddSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //加载数据
    [self loadBrandList];
}

#pragma mark - **********  添加子视图
- (void)createAndAddSubviews {

    //导航栏设置
    self.title = @"车型选择";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"prov_select"] style:UIBarButtonItemStyleDone target:self action:@selector(backToBuyVC)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //tablView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionIndexColor = [UIColor grayColor];
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //注册
    [tableView registerNib:[UINib nibWithNibName:@"QYBrandTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - ********点击事件
- (void)backToBuyVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ********** 加载品牌数据
- (void)loadBrandList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"brand" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

    _dict = [NSMutableDictionary dictionary];
    _dict = dict[@"brand"];
    _keys = [NSArray array];
    _keys = [dict[@"initial"] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - 请求车系列表

- (void)loadServiceList:(NSDictionary *)parameters {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [manager POST:kServiceListUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *keys = responseObject[@"keys"];
        NSDictionary *data = responseObject[@"data"];
        [self addServiceListView:keys data:data];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
}

#pragma mark - 加载车系视图
- (void)addServiceListView:(NSArray *)keys data:(NSDictionary *)data {
    QYServiceListView *serviceView = [[QYServiceListView alloc] initWithFrame:CGRectMake(kScreenWidth, 64, kScreenWidth/2, kScreenHeight)];
    serviceView.keys = keys;
    serviceView.data = data;
    [self.view addSubview:serviceView];
    _serviceView = serviceView;
    
    // 开始动画
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint center = serviceView.center;
        center.x = kScreenWidth * 3 / 4;
        serviceView.center = center;
    }];
    
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dict[_keys[section]];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[QYBrandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray *array = _dict[_keys[indexPath.section]];
    QYBrandModel *brandModel = [[QYBrandModel alloc] initWithDict:array[indexPath.row]];
    cell.brandModel = brandModel;
    return cell;
}

#pragma mark - table view delegate
// 头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _keys[section];
}

// 设置索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _keys;
}

// 点击索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_serviceView) {
        // 开始动画
        [UIView animateWithDuration:0.3f animations:^{
            CGPoint center = _serviceView.center;
            center.x = kScreenWidth * 3 / 4;
            _serviceView.center = center;
        }];
        [_serviceView removeFromSuperview];
    }
    NSArray *array = _dict[_keys[indexPath.section]];
    QYBrandModel *brandModel = [[QYBrandModel alloc] initWithDict:array[indexPath.row]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:brandModel.brandId forKey:@"brand"];
    [self loadServiceList:dict];
   
}




@end
