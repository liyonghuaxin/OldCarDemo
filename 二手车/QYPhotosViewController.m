//
//  QYPhotosViewController.m
//  二手车
//
//  Created by qingyun on 16/1/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYPhotosViewController.h"
#import "Header.h"
#import "Masonry.h"



@interface QYPhotosViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;



@end

@implementation QYPhotosViewController

#pragma mark - life clcle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self createAndAddSubviews];
    //添加手势
    [self createAndAddTaps];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 添加手势
- (void)createAndAddTaps {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToSuperVC)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 手势事件
- (void)backToSuperVC {
    //回调当前页
    if (_imagesIndexBlcok) {
        _imagesIndexBlcok(_currentCount);
    }
    [self dismissViewControllerAnimated:nil completion:nil];
}

#pragma mark - 添加子视图
- (void)createAndAddSubviews {
    //添加scrollView
    [self addScrollView];
    
    //添加label
    [self addTitLabel];
}

// 添加scrollView
- (void)addScrollView {
    CGFloat kHeight = 240;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - kHeight)/2, kScreenWidth, kHeight)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(kScreenWidth * _imagesArray.count, kHeight);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES;
    
    // 添加内容视图
    [self addZoomView:scrollView];
    // 设置初始显示的内容
    scrollView.contentOffset = CGPointMake((_currentCount-1) * kScreenWidth, 0);
}

- (void)addZoomView:(UIScrollView *)scrollview {
    
    for (int i = 0; i < _imagesArray.count; i++) {
        UIImageView *zoomView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, scrollview.frame.size.height)];
        zoomView.image = _imagesArray[i];
        [scrollview addSubview:zoomView];
    }
}

// 添加显示当前图片页数的label
- (void)addTitLabel {
    _titleLabel = [[UILabel alloc] init];
    [self.view addSubview:_titleLabel];
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentCount,_imagesArray.count];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}

#pragma mark - Scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentCount = scrollView.contentOffset.x / scrollView.frame.size.width + 1;
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentCount,_imagesArray.count];
}

@end
