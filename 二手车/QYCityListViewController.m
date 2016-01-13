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
#pragma mark - ********** 最近选择


#pragma mark - ********** 加载数据
- (void)loadCityList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city_data" ofType:@"plist"];
    _dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *keys = _dict.allKeys;
    _keys = [keys sortedArrayUsingSelector:@selector(compare:)];
}

- (void)createNavigationBar {
    self.title = @"选择城市";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"prov_select"] style:UIBarButtonItemStyleDone target:self action:@selector(backToBuyVC)];
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

}

#pragma mark - table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section <= 1) {
//        return 1;
//    }
    NSString *key = _keys[section];
    NSArray *array = _dict[key];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
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

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.city_id forKey:kCityId];
    [dict setValue:model.city_name forKey:kCityName];
    [dict setValue:model.prov_id forKey:kProv_id];
    
    //判断是否已经存在
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kcityModel]) {
        //删除
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kcityModel];
    }
    //添加
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kcityModel];
    //持久化
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     [self dismissViewControllerAnimated:YES completion:nil];     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
