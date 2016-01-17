//
//  Header.h
//  二手车
//
//  Created by qingyun on 16/1/3.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#ifndef Header_h
#define Header_h

//屏幕的大小和长宽
#define kScreenBounds    [UIScreen mainScreen].bounds
#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height


//汽车列表的url
#define kCarsListUrl      @"http://dingjia.che300.com/api/v224/util/car/car_list"

//汽车详情的url
#define kCarInfoBaseUrl   @"http://dingjia.che300.com/app/CarDetail/getInfo/"
//推荐汽车的基本url
#define kRecommendCarsUrl @"http://dingjia.che300.com/app/CarDetail/loadRecommendCars?"

// 车系列表的基本url
#define kServiceListUrl   @"http://dingjia.che300.com/api/v224/util/brand/find_series_by_brand"

//存储的键名
#define kCityName  @"city_name"
#define kCityId    @"city_id"
#define kProv_id   @"prov_id"
#define kcityModel  @"cityModel"

// weak 修饰
#define MTWeak(var, weakVar) __weak __typeof(&*var) weakVar = var

#endif /* Header_h */


