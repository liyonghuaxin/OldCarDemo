//
//  QYSegmentTapView.h
//  二手车
//
//  Created by qingyun on 16/1/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBtnIndexBlock)(NSInteger index);

@interface QYSegmentTapView : UIView

@property (nonatomic, strong) selectBtnIndexBlock selectIndexBlcok;

@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, strong) UIColor *selectColor;

@property (nonatomic, assign) NSInteger index;


- (instancetype)initWithButtonsArr:(NSArray *)arr frame:(CGRect)frame;

@end
