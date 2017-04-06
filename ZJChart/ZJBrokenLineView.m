//
//  ZJBrokenLineView.m
//  BrokenLineDemo
//
//  Created by 陈志健 on 2016/11/7.
//  Copyright © 2016年 czj. All rights reserved.
//

#import "ZJBrokenLineView.h"
#import "MonthChooseModel.h"

@interface ZJBrokenLineView ()

/* 折线图层 */
//@property (nonatomic, strong) CAShapeLayer *lineChartLayer;

/* 坐标宽度 */
@property (nonatomic, assign) CGFloat lineViewWidth;

/* 坐标高度 */
@property (nonatomic, assign) CGFloat lineViewHeight;

//代理数据
/* 月份 */
@property (nonatomic, strong) NSString *monthString;
/* 数据源-x轴数据 */
@property (nonatomic, strong) NSArray *xDataArray;

/* 数据源-x轴数据 */
@property (nonatomic, strong) NSArray *yDataArray;

@property (nonatomic, assign) CGFloat yTotalValue;

/*当月的天数  总共多少个点*/
@property (nonatomic, assign) NSInteger monthDays;

//计算数据
/* y轴最大数据值 */
@property (nonatomic, assign) CGFloat maxYValue;

/* y轴最小数据值 */
@property (nonatomic, assign) CGFloat minYValue;

/* 最大数据值 */
@property (nonatomic, assign) CGFloat maxDataValue;

/* 最小数据值 */
@property (nonatomic, assign) CGFloat minDataValue;

/*
 记录已经标记最大最小值
 */
@property (nonatomic, assign) BOOL hasMinValue;

@property (nonatomic, assign) BOOL hasMaxValue;

//暂无数据按钮
@property (nonatomic, strong) UIButton *noDataButton;


//折线与标记Layer array
@property (nonatomic, strong) NSMutableArray *mLayerArray;

@end

/* 动画持续时间 */
static  CGFloat drawAnimaTime = 1.0;

@implementation ZJBrokenLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor orangeColor];
        //初始化颜色,间距
        self.coordinatesColor = [UIColor grayColor];
        self.lineColor = [UIColor grayColor];
        self.xLabelColor = [UIColor blackColor];
        self.flagColor = [UIColor whiteColor];
        self.titleColor = [UIColor blackColor];
        self.bounceX = 30;
        self.bounceBottom = 28;
        self.bounceTop = 28;
        self.lineSpacePercent = 0.3;
        self.leftTitle = @"日均";
        self.rightTitle = @"累计";
        self.unitName = @"元";
        //设置阴影
        self.layer.shadowColor = [UIColor colorWithRed:90/255.0 green:52/255.0 blue:154/255.0 alpha:1].CGColor;
        self.layer.shadowOffset = CGSizeMake(3,3);
        //阴影透明度，默认0
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 3;
    }
    return self;
}

//设置上下间隙   不能小于0
- (void)setLineSpacePercent:(CGFloat)lineSpacePercent {
    
    if (lineSpacePercent <= 0){
    
        return;
    }else if (lineSpacePercent >= 0.5) {
    
        return;
    }

    _lineSpacePercent = lineSpacePercent;
}

