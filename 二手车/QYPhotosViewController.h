//
//  QYPhotosViewController.h
//  二手车
//
//  Created by qingyun on 16/1/16.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^indexBlcok)(NSInteger index);

@interface QYPhotosViewController : UIViewController

@property (nonatomic, strong) NSArray *imagesArray;//传过来的图片
@property (nonatomic, assign) NSInteger currentCount;//当前显示图片的下标

@property (nonatomic, strong) indexBlcok imagesIndexBlcok;

@end
