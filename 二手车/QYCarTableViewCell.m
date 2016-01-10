//
//  QYCarTableViewCell.m
//  二手车
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCarTableViewCell.h"
#import "QYCarModel.h"
#import "UIImageView+webCache.h"



@implementation QYCarTableViewCell

- (void)awakeFromNib {

}

- (void)setModel:(QYCarModel *)model {
    _model = model;
    
    [_iconImageView loadImageFormNetWork:model.iconUrl];
    _carNameLable.text = model.carName;
    _dataAndMileLable.text = [NSString stringWithFormat:@"%@上牌-%@万公里-%@",model.registerDate,model.mileage,model.cityName];
    _priceLable.text = [NSString stringWithFormat:@"%@万",model.price];

    if (model.vpr.floatValue >= 60.0) {
        _vprLable.backgroundColor = [UIColor colorWithRed:95/255.0 green:196/255.0 blue:249/255.0 alpha:1];
        _vprLable.text = [NSString stringWithFormat:@"推荐指数:%@%%",model.vpr];
        
    }else {
        _vprLable.text = nil;
        _vprLable.backgroundColor = [UIColor whiteColor];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
