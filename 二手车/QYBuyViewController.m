//
//  QYBuyViewController.m
//  二手车
//
//  Created by qingyun on 16/1/3.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYBuyViewController.h"
#import "QYCarDetailsViewController.h"
#import "QYCityListViewController.h"
#import "QYSearchViewController.h"
#import "QYBrandViewController.h"

#import "QYCityModel.h"
#import "QYCarModel.h"

#import "Header.h"
#import <AFNetworking.h>
#import "QYCarTableViewCell.h"
#import "QYSortView.h"
#import "QYPriceView.h"

@interface QYBuyViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;// 保存数据的数组
@property (nonatomic, strong) NSMutableDictionary *parameters;// 请求的参数的数组
@property (nonatomic, strong) UIBarButtonItem *leftbarBtnItem;// 导航栏左侧的item

@property (nonatomic, assign) BOOL isFristLoad;// 判断是否是第一次加载界面
// 搜索车源的参数
@property (nonatomic, strong) NSString *price;// 价格范围
@property (nonatomic, strong) NSDictionary *brandModel;// 品牌模型
@property (nonatomic, assign) NSInteger pageIndex; // 页数
@property (nonatomic, strong) NSDictionary *cityModel;// 城市
@property (nonatomic, strong) NSDictionary *sortModel;// 排序方式


@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *vprBtn;
@property (nonatomic, assign) NSInteger openBtnIndex; // 记录打开的btn的下标
@property (nonatomic, strong) UIView *openView; // 打开的view
@end

@implementation QYBuyViewController
static NSString *cellIdtifier = @"carCell";
#pragma mark - ************* 懒加载
//数据
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - *************** 点击事件
// 切换城市
- (void)switchCity:(UIBarButtonItem *)sender {
    QYCityListViewController *cityVC = [[QYCityListViewController alloc] init];
    UINavigationController *navigaVC = [[UINavigationController alloc] initWithRootViewController:cityVC];
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigaVC animated:YES completion:nil];
    
}

// 搜素
- (void)searchCars:(UIBarButtonItem *)sender {
    QYSearchViewController *searchVC = [[QYSearchViewController alloc] init];
    UINavigationController *navigaVC = [[UINavigationController alloc] initWithRootViewController:searchVC];
    navigaVC.navigationBar.tintColor = [UIColor orangeColor];
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navigaVC animated:YES completion:nil];
}

// buttons 事件
- (IBAction)btnsClick:(UIButton *)sender {
    switch (sender.tag) {
        case sortButtonTag:
            [self sortBtnClick];// 点击第一个排序的btn
            break;
        case brandButtonTag:
            [self brandBtnClick];//点击品牌按钮
            break;
        case priceButtonTag:
            [self priceBtnClick];//点击价格
            break;
        case vprButotonTag:
            [self vprBtnClick];//点击性价比
            break;
        default:
            break;
    }
}

#pragma mark - 四个菜单的点击事件的具体实现
// 点击第一个排序方式
- (void)sortBtnClick {
    //判断当前显示的本身
    if (_openBtnIndex != sortButtonTag) {
        [_openView removeFromSuperview];
        QYSortView *sortView = [[QYSortView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight)];
        [self.view addSubview:sortView];
        
        //关闭这个view
        sortView.isCloseBlock = ^{
            _openBtnIndex = 0;
            [_openView removeFromSuperview];
        };
        
        //选择排序方式
        sortView.changeParameterBlock = ^(NSDictionary *dict){
            [_parameters setDictionary:dict];
            _openView = sortView;
            _openBtnIndex = 0;
        };
        _openView = sortView;
        _openBtnIndex = sortButtonTag;
    }else {
        [_openView removeFromSuperview];
        _openBtnIndex = 0;
    }
}

// 第二个品牌选择
- (void)brandBtnClick {
    QYBrandViewController *brandVC = [[QYBrandViewController alloc] init];
    UINavigationController *navigaVC = [[UINavigationController alloc] initWithRootViewController:brandVC];
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigaVC animated:YES completion:^{
        // 如果有打开的view 关闭
        [_openView removeFromSuperview];
        _openBtnIndex = 0;
    }];
}

// 点击第三个价格按钮
- (void)priceBtnClick {
    if (_openBtnIndex != priceButtonTag) {//当前打开的view不等于价格
        [_openView removeFromSuperview];
        QYPriceView *priceView = [[QYPriceView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight)];
        [self.view addSubview:priceView];
        
        // 关闭view时改变
        priceView.isCloseBlock = ^{
            [_openView removeFromSuperview];
            _openBtnIndex = 0;
        };
        
        // 改变价格
        priceView.changePriceBlock = ^(NSDictionary *dict){
            [_parameters setDictionary:dict];
            [_openView removeFromSuperview];
            _openBtnIndex = 0;
        };
        _openView = priceView;
        _openBtnIndex = priceButtonTag;
    }else {
        [_openView removeFromSuperview];
        _openBtnIndex = 0;
    }
}

// 点击性价比的btn
- (void)vprBtnClick {
    [_openView removeFromSuperview];
    _openBtnIndex = 0;
}

#pragma mark - ************* 子视图
- (void)addSubViews {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 80;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //barBtnItem
    _leftbarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStyleDone target:self action:@selector(switchCity:)];
    self.navigationItem.leftBarButtonItem = _leftbarBtnItem;
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchCars:)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

#pragma mark - *************  请求数据
// 请求数据
- (void)downloadDataFromNetwork:(NSDictionary *)parameters {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];

    [manager POST:kCarsListUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.dataArray = [[QYCarModel alloc] objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - table view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdtifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:nil][2];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - ************* tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYCarDetailsViewController *carVC = [[QYCarDetailsViewController alloc] init];
    carVC.carModel = self.dataArray[indexPath.row];
    carVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:carVC animated:YES];
    
}

#pragma mark - 改变参数 或者 第一次进入界面重新请求数据
//第一次请求数据
- (void)fristLoadData {
    // 加载保存的城市
    _cityModel = [[NSUserDefaults standardUserDefaults] objectForKey:kcityModel];
     _parameters = [NSMutableDictionary dictionary];
    _pageIndex = 1;
    if (self.cityModel) {
        [_parameters setValue:self.cityModel[@"city_id"] forKey:@"city"];
        [_parameters setValue:@(_pageIndex) forKey:@"page"];
        [_parameters setValue:self.cityModel[@"prov_id"] forKey:@"prov"];
        _leftbarBtnItem.title = self.cityModel[@"city_name"];
        
    }else {
        [_parameters setValue:@1 forKey:@"city"];
        [_parameters setValue:@(_pageIndex) forKey:@"page"];
        [_parameters setValue:@1 forKey:@"prov"];
    }
    [self downloadDataFromNetwork:self.parameters];
  
}

// 参数改变
- (void)changParameters {
    // 加载保存的城市
    _cityModel = [[NSUserDefaults standardUserDefaults] objectForKey:kcityModel];
//    price 20-35;
//    priceSort desc 价格最高 asc最低
//    vprSort desc
//    brand 0
//    mileSort asc
//    regDateSort desc 车龄最短
    
//    默认排序 postDateSort desc
    
}

#pragma mark - ***************** life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 请求数据
    
    // 判断是第一次 还是改变参数
    if (!_isFristLoad) {
        //第一次加载
        [self fristLoadData];
        _isFristLoad = YES;
    }else {
        //参数改变
//        [self ]
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
