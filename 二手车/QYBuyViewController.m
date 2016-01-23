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

#import <AFHTTPSessionManager.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

#import "QYDBFileManager.h"
#import "QYCityModel.h"
#import "QYCarModel.h"
#import "QYBrandModel.h"
#import "QYServiceModel.h"
#import "QYParametersManager.h"
#import "QYNetworkTools.h"

#import "Header.h"
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
        NSDictionary *cityModel = [[NSUserDefaults standardUserDefaults] objectForKey:kcityModel];
        [_parameters setValue:cityModel[kCityId] forKey:kCityId];
        [_parameters setValue:cityModel[kProvId] forKey:kProvId];
        [_parameters setValue:cityModel[kCityName] forKey:kCityName];
        // 改变城市的名字
        _leftbarBtnItem.title = cityModel[kCityName];
        [weakSelf loadDataForType:1];
    };
    
    UINavigationController *navigaVC = [[UINavigationController alloc] initWithRootViewController:cityVC];
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (_openView) {
        [_openView removeFromSuperview];
        _openBtnIndex = 0;
    }
    [self presentViewController:navigaVC animated:YES completion:nil];
    
}

// 搜素
- (void)searchCars:(UIBarButtonItem *)sender {
    QYSearchViewController *searchVC = [[QYSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
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
            [weakSelf loadDataForType:1];
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
                // 持久化存储
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSeriesName];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSeriesId];
                [[NSUserDefaults standardUserDefaults] setObject:brandModel.brandId forKey:kBrandId];
                [[NSUserDefaults standardUserDefaults] setObject:brandModel.brandName forKey:kBrandName];
               // 改变参数
                [_parameters removeObjectsForKeys:@[kSeriesName,kSeriesId]];
                [_parameters setObject:brandModel.brandName forKey:kBrandName];
                [_parameters setObject:brandModel.brandId forKey:kBrandId];
            }else {
                // 改变颜色
                [weakSelf changBtnProperty:_brandBtn title:serviceModel.seriesName titleColor:[UIColor orangeColor]];
                // 持久化
                [[NSUserDefaults standardUserDefaults] setObject:brandModel.brandId forKey:kBrandId];
                [[NSUserDefaults standardUserDefaults] setObject:brandModel.brandName forKey:kBrandName];
                [[NSUserDefaults standardUserDefaults] setObject:serviceModel.series forKey:kSeriesId];
                [[NSUserDefaults standardUserDefaults] setObject:serviceModel.seriesName forKey:kSeriesName];
                // 参数改变
                [_parameters setObject:brandModel.brandName forKey:kBrandName];
                [_parameters setObject:brandModel.brandId forKey:kBrandId];
                [_parameters setObject:serviceModel.seriesName forKey:kSeriesName];
                [_parameters setObject:serviceModel.series forKey:kSeriesId];
            }
        }else {
            // 点击不限品牌时
            [weakSelf changBtnProperty:_brandBtn title:@"品牌" titleColor:[UIColor darkGrayColor]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSeriesName];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSeriesId];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBrandName];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBrandId];
            [_parameters removeObjectsForKeys:@[kBrandId,kBrandName,kSeriesId,kSeriesName]];
        }
        // 请求数据
        [weakSelf loadDataForType:1];
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
                [weakSelf changBtnProperty:_priceBtn title:@"价格" titleColor:[UIColor darkGrayColor]];
            }else {
                [weakSelf changBtnProperty:_priceBtn title:title titleColor:[UIColor orangeColor]];
            }
            
            // 移除视图
            [_openView removeFromSuperview];
            _openBtnIndex = 0;
            
            //改变价格参数 请求数据
            [_parameters setObject:price forKey:kPrice];
            [weakSelf loadDataForType:1];
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
    [self loadDataForType:1];
}

#pragma mark - ************* 子视图
- (void)addSubViews {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight-160) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 84;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerLoadData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadData)];
    
    //barBtnItem
    _leftbarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStyleDone target:self action:@selector(switchCity:)];
    self.navigationItem.leftBarButtonItem = _leftbarBtnItem;
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchCars:)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}
#pragma mark - 刷新数据
// 下拉刷新
- (void)headerLoadData {
    [self loadDataForType:1];
}

