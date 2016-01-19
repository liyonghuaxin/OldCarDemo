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

typedef void(^photoBlock)(NSInteger index,NSArray *images);

@interface QYCarTableViewCell : UITableViewCell

// 第四种cell  头标题
@property (weak, nonatomic) IBOutlet UILabel *sectionTitle_label;
// 第五种cell  描述
@property (weak, nonatomic) IBOutlet UILabel *desc_label;

@property (nonatomic, strong) QYCarModel *model;//car模型
@property (nonatomic, strong) QYCarInfoModel *headerModel;//头cell
@property (nonatomic, strong) QYCarInfoModel *infoModel;//基本信息

@property (nonatomic, strong) photoBlock imagesBlock;

@property (nonatomic, assign) NSInteger index;//当前的图片的下标

@end
