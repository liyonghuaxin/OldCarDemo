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
#import "QYPhotosViewController.h"

@interface QYCarTableViewCell () <UIScrollViewDelegate>

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

// car info Cell 第3种
@property (weak, nonatomic) IBOutlet UILabel *brand_label;
@property (weak, nonatomic) IBOutlet UILabel *sourceName_label;
@property (weak, nonatomic) IBOutlet UILabel *mileage_label;
@property (weak, nonatomic) IBOutlet UILabel *regisData_label;
@property (weak, nonatomic) IBOutlet UILabel *gearTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lites_lable;


@property (nonatomic, strong) UILabel *imageCountLabel;
@property (nonatomic, strong) NSArray *images;//总共的图片



@end

@implementation QYCarTableViewCell

- (void)awakeFromNib {

}
#pragma mark - 给自定义的cell上的属性赋值
// 第一种cell类型 - car的基本信息模型
- (void)setModel:(QYCarModel *)model {
    _model = model;
    
    _carNameLable.text = model.carName;
    _dataAndMileLable.text = [NSString stringWithFormat:@"%@上牌-%@万公里-%@",model.registerDate,model.mileage,model.cityName];
    _priceLable.text = [NSString stringWithFormat:@"%@万",model.price];
    
    if (model.vpr.floatValue >= 60.0) {
        _vprLable.backgroundColor = [UIColor colorWithRed:95/255.0 green:196/255.0 blue:255/255.0 alpha:1];
        _vprLable.text = [NSString stringWithFormat:@"推荐指数:%.1f%%",[model.vpr floatValue]];
        _vprLable.layer.cornerRadius = 3;
        _vprLable.layer.masksToBounds = YES;
    }else {
        _vprLable.text = nil;
        _vprLable.backgroundColor = [UIColor whiteColor];
    }

    //请求图片
    [_iconImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"slider-default-trackBackground"] options:0 progress:nil completed:nil];
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
    _images = headerModel.picUrls;
}

// 第三种cell
- (void)setInfoModel:(QYCarInfoModel *)infoModel {
    _infoModel = infoModel;
    self.brand_label.text = infoModel.brand_name;
    self.gearTypeLabel.text = infoModel.gear_type;
    _sourceName_label.text = infoModel.source_name;
    _mileage_label.text = [NSString stringWithFormat:@"%@万公里",infoModel.mile_age];
    _lites_lable.text = infoModel.liter;
    _regisData_label.text = [NSString stringWithFormat:@"%@年%@月上牌",[infoModel.register_date substringWithRange:NSMakeRange(0, 4)],[infoModel.register_date substringWithRange:NSMakeRange(5, 2)]];
}


#pragma mark - ***** srcollView
- (void)loadImagesForNetWork:(NSArray *)imagesUrlArray {
    _imagesScrollView.contentSize = CGSizeMake(kScreenWidth * imagesUrlArray.count, self.imagesScrollView.frame.size.height);
    _imagesScrollView.pagingEnabled = YES;
    _imagesScrollView.delegate = self;
    _imagesScrollView.showsHorizontalScrollIndicator = NO;
    
    // 判断下标是否有值
    if (_index == 0) {
        _index = 1;
    }
    
    // 添加显示页数的label
    [self addCurrentImagesLable];
    // 添加滚动的子视图
    [self addimageView2Scrollview:imagesUrlArray];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
    tap.numberOfTapsRequired = 1;
    [_imagesScrollView addGestureRecognizer:tap];
    
    // 设置当前显示的页数
    _imagesScrollView.contentOffset = CGPointMake((_index-1) * kScreenWidth, 0);
}

// 添加滚动视图
- (void)addimageView2Scrollview:(NSArray *)imagesUrlArray {
    _images = [NSMutableArray array];
    for (int i = 0; i < imagesUrlArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, _imagesScrollView.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagesUrlArray[i]] placeholderImage:[UIImage imageNamed:@"slider-default-trackBackground"] completed:nil];
         [_imagesScrollView addSubview:imageView];
    }

}

// 添加一个计算图片的lable
- (void)addCurrentImagesLable {
    _imageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 200, 80, 30)];
    [self addSubview:_imageCountLabel];
    _imageCountLabel.layer.cornerRadius = 7;
    _imageCountLabel.layer.masksToBounds = YES;
    _imageCountLabel.textColor = [UIColor whiteColor];
    _imageCountLabel.backgroundColor = [UIColor blackColor];
    _imageCountLabel.textAlignment = NSTextAlignmentCenter;
    _imageCountLabel.text = _imageCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_index,(unsigned long)_headerModel.picUrls.count];
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
    _imageCountLabel.text = _imageCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_index,(unsigned long)_headerModel.picUrls.count];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
