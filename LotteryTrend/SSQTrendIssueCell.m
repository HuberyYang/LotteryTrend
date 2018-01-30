//
//  SSQTrendIssueCell.m
//  LotteryTrend
//
//  Created by mac on 2017/12/15.
//  Copyright © 2017年 Hubery. All rights reserved.
//

#import "SSQTrendIssueCell.h"

@implementation SSQTrendIssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.issue = [[UILabel alloc] init];
        self.issue.textAlignment = NSTextAlignmentCenter;
        self.issue.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.issue];
        [self.issue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.bottom.and.right.equalTo(self);
        }];
        
        
        UIImageView *lineV = [[UIImageView alloc] init];
        [self addSubview:lineV];
        lineV.backgroundColor = kDARK_GRAY_COLOR;
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}

@end
