//
//  QYStarViewController.m
//  二手车
//
//  Created by qingyun on 16/1/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYStarViewController.h"
#import "QYDBFileManager.h"
#import "Header.h"
#import "QYCarModel.h"
#import "QYCarTableViewCell.h"
#import "QYCarDetailsViewController.h"
#import <MJRefresh.h>

@interface QYStarViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QYStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载本地数据
    [self loadDataFromLocal];
    [self createAndAddSubviews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 添加子视图
- (void)createAndAddSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataFromLocal)];
    
}

- (void)loadDataFromLocal {
    _dataArray = [NSMutableArray array];
    _dataArray = [[QYDBFileManager sharedDBManager] selectAllData:kStarTable];
    if (_dataArray.count > 0) {
        [self setBarItem];
    }
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
}


- (void)setBarItem {
    UIBarButtonItem *deleteAllItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAllDatas)];
    self.navigationItem.rightBarButtonItem = deleteAllItem;
}

- (void)deleteAllDatas {
    [_dataArray removeAllObjects];
    [[QYDBFileManager sharedDBManager] deleteLocalAllData:kStarTable];
    
    self.navigationItem.rightBarButtonItem = nil;
    [_tableView reloadData];
}

#pragma mark - table view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdtifier = @"carCell";
    
    if (_dataArray.count > 0) {
        QYCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdtifier];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"QYCarTableViewCell" owner:nil options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _dataArray[indexPath.row];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"newCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-200)/2, 200, 200, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"亲! 你当前还没有收藏~";
    title.font = [UIFont systemFontOfSize:12];
    title.tintColor = [UIColor lightGrayColor];
    title.alpha = 0.7;
    [cell.contentView addSubview:title];
    
    return cell;
    
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count > 0) {
        QYCarDetailsViewController *carVC = [[QYCarDetailsViewController alloc] init];
        carVC.carModel = self.dataArray[indexPath.row];
        carVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:carVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count > 0) {
        return 84;
    }
    return _tableView.frame.size.height;
}


// 允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count > 0) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_dataArray.count == 1) {
            [self deleteAllDatas];
        }else {
            //取出模型
            QYCarModel *model = _dataArray[indexPath.row];
            // 删除数据源
            [_dataArray removeObjectAtIndex:indexPath.row];
            
            // 删除表格
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //删除数据库
            [[QYDBFileManager sharedDBManager] deleteLocalFromCarId:model.carID tableName:kStarTable];
        }
    }
    
}


@end
