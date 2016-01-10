//
//  QYCarTableViewController.m
//  二手车
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYCarTableViewController.h"
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Header.h"
#import "QYCarModel.h"
#import "QYCarInfoModel.h"
#import "QYCarTableViewCell.h"

@interface QYCarTableViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *evalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vprLabel;
@property (weak, nonatomic) IBOutlet UILabel *regisDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
@property (weak, nonatomic) IBOutlet UILabel *literLabel;
@property (weak, nonatomic) IBOutlet UILabel *gearTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *brand_nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dealer_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carDescLabel;


@property (nonatomic, strong) QYCarInfoModel *dataDict;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (nonatomic, strong) NSArray *recommendCarsArr;



@end

@implementation QYCarTableViewController
static NSString *cellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车源详情";
    
    NSString *url = [kCarInfoBaseUrl stringByAppendingString:self.carModel.carID];
    //请求数据
    [self loadDataFromnwtWork:url];
    
    //注册
//    [self.tableView registerNib:[UINib nibWithNibName:@"" bundle:nil] forCellReuseIdentifier:cellIdentifier];
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ************* 请求网络数据
- (void)loadDataFromnwtWork:(NSString *)url {
    AFHTTPSessionManager *maneger = [AFHTTPSessionManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [maneger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject[@"success"];
//        NSLog(@"%@",dict);
        self.dataDict = [QYCarInfoModel carInfoWithDict:dict];
        //给数据赋值
        [self assidnmentToData];
        //请求图片
        [self loadImagesFormNetWork:self.dataDict.picUrls];
        NSLog(@"%@",self.dataDict.city);
        //请求推荐车辆
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
        [parameters setValue:self.dataDict.city forKey:@"city"];
        [parameters setValue:self.dataDict.price forKey:@"price"];
        [parameters setValue:self.dataDict.carId forKey:@"carId"];
        [self loadRecommendCars:kRecommendCarsUrl andParameters:parameters];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark -  ********* 请求推荐车源
- (void)loadRecommendCars:(NSString *)urlStr andParameters:(NSDictionary *)parameters {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    [manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _recommendCarsArr = [NSArray array];
        _recommendCarsArr = responseObject[@"success"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - ************* 请求网络图片
- (void)loadImagesFormNetWork:(NSArray *)imagesURLStrings {
    
    _imagesScrollView.contentSize = CGSizeMake(kScreenWidth * imagesURLStrings.count, self.imagesScrollView.frame.size.height);
    _imagesScrollView.pagingEnabled = YES;
    _imagesScrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < imagesURLStrings.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, _imagesScrollView.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagesURLStrings[i]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_imagesScrollView addSubview:imageView];
        }];
    }
}
#pragma mark - ************ 给数据赋值
- (void)assidnmentToData {
//    _numberLabel.text = [NSString stringWithFormat:@":%@",self.dataDict.];
    
    _nameLabel.text = self.dataDict.name;
    _priceLabel.text = [NSString stringWithFormat:@"%@万",self.dataDict.price];
    _modelPriceLabel.text = [NSString stringWithFormat:@"%@万",self.dataDict.model_price];
    _evalPriceLabel.text = [NSString stringWithFormat:@"%@万",self.dataDict.eval_price];
    _vprLabel.text = [NSString stringWithFormat:@"%.1f%%",self.dataDict.vpr.floatValue*100];
    
    _regisDataLabel.text = [NSString stringWithFormat:@"%@年%@月",[self.dataDict.register_date substringWithRange:NSMakeRange(0, 4)],[self.dataDict.register_date substringWithRange:NSMakeRange(5, 2)]];
    _mileageLabel.text = [NSString stringWithFormat:@"%@万公里",self.dataDict.mile_age];
    _gearTypeLabel.text = self.dataDict.gear_type;
    _literLabel.text = [NSString stringWithFormat:@"%@升",self.dataDict.liter];
    _dealer_nameLabel.text = self.dataDict.dealer_name;
    _brand_nameLabel.text = self.dataDict.brand_name;
    
    if (self.dataDict.car_desc.length <= 1) {
        _carDescLabel.text =@"暂无描述";
    }else {
         _carDescLabel.text = self.dataDict.car_desc;
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else {
        return 4;
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 2) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//        
//        return cell;
//    }
//    return nil;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
