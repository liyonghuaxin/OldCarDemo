//
//  QYCustomCarCell.h
//  二手车
//
//  Created by qingyun on 16/1/15.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QYCarModel;
@class QYCarInfoModel;

typedef void(^photoBlock)(NSInteger index,NSMutableArray *images);

@interface QYCustomCarCell : UITableViewCell

// 第四种cell  头标题
@property (weak, nonatomic) IBOutlet UILabel *sectionTitle_label;
// 第五种cell  描述
@property (weak, nonatomic) IBOutlet UILabel *desc_label;

// car info Cell 第3种
@property (weak, nonatomic) IBOutlet UILabel *brand_label;
@property (weak, nonatomic) IBOutlet UILabel *sourceName_label;
@property (weak, nonatomic) IBOutlet UILabel *mileage_label;
@property (weak, nonatomic) IBOutlet UILabel *regisData_label;
@property (weak, nonatomic) IBOutlet UILabel *gearTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lites_lable;


@property (nonatomic, strong) QYCarModel *model;//car模型
@property (nonatomic, strong) QYCarInfoModel *headerModel;//头cell
@property (nonatomic, strong) QYCarInfoModel *infoModel;//基本信息

@property (nonatomic, strong) photoBlock imagesBlock;



@end
