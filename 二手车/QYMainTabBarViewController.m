//
//  QYMainTabBarViewController.m
//  二手车
//
//  Created by qingyun on 16/1/3.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYMainTabBarViewController.h"
#import "QYTabBar.h"

@interface QYMainTabBarViewController ()

@end

@implementation QYMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = YES;

//    QYTabBar *tabBar = [[QYTabBar alloc] init];
//    tabBar.frame = self.tabBar.frame;
////    tabBar.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:1/255.0 alpha:1];
//    [self.tabBar addSubview:tabBar];
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
