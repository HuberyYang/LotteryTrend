//
//  SSQTrendLayout.m
//  LotteryTrend
//
//  Created by mac on 2017/12/15.
//  Copyright © 2017年 Hubery. All rights reserved.
//

#import "SSQTrendLayout.h"

@implementation SSQTrendLayout{
    
    NSMutableArray *_attributes;
    NSInteger _itemCount;
}

- (void)prepareLayout{
    [super prepareLayout];
    
    _itemCount = [self.collectionView numberOfSections];
    _attributes = [NSMutableArray array];
    
    for (int index = 0; index < _itemCount; index ++) {
        NSInteger pSec = [self.collectionView numberOfItemsInSection:index];
        for (int i = 0; i < pSec; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:index];
            UICollectionViewLayoutAttributes *pAttri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            CGFloat x = 0;
            CGFloat y = 0;
            
            // 每个item的宽高
            x = i * (1 + kItemSize.width);
            y = 1 + index * (1 + kItemSize.height);
            pAttri.frame = CGRectMake(x, y, kItemSize.width, kItemSize.height);
            
            [_attributes addObject:pAttri];
        }
    }
    
    
}

// 设置内容区域的大小
- (CGSize)collectionViewContentSize{
    // sections
    NSInteger sec = [self.collectionView numberOfSections];
    return CGSizeMake((self.cols + 1) * 1 + self.cols * kItemSize.width, sec * (kItemSize.height + 1));
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributes;
}



@end
