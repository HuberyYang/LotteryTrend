//
//  SSQTrendViewController.m
//  LotteryTrend
//
//  Created by mac on 2018/1/30.
//  Copyright © 2018年 Hubery. All rights reserved.
//

#import "SSQTrendViewController.h"
#import "SSQTrendLayout.h"
#import "SSQTrendIssueCell.h"
#import "SSQTrendNumberCell.h"
#import "SSQTrendModel.h"
#import "StatisticsModel.h"

@interface SSQTrendViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 号码标签 */
@property (strong, nonatomic) UIScrollView *ballsPagView;

/** 期号列表 */
@property (strong, nonatomic) UITableView *issueList;

/** 投注号列表 */
@property (strong, nonatomic) UICollectionView *numberList;

/** 列表数据 */
@property (strong, nonatomic) NSArray *listSource;

/** 统计数据 */
@property (strong, nonatomic) NSArray *statisticsSource;

@end

@implementation SSQTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"双色球蓝球走势";
    self.view.backgroundColor = kDARK_GRAY_COLOR;
    // 获取数据
    [self getListSource];
    // 添加号码标签view
    [self.view addSubview:self.ballsPagView];
    // 添加列表
    [self.view addSubview:self.issueList];
    [self.view addSubview:self.numberList];
    // 绘制折线
    [self drawBrokenLines];
}

- (void)getListSource{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ssq_trend" ofType:@"plist"];
    NSArray *dataArr = [[NSArray alloc] initWithContentsOfFile:filePath];
    self.listSource = [SSQTrendModel parseSSQTrendData:dataArr];
}

- (NSArray *)statisticsSource{
    
    if (!_statisticsSource) {
        
        // 出现次数统计
        NSMutableArray *appearCount = [NSMutableArray array];
        // 最大遗漏统计
        NSMutableArray *maxOmission = [NSMutableArray array];
        // 最大连出统计
        NSMutableArray *maxEven = [NSMutableArray array];
        // 最大连出中间量
        NSMutableArray *tmpEven = [NSMutableArray array];
        
        for (int sec = 0; sec < self.listSource.count; sec ++) {
            SSQTrendModel *tm = self.listSource[sec];
            NSArray *showBalls = tm.trends[1];
            for (int row = 0; row < showBalls.count; row ++) {
                TrendPerBall *pb = showBalls[row];
                
                // 出现次数统计 - 初始化
                if (appearCount.count <= row) {
                    [appearCount addObject:@0];
                }
                
                // 最大遗漏 - 初始化
                if (maxOmission.count <= row) {
                    [maxOmission addObject:@0];
                }
                
                
                // 中奖号出现次数统计
                if (pb.isAwardNumber) {
                    
                    int appear = [appearCount[row] intValue];
                    [appearCount replaceObjectAtIndex:row withObject:@(++appear)];
                    
                }else{ // 最大遗漏统计
                    
                    int max = [maxOmission[row] intValue];
                    int tmp = [pb.showcase intValue];
                    if (tmp > max) {
                        [maxOmission replaceObjectAtIndex:row withObject:@(tmp)];
                    }
                }
                
                // 最大连出统计
                if (sec == 0) {
                    pb.isAwardNumber ? [tmpEven addObject:@1] : [tmpEven addObject:@0];
                    pb.isAwardNumber ? [maxEven addObject:@1] : [maxEven addObject:@0];
                }else{
                    
                    SSQTrendModel *lastTm = self.listSource[sec - 1];
                    NSArray *lastShowBalls = lastTm.trends[1];
                    TrendPerBall *lastPb = lastShowBalls[row];
                    
                    if (!lastPb.isAwardNumber && pb.isAwardNumber) {
                        [tmpEven replaceObjectAtIndex:row withObject:@1];
                    }else if (lastPb.isAwardNumber && pb.isAwardNumber){
                        int tmp = [tmpEven[row] intValue];
                        [tmpEven replaceObjectAtIndex:row withObject:@(++tmp)];
                    }
                    
                    if ([tmpEven[row] intValue] > [maxEven[row] intValue]) {
                        [maxEven replaceObjectAtIndex:row withObject:tmpEven[row]];
                    }
                }
            }
        }
        
        // 平均遗漏
        NSMutableArray *appearOmission = [NSMutableArray array];
        for (int idx = 0; idx < appearCount.count; idx ++) {
            if ([appearCount[idx] intValue] == 0) {
                [appearOmission addObject:@(1)];
            }else{
                double res = (self.listSource.count - [appearCount[idx] intValue]) / [appearCount[idx] intValue];
                int apo = (int)round(res);
                [appearOmission addObject:@(apo)];
            }
        }
        
        NSMutableArray *tmpSource = [NSMutableArray array];
        for (int idx = 0; idx < 4; idx ++) {
            
            StatisticsModel *sm = [StatisticsModel new];
            switch (idx) {
                case 0:
                {
                    sm.itemName = @"出现次数";
                    sm.showColor = kRGB(121, 47, 155);
                    sm.showSource = [appearCount copy];
                }
                    break;
                case 1:
                {
                    sm.itemName = @"平均遗漏";
                    sm.showColor = kRGB(46, 99, 0);
                    sm.showSource = [appearOmission copy];
                }
                    break;
                case 2:
                {
                    sm.itemName = @"最大遗漏";
                    sm.showColor = kRGB(125, 67, 26);
                    sm.showSource = [maxOmission copy];
                }
                    break;
                case 3:
                {
                    sm.itemName = @"最大连出";
                    sm.showColor = kRGB(0, 104, 142);
                    sm.showSource = [maxEven copy];
                }
                    break;
                    
                default:
                    break;
            }
            
            
            [tmpSource addObject:sm];
        }
        
        _statisticsSource = [tmpSource copy];
    }
    return _statisticsSource;
}

