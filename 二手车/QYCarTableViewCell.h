//
//  QYCarTableViewCell.h
//  二手车
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QYCarModel;

@interface QYCarTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNameLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *dataAndMileLable;
@property (weak, nonatomic) IBOutlet UILabel *vprLable;




@property (nonatomic, strong) QYCarModel *model;

@end
