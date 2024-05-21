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
        [self.contentView addSubview:self.timeL];
        [self.timeL setAllCorner:10];
    }
    return self;
}

- (void)setCateModel:(SXGoodsInfoModel *)cateModel{
    _cateModel = cateModel;
    
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    self.timeL.text = cateModel.category_name;
    self.timeL.frame = CGRectMake(0, 0, cateModel.cateWidth, 18);
    self.timeL.layer.cornerRadius = 6;
    self.timeL.layer.masksToBounds = YES;
    self.timeL.font = [UIFont systemFontOfSize:10];
    self.timeL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
}

- (void)setTimeModel:(SXGoodsInfoModel *)timeModel{
    _timeModel = timeModel;
    self.timeL.text = [NSString stringWithFormat:@"%@分钟",timeModel.time];
    self.timeL.backgroundColor = [UIColor colorWithHexString:timeModel.isChoice? @"#FF68A3":@"#F0F1F5"];
    self.timeL.textColor = [UIColor colorWithHexString:timeModel.isChoice?@"#FFFFFF": @"#14151A"];
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
