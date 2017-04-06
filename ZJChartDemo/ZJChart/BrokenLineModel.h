//
//  BrokenLineModel.h
//  KangarooBoss
//
//  Created by 陈志健 on 2017/3/1.
//  Copyright © 2017年 kanwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokenLineModel : NSObject

//y轴数据
@property(nonatomic, strong) NSArray *yDataArray;
//x轴数据
@property(nonatomic, strong) NSArray *xDataArray;
//总共的点数
@property(nonatomic, assign) NSInteger totalPointNub;

@end
