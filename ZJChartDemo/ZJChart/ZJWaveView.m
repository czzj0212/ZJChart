//
//  ZJWaveView.m
//  BrokenLineDemo
//
//  Created by 陈志健 on 2016/11/22.
//  Copyright © 2016年 czj. All rights reserved.
//

#import "ZJWaveView.h"

@interface ZJWaveView ()


/*
 
    公式  y=Asin(ωx+φ)+k
    A : 振幅      amplitude
    ω : 角速度    angularSpeed
    φ : 初相      initialPhase
    k : 偏距      offsetK
 
 */


/*
 偏距 k
 */
@property (nonatomic, assign) CGFloat offsetK;

/*
 角速度 ω
 */
@property (nonatomic, assign) CGFloat angularSpeed;

/*
 振幅
 */
@property (nonatomic, assign) CGFloat amplitude;


/*
波浪模型数组
 */
@property (nonatomic, strong) NSArray *waveModels;


/*
 定时显示
 */
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation ZJWaveView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        self.waveNum = 3;
        self.amplitude = 10;
        self.angularSpeed = M_PI *2 / frame.size.width ;
        self.offsetK = 10;
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawWaveAnimation)];
        
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        UIColor *color = [UIColor colorWithRed:80/255.0 green:180/255.0 blue:250/255.0 alpha:1];
        
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        for (int i = 0; i < _waveNum; i ++) {
            
            ZJWaveModel *waveModel = [[ZJWaveModel alloc] init];
            
            waveModel.waveSpeed = (i +1)/80.0;
            waveModel.waveLayer = [self customWaveLayerWithColor:color opacity:i /5.0 + 0.5];
            
            [mArray addObject:waveModel];
        }
        
        self.waveModels = [mArray copy];

    }
    return self;
}


- (CAShapeLayer *)customWaveLayerWithColor:(UIColor *)color opacity:(CGFloat)opacity{

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.fillColor = [color CGColor];
    shapeLayer.lineCap = kCALineCapSquare;
    shapeLayer.lineJoin = kCALineJoinBevel;
    shapeLayer.lineWidth = 1.0;
    shapeLayer.opacity = opacity;
    [self.layer addSublayer:shapeLayer];
    return shapeLayer;
}


- (void)drawWaveAnimation {


    
    
    
    for (ZJWaveModel *waveModel  in self.waveModels) {
        
        waveModel.offsetX -= waveModel.waveSpeed;
        
        [self drawWaveLineWithShapeLaye:waveModel.waveLayer initialPhase:50  offsetX:waveModel.offsetX ];

    }
    

}



- (void)drawWaveLineWithShapeLaye:(CAShapeLayer *)layer  initialPhase:(CGFloat)initialPhase offsetX:(CGFloat)offsetX {
    
    
    //路径
    UIBezierPath * linePath = [[UIBezierPath alloc] init];

    for (int x = 0; x <= self.frame.size.width; x ++) {
        /*
         公式  y=Asin(ωx+φ)+k
         */
        CGFloat yValue = self.frame.size.height - _amplitude * sin(_angularSpeed * x + initialPhase + offsetX) - _offsetK - _amplitude;
        CGPoint point = CGPointMake(x, yValue);
        if (x == 0) {
            
            [linePath moveToPoint:point];
            
        }else {
        
            [linePath addLineToPoint:point];
        }
    }
    
    [linePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [linePath addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [linePath closePath];
    
    //创建layer
    layer.path = linePath.CGPath;
    
//直接添加导视图上
    
//    //绘制动画
//    CABasicAnimation *waveAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    waveAnimation.repeatCount = HUGE_VALF;
//    waveAnimation.fromValue = @(0);
//    waveAnimation.toValue = @(1);
//    waveAnimation.duration = drawAnimaTime;
//    waveAnimation.fillMode = kCAFillModeForwards;
//    [lineLayer addAnimation:waveAnimation forKey:@"waveAnimation"];
}

@end



#pragma mark - 波浪模型
@implementation ZJWaveModel



@end


