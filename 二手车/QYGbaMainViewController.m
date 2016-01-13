//
//  QYGbaMainViewController.m
//  二手车
//
//  Created by qingyun on 16/1/3.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYGbaMainViewController.h"
#import "Header.h"
#import "QYTitleLable.h"
#import "QYRaiTableViewController.h"

#define kLableWidth 100

@interface QYGbaMainViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *smallScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *BigScrollView;
@property (nonatomic, strong) NSArray *arrayList;

@end

@implementation QYGbaMainViewController

#pragma mark - ************ 懒加载
- (NSArray *)arrayList {
    if (_arrayList == nil) {
        _arrayList = @[@"全部文章",@"购车常识",@"选车导购",@"二手车实拍",@"政策法规",@"行业资讯"];
    }
    return _arrayList;
}

#pragma mark - ********** 页面首次加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"攻略";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    self.BigScrollView.showsHorizontalScrollIndicator = NO;
    self.BigScrollView.showsVerticalScrollIndicator = NO;
    self.BigScrollView.delegate = self;

    
    [self addController];
    [self addLable];
    
    self.smallScrollView.contentSize = CGSizeMake(self.arrayList.count * kLableWidth, 40);
    CGFloat contentX = self.childViewControllers.count * kScreenWidth;
    self.BigScrollView.contentSize = CGSizeMake(contentX, kScreenHeight);
    self.BigScrollView.pagingEnabled = YES;
    self.BigScrollView.bounces = NO;
    
    //添加默认的控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.BigScrollView.bounds;
    [self.BigScrollView addSubview:vc.view];
    QYTitleLable *lable = [self.smallScrollView.subviews firstObject];
    lable.scale = 1.0;
    
    
    
}

#pragma mark - ***************** 添加方法
// 添加子视图控制器
- (void)addController {
    for (int i = 0; i < self.arrayList.count; i++) {
        QYRaiTableViewController *vc1 = [[QYRaiTableViewController alloc] init];
        vc1.title = self.arrayList[i];
        [self addChildViewController:vc1];
    }
}

//添加标题
- (void)addLable {
    for (int i = 0; i < 6; i++) {
        CGFloat lableW = kLableWidth;
        CGFloat lableH = 40;
        CGFloat lableY = 0;
        CGFloat lableX = i * lableW;
        QYTitleLable *lable1 = [[QYTitleLable alloc] init];
//        UIViewController *vc = self.childViewControllers[i];
//        lable1.text = vc.title;
        lable1.text = self.arrayList[i];
        lable1.frame = CGRectMake(lableX, lableY, lableW, lableH);
        lable1.font = [UIFont fontWithName:@"HYQiHei" size:19];
        [self.smallScrollView addSubview:lable1];
        lable1.tag = 100 + i;
        lable1.userInteractionEnabled = YES;
        lable1.backgroundColor = [UIColor grayColor];
        
        [lable1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lableClick:)]];
    }
}

/** 标题栏label的点击事件 */
- (void)lableClick:(UITapGestureRecognizer *)recognizer {
    QYTitleLable *titleLable = (QYTitleLable *)recognizer.view;
    
    CGFloat offsetX = (titleLable.tag - 100) *self.BigScrollView.frame.size.width;
    CGFloat offsetY = self.BigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.BigScrollView setContentOffset:offset animated:YES];
}

#pragma mark - ****************** scrollView 代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.BigScrollView.frame.size.width;
    
    // 滚动标题栏
    QYTitleLable *titleLabel = (QYTitleLable *)self.smallScrollView.subviews[index];
    
//    CGFloat offsetX = titleLabel.center.x - self.smallScrollView.frame.size.width * 0.5;
//    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
//    if (offsetX < 0) {
//        offsetX = 0;
//    }else if (offsetX > offsetMax) {
//        offsetX = offsetMax;
//    }
    CGFloat offsetX = titleLabel.frame.origin.x - kScreenWidth / 2;
    offsetX = offsetX > 0 ? (offsetX + kLableWidth / 2) : 0;
    offsetX = offsetX > self.smallScrollView.contentSize.width - kScreenWidth ? self.smallScrollView.contentSize.width - kScreenWidth : offsetX;
    
    CGPoint offest = CGPointMake(offsetX, 0);
    [self.smallScrollView setContentOffset:offest animated:YES];
    
    //添加控制器
    QYRaiTableViewController *raiVC = self.childViewControllers[index];
    raiVC.index = index;
    
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != index) {
            QYTitleLable *temLable = self.smallScrollView.subviews[idx];
            temLable.scale = 0.0;
        }
    }];
    
    if (raiVC.view.superview) {
        return;
    }
    
    raiVC.view.frame = scrollView.bounds;
    [self.BigScrollView addSubview:raiVC.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    
    QYTitleLable *lableLeft = self.smallScrollView.subviews[leftIndex];
    lableLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.smallScrollView.subviews.count) {
        QYTitleLable *lableRight = self.smallScrollView.subviews[rightIndex];
        lableRight.scale = scaleRight;
    }
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
