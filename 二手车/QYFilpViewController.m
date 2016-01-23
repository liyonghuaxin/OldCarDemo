//
//  QYFilpViewController.m
//  二手车
//
//  Created by qingyun on 16/1/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYFilpViewController.h"
#import "Header.h"
#import "QYSegmentTapView.h"
#import "QYContentTableVC.h"

@interface QYFilpViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) QYSegmentTapView *btnsView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation QYFilpViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createAndAddSubViews];
}

- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = @[@"推荐",@"导购",@"行业"];
    }
    return _titleArray;
}

- (void)createAndAddSubViews {

    // 导航view
    _btnsView = [[QYSegmentTapView alloc] initWithButtonsArr:self.titleArray frame:CGRectMake(0, 64, kScreenWidth, 40)];
    [self.view addSubview:_btnsView];
    MTWeak(self, weakSelf);
    _btnsView.selectIndexBlcok = ^(NSInteger index) {
        _currentIndex = index;
        
        [weakSelf changScrollViewContentOffest:index];
    };
    
    [self addControllers];
  
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight-152)];
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _titleArray.count, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    
    // 添加默认的控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = CGRectMake(0, 0, kScreenWidth, _scrollView.frame.size.height);
    [_scrollView addSubview:vc.view];
}

- (void)addControllers {
    for (int i = 0; i < self.titleArray.count; i++) {
        QYContentTableVC *contentVC = [[QYContentTableVC alloc] init];
        [self addChildViewController:contentVC];
    }
}

#pragma mark - 方法
- (void)changScrollViewContentOffest:(NSInteger)index {
    _scrollView.contentOffset = CGPointMake(index * kScreenWidth, 0);
    [self showChildVC:index];
}

- (void)showChildVC:(NSInteger)index {
    // 添加控制器
    QYContentTableVC *currentVC = self.childViewControllers[index];
    currentVC.index = index;
    
    if (currentVC.view.superview) {
        return;
    }
    
    currentVC.view.frame = CGRectMake(index * kScreenWidth, 0, kScreenWidth, _scrollView.frame.size.height);
    [_scrollView addSubview:currentVC.view];
}


#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / _scrollView.frame.size.width;
    _btnsView.index = index;
    
    [self showChildVC:index];
}



@end
