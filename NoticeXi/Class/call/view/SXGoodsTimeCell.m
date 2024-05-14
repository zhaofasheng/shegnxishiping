//
//  SXGoodsTimeCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXGoodsTimeCell.h"

@implementation SXGoodsTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.timeL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, 88, 40)];
        self.timeL.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        self.timeL.font = XGFifthBoldFontSize;
        self.timeL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.text = @"10分钟";
        [self.contentView addSubview:self.timeL];
        [self.timeL setAllCorner:10];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
