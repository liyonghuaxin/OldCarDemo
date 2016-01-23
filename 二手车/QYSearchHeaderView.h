//
//  QYSearchHeaderView.h
//  二手车
//
//  Created by qingyun on 16/1/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onBtnClickBlkT)(NSString *brandId, NSString *brandName);

@interface QYSearchHeaderView : UIView

@property (nonatomic, strong) onBtnClickBlkT brandParasBlock;

@end
