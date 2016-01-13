//
//  QYCarTableViewCell.m
//  二手车
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCarTableViewCell.h"
#import "QYCarModel.h"
#import "QYCarInfoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Header.h"

@interface QYCarTableViewCell ()
//car Model 第一种
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNameLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *dataAndMileLable;
@property (weak, nonatomic) IBOutlet UILabel *vprLable;

//header Cell 第二种
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *price_label;
@property (weak, nonatomic) IBOutlet UILabel *newcarPrice_label;
@property (weak, nonatomic) IBOutlet UILabel *evalPrice_label;
@property (weak, nonatomic) IBOutlet UILabel *vpr_label;

// car info Cell 第五种
@property (weak, nonatomic) IBOutlet UILabel *brand_label;
@property (weak, nonatomic) IBOutlet UILabel *liter_label;
@property (weak, nonatomic) IBOutlet UILabel *sourceName_label;
@property (weak, nonatomic) IBOutlet UILabel *mileage_label;
@property (weak, nonatomic) IBOutlet UILabel *regisData_label;
@property (weak, nonatomic) IBOutlet UILabel *gearTypeLabel;

@end

@implementation QYCarTableViewCell

- (void)awakeFromNib {

}
// 第一种cell类型 - car的基本信息模型
- (void)setModel:(QYCarModel *)model {
    _model = model;

    [_iconImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
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

// 第二种 头cell
- (void)setHeaderModel:(QYCarInfoModel *)headerModel {
    _headerModel = headerModel;
    
    [self loadImagesForNetWork:headerModel.picUrls];
    _title_label.text = headerModel.title;
    _price_label.text = [NSString stringWithFormat:@"%@万",headerModel.price];
    _newcarPrice_label.text = [NSString stringWithFormat:@"%@万",headerModel.model_price];
    _evalPrice_label.text = [NSString stringWithFormat:@"%@万",headerModel.eval_price];
    _vpr_label.text = [NSString stringWithFormat:@"%.1f",headerModel.vpr.floatValue*100];
}



#pragma mark - ***** srcollView

- (void)loadImagesForNetWork:(NSArray *)imagesUrlArray {
    _imagesScrollView.contentSize = CGSizeMake(kScreenWidth * imagesUrlArray.count, self.imagesScrollView.frame.size.height);
    _imagesScrollView.pagingEnabled = YES;
    _imagesScrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < imagesUrlArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, _imagesScrollView.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagesUrlArray[i]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_imagesScrollView addSubview:imageView];
        }];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
