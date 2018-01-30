//
//  SSQTrendNumberCell.h
//  LotteryTrend
//
//  Created by mac on 2017/12/15.
//  Copyright © 2017年 Hubery. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 走势图元素背景形状 */
typedef NS_ENUM(NSUInteger, ShapeType) {
    
    ShapeWithNothing = 0,            // 无背景，无文字
    ShapeWithNoBackgroundView ,      // 没有背景，有文字
    ShapeWithBackgroundViewRound,    // 圆形背景，有文字
};

@interface SSQTrendNumberCell : UICollectionViewCell

/** 数字 */
@property (copy, nonatomic) NSString *number;

/** 文字颜色 */
@property (strong, nonatomic) UIColor *textColor;

/** 背景色 */
@property (strong, nonatomic) UIColor *bgColor;

/** 背景形状 */
@property (assign, nonatomic) ShapeType shapeType;


@end
