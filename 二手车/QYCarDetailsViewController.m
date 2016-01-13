//
//  QYCarDetailsViewController.m
//  二手车
//
//  Created by qingyun on 16/1/12.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCarDetailsViewController.h"
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Header.h"
#import "QYCarModel.h"
#import "QYCarInfoModel.h"
#import "QYCarTableViewCell.h"

@interface QYCarDetailsViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *recommendCarsArr;//推荐的汽车的信息
@property (nonatomic, strong) QYCarInfoModel *dataDict;//得到的数据字典
@end

@implementation QYCarDetailsViewController

#pragma mark - ********** life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAndAddSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *url = [kCarInfoBaseUrl stringByAppendingString:self.carModel.carID];
    //请求数据
    [self loadDataFromnwtWork:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ********** 添加视图
- (void)createAndAddSubviews {
    self.title = @"车辆详情";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - ********** 请求网络数据
- (void)loadDataFromnwtWork:(NSString *)url {
    AFHTTPSessionManager *maneger = [AFHTTPSessionManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"application/xml",@"application/xhtml+xml", nil];
    
    [maneger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject[@"success"];
        self.dataDict = [QYCarInfoModel carInfoWithDict:dict];
        [_tableView reloadData];
        //请求图片
//        [self loadImagesFormNetWork:self.dataDict.picUrls];
        //请求推荐车辆
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:self.dataDict.city forKey:@"city"];
        [parameters setValue:self.dataDict.price forKey:@"price"];
        [parameters setValue:self.dataDict.carId forKey:@"carId"];
        [self loadRecommendCars:kRecommendCarsUrl andParameters:parameters];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -  ********* 请求推荐车源
- (void)loadRecommendCars:(NSString *)urlStr andParameters:(NSDictionary *)parameters {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _recommendCarsArr = [NSArray array];
        _recommendCarsArr = responseObject[@"success"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - ********** tableView DataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 6+_recommendCarsArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYCarTableViewCell *cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:{
            cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][1];
            cell.headerModel = _dataDict;
            return cell;
        }
            break;
        case 1:{
            cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][4];
            cell.sectionTitle_label.text = @"基础信息";
            return cell;
        }
            break;
        case 2:{
            cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][2];
            cell.carInforModel = _dataDict;
            return cell;
        }
        default:
            break;
    }
    
//    if (indexPath.row == 0) {//用第1个 cell
//       cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][1];
//        cell.headerModel = _dataDict;
//    }else if (indexPath.row == 1) {//用第4个 cell
//        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][4];
//        cell.sectionTitle_label.text = @"基础信息";
//    }else if (indexPath.row == 2) {//用第2个 cell
//        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][2];
//        cell.carInforModel = _dataDict;
//    }else if (indexPath.row == 3) {//用第4个 cell
//        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][4];
//        cell.sectionTitle_label.text = @"商家描述";
//    }else if (indexPath.row == 4) {//用第3个 cell
//        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][3];
//        if ([_dataDict.car_desc  isEqual: @"<null>"]) {
//            cell.desc_label.text = @"暂无描述";
//        }else {
//            cell.desc_label.text = _dataDict.car_desc;
//        }
//    }else if (indexPath.row == 5) {//用第4个 cell
//        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][4];
//        cell.sectionTitle_label.text = @"车辆推荐";
//    }else {
//        //用第0个 cell  推荐的车辆信息
//        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][0];
//        QYCarModel *model = [[QYCarModel alloc] initWithDict:_recommendCarsArr[indexPath.row-6]];
//        cell.model = model;
//    }
//
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 400;
            break;
        case 1:
            return 40;
            break;
        case 2:
            return 90;
            break;
        case 4:
            return 40;
            break;
        default:
            break;
    }
    return 40;
}





@end
