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
#import "AppDelegate.h"

#import "QYCityModel.h"
#import "QYCarModel.h"
#import "QYBrandModel.h"
#import "QYServiceModel.h"
#import "QYParametersManager.h"

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
@property (nonatomic, strong) NSDictionary *brandModel;// 品牌模型
@property (nonatomic, assign) NSInteger pageIndex; // 页数

@property (nonatomic, strong) NSArray *sortkeys;// 排序方式
@property (nonatomic, assign) NSInteger sortModel;// 排序方式

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

// 排序方式的键
- (NSArray *)sortkeys {
    if (_sortkeys == nil) {
        _sortkeys = @[@"postDateSort",@"priceSort",@"mileSort",@"regDateSort",@"vprSort"];
    }
    return _sortkeys;
}

#pragma mark - *************** 点击事件
// 跳转到城市列表
- (void)switchCity:(UIBarButtonItem *)sender {
    QYCityListViewController *cityVC = [[QYCityListViewController alloc] init];
    // 回调
    MTWeak(self, weakSelf);
    cityVC.changeCityBlock = ^{
        [weakSelf loadDataWithBasicParameters];
    };
    
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
    // 判断当前显示的本身
    if (_openBtnIndex != sortButtonTag) {
        [_openView removeFromSuperview];
        QYSortView *sortView = [[QYSortView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight)];
        [[[UIApplication sharedApplication].delegate window] addSubview:sortView];
        // 关闭这个view
        sortView.isCloseBlock = ^{
            _openBtnIndex = 0;
            [_openView removeFromSuperview];
        };
        
        /**
         *  选择排序方式 只能有一种排序方式
         */
        MTWeak(self, weakSelf);
        sortView.changeParameterBlock = ^(NSString *key, NSString *value, NSString *title){
            // 移除当前的视图
            [_openView removeFromSuperview];
            _openBtnIndex = 0;
            
            // 改变当前排序的btn的颜色及标题
            if ([title isEqualToString:@"默认排序"]) {
                [weakSelf changBtnProperty:_sortBtn title:title titleColor:[UIColor darkGrayColor]];
            }else {
                [weakSelf changBtnProperty:_sortBtn title:title titleColor:[UIColor orangeColor]];
            }
            if (_sortModel == 2) {
                [_vprBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
            _sortModel = 1;
            // 判断现在是否已经有排序方式 如果有 移除当前的排序方式
            for (NSString *sortModel in self.sortkeys) {
                for (NSString *sortKey in _parameters.allKeys) {
                    if ([sortModel isEqualToString:sortKey]) {
                        [_parameters removeObjectForKey:sortKey];
                    }
                }
            }
            // 添加排序方式
            [_parameters setObject:value forKey:key];
            [weakSelf downloadDataFromNetwork:_parameters];
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
    // 如果有打开的view 关闭
    [_openView removeFromSuperview];
    _openBtnIndex = 0;
    
    QYBrandViewController *brandVC = [[QYBrandViewController alloc] init];

    /**
     *  品牌参数的改变的回调 主要改变btn的标题及颜色 改变请求品牌的参数 然后请求数据
     */
    MTWeak(self, weakSelf);
    brandVC.changeBrandBlock = ^(QYBrandModel *brandModel, QYServiceModel *serviceModel) {
        // 判断选择的品牌类型
        if (serviceModel != nil) {
            if ([serviceModel.series isEqualToString:@"0"]) {
                // 不限车系
                [weakSelf changBtnProperty:_brandBtn title:brandModel.brandName titleColor:[UIColor orangeColor]];
                [_parameters removeObjectForKey:kSeriesId];
                [_parameters removeObjectForKey:kSeriesName];
                [_parameters setObject:brandModel.brandId forKey:kBrandId];
                [_parameters setObject:brandModel.brandName forKey:kBrandName];
            }else {
                // 改变颜色
                [weakSelf changBtnProperty:_brandBtn title:serviceModel.seriesName titleColor:[UIColor orangeColor]];
                // 参数改变
                [_parameters setObject:serviceModel.series forKey:kSeriesId];
                [_parameters setObject:serviceModel.seriesName forKey:kSeriesName];
                [_parameters setObject:brandModel.brandId forKey:kBrandId];
                [_parameters setObject:brandModel.brandName forKey:kBrandName];
            }
        }else {
            // 点击不限品牌时
            [weakSelf changBtnProperty:_brandBtn title:@"品牌" titleColor:[UIColor darkGrayColor]];
            [_parameters removeObjectForKey:kSeriesId];
            [_parameters removeObjectForKey:kSeriesName];
            [_parameters removeObjectForKey:kBrandId];
            [_parameters removeObjectForKey:kBrandName];
        }
        // 请求数据
        [weakSelf downloadDataFromNetwork:_parameters];
    };
    
    UINavigationController *navigaVC = [[UINavigationController alloc] initWithRootViewController:brandVC];
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigaVC animated:YES completion:nil];
}

// 点击第三个价格按钮
- (void)priceBtnClick {
    if (_openBtnIndex != priceButtonTag) {//当前打开的view不等于价格
        [_openView removeFromSuperview];
        QYPriceView *priceView = [[QYPriceView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight)];
        [[[UIApplication sharedApplication].delegate window] addSubview:priceView];
        
        // 关闭view时改变
        priceView.isCloseBlock = ^{
            [_openView removeFromSuperview];
            _openBtnIndex = 0;
        };
        
        // 改变价格
        MTWeak(self, weakSelf);
        priceView.changePriceBlock = ^(NSString *price, NSString *title){
            // 改变btn的颜色和字体
            if ([price isEqualToString:@"0"]) {
                [weakSelf changBtnProperty:_priceBtn title:title titleColor:[UIColor darkGrayColor]];
            }else {
                [weakSelf changBtnProperty:_priceBtn title:title titleColor:[UIColor orangeColor]];
            }
            
            // 移除视图
            [_openView removeFromSuperview];
            _openBtnIndex = 0;
            
            //改变价格参数 请求数据
            [_parameters setObject:price forKey:kPrice];
            [weakSelf downloadDataFromNetwork:_parameters];
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
    if (_openView) {
        [_openView removeFromSuperview];
        _openBtnIndex = 0;
    }
    
    // 判断现在是否已经有排序方式 如果有 移除当前的排序方式
    for (NSString *sortModel in self.sortkeys) {
        for (NSString *sortKey in _parameters.allKeys) {
            if ([sortModel isEqualToString:sortKey]) {
                [_parameters removeObjectForKey:sortKey];
            }
        }
    }
    if (_sortModel == 2) {
        _sortModel = 0;
        [_vprBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }else  {
        if (_sortModel == 1) {
            [self changBtnProperty:_sortBtn title:@"默认排序" titleColor:[UIColor darkGrayColor]];
        }
        [_parameters setObject:@"desc" forKey:kVprSort];
        [_vprBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _sortModel = 2;
    }
    [self downloadDataFromNetwork:_parameters];
}

#pragma mark - ************* 子视图
- (void)addSubViews {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight-160) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 84;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //barBtnItem
    _leftbarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStyleDone target:self action:@selector(switchCity:)];
    self.navigationItem.leftBarButtonItem = _leftbarBtnItem;
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchCars:)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

#pragma mark - 请求数据
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
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYCarDetailsViewController *carVC = [[QYCarDetailsViewController alloc] init];
    carVC.carModel = self.dataArray[indexPath.row];
    carVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:carVC animated:YES];
    
}

#pragma mark - 公用方法

// 请求数据 (改变城市)
- (void)loadDataWithBasicParameters {
    _pageIndex = 1;
    _parameters = [[QYParametersManager shaerdParameters] fristLoadParameters];
    [_parameters setObject:[@(_pageIndex) stringValue] forKey:kPage];
    // 改变城市的名字
    _leftbarBtnItem.title = self.parameters[kCityName];
    
    // 改变价格btn 的名字和颜色
    NSString *priceBtnTitle = [[NSUserDefaults standardUserDefaults] stringForKey:KpriceBtnTitle];
    if (priceBtnTitle) {
        if ([_parameters[kPrice] isEqualToString:@"0"]) {
            [_priceBtn setTitle:priceBtnTitle forState:UIControlStateNormal];
        }else {
            [_priceBtn setTitle:priceBtnTitle forState:UIControlStateNormal];
            [_priceBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
    }
    
    [self downloadDataFromNetwork:self.parameters];
}

// 改变上面四个btn的颜色和文字
- (void)changBtnProperty:(UIButton *)sender title:(NSString *)title titleColor:(UIColor *)color {
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:color forState:UIControlStateNormal];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubViews];
    self.title = @"二手车";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    // 判断是否第一次
    if (!_isFristLoad) {
        _parameters = [NSMutableDictionary dictionary];
        [self loadDataWithBasicParameters];
        _isFristLoad = YES;
    }
} 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
