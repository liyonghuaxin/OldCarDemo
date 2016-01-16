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


@interface QYBuyViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;//保存数据的数组
@property (nonatomic, strong) NSMutableDictionary *parameters;//请求的参数
@property (nonatomic, strong) UIBarButtonItem *leftbarBtnItem;//导航栏左侧的item

@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSDictionary *cityModel;

@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UIButton *brandBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *vprBtn;
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
        case sortButtonTag:{//点击排序
            QYSortView *sortView = [[QYSortView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 200)];
            [self.view addSubview:sortView];
        }
            break;
        case brandButtonTag:{//点击品牌
            QYBrandViewController *brandVC = [[QYBrandViewController alloc] init];
            UINavigationController *navigaVC = [[UINavigationController alloc] initWithRootViewController:brandVC];
            self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:navigaVC animated:YES completion:nil];
            
        }
            break;
        case priceButtonTag:{//点击价格
            
        }
            break;
        case vprButotonTag:{//点击性能
            
        }
            break;
        default:
            break;
    }
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
//    NSDictionary *parameters = @{@"city":@"11",@"page":@"1",@"prov":@"11"};
    
    
    [manager POST:kCarsListUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        self.dataArray = [[QYCarModel alloc] objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (UIImage *)loadImageFormNetWork:(NSString *)imageUrl {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
    UIImage *image;
    
    [manager GET:imageUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"下载图片失败----%@",error);
    }];
    return image;
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


#pragma mark - ***************** life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
  
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubViews];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    _cityModel = [[NSUserDefaults standardUserDefaults] objectForKey:kcityModel];
    if (self.cityModel) {
        _pageIndex = 1;
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:self.cityModel[@"city_id"] forKey:@"city"];
        [_parameters setValue:@(_pageIndex) forKey:@"page"];
        [_parameters setValue:self.cityModel[@"prov_id"] forKey:@"prov"];
        _leftbarBtnItem.title = self.cityModel[@"city_name"];
        
    }else {
        _pageIndex = 1;
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:@1 forKey:@"city"];
        [_parameters setValue:@(_pageIndex) forKey:@"page"];
        [_parameters setValue:@1 forKey:@"prov"];
    }
    [self downloadDataFromNetwork:self.parameters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
