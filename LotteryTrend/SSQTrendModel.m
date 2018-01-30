//
//  SSQTrendModel.m
//  LotteryTrend
//
//  Created by mac on 2017/12/15.
//  Copyright © 2017年 Hubery. All rights reserved.
//

#import "SSQTrendModel.h"

@implementation TrendPerBall

@end

@implementation SSQTrendModel

+ (NSArray *)parseSSQTrendData:(NSArray *)dataArr{
    
    NSMutableArray *backM = [NSMutableArray array];
    // 升序排序
   NSArray *tmpArr = [dataArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
        return [obj1[@"issue"] intValue] > [obj2[@"issue"] intValue];
    }];
    
    for (NSDictionary *pDict in tmpArr) {
        
        SSQTrendModel *pm = [SSQTrendModel new];
        pm.issue = pDict[@"issue"];
        pm.showIssue = [NSString stringWithFormat:@"%@期",[pm.issue substringWithRange:NSMakeRange(pm.issue.length - 3, 3)]];
        
        NSArray *trendCodes = pDict[@"bonus_code"];
        NSMutableArray *codes = [NSMutableArray array];
        for (NSArray *pArr in trendCodes) {
            NSMutableArray *codeTmp = [NSMutableArray array];
            for (NSString *pCode in pArr) {
                NSString *tmpStr = pCode;
                TrendPerBall *tp = [TrendPerBall new];
                if ([tmpStr containsString:@"_"]) {
                    tp.isAwardNumber = YES;
                    NSMutableArray *nums = [NSMutableArray arrayWithArray:[tmpStr componentsSeparatedByString:@"_"]];
                    [nums removeObject:@""];
                    tmpStr = nums.firstObject;
                }
                tp.showcase = tmpStr;
                [codeTmp addObject:tp];
            }
            [codes addObject:[codeTmp copy]];
        }
        pm.trends = [codes copy];
        [backM addObject:pm];
    }
    return [backM copy];
}










@end
