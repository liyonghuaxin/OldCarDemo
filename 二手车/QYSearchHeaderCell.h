//
//  QYSearchHeaderCell.h
//  二手车
//
//  Created by qingyun on 16/1/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onBtnClickBlkT)(NSInteger index);

@interface QYSearchHeaderCell : UITableViewCell

@property (nonatomic, strong) onBtnClickBlkT btnIndexBlock;

@end
