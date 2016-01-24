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

// app 第一次运行的判断
#define kAppRun @"appRun"

//汽车列表的url
#define kCarsListUrl      @"http://dingjia.che300.com/api/v224/util/car/car_list"

//汽车详情的url
#define kCarInfoBaseUrl   @"http://dingjia.che300.com/app/CarDetail/getInfo/"
//推荐汽车的基本url
#define kRecommendCarsUrl @"http://dingjia.che300.com/app/CarDetail/loadRecommendCars?"

// 车系列表的基本url
#define kServiceListUrl   @"http://dingjia.che300.com/api/v224/util/brand/find_series_by_brand"

// 请求参数的 键名
#define kCityName         @"cityName"
#define kCityId           @"city"
#define kProvId           @"prov"
#define kcityModel        @"cityModel"

#define kPage             @"page"

#define kBrandId          @"brand"
#define kBrandName        @"brandName"
#define kSeriesId         @"series"
#define kSeriesName       @"seriesName"

// 请求的价格参数
#define kPrice            @"price"

// 保存选中价格btn的标题
#define KpriceBtnTitle    @"KpriceBtnTitle"
// 保存选中价格btn 的tag
#define kSelectBtnTag @"selectBtnTag"

// 性价比排序 的键
#define kVprSort          @"vprSort"

// weak 修饰
#define MTWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
// 描述为空的字符串
#define kNoDesc      @"暂无描述"

//数据库名
#define DBNAME                 @"car.db"

// 表名
#define kWatchTable           @"watchTable"
#define kStarTable            @"starTable"
#define kCarTable             @"carTable"

#define kSearchBrandTable     @"searchBrand"
#define ksearchSeriesTbale    @"searchSeries"

// 购车指南
#define kGuideBaseUrl   @"http://auto.news18a.com/init.php?m=price&c=index&a=getData"

// 详情页面的基本url
#define kDetailBaseUrl  @"http://auto.news18a.com"

#endif /* Header_h */