- (UIScrollView *)ballsPagView{
    
    if (!_ballsPagView) {
        
        UIView *fillView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kIssueListWidth + 1, kItemSize.height)];
        fillView.backgroundColor = kBG_COLOR;
        [self.view addSubview:fillView];
        
        NSArray *balls = [self getNumberListFrom:1 count:16 isAuto:YES];
        _ballsPagView = [[UIScrollView alloc] initWithFrame:CGRectMake(kIssueListWidth + 1, 0, kScreenWidth - kIssueListWidth - 1, kItemSize.height)];
        _ballsPagView.backgroundColor = kDARK_GRAY_COLOR;
        _ballsPagView.contentSize = CGSizeMake(kItemSize.width * balls.count + (balls.count - 1) * 1, kItemSize.height);
        _ballsPagView.showsHorizontalScrollIndicator = NO;
        _ballsPagView.bounces = NO;
        _ballsPagView.delegate = self;
        for (int idx = 0; idx < balls.count; idx ++) {
            UILabel *ball = [[UILabel alloc] initWithFrame:CGRectMake((kItemSize.width + 1) * idx, 0, kItemSize.width, kItemSize.height)];
            ball.text = balls[idx];
            ball.textAlignment = NSTextAlignmentCenter;
            ball.font = [UIFont systemFontOfSize:12];
            ball.textColor = kRGB(112, 103, 96);
            ball.backgroundColor = kBG_COLOR;
            [_ballsPagView addSubview:ball];
        }
    }
    return _ballsPagView;
}

- (UITableView *)issueList{
    
    if (!_issueList) {
        
        _issueList = [[UITableView alloc] initWithFrame:CGRectMake(0, kItemSize.height, kIssueListWidth, kScreenHeight - kItemSize.height - kNavBarHeight) style:UITableViewStylePlain];
        _issueList.delegate = self;
        _issueList.dataSource = self;
        _issueList.bounces = NO;
        _issueList.backgroundColor = kDARK_GRAY_COLOR;
        _issueList.showsVerticalScrollIndicator = NO;
        _issueList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_issueList registerClass:[SSQTrendIssueCell class] forCellReuseIdentifier:NSStringFromClass([SSQTrendIssueCell class])];
        
    }
    return _issueList;
}

- (UICollectionView *)numberList{
    
    if (!_numberList) {
        
        SSQTrendLayout *layout = [[SSQTrendLayout alloc] init];
        layout.cols = 16;
        _numberList = [[UICollectionView alloc] initWithFrame:CGRectMake(kIssueListWidth + 1, kItemSize.height, kScreenWidth - kIssueListWidth - 1, kScreenHeight - kItemSize.height - kNavBarHeight) collectionViewLayout:layout];
        _numberList.delegate = self;
        _numberList.dataSource = self;
        _numberList.bounces = NO;
        _numberList.backgroundColor = kDARK_GRAY_COLOR;
        
        [_numberList registerClass:[SSQTrendNumberCell class] forCellWithReuseIdentifier:NSStringFromClass([SSQTrendNumberCell class])];
    }
    return _numberList;
}

- (NSArray *)getNumberListFrom:(int)from count:(int)count isAuto:(BOOL)isAuto{
    
    NSMutableArray *list = [NSMutableArray array];
    for (int idx = 0; idx < count; idx ++) {
        NSString *pStr = isAuto ? [NSString stringWithFormat:@"%02d",idx + from] : [NSString stringWithFormat:@"%d",idx + from];
        [list addObject:pStr];
    }
    return [list copy];
}

