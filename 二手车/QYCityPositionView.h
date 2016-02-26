//
//  QYCityPositionView.h
//  二手车
//
//  Created by qingyun on 16/1/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cityLocationBlock)(void);

@interface QYCityPositionView : UIView

@property (nonatomic, strong) cityLocationBlock locationCityBlock;

@end
