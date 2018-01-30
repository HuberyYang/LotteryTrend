//
//  SSQTrendModel.h
//  LotteryTrend
//
//  Created by mac on 2017/12/15.
//  Copyright © 2017年 Hubery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TrendPerBall : NSObject

/** 展示的数据 */
@property (copy, nonatomic) NSString *showcase;

/** 是否是开奖号码 */
@property (assign, nonatomic) BOOL isAwardNumber;

/** 相对于列表的真实frame */
@property (assign, nonatomic) CGRect realRect;

/** 相对于列表的控件中心坐标 */
@property (assign, nonatomic) CGPoint center;

/** 折线开始点 */
@property (assign, nonatomic) CGPoint startPoint;

/** 折线结束点 */
@property (assign,nonatomic) CGPoint endPoint;


@end


@interface SSQTrendModel : NSObject

/*****  原始数据  ****/

/** 期号 */
@property (copy, nonatomic) NSString *issue;

/** 开奖号码 */
@property (copy, nonatomic) NSString *bonuscode;



/*****  添加的数据  ****/

/** 展示期号 */
@property (copy, nonatomic) NSString *showIssue;

/** 走势结果 */
@property (strong, nonatomic) NSArray <NSArray *> *trends;

// 数据解析
+ (NSArray *)parseSSQTrendData:(NSArray *)dataArr;


@end


