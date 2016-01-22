//
//  QYContentTableVC.m
//  二手车
//
//  Created by qingyun on 16/1/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYContentTableVC.h"
#import "QYNetworkTools.h"
#import "Header.h"
#import "QYNewsModel.h"
#import "QYCustomNewCell.h"

@interface QYContentTableVC ()

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableDictionary *parameters;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation QYContentTableVC
static NSString *Identifier = @"cell";

#pragma mark - 懒加载
- (NSMutableDictionary *)parameters {
    if (_parameters == nil) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setObject:@"0" forKey:@"flash"];
        [_parameters setObject:@"10" forKey:@"num"];
        [_parameters setObject:@"0" forKey:@"start"];
    }
    return _parameters;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 90;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"QYCustomNewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    if (_index == 0) {
        NSDictionary *parameters = @{@"type":@"daogou",@"start":@"20",@"num":@"10",@"flash":@"0"};
        
        [self loadDataWithParameters:_parameters];
    }else if (_index == 1) {
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


#pragma mark - 请求数据
- (void)loadDataWithParameters:(NSMutableDictionary *)parameters {
    [[QYNetworkTools sharedNetworkTools] GET:kGuideBaseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _data = [NSMutableArray array];
        for (NSDictionary *dict in responseObject) {
            QYNewsModel *newsModel = [[QYNewsModel alloc] initWithDict:dict];
            [_data addObject:newsModel];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
//    http://auto.news18a.com/m/news/story_85832_1_0.html

}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYCustomNewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    QYNewsModel *newsModel = _data[indexPath.row];
    cell.newsModel = newsModel;
    return cell;
}

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
