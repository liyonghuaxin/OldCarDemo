//
//  QYSearchCarListVC.h
//  二手车
//
//  Created by qingyun on 16/1/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYSearchCarListVC : UIViewController

@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *seriesId;
@property (nonatomic, strong) NSString *seriesName;

@property (nonatomic, assign) NSInteger type;// 得到的参数类型
@end
