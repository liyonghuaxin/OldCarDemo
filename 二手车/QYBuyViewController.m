//
//  QYBuyViewController.m
//  二手车
//
//  Created by qingyun on 16/1/3.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYBuyViewController.h"
#import "Header.h"
#import <AFNetworking.h>
#import "QYCarModel.h"
#import "QYCarTableViewCell.h"
#import "QYCarTableViewController.h"
#import "QYCityListViewController.h"
#import "QYCityModel.h"

@interface QYBuyViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *parameters;//请求的参数

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftbarBtnItem;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSDictionary *cityModel;
@end

@implementation QYBuyViewController
static NSString *cellIdentifier = @"MTCell";

#pragma mark - ************* 懒加载
//数据
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



#pragma mark - *************** 切换城市或定位
- (IBAction)switchCity:(UIBarButtonItem *)sender {
    QYCityListViewController *cityVC = [[QYCityListViewController alloc] init];
    
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark - ************* 子视图
- (void)addSubViews {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREENW, KSCReENH) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 80;
    //注册单元格
    [_tableView registerNib:[UINib nibWithNibName:@"QYCarTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
}

#pragma mark - *************  请求数据

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
    
    
    QYCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[QYCarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - ************* tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYCarTableViewController *carVC = [[UIStoryboard storyboardWithName:@"CarStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"carTableVC"];
    
    carVC.carModel = self.dataArray[indexPath.row];

    [self.navigationController pushViewController:carVC animated:YES];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutManager:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




#pragma mark - ***************** viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self addSubViews];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
