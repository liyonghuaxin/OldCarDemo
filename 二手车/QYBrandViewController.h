//
//  QYBrandViewController.h
//  二手车
//
//  Created by qingyun on 16/1/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QYBrandModel;

typedef void(^brandChangeBlock)(QYBrandModel *brandModel);

@interface QYBrandViewController : UIViewController

@property (nonatomic, strong) brandChangeBlock changeBrandBlock;//改变品牌

@end
