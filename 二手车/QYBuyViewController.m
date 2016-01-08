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

@interface QYBuyViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation QYBuyViewController
static NSString *cellIdentifier = @"MTCell";

#pragma mark - ************* 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - ************* 子视图 ********************
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

- (void)downloadDataFromNetwork {
    
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlStr = @"http://dingjia.che300.com/api/v224/util/car/car_list";

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSDictionary *parameters = @{@"app_channel":@"local",@"app_type":@"ios_csb",@"city":@"11",@"device_id":@"44D1E5AA-9A6C-4ED8-A9BE-AF70CB4179E5",@"page":@"1",@"platform":@"ios",@"postDateSort":@"desc",@"prov":@"11",@"version":@"2.2.4"};
    
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

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

#pragma mark - ************* tableView delegate ******************

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
    
    [self downloadDataFromNetwork];
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
