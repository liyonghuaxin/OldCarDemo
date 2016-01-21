//
//  QYMeTableViewController.m
//  二手车
//
//  Created by qingyun on 16/1/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYMeTableViewController.h"
#import "QYStarViewController.h"
#import "QYWatchCarListVC.h"
#import "SDImageCache.h"
#import "QYAboutViewController.h"

@interface QYMeTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *memeryTitle;


@end

@implementation QYMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMemeryTitleLabel];
}

- (void)setMemeryTitleLabel {
    CGFloat size = [[SDImageCache sharedImageCache] getSize];
    if (size > 0) {
        _memeryTitle.text = [NSString stringWithFormat:@"缓存%.2lfM",size/1024/1024];
    }else {
        _memeryTitle.text = @"暂无缓存";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return 2;
}


#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 收藏界面
            QYStarViewController *starVC = [[QYStarViewController alloc] init];
            starVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:starVC animated:YES];
        }else {
            // 浏览界面
            QYWatchCarListVC *watchVC = [[QYWatchCarListVC alloc] init];
            watchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:watchVC animated:YES];
        }
    }else if (indexPath.section == 1) {
        // 缓存管理
        CGFloat size = [[SDImageCache sharedImageCache] getSize];
        if (size > 0) {
            NSString *titleNews = [NSString stringWithFormat:@"是否清除[ %.2lfM ]的缓存" , size / 1024 / 1024 ];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:titleNews preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                _memeryTitle.text = @"暂无缓存";
                [[SDImageCache sharedImageCache] clearDisk];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"暂无缓存" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"开发者信息" message:@"QQ:839632616\nTel:15737972326\nemail:kangdexingaaaaa@sina.com" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else if (indexPath.row == 1) {
            QYAboutViewController *aboutVC = [[QYAboutViewController alloc] init];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
}

@end
