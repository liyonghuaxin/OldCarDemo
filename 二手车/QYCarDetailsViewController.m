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
#import "QYPhotosViewController.h"
#import "NSString+StringSize.h"


@interface QYCarDetailsViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *recommendCarsArr;// 推荐的汽车的信息
@property (nonatomic, strong) QYCarInfoModel *dataDict;// 得到的数据字典

@property (nonatomic, assign) NSInteger currentIndex;// 当前的图片下标
@property (nonatomic, assign) BOOL isLoad;// 是否已经请求过数据了
@end

@implementation QYCarDetailsViewController

#pragma mark - ********** life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createAndAddSubviews];
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 判断是否是第一次加载界面
    if (!_isLoad) {
        NSString *url = [kCarInfoBaseUrl stringByAppendingString:self.carModel.carID];
        //请求数据
        [self loadDataFromnwtWork:url];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ********** 添加视图
- (void)createAndAddSubviews {
    self.title = @"车辆详情";
    self.view.backgroundColor = [UIColor grayColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

#pragma mark - ********** 请求网络数据
- (void)loadDataFromnwtWork:(NSString *)url {
    AFHTTPSessionManager *maneger = [AFHTTPSessionManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"application/xml",@"application/xhtml+xml", nil];
    
    [maneger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"success"];
        self.dataDict = [QYCarInfoModel carInfoWithDict:dict];
        [_tableView reloadData];
        //请求推荐车辆
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:self.dataDict.city forKey:@"city"];
        [parameters setValue:self.dataDict.price forKey:@"price"];
        [parameters setValue:self.dataDict.carId forKey:@"carId"];
        [self loadRecommendCars:kRecommendCarsUrl andParameters:parameters];
        _isLoad = YES;
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
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - ********** tableView DataSource 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6+_recommendCarsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYCarTableViewCell *cell;
   
    if (indexPath.row == 0) {//用第1个 cell
       cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][1];
    
        // 跳转到图片详情
        MTWeak(self, weakSelf);
        cell.imagesBlock = ^(NSInteger index,NSArray *images){
            QYPhotosViewController *photoVC = [[QYPhotosViewController alloc] init];
            photoVC.imagesArray = images;
            photoVC.currentCount = index;
            photoVC.imagesIndexBlcok = ^(NSInteger index) {
                _currentIndex = index;
                [_tableView reloadData];
            };
            [weakSelf presentViewController:photoVC animated:NO completion:nil];
        };
        cell.index = _currentIndex;
        cell.headerModel = _dataDict;
    }else if (indexPath.row == 1) {//用第4个 cell
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][4];
        cell.sectionTitle_label.text = @"基础信息";
    }else if (indexPath.row == 2) {//用第2个 cell
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][2];
        cell.infoModel = _dataDict;
    }else if (indexPath.row == 3) {//用第4个 cell
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][4];
        cell.sectionTitle_label.text = @"商家描述";
    }else if (indexPath.row == 4) {//用第3个 cell
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][3];
            if ([_dataDict.car_desc  isEqual:[NSNull null]] ) {
                cell.desc_label.text = kNoDesc;
            }else {
                if ([_dataDict.car_desc isEqualToString:@""]) {
                    cell.desc_label.text = kNoDesc;
                }else {
                    cell.desc_label.text = _dataDict.car_desc;
                }
            }
    }else if (indexPath.row == 5) {//用第4个 cell
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][4];
        cell.sectionTitle_label.text = @"车辆推荐";
    }else {
        //用第0个 cell  推荐的车辆信息
        cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:0][0];
        QYCarModel *model = [[QYCarModel alloc] initWithDict:_recommendCarsArr[indexPath.row-6]];
        cell.model = model;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 5) {
        QYCarDetailsViewController *selfVC = [[QYCarDetailsViewController alloc] init];
        QYCarModel *model = [[QYCarModel alloc] initWithDict:_recommendCarsArr[indexPath.row-6]];
        selfVC.carModel = model;
        [self.navigationController pushViewController:selfVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return (kScreenWidth * 0.64 +140);
            break;
        case 1:
            return 40;
            break;
        case 2:
            return 90;
            break;
        case 3:
            return 40;
            break;
        case 4:{
            CGFloat width = kScreenWidth - 18;
            NSString *text;
            if ([_dataDict.car_desc isEqual:[NSNull null]]) {
                text = kNoDesc;
            }else {
                if ([_dataDict.car_desc isEqualToString:@""]) {
                    text = kNoDesc;
                }else {
                    text = _dataDict.car_desc;
                }
            }
            CGSize size = [text stringSizeWith:width Font:[UIFont systemFontOfSize:14]];
            return size.height + 20;
        }
            break;
        case 5:
            return 40;
            break;
        default:
            break;
    }
    return 84;
}

@end
