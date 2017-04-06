//
//  RingChartViewController.m
//  ZJChartDemo
//
//  Created by 陈志健 on 2017/4/6.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "RingChartViewController.h"
#import "ZJChartHeader.h"
@interface RingChartViewController ()<ZJRingViewDataSource>

@property (nonatomic, strong) ZJRingView *ringView;

@end

@implementation RingChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"环形图";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.ringView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//环状图
- (ZJRingView *)ringView {
    
    if (_ringView == nil) {
        
        _ringView = [[ZJRingView alloc] initWithFrame:CGRectMake(0, 64, 350, 300)];
        
        _ringView.dataSource = self;
        _ringView.title = @"销售分布";
        _ringView.subTitle = @"2016年12月";
        _ringView.ringSpace = 2.0;
        [self.view addSubview:_ringView];
    }
    
    return _ringView;
}
#pragma mark - 环图数据源
- (NSArray <ZJRingModel *> *)dataModelArrayOfZJRingView:(ZJRingView *)ZJRingView{
    
    
    UIColor *pinkColor = [UIColor colorWithRed:250/255.0 green:100/255.0 blue:150/255.0 alpha:1];
    UIColor *blueColor = [UIColor colorWithRed:117/255.0 green:157/255.0 blue:255/255.0 alpha:1];
    UIColor *orangeColor = [UIColor colorWithRed:242/255.0 green:137/255.0 blue:67/255.0 alpha:1];
    NSArray *colorArray = @[pinkColor,blueColor,orangeColor];
    NSArray *titleArray = @[@"商品1",@"商品2",@"商品3"];
    NSMutableArray *mmArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int i = 0; i < titleArray.count ; i ++) {
        
        ZJRingModel *ringmodel = [[ZJRingModel alloc] init];
        
        if (i == 0) {
            
            ringmodel.dataValue = 0.5;
            
        }else if (i == 1) {
            ringmodel.dataValue = 0.3;
            
        }else if (i == 2) {
            
            ringmodel.dataValue = 0.2;
        }
        
        ringmodel.ringColor = colorArray[i];
        ringmodel.name = titleArray[i];
        
        [mmArr addObject:ringmodel];
        
    }
    
    return mmArr;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
