//
//  SSQTrendNumberCell.m
//  LotteryTrend
//
//  Created by mac on 2017/12/15.
//  Copyright © 2017年 Hubery. All rights reserved.
//

#import "SSQTrendNumberCell.h"

@implementation SSQTrendNumberCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    // 创建画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置填充色
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    // 圆形直径
    CGFloat w = MIN(kItemSize.width, kItemSize.height) - 4;
    // 园点坐标
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width / 2.0,
                                 rect.origin.y + rect.size.height / 2.0);
    
    if (self.shapeType == ShapeWithBackgroundViewRound) { // 圆形背景
        
        CGContextAddArc(context, center.x, center.y, w / 2.0, 0 , 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathFill);
        [self drawShowText];
    }else if (self.shapeType == ShapeWithNoBackgroundView){ // 无背景
        [self drawShowText];
    }
}

// 绘制文字
- (void)drawShowText{
    
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize textSize = [self.number sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect textRect = CGRectMake((self.frame.size.width - textSize.width) / 2.0, (self.frame.size.height - textSize.height) / 2.0, self.frame.size.width, self.frame.size.height);
    [self.number drawInRect:textRect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:self.textColor}];
}


@end
