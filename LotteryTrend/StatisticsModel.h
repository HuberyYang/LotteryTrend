//
//  StatisticsModel.h
//  LotteryTrend
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 yml. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsModel : NSObject

/** 条目名称 */
@property (copy, nonatomic) NSString *itemName;

/** 文字颜色 */
@property (strong, nonatomic) UIColor *showColor;

/** 统计数据 */
@property (strong, nonatomic) NSArray <NSNumber *> *showSource;


@end
