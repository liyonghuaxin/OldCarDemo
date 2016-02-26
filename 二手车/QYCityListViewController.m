//
//  QYSearchViewController.m
//  二手车
//
//  Created by qingyun on 16/1/10.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCityListViewController.h"
#import "Header.h"
#import "QYCityModel.h"
#import "QYCityPositionView.h"


@interface QYCityListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;//索引键值
@property (nonatomic, strong) NSDictionary *dict;//字典
@property (nonatomic, strong) NSMutableArray *recentChooseArr;//最近选择

@end

@implementation QYCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加视图
    [self loadCityList];
    [self createTableView];
    [self createNavigationBar];

}


#pragma mark - 定位选择

/*


- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10.f;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位不成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // 获取最后一个地址
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil && placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            // 获取信息显示
            NSLog(@"%@", placemark.name);
            
            // 获取城市
            NSString *cityName = placemark.locality;
             NSLog(@"city:%@", cityName);
            if (!cityName) {
                cityName = placemark.administrativeArea;
            }
            NSLog(@"%@", cityName);
        }
    }];
    
    // 获取之后停止更新
    [manager stopUpdatingLocation];
    
}

*/

#pragma mark - ********** 加载数据
- (void)loadCityList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city_data" ofType:@"plist"];
    _dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *keys = _dict.allKeys;
    _keys = [keys sortedArrayUsingSelector:@selector(compare:)];
}

- (void)createNavigationBar {
    self.title = @"地区选择";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_close.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backToBuyVC)];
    self.navigationItem.leftBarButtonItem = backItem;
}
#pragma mark - ********点击事件
- (void)backToBuyVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ********** 创建tableView
- (void)createTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.sectionIndexColor = [UIColor grayColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    QYCityPositionView *headerView = [[QYCityPositionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    _tableView.tableHeaderView = headerView;
    
    MTWeak(self, weakSelf);
    headerView.locationCityBlock = ^{
        NSString *locationCityName = [[NSUserDefaults standardUserDefaults] stringForKey:kLocationCityName];
        
        if (locationCityName == nil) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位失败!请到手机系统的[设置]->[隐私]->[定位系统]中打开定位服务." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"city_data" ofType:@"plist"];
            NSDictionary *cityDict = [NSDictionary dictionaryWithContentsOfFile:path];
            NSArray *keys = cityDict.allKeys;
            
            for (int i = 0; i < keys.count; i++) {
                for (NSDictionary *dict in cityDict[keys[i]]) {
                    QYCityModel *model = [[QYCityModel alloc] initWithDict:dict];
                    
                    if ([model.city_name isEqualToString:locationCityName]) {
                        [weakSelf chooseCityWithCityModel:model];
                        return;
                    }
                }
            }
        }
    };
    
}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = _keys[section];
    NSArray *array = _dict[key];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    if (indexPath.section <= 1) {
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *key = _keys[indexPath.section];
    NSArray *array = _dict[key];
    
    QYCityModel *model = [QYCityModel cityModelWithDict:array[indexPath.row]];
    cell.textLabel.text = model.city_name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.tintColor = [UIColor blackColor];
    return cell;
}

#pragma mark - table view delegate
//头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _keys[section];
}

//设置索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _keys;
}

//点击索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

//点击选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = _keys[indexPath.section];
    NSArray *array = _dict[key];
    QYCityModel *model = [QYCityModel cityModelWithDict:array[indexPath.row]];

    [self chooseCityWithCityModel:model];
}


/**
 *  选择城市后要保存选择城市的信息 还要跳转到主页面去请求数据
 */
- (void)chooseCityWithCityModel:(QYCityModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.city_id forKey:kCityId];
    [dict setValue:model.city_name forKey:kCityName];
    [dict setValue:model.prov_id forKey:kProvId];
    
    //判断是否已经存在
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kcityModel]) {
        //删除
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kcityModel];
    }
    //添加
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kcityModel];
    //持久化
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_changeCityBlock) {
            _changeCityBlock();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
