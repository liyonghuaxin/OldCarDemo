//
//  QYGuideViewController.m
//  二手车
//
//  Created by qingyun on 16/1/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYGuideViewController.h"
#import "AppDelegate.h"

@interface QYGuideViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation QYGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)btnClick:(id)sender {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate guideEnd];
}

#pragma mark - Scroll view delegate

// 结束拖拽 开始减速
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //不减速，则滚动结束
    if (!decelerate) {
        self.pageControl.currentPage = self.scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

// 减速结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = self.scrollView.contentOffset.x / scrollView.frame.size.width;
}

@end
