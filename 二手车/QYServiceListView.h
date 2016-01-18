//
//  QYServiceListView.h
//  二手车
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QYServiceModel;

typedef void(^serviceModelBlcok)(QYServiceModel *model);

@interface QYServiceListView : UIView

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) serviceModelBlcok serviceBlcok;
@end
