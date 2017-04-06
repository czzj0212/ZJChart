//
//  ZJBrokenLineView.h
//  BrokenLineDemo
//
//  Created by 陈志健 on 2016/11/7.
//  Copyright © 2016年 czj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleDataModel.h"
@class ZJBrokenLineView;
#import "BrokenLineModel.h"
#pragma mark - 数据源
@protocol ZJBrokenLineDataSource <NSObject>

/*
 数据源 日期
 */

- (NSString *)monthStringOfZJBrokenLineView:(ZJBrokenLineView *)brokenLineView;

/*
 数据源 NSArray Y轴数据
 */
- (BrokenLineModel *)yDataModelOfZJBrokenLineView:(ZJBrokenLineView *)brokenLineView;


@end

@interface ZJBrokenLineView : UIView

//坐标轴的颜色-默认灰
@property (nonatomic, strong) UIColor *coordinatesColor;

//折线的颜色-默认灰
@property (nonatomic, strong) UIColor *lineColor;

//x轴Label颜色-默认黑
@property (nonatomic, strong) UIColor *xLabelColor;

//标记数据颜色-默认灰
@property (nonatomic, strong) UIColor *flagColor;

//标题颜色-默认黑
@property (nonatomic, strong) UIColor *titleColor;

//标题(左上角)
@property (nonatomic, copy) NSString *leftTitle;

//标题(右上角)
@property (nonatomic, copy) NSString *rightTitle;

//折线图与左右间距
@property (nonatomic, assign) CGFloat bounceX;

//折线图与上面间距
@property (nonatomic, assign) CGFloat bounceTop;

//折线图与下面间距
@property (nonatomic, assign) CGFloat bounceBottom;

//折线距离折线图上下间距百分比 (0-0.5) 默认0.2
@property (nonatomic, assign) CGFloat lineSpacePercent;

//数据源
@property(nonatomic, weak) id<ZJBrokenLineDataSource>dataSource;

//数据的单位
@property (nonatomic, copy)NSString *unitName;
//数据的小数点位数
@property (nonatomic, assign)int numbOfFloat;

//刷新数据
- (void)reloadData;

//背景图设置
- (void)setUIViewBackgoundImageName:(NSString *)imageName;

@end
