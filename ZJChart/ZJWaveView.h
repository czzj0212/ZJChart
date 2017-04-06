//
//  ZJWaveView.h
//  BrokenLineDemo
//
//  Created by 陈志健 on 2016/11/22.
//  Copyright © 2016年 czj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJWaveView : UIView


/*
 波的数量
 */
@property (nonatomic, assign) NSInteger waveNum;


@end



#pragma mark - 波浪模型
@interface ZJWaveModel : NSObject

/*
 x偏移
 */
@property (nonatomic, assign) CGFloat offsetX;

/*
 速度
 */
@property (nonatomic, assign) CGFloat waveSpeed;

/*
layer
 */
@property (nonatomic, strong) CAShapeLayer *waveLayer;

@end
