//
//  SXHasBuyVideoOrderListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasBuyVideoOrderListCell.h"

@implementation SXHasBuyVideoOrderListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 124)];
        backView.backgroundColor = [UIColor whiteColor];
        [backView setAllCorner:8];
        [self addSubview:backView];
        
        _orderNumL = [[UILabel alloc] initWithFrame:CGRectMake(10,11,backView.frame.size.width-10-100, 17)];
        _orderNumL.font = TWOTEXTFONTSIZE;
        _orderNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        _orderNumL.text = @"订单编号：20220609000012";
        [backView addSubview:_orderNumL];
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-110,10,100, 20)];
        _markL.font = XGFourthBoldFontSize;
        _markL.textAlignment = NSTextAlignmentRight;
        _markL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [backView addSubview:_markL];
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 40, 56, 74)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [backView addSubview:self.coverImageView];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(76,44,backView.frame.size.width-80, 22)];
        _titleL.font = XGSIXBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [backView addSubview:_titleL];
        

        _numL = [[UILabel alloc] initWithFrame:CGRectMake(76,74,backView.frame.size.width-10-100, 17)];
        _numL.font = TWOTEXTFONTSIZE;
        _numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backView addSubview:_numL];
    
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-100,90,100, 24)];
        _moneyL.font = SXNUMBERFONT(22);
        _moneyL.textAlignment = NSTextAlignmentRight;
        _moneyL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [backView addSubview:_moneyL];
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
