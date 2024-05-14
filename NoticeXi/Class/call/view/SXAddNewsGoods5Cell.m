//
//  SXAddNewsGoods5Cell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAddNewsGoods5Cell.h"

@implementation SXAddNewsGoods5Cell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 50)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];
        
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 150, 20)];
        markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        markL.font = XGFourthBoldFontSize;
        markL.attributedText = [DDHAttributedMode setColorString:@"*商品属性" setColor:[UIColor colorWithHexString:@"#EE4B4E"] setLengthString:@"*" beginSize:0];
        [self.backView addSubview:markL];


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
