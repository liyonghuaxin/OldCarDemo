//
//  QYCarTableViewCell.h
//  二手车
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QYCarModel;
@class QYCarInfoModel;

@interface QYCarTableViewCell : UITableViewCell

// 第二种cell  头标题
@property (weak, nonatomic) IBOutlet UILabel *sectionTitle_label;
// 第三种cell  描述
@property (weak, nonatomic) IBOutlet UILabel *desc_label;

@property (nonatomic, strong) QYCarModel *model;//car模型
@property (nonatomic, strong) QYCarInfoModel *headerModel;//头cell
@property (nonatomic, strong) QYCarInfoModel *carInforModel;//基本信息



@end