// 上拉加载
- (void)footerLoadData {
    _pageIndex ++;
    [_parameters setObject:[@(_pageIndex) stringValue] forKey:kPage];
    [self loadDataForType:2];
}

// 请求数据
- (void)loadDataForType:(int)type {
    if (type == 1) {
        [SVProgressHUD show];
    }
    [[QYNetworkTools sharedNetworkTools] POST:kCarsListUrl parameters:_parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *tempArray = [[QYCarModel alloc] objectArrayWithKeyValuesArray:responseObject];

        if (type == 1) {
            self.dataArray = tempArray;
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
            if (tempArray.count != 0) {
                [SVProgressHUD dismiss];
            }
        }else if (type == 2) {
            [self.dataArray addObjectsFromArray:tempArray];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];
        }
        
        if (tempArray.count != 0) {
            // 删除
            [[QYDBFileManager sharedDBManager] deleteLocalAllData:kCarTable];
            // 存储到数据库
            for (QYCarModel *model in tempArray) {
                [[QYDBFileManager sharedDBManager] saveData2Local:model class:kCarTable];
            }
        }
        
        if (tempArray.count == 0) {
            [SVProgressHUD showImage:nil status:@"非常抱歉，没有找到你想要的车" duration:2 complete:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NSThread sleepForTimeInterval:2];
        if (type == 1) {
            [_tableView.mj_header endRefreshing];
        }else {
            [_tableView.mj_footer endRefreshing];
        }
        [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
        [SVProgressHUD showImage:nil status:@"网络连接失败！请检查网络后重试"];

    }];
}

#pragma mark - table view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdtifier = @"carCell";
    QYCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdtifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > 0) {
         cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYCarDetailsViewController *carVC = [[QYCarDetailsViewController alloc] init];
    carVC.carModel = self.dataArray[indexPath.row];
    carVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:carVC animated:YES];
    
    // 存储到数据库的浏览历史
    [[QYDBFileManager sharedDBManager] saveData2Local:self.dataArray[indexPath.row] class:kWatchTable];
}

#pragma mark - 公用方法

// 请求数据 (改变城市)
- (void)loadDataWithBasicParameters {
     _parameters = [NSMutableDictionary dictionary];
    _pageIndex = 1;
    _parameters = [[QYParametersManager shaerdParameters] fristLoadParameters];
    [_parameters setObject:[@(_pageIndex) stringValue] forKey:kPage];
    // 改变城市的名字
    _leftbarBtnItem.title = self.parameters[kCityName];
    
    // 改变btn 的名字和颜色
    if (!_isFristLoad) {
        [self setBtnsTitleWithFristLoad];
    }
}

// 第一次加载页面时btn的标题和颜色
- (void)setBtnsTitleWithFristLoad {
    // 品牌
    NSString *brandName = [[NSUserDefaults standardUserDefaults] stringForKey:kBrandName];
     NSString *seresName = [[NSUserDefaults standardUserDefaults] stringForKey:kSeriesName];
    if (brandName) {
        if (seresName) {
            [self changBtnProperty:_brandBtn title:seresName titleColor:[UIColor orangeColor]];
        }else {
            [self changBtnProperty:_brandBtn title:brandName titleColor:[UIColor orangeColor]];
        }
    }else {
        [self changBtnProperty:_brandBtn title:@"品牌" titleColor:[UIColor darkGrayColor]];
    }
    
    // 价格
    NSString *priceBtnTitle = [[NSUserDefaults standardUserDefaults] stringForKey:KpriceBtnTitle];
    if (priceBtnTitle) {
        if ([priceBtnTitle isEqualToString:@"不限"]) {
            [self changBtnProperty:_priceBtn title:@"价格" titleColor:[UIColor darkGrayColor]];
        }else {
            [_priceBtn setTitle:priceBtnTitle forState:UIControlStateNormal];
            [_priceBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
    }
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
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [self addSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 判断是否第一次
    if (!_isFristLoad) {
        self.dataArray = [[QYDBFileManager sharedDBManager] selectAllData:kCarTable];
        if (self.dataArray.count != 0) {
            [self loadDataWithBasicParameters];
            [_tableView reloadData];
        }else {
            [self loadDataWithBasicParameters];
            [self loadDataForType:1];
        }
        _isFristLoad = YES;
    }
} 

@end
