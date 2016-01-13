//
//  QYBrandTableViewCell.m
//  二手车
//
//  Created by qingyun on 16/1/13.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYBrandTableViewCell.h"
#import "QYBrandModel.h"

@interface QYBrandTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *Brand_icon;
@property (weak, nonatomic) IBOutlet UILabel *brand_name;

@end

@implementation QYBrandTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setBrandModel:(QYBrandModel *)brandModel {
    _brandModel = brandModel;
    _Brand_icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"b%@.jpg",brandModel.brandId]];
    _brand_name.text = brandModel.brandName;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

@end
