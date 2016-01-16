//
//  QYCustomCarCell.m
//  二手车
//
//  Created by qingyun on 16/1/15.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCustomCarCell.h"
#import "QYCarModel.h"
#import "QYCarInfoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Header.h"


@interface QYCustomCarCell () <UIScrollViewDelegate>

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




@property (nonatomic, strong) UILabel *imageCountLabel;
@property (nonatomic, strong) NSMutableArray *images;//总共的图片
@property (nonatomic, assign) NSInteger index;//当前的图片的下标

@end

@implementation QYCustomCarCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - 给自定义的cell上的属性赋值
// 第一种cell类型 - car的基本信息模型
- (void)setModel:(QYCarModel *)model {
    _model = model;
    
    
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
    //请求图片
    [_iconImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

// 第二种 头cell
- (void)setHeaderModel:(QYCarInfoModel *)headerModel {
    _headerModel = headerModel;
    
    _title_label.text = headerModel.title;
    _price_label.text = [NSString stringWithFormat:@"%.2f万",[headerModel.price floatValue]];
    _newcarPrice_label.text = [NSString stringWithFormat:@"%.2f万",[headerModel.model_price floatValue]];
    _evalPrice_label.text = [NSString stringWithFormat:@"%.2f万",[headerModel.eval_price floatValue]];
    _vpr_label.text = [NSString stringWithFormat:@"%.1f%%",headerModel.vpr.floatValue*100];
    // 加载图片数组
    [self loadImagesForNetWork:headerModel.picUrls];
}

//// 第三种cell
//- (void)setInfoModel:(QYCarInfoModel *)infoModel {
//    _infoModel = infoModel;
//    self.brand_label.text = infoModel.brand_name;
//    self.gearTypeLabel.text = infoModel.gear_type;
//    _sourceName_label.text = infoModel.source_name;
//    _mileage_label.text = [NSString stringWithFormat:@"%@万公里",infoModel.mile_age];
//    _lites_lable.text = @"sddfffg";
//    _regisData_label.text = [NSString stringWithFormat:@"%@年%@月",[infoModel.register_date substringWithRange:NSMakeRange(0, 4)],[infoModel.register_date substringWithRange:NSMakeRange(5, 2)]];
//}





#pragma mark - ***** srcollView

- (void)loadImagesForNetWork:(NSArray *)imagesUrlArray {
    _imagesScrollView.contentSize = CGSizeMake(kScreenWidth * imagesUrlArray.count, self.imagesScrollView.frame.size.height);
    _imagesScrollView.pagingEnabled = YES;
    _imagesScrollView.delegate = self;
    _imagesScrollView.showsHorizontalScrollIndicator = NO;
    
    _index = 1;
    
    //添加一个计算图片的lable
    _imageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 200, 80, 30)];
    [self addSubview:_imageCountLabel];
    _imageCountLabel.layer.cornerRadius = 7;
    _imageCountLabel.layer.masksToBounds = YES;
    _imageCountLabel.textColor = [UIColor whiteColor];
    _imageCountLabel.backgroundColor = [UIColor blackColor];
    _imageCountLabel.textAlignment = NSTextAlignmentCenter;
    _imageCountLabel.text = _imageCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",_index,_headerModel.picUrls.count];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
    tap.numberOfTapsRequired = 1;
    [_imagesScrollView addGestureRecognizer:tap];
    
    _images = [NSMutableArray array];
    // 添加可以点击视图
    for (int i = 0; i < imagesUrlArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, _imagesScrollView.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagesUrlArray[i]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_images addObject:image];
            [_imagesScrollView addSubview:imageView];
        }];
    }
}


#pragma mark - 点击图片
- (void)singleClick:(UITapGestureRecognizer *)tap {
    if (_imagesBlock) {
        _imagesBlock(_index,_images);
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _index = scrollView.contentOffset.x / scrollView.frame.size.width + 1;
    //更新lable的值
    _imageCountLabel.text = _imageCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",_index,_headerModel.picUrls.count];
}


@end
