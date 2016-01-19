//
//  QYSearchViewController.h
//  二手车
//
//  Created by qingyun on 16/1/10.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QYCityModel;

typedef void(^cityModelBlock)(void);

@interface QYCityListViewController : UIViewController

@property (nonatomic, strong) cityModelBlock changeCityBlock;

@end
