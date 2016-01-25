//
//  QYSegmentTapView.m
//  二手车
//
//  Created by qingyun on 16/1/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYSegmentTapView.h"
#import  "Header.h"
@interface QYSegmentTapView ()
@property (nonatomic, strong) NSArray *btnsArray;
@property (nonatomic, strong) UIView *lineSliderView;

@end

@implementation QYSegmentTapView


- (instancetype)initWithButtonsArr:(NSArray *)arr frame:(CGRect)frame {
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
        
        _selectColor = [UIColor orangeColor];
        [self createAndAddsubviews:arr];
    }
    return self;
}


#pragma mark - 添加子视图
- (void)createAndAddsubviews:(NSArray *)titleArray {
    CGFloat btnW = self.frame.size.width / titleArray.count;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnY = 0;
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        CGFloat btnX = i * btnW;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:_selectColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = i + 800;
        [btn addTarget:self action:@selector(changeBtnIdnexClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            btn.selected = YES;
        }else {
            btn.selected = NO;
        }
        [tempArr addObject:btn];
    }
    _btnsArray = tempArr;
    
    _lineSliderView = [[UIView alloc] initWithFrame:CGRectMake((btnW-64)/2, self.frame.size.height - 1, 64, 1)];
    [self addSubview:_lineSliderView];
    _lineSliderView.backgroundColor = [UIColor orangeColor];
}

#pragma mark - 点击事件
- (void)changeBtnIdnexClick:(UIButton *)sender {
    self.index = sender.tag - 800;
    if (_selectIndexBlcok) {
        _selectIndexBlcok(_index);
    }
    
}

- (void)setIndex:(NSInteger)index {
    // 取消上次选中
    UIButton *noSelectBtn = _btnsArray[_index];
    noSelectBtn.selected = NO;
    
    //选中
    UIButton *selectBtn = _btnsArray[index];
    selectBtn.selected = YES;
    
    _index = index;
    CGRect frame = _lineSliderView.frame;
    frame.origin.x = _index * (self.frame.size.width / _btnsArray.count)+ ((kScreenWidth / _btnsArray.count)-64)/2;
    [UIView animateWithDuration:0.3f animations:^{
        _lineSliderView.frame = frame;
    }];
    
}


@end
