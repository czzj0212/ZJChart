//
//  ZJRingView.h
//  BrokenLineDemo
//
//  Created by 陈志健 on 2016/11/21.
//  Copyright © 2016年 czj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJRingView;
@class ZJRingModel;
#pragma mark - 数据源
@protocol ZJRingViewDataSource <NSObject>

/*
 数据源 NSArray 数据模型数组
 */
- (NSArray <ZJRingModel *> *)dataModelArrayOfZJRingView:(ZJRingView *)ZJRingView;


@end




@interface ZJRingView : UIView


/*
 数据源
 */
@property(nonatomic, weak) id<ZJRingViewDataSource>dataSource;



/*
 半径
 */
@property (nonatomic, assign) CGFloat redius;

/*
 最小环的宽度         
 */
@property (nonatomic, assign) CGFloat minRingWidth;

/*
 不同环的宽度差
 */
@property (nonatomic, assign) CGFloat ringSpace;

/*
 标题
 */
@property (nonatomic, strong) NSString *title;

/*
 小标题(月份) 
 */
@property (nonatomic, strong) NSString *subTitle;


- (void)reloadData ;

@end


#pragma mark - 数据模型
@interface ZJRingModel : NSObject

/*
 环的颜色
 */
@property (nonatomic, strong) UIColor *ringColor;

/*
 数据
 */
@property (nonatomic, assign) CGFloat dataValue;

/*
 名字
 */
@property (nonatomic, strong) NSString *name;

@end
