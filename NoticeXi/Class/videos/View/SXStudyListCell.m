//
//  SXStudyListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXStudyListCell.h"

@implementation SXStudyListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 56, 74)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(89,11,DR_SCREEN_WIDTH-89, 20)];
        _titleL.font = XGSIXBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:_titleL];
  
        UILabel *moneyML = [[UILabel alloc] initWithFrame:CGRectMake(89,60,GET_STRWIDTH(@"¥", 17, 24), 24)];
        moneyML.font = XGSIXBoldFontSize;
        moneyML.text = @"¥";
        moneyML.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [self.contentView addSubview:moneyML];
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moneyML.frame),59,100, 24)];
        _moneyL.font = SXNUMBERFONT(20);
        _moneyL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [self.contentView addSubview:_moneyL];
        
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-56-25, 31, 56, 32)];
        [label setAllCorner:16];
        label.text = @"添加";
        label.font = TWOTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    }
    return self;
}

- (void)setStudyModel:(SXPayForVideoModel *)studyModel{
    _studyModel = studyModel;
    self.titleL.text = _studyModel.series_name;
    self.moneyL.text = _studyModel.original_price;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_studyModel.simple_cover_url]];
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
