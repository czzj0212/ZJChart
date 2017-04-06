//
//  BrokenLineViewController.m
//  ZJChartDemo
//
//  Created by 陈志健 on 2017/4/6.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "BrokenLineViewController.h"
#import "ZJChartHeader.h"
@interface BrokenLineViewController ()<ZJBrokenLineDataSource>

@property(nonatomic, strong)ZJBrokenLineView *brokenLineView;

@property(nonatomic, strong)BrokenLineModel *lineModel;
@end

@implementation BrokenLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"折线图";
    self.view.backgroundColor = [UIColor whiteColor];
    _lineModel = [[BrokenLineModel alloc] init];
    _lineModel.xDataArray = @[@"第一周",@"第二周",@"第三周",@"第四周"];
    _lineModel.totalPointNub = 30;
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i=0 ; i < 30; i++) {
        
        NSInteger yValue = random()%100;
        [mArray addObject:[NSNumber numberWithInteger:yValue]];
    }
    _lineModel.yDataArray = mArray;
    
    //刷新
    [self.brokenLineView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (ZJBrokenLineView *)brokenLineView {
    
    if (_brokenLineView == nil) {
        
        _brokenLineView = [[ZJBrokenLineView alloc] initWithFrame:CGRectMake(0, 64, 320, 200)];
        
        _brokenLineView.dataSource = self;
        _brokenLineView.titleColor = [UIColor whiteColor];
        _brokenLineView.xLabelColor = [UIColor colorWithRed:130/255.0 green:113/255.0 blue:175/255.0 alpha:1];
        _brokenLineView.lineColor = [UIColor colorWithRed:203/255.0  green:170/255.0  blue:252/255.0 alpha:1];
        //130 113 175
        _brokenLineView.coordinatesColor = [UIColor colorWithRed:130/255.0 green:113/255.0 blue:175/255.0 alpha:1];
        //90 52 154
        _brokenLineView.backgroundColor = [UIColor colorWithRed:90/255.0 green:52/255.0 blue:154/255.0 alpha:1];
        [self.view addSubview:_brokenLineView];

    }
    
    return _brokenLineView;
}

#pragma mark - 折线图数据源

/*
 数据源 NSArray Y轴数据
 */
- (BrokenLineModel *)yDataModelOfZJBrokenLineView:(ZJBrokenLineView *)brokenLineView {
    
    
    return _lineModel;
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
