//
//  QYCustomNewCell.m
//  二手车
//
//  Created by qingyun on 16/1/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCustomNewCell.h"
#import "QYNewsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface QYCustomNewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *autherLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation QYCustomNewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setNewsModel:(QYNewsModel *)newsModel {
    _newsModel = newsModel;
    
    _titleLabel.text = newsModel.title;
    _autherLabel.text = [NSString stringWithFormat:@"作者:%@", newsModel.author];
    _dateLabel.text = [NSString stringWithFormat:@"发布于%@",newsModel.pub];
    [_titleImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.title_pic1] placeholderImage:[UIImage imageNamed:@"image_replace.png"] completed:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
