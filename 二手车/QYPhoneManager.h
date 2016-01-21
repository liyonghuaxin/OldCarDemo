//
//  QYPhoneManager.h
//  二手车
//
//  Created by qingyun on 16/1/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYPhoneManager : UIViewController

+(void)call:(NSString *)phoneNumber inViewController:(UIViewController *)vc failBlock:(void(^)())failBlock;

@end
