//
//  QYSortView.h
//  二手车
//
//  Created by qingyun on 16/1/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^viewCloseBlock)(void);// 移除view
typedef void(^changeParatBlock)(NSString *key, NSString *value, NSString *title);//选中的排序方式

@interface QYSortView : UIView

@property (nonatomic, strong) viewCloseBlock isCloseBlock;
@property (nonatomic, strong) changeParatBlock changeParameterBlock;
@end
