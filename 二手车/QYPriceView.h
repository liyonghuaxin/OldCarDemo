//
//  QYPriceView.h
//  二手车
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^viewCloseBlock)(void);// 关闭视图
typedef void(^priceBlock)(NSString *price, NSString *title);// 改变价格
@interface QYPriceView : UIView

@property (nonatomic, strong) viewCloseBlock isCloseBlock;
@property (nonatomic, strong) priceBlock changePriceBlock;

@end
