//
//  ViewController.m
//  ZJChartDemo
//
//  Created by 陈志健 on 2017/4/6.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ViewController.h"
#import "BrokenLineViewController.h"
#import "RingChartViewController.h"
#import "WaveViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"ZJChart";
    _dataArray = @[@"折线图",@"环形图",@"波浪"];
    [self.view addSubview:self.tableView];
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
        
        BrokenLineViewController *brokenVC = [[BrokenLineViewController alloc] init];
        [self.navigationController pushViewController:brokenVC animated:YES];
    }else if (indexPath.row == 1) {
        RingChartViewController *ringVC = [[RingChartViewController alloc] init];
        [self.navigationController pushViewController:ringVC animated:YES];
    }else if (indexPath.row == 2) {
        WaveViewController *waveVC = [[WaveViewController alloc] init];
        [self.navigationController pushViewController:waveVC animated:YES];
    }

}

@end