- (NSMutableArray *)mLayerArray {

    if (_mLayerArray == nil) {
        
        _mLayerArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return _mLayerArray;
    
}

#pragma mark - 懒加载视图
- (UIButton *)noDataButton {


    if (_noDataButton == nil) {
        
        _noDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _noDataButton.frame = CGRectMake(0, 0, 80, 20);
        
        [_noDataButton setTitle:@"暂无数据" forState:UIControlStateNormal];
        [_noDataButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _noDataButton.titleLabel.font = [UIFont systemFontOfSize:14.7 weight:UIFontWeightLight];
        _noDataButton.center = CGPointMake(self.width / 2.0, self.height / 2.0);
        [_noDataButton addTarget:self action:@selector(noDataButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _noDataButton.hidden = YES;
        [self addSubview:_noDataButton];
    }

    return _noDataButton;
}

- (void)noDataButtonAction {

    NSLog(@"123");

}

#pragma mark - view重绘
- (void)drawRect:(CGRect)rect{
    
    //画出坐标轴与标题,日期
    [self drawCoordinatesAndTitle];
    
}


#pragma mark - 画出坐标轴与标题,日期
- (void)drawCoordinatesAndTitle {
    
    CGRect rect = self.bounds;
    /*
     画出坐标轴
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.3);
    CGContextSetStrokeColorWithColor(context, self.coordinatesColor.CGColor);
    CGContextMoveToPoint(context, _bounceX, _bounceTop);
    CGContextAddLineToPoint(context, rect.size.width - _bounceX, _bounceTop);
    CGContextMoveToPoint(context, _bounceX, rect.size.height - _bounceBottom);
    CGContextAddLineToPoint(context, rect.size.width - _bounceX, rect.size.height - _bounceBottom);
    CGContextStrokePath(context);
    /*
     显示标题,日期
     */
    UIFont *titleFont = [UIFont systemFontOfSize:12];
    NSDictionary *titleAttributes = @{NSFontAttributeName : titleFont , NSForegroundColorAttributeName : self.titleColor};
    
    [self.leftTitle drawAtPoint:CGPointMake(_bounceX, 11.3) withAttributes:titleAttributes];
    CGSize rightTitleSize = [self.rightTitle sizeWithAttributes:titleAttributes];
    [self.rightTitle drawAtPoint:CGPointMake(rect.size.width - _bounceX - rightTitleSize.width, 11.3) withAttributes:titleAttributes];
    
    /* 
     绘制x轴文字
     */
    NSInteger xNum = self.xDataArray.count;
    //x轴字体
    UIFont *xTextFont = [UIFont systemFontOfSize:12];
    NSDictionary *xTextAttributes = @{NSFontAttributeName : xTextFont , NSForegroundColorAttributeName : self.xLabelColor};
    
    for (int i = 0; i < xNum; i ++) {

        //x轴文字
        NSString *xText = self.xDataArray[i];
        CGSize textSize = [xText sizeWithAttributes:xTextAttributes];
        
        CGFloat pointX = (self.lineViewWidth - textSize.width)/(xNum - 1) * i + _bounceX ;
        
        CGPoint xTextPoint = CGPointMake(pointX, self.frame.size.height - _bounceBottom + 5);
        
        [xText drawAtPoint:xTextPoint withAttributes:xTextAttributes];
  
    }
    

    
}

- (void)drawBrokenLine {
    /*
     绘制折线
     */
    //折线路径
    UIBezierPath * linePath = [[UIBezierPath alloc] init];
    
    CGFloat yValueSpace = self.maxYValue  - self.minYValue;
    //maxData与minData都是0时,yValueSpace会为0
    if (yValueSpace == 0) {
        yValueSpace = 1;
    }
    for (int i = 0; i < self.yDataArray.count; i ++) {
        
        //绘制折线
        CGFloat pointValue = [self.yDataArray[i] floatValue];
        
        CGPoint linePoint = CGPointMake(self.lineViewWidth/(_monthDays-1) * i + _bounceX, (1 - (pointValue - self.minYValue) / yValueSpace) *self.lineViewHeight + self.bounceTop);
        
        if (i == 0) {
            
            [linePath moveToPoint:linePoint];
        }else {
            
            [linePath addLineToPoint:linePoint];
            
        }
        
        //最大或者最小
        /*
         绘制标记点和折线
         */
        if ([self.yDataArray[i] floatValue] == self.maxDataValue) {
        
            if (self.hasMaxValue == NO) {
                
                CFTimeInterval beginTime = drawAnimaTime * i / _monthDays + CACurrentMediaTime();
                [self drawArcAtPoint:linePoint value:pointValue beginTime:beginTime isTop:YES];
                self.hasMaxValue = YES;
            }
        }else if ([self.yDataArray[i] floatValue] == self.minDataValue) {
            
            if (self.hasMinValue == NO) {
                
                CFTimeInterval beginTime = drawAnimaTime * i / _monthDays + CACurrentMediaTime();
                [self drawArcAtPoint:linePoint value:pointValue beginTime:beginTime isTop:NO];
                self.hasMinValue = YES;
            }
        }

  
    }
    CAShapeLayer *lineChartLayer = [CAShapeLayer layer];
    //self.lineChartLayer = [CAShapeLayer layer];
    lineChartLayer.path = linePath.CGPath;
    lineChartLayer.strokeColor = [self.lineColor CGColor];
    lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    lineChartLayer.lineCap = kCALineCapSquare;
    lineChartLayer.lineJoin = kCALineJoinBevel;
    lineChartLayer.lineWidth = 2;
    //直接添加导视图上,最底层
    [self.layer insertSublayer:lineChartLayer atIndex:0];
    [self.mLayerArray addObject:lineChartLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = drawAnimaTime;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [lineChartLayer addAnimation:pathAnimation forKey:@"pathAnimation"];
    
    

}
#pragma mark - 画点与标记
- (void)drawArcAtPoint:(CGPoint)point value:(CGFloat)value beginTime:(CFTimeInterval)beginTime  isTop:(BOOL)istop{

    /*
     画点
     */
    UIBezierPath * arcPath = [[UIBezierPath alloc]init];
    [arcPath addArcWithCenter:point radius:4 startAngle:0 endAngle:M_PI * 2 clockwise:0];
    CAShapeLayer *arcLayer = [CAShapeLayer layer];
    arcLayer.path = arcPath.CGPath;
    arcLayer.strokeColor = [[UIColor clearColor] CGColor];
    arcLayer.fillColor = [self.lineColor CGColor];
    arcLayer.lineCap = kCALineCapSquare;
    arcLayer.lineJoin = kCALineJoinBevel;
    arcLayer.lineWidth = 0.0;
    arcLayer.opacity = 0.0;
    //直接添加导视图上
    [self.layer addSublayer:arcLayer];
    [self.mLayerArray addObject:arcLayer];

    
    //设置延时动画
    CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    arcAnimation.beginTime = beginTime;
    arcAnimation.duration = 1;
    arcAnimation.repeatCount = 1;
    arcAnimation.removedOnCompletion = NO;
    arcAnimation.fillMode = kCAFillModeForwards;
    arcAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    arcAnimation.toValue = [NSNumber numberWithFloat:1.0f];

    [arcLayer addAnimation:arcAnimation forKey:@"arcAnimation"];
   
    /*
     标记线段
     */
    UIBezierPath * textLinePath = [[UIBezierPath alloc]init];
    [textLinePath moveToPoint:point];
    
    CGFloat lineYchange = 0;
    if (istop) {
        //往上
        lineYchange = - 10;
    }else {
        //往下
        lineYchange =  10;

    }
    
    [textLinePath addLineToPoint:CGPointMake(point.x + 5, point.y + lineYchange)];
    [textLinePath addLineToPoint:CGPointMake(point.x + 25, point.y + lineYchange)];

    CAShapeLayer *textLineLayer = [CAShapeLayer layer];
    textLineLayer.path = textLinePath.CGPath;
    textLineLayer.strokeColor = [self.lineColor CGColor];
    textLineLayer.fillColor = [[UIColor clearColor] CGColor];
    textLineLayer.lineCap = kCALineCapSquare;
    textLineLayer.lineJoin = kCALineJoinBevel;
    textLineLayer.lineWidth = 1.0;
    textLineLayer.opacity = 0.0;
    //直接添加导视图上
    [self.layer addSublayer:textLineLayer];
    [self.mLayerArray addObject:textLineLayer];

    //设置延时动画,画线动画
    CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    lineAnimation.beginTime = beginTime;
    lineAnimation.duration = 1;
    lineAnimation.repeatCount = 1;
    lineAnimation.removedOnCompletion = YES;
    lineAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    lineAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    //设置动画代理，动画结束时添加一个标签，显示折线终点的信息
    [textLineLayer addAnimation:lineAnimation forKey:@"lineAnimation"];
    
    //设置延时动画,显示动画
    CABasicAnimation *showAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showAnimation.beginTime = beginTime;
    showAnimation.duration = 1;
    showAnimation.repeatCount = 1;
    showAnimation.removedOnCompletion = NO;
    showAnimation.fillMode = kCAFillModeForwards;
    showAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    showAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    //设置动画代理，动画结束时添加一个标签，显示折线终点的信息
    [textLineLayer addAnimation:showAnimation forKey:@"showAnimation"];
    
    //标记字体
    UIFont *textFont = [UIFont systemFontOfSize:8];
    NSDictionary *textAttributes = @{NSFontAttributeName : textFont , NSForegroundColorAttributeName : self.flagColor};
    NSAttributedString *textAttString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.*f",_numbOfFloat, value] attributes:textAttributes];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = textAttString;
    textLayer.alignmentMode = kCAAlignmentCenter;
    
    if (istop) {
        //往上
        lineYchange = - 20;
    }else {
        //往下
        lineYchange =  0;
        
    }
    textLayer.frame = CGRectMake(point.x  , point.y + lineYchange, 30, 10);
    textLayer.foregroundColor = self.flagColor.CGColor;
    textLayer.opacity = 0.0;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:textLayer];
    [self.mLayerArray addObject:textLayer];

    [textLayer addAnimation:showAnimation forKey:@"showAnimation"];

}


#pragma mark - 重新加载数据源
- (void)reloadDataSourceValue {

    //更新代理的数据
    BrokenLineModel *brokenLineModel = [self.dataSource yDataModelOfZJBrokenLineView:self];
    
    self.yDataArray = brokenLineModel.list;
    //x轴
    self.monthString = [self.dataSource monthStringOfZJBrokenLineView:self];
    
    MonthChooseModel *monthChooseModel = [[MonthChooseModel alloc] init];
    NSInteger lastDay = [monthChooseModel theNumberOfDaysInMonth:self.monthString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *monthDate = [dateFormatter dateFromString:_monthString];
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:monthDate];
    self.xDataArray = @[ [NSString stringWithFormat:@"%@/01",month],
                         [NSString stringWithFormat:@"%@/08",month],
                         [NSString stringWithFormat:@"%@/15",month],
                         [NSString stringWithFormat:@"%@/22",month],
                         [NSString stringWithFormat:@"%@/%ld",month,(long)lastDay]];
    self.monthDays = lastDay;
    
    self.hasMinValue = NO;
    self.hasMaxValue = NO;
    //取数据源最大值和最小值
    
    NSArray * sortYDataArray = [self.yDataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        if([obj1 floatValue] > [obj2 floatValue]){
            
            return NSOrderedDescending;
        }else if([obj1 floatValue] < [obj2 floatValue]){
            
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
            
        }

    }];

    NSNumber *maxYNub = [sortYDataArray lastObject];
    NSNumber *minYNub = [sortYDataArray firstObject];
    self.maxDataValue = [maxYNub floatValue];
    self.minDataValue = [minYNub floatValue];

    //计算Y轴最大数据和最小数据
    self.maxYValue = self.maxDataValue + (self.maxDataValue-self.minDataValue) / 2* self.lineSpacePercent;
    self.minYValue = self.minDataValue - (self.maxDataValue-self.minDataValue) / 2* self.lineSpacePercent;
    
    //计算累计值
    self.yTotalValue = [brokenLineModel.total floatValue];

    self.leftTitle = [NSString stringWithFormat:@"日均 : %.*f%@",_numbOfFloat,[brokenLineModel.average floatValue],_unitName];
    self.rightTitle = [NSString stringWithFormat:@"累计 : %.*f%@",_numbOfFloat,self.yTotalValue,_unitName];
    //重新计算折线图高度,宽度
    self.lineViewWidth = self.frame.size.width - 2 * self.bounceX;
    self.lineViewHeight = self.frame.size.height - self.bounceTop - self.bounceBottom;
}


#pragma mark - 背景图
- (void)setUIViewBackgoundImageName:(NSString *)imageName {
    
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}

#pragma mark - 重新绘制(外部)
- (void)reloadData {
    
    //移除layer
    for (CALayer *subLayer in self.mLayerArray) {
        
        [subLayer removeFromSuperlayer];
        
    }
    
    [self.mLayerArray removeAllObjects];
    //取数据源数据
    [self reloadDataSourceValue];
    //重新绘图
    [self setNeedsDisplay];
    
    if (self.yDataArray.count == 0) {
        //显示暂无数据
        self.noDataButton.hidden = NO;

    }else {
        
        self.noDataButton.hidden = YES;
        [self drawBrokenLine];
    }
    
    
//    if (self.yTotalValue > 0) {
//        
//        //开始画线
//        [self drawBrokenLine];
//        //隐藏暂无数据
//        self.noDataButton.hidden = YES;
//    }else {
//        //显示暂无数据
//        self.noDataButton.hidden = NO;
//    }
    


}


@end
