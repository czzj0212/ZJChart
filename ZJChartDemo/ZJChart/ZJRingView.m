//
//  ZJRingView.m
//  BrokenLineDemo
//
//  Created by 陈志健 on 2016/11/21.
//  Copyright © 2016年 czj. All rights reserved.
//

#import "ZJRingView.h"

@interface ZJRingView ()


//数值和
@property (nonatomic, assign) CGFloat totalValue;

//圆心
@property (nonatomic, assign) CGPoint chartOrigin;

//排序后数据
@property (nonatomic, strong) NSArray <ZJRingModel *> * sortDataModelArray;

//暂无数据按钮
@property (nonatomic, strong) UIButton *noDataButton;

@property (nonatomic, strong) NSMutableArray *mLayerArray;

@end

@implementation ZJRingView

static  CGFloat drawAnimaTime = 1.0;


- (instancetype)initWithFrame:(CGRect)frame {
   
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.chartOrigin = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2);
        self.backgroundColor = [UIColor clearColor];
        self.minRingWidth = frame.size.height / 8;
        self.redius = frame.size.height / 4 + self.minRingWidth / 2;
        self.ringSpace = 2.0;
        self.title = @"销售分布";
        self.subTitle = @"";
    }
    return self;
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
        _noDataButton.center = CGPointMake(self.width / 2.0, self.height *3/ 4.0);
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
    
    //标题和日期
    [self drawTitleAndDate];

}

#pragma mark - 画圆环
- (void)drawRings{
    
    CGFloat lastBegin = 0;
    CGFloat totalAngle = 0;
    
    for (int i = 0; i < self.sortDataModelArray.count; i ++) {
        
        ZJRingModel *ringModel = self.sortDataModelArray[i];
        
        if (ringModel.dataValue == 0) {
            
            continue;
        }
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat cuttentpace = ringModel.dataValue  * M_PI * 2 ;
        totalAngle += ringModel.dataValue ;
        
        [path addArcWithCenter:self.chartOrigin radius:_redius + i*_ringSpace startAngle:lastBegin  endAngle:lastBegin  + cuttentpace clockwise:YES];
        
        CAShapeLayer *arcLayer = [CAShapeLayer layer];
        arcLayer.fillColor = [UIColor clearColor].CGColor;
        arcLayer.strokeColor = [ringModel.ringColor CGColor];
        arcLayer.path = path.CGPath;
        [self.layer addSublayer:arcLayer];
        [self.mLayerArray addObject:arcLayer];
        arcLayer.lineWidth = i*_ringSpace*2 + _minRingWidth;
        //绘制动画
        CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        fillAnimation.fromValue = @(0);
        fillAnimation.toValue = @(1);
        fillAnimation.duration = drawAnimaTime;
        fillAnimation.fillMode = kCAFillModeForwards;
        [arcLayer addAnimation:fillAnimation forKey:@"fillAnimation"];
        lastBegin += cuttentpace;
    }
    
}

