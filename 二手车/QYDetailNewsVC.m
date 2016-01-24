//
//  QYDetailNewsVC.m
//  二手车
//
//  Created by qingyun on 16/1/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYDetailNewsVC.h"
#import "Header.h"
#import <SVProgressHUD.h>

@interface QYDetailNewsVC ()

@end

@implementation QYDetailNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SVProgressHUD show];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:[kDetailBaseUrl stringByAppendingString:self.url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
     [SVProgressHUD dismissWithDelay:2];
}



@end
