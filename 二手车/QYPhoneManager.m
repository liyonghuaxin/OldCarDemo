//
//  QYPhoneManager.m
//  二手车
//
//  Created by qingyun on 16/1/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYPhoneManager.h"

@interface QYPhoneManager ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation QYPhoneManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc] init];
    }
    return self;
}

+ (void)call:(NSString *)phoneNumber inViewController:(UIViewController *)vc failBlock:(void (^)())failBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    
    if (!canOpen) {
        if (failBlock != nil) {
            failBlock();
            return;
        }
    }
    
    QYPhoneManager *phoneVC = [[QYPhoneManager alloc] init];
    [vc addChildViewController:phoneVC];
    
    phoneVC.view.frame = CGRectZero;
    phoneVC.view.alpha = .0f;
    
    [vc.view addSubview:phoneVC.view];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [phoneVC.webView loadRequest:request];
        
}

@end