// 绘制折线
- (void)drawBrokenLines{
    
    // 计算线段开始点与结束点
    NSMutableArray <TrendPerBall *> *ballsPoints = [NSMutableArray array];
    for (int sec = 0; sec < self.listSource.count; sec ++) {
        SSQTrendModel *tm = self.listSource[sec];
        NSArray *showBalls = tm.trends.lastObject;
        for (int row = 0; row < showBalls.count; row ++) {
            
            TrendPerBall *pb = showBalls[row];
            CGFloat x = 0;
            CGFloat y = 0;
            
            // 每个item的宽高，需要与layout中item的frame保持一致
            x = row * (1 + kItemSize.width);
            y = 1 + sec * (1 + kItemSize.height);
            CGRect pFrame = CGRectMake(x, y, kItemSize.width, kItemSize.height);
            CGPoint pCenter = CGPointMake(pFrame.origin.x + pFrame.size.width / 2.0,
                                          pFrame.origin.y + pFrame.size.height / 2.0);
            
            pb.realRect = pFrame;
            pb.center = pCenter;
            
            if (pb.isAwardNumber) {
                [ballsPoints addObject:pb];
            }
        }
    }
    
    // 节点圆形半径
    CGFloat r = (MIN(kItemSize.width, kItemSize.height) - 4) / 2.0;
    // 计算绘制线段的开始点和结束点
    for (int index = 0; index < ballsPoints.count - 1; index ++) {
        
        TrendPerBall *fm = ballsPoints[index];
        TrendPerBall *tm = ballsPoints[index + 1];
        // 节点间距
        CGFloat dis = sqrt(pow(tm.center.x - fm.center.x, 2.0) + pow(tm.center.y - fm.center.y, 2.0));
        if (tm.center.x <= fm.center.x) { // 下个节点位于第上个节点左侧
            
            fm.startPoint = CGPointMake(fm.center.x - r * ((fm.center.x - tm.center.x) / dis),
                                        fm.center.y + r * ((tm.center.y - fm.center.y) / dis));
            
            tm.endPoint   = CGPointMake(tm.center.x + r * ((fm.center.x - tm.center.x) / dis),
                                        tm.center.y - r * ((tm.center.y - fm.center.y) / dis));
            
        }else{ // 下个节点位于第上个节点右侧
            
            fm.startPoint = CGPointMake(fm.center.x + r * ((tm.center.x - fm.center.x) / dis),
                                        fm.center.y + r * ((tm.center.y - fm.center.y) / dis));
            
            tm.endPoint   = CGPointMake(tm.center.x - r * ((tm.center.x - fm.center.x) / dis),
                                        tm.center.y - r * ((tm.center.y - fm.center.y) / dis));
        }
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:fm.startPoint];
        [path addLineToPoint:tm.endPoint];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.strokeColor = kBLUE_COLOR.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineWidth = 1;
        layer.lineCap = kCALineJoinRound;
        layer.lineJoin = kCALineJoinRound;
        
        [self.numberList.layer addSublayer:layer];
    }
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    
    if (scrollView == self.issueList) {
        self.numberList.contentOffset = CGPointMake(self.numberList.contentOffset.x, offset.y);
    }else if (scrollView == self.numberList){
        self.issueList.contentOffset = CGPointMake(self.issueList.contentOffset.x, offset.y);
        self.ballsPagView.contentOffset = CGPointMake(self.numberList.contentOffset.x, self.ballsPagView.contentOffset.y);
    }else if (scrollView == self.ballsPagView){
        self.numberList.contentOffset = CGPointMake(self.ballsPagView.contentOffset.x, self.numberList.contentOffset.y);
    }
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listSource.count + self.statisticsSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kItemSize.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSQTrendIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SSQTrendIssueCell class]) forIndexPath:indexPath];
    
    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : kBG_COLOR;
    
    if (indexPath.row < self.listSource.count) {
        SSQTrendModel *tm = self.listSource[indexPath.row];
        cell.issue.text = tm.showIssue;
        cell.issue.textColor = kRGB(154, 148, 142);
    }else{
        StatisticsModel *sm = self.statisticsSource[indexPath.row - self.listSource.count];
        cell.issue.text = sm.itemName;
        cell.issue.textColor = sm.showColor;
    }
    return cell;
}


#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.listSource.count + self.statisticsSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SSQTrendNumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SSQTrendNumberCell class]) forIndexPath:indexPath];
    cell.backgroundColor = indexPath.section % 2 == 0 ? [UIColor whiteColor] : kBG_COLOR;
    
    if (indexPath.section < self.listSource.count) {
        
        SSQTrendModel *pm = self.listSource[indexPath.section];
        TrendPerBall *pb = pm.trends[1][indexPath.row];
        
        cell.number = pb.showcase;
        if (pb.isAwardNumber) {
            
            cell.textColor = [UIColor whiteColor];
            cell.bgColor = kBLUE_COLOR;
            cell.shapeType = ShapeWithBackgroundViewRound;
        }else{
            
            cell.textColor = kRGB(186, 180, 175);
            cell.shapeType = ShapeWithNoBackgroundView;
        }
        
    }else{
        
        StatisticsModel *sm = self.statisticsSource[indexPath.section - self.listSource.count];
        
        cell.number = [sm.showSource[indexPath.row] stringValue];
        cell.textColor = sm.showColor;
        cell.shapeType = ShapeWithNoBackgroundView;
    }
    
    [cell setNeedsDisplay];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
