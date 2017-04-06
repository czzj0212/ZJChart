//
//  ViewController.m
//  ZJChartDemo
//
//  Created by 陈志健 on 2017/4/6.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _dataArray = @[@"折线图",@"环形图",@"波浪"];

}


- (UITableView *)tableView {

    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
     
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        
    }else if (indexPath.row == 1) {
    
    }else if (indexPath.row == 2) {
        
    }

}

@end