#pragma mark - 标题日期
- (void)drawTitleAndDate {


    /*
     显示标题
     */
    UIFont *titleFont = [UIFont systemFontOfSize:14.7];
    NSDictionary *titleAttributes = @{NSFontAttributeName : titleFont , NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize titleSize = [self.title sizeWithAttributes:titleAttributes];
    CGPoint titlePoint = CGPointMake(self.chartOrigin.x - titleSize.width /2.0, self.chartOrigin.y - titleSize.height);
    [self.title drawAtPoint:titlePoint withAttributes:titleAttributes];
    /*
     显示日期
     */
    UIFont *subTitleFont = [UIFont systemFontOfSize:10];
    NSDictionary *subTitleAttributes = @{NSFontAttributeName : subTitleFont , NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize subTitleSize = [self.subTitle sizeWithAttributes:subTitleAttributes];
    CGPoint subTitlePoint = CGPointMake(self.chartOrigin.x - subTitleSize.width /2.0, self.chartOrigin.y + 10);
    [self.subTitle drawAtPoint:subTitlePoint withAttributes:subTitleAttributes];



}

#pragma mark - 标记线条文字
- (void)drawFlagTextAndLine {

    /*
     绘制标记线与文字
     */
    
    CGFloat lastBegin = 0;
    CGFloat longLen = _redius + self.minRingWidth/2.0 + self.sortDataModelArray.count * self.ringSpace * 2;
    
    for (NSInteger i = 0; i < self.sortDataModelArray.count; i++) {
        
        ZJRingModel *ringModel = self.sortDataModelArray[i];
        
        if (ringModel.dataValue == 0) {
            
            continue;
        }
        
        CGFloat currentSpace = ringModel.dataValue  * M_PI * 2 ;;
        CGFloat midSpace = lastBegin + currentSpace / 2;
        CGPoint beginPoint = CGPointMake(self.chartOrigin.x + cos(midSpace) * _redius, self.chartOrigin.y + sin(midSpace)*_redius);
        CGPoint secondPoint = CGPointMake(self.chartOrigin.x + cos(midSpace) * longLen, self.chartOrigin.y + sin(midSpace)*longLen);
        
        lastBegin +=  currentSpace;
        
        UIColor * whiteColor= [UIColor whiteColor];
        
        
        /*
         标记线段
         */
        UIBezierPath * textLinePath = [[UIBezierPath alloc] init];
        [textLinePath moveToPoint:beginPoint];
        [textLinePath addLineToPoint:secondPoint];
        
        //结束点
        CGPoint endPoint = CGPointZero;
        CGPoint textPoint = CGPointZero;
        /*
         文字字体
         */
        UIFont *textFont = [UIFont systemFontOfSize:11];
        NSDictionary *textAttributes = @{NSFontAttributeName : textFont , NSForegroundColorAttributeName : whiteColor};
        NSString *textString = [NSString stringWithFormat:@" %.1f%%  ", ringModel.dataValue   * 100];
        CGSize textSize = [textString sizeWithAttributes:textAttributes];
        
        
        if (midSpace < M_PI_2 || midSpace > M_PI_2 *3) {
            
            endPoint = CGPointMake(secondPoint.x + _minRingWidth / 2.0, secondPoint.y);
            
            textPoint = CGPointMake(endPoint.x + 3, endPoint.y - textSize.height);
            
        }else{
            
            endPoint = CGPointMake(secondPoint.x - _minRingWidth / 2.0, secondPoint.y);
            
            textPoint = CGPointMake(endPoint.x - (3 + textSize.width), endPoint.y - textSize.height);
            
        }
        
        [textLinePath addLineToPoint:endPoint];
        
        
        [textLinePath addArcWithCenter:endPoint radius:1.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        
        CAShapeLayer *textLineLayer = [CAShapeLayer layer];
        textLineLayer.path = textLinePath.CGPath;
        textLineLayer.strokeColor = [whiteColor CGColor];
        textLineLayer.fillColor = [[UIColor clearColor] CGColor];
        textLineLayer.lineCap = kCALineCapSquare;
        textLineLayer.lineJoin = kCALineJoinBevel;
        textLineLayer.lineWidth = 2.0;
        textLineLayer.opacity = 1.0;
        [self.layer addSublayer:textLineLayer];
        [self.mLayerArray addObject:textLineLayer];
        //动画
        CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        fillAnimation.fromValue = @(0);
        fillAnimation.toValue = @(1);
        fillAnimation.duration = drawAnimaTime;
        fillAnimation.fillMode = kCAFillModeForwards;
        [textLineLayer addAnimation:fillAnimation forKey:@"fillAnimation"];
        
        //标记文字百分比
        CATextLayer *textLayer = [CATextLayer layer];
        
        NSAttributedString *textAttString = [[NSAttributedString alloc] initWithString:textString attributes:textAttributes];
        
        textLayer.string = textAttString;
        textLayer.alignmentMode = kCAAlignmentCenter;

        textLayer.frame = CGRectMake(textPoint.x , textPoint.y , textSize.width , textSize.height);
        textLayer.foregroundColor = whiteColor.CGColor;
        textLayer.opacity = 0.0;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:textLayer];
        [self.mLayerArray addObject:textLayer];
        
        //标记文字名字
        CATextLayer *textNameLayer = [CATextLayer layer];
        
        NSAttributedString *textNameAttString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", ringModel.name] attributes:textAttributes];
        textNameLayer.string = textNameAttString;
        textNameLayer.alignmentMode = kCAAlignmentCenter;
        textNameLayer.frame = CGRectMake(textPoint.x , textPoint.y + textSize.height , textSize.width , textSize.height);
        textNameLayer.foregroundColor = whiteColor.CGColor;
        textNameLayer.opacity = 0.0;
        textNameLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:textNameLayer];
        [self.mLayerArray addObject:textNameLayer];

        //如果最大的大于90%,后面两个文字可能重叠
        ZJRingModel *maxRingModel = self.sortDataModelArray[0];

        if (maxRingModel.dataValue > 0.92) {
            
            if (i == 1) {
                
                //文字往上
                textLayer.frame = CGRectMake(textPoint.x , textPoint.y - textSize.height , textSize.width , textSize.height);

                textNameLayer.frame = CGRectMake(textPoint.x , textPoint.y , textSize.width , textSize.height);

                
            }else if (i == 2) {
            
                //文字往下
                textLayer.frame = CGRectMake(textPoint.x , textPoint.y + textSize.height , textSize.width , textSize.height);
                
                textNameLayer.frame = CGRectMake(textPoint.x , textPoint.y + textSize.height * 2, textSize.width , textSize.height);
            }
            
        }
        
        
        //设置延时动画,显示动画
        CABasicAnimation *showAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        showAnimation.duration = drawAnimaTime;
        showAnimation.repeatCount = 1;
        showAnimation.removedOnCompletion = NO;
        showAnimation.fillMode = kCAFillModeForwards;
        showAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        showAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [textLayer addAnimation:showAnimation forKey:@"showAnimation"];
        [textNameLayer addAnimation:showAnimation forKey:@"showAnimation"];

    }
    

}

#pragma mark - 重新加载数据源
- (void)reloadDataSourceValue {
    
    NSArray *modeLArray = [self.dataSource dataModelArrayOfZJRingView:self];
    
    //取数据源最大值和最小值
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"dataValue" ascending:NO];
    
    self.sortDataModelArray = [modeLArray sortedArrayUsingDescriptors:@[sort]];

    self.totalValue = 0;

    int i=0;
    for (ZJRingModel* ringModel in self.sortDataModelArray) {
       
        //
//        if (i == 0) {
//            
//            
//            ringModel.dataValue = 0.04;
//        }else if (i == 1) {
//        
//            ringModel.dataValue = 0.92;
//
//        }else if (i == 2) {
//            ringModel.dataValue = 0.04;
//
//        }
//        i++;
        //
        self.totalValue += ringModel.dataValue;

    }
    //
   // self.sortDataModelArray = [modeLArray sortedArrayUsingDescriptors:@[sort]];
//
    
}

#pragma mark - 重新绘制(外部)
- (void)reloadData {
    
    //移除layer
    for (CALayer *subLayer in self.mLayerArray) {
        
        [subLayer removeFromSuperlayer];
        
    }
    
    [self.mLayerArray removeAllObjects];
    //重新加载数据源
    [self reloadDataSourceValue];
    
    //重新绘图
    [self setNeedsDisplay];
    
    if (self.totalValue > 0 ) {
    
        //画圆环
        [self drawRings];
        //标记线条与文字
        [self drawFlagTextAndLine];

        //隐藏暂无数据
        self.noDataButton.hidden = YES;
        
    }else {
        //显示暂无数据
        self.noDataButton.hidden = NO;

    }
    
    
}

@end


#pragma mark - 数据模型
@implementation ZJRingModel



@end

