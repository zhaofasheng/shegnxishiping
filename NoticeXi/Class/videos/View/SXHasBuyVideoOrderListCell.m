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


- (void)setOrderListM:(SXBuyVideoOrderList *)orderListM{
    _orderListM = orderListM;
    self.orderNumL.text = [NSString stringWithFormat:@"订单编号：%@",orderListM.sn];
    
    if (orderListM.pay_status.intValue == 2) {
        self.markL.text = @"交易成功";
        _markL.textColor = [UIColor colorWithHexString:@"#14151A"];
    }else{
        self.markL.text = @"交易失败";
        _markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    }
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:orderListM.paySearModel.simple_cover_url]];
    self.titleL.text = orderListM.paySearModel.series_name;
    
    if (orderListM.cardModel.card_number.length > 6) {
        _numL.text = orderListM.product_type.intValue == 3? [NSString stringWithFormat:@"礼品卡(编号%@)",[orderListM.cardModel.card_number substringFromIndex:orderListM.cardModel.card_number.length-6]] : [NSString stringWithFormat:@"共%@课时",orderListM.paySearModel.episodes];
    }else{
        if (orderListM.product_type.intValue == 4) {
            if (orderListM.quantity.intValue == 0) {
                _numL.text = [NSString stringWithFormat:@"购买单节：%@",orderListM.video_title];
            }else{
                _numL.text = [NSString stringWithFormat:@"购买%@节(课程剩余所有内容)",orderListM.quantity];
            }
        }else{
            _numL.text = orderListM.product_type.intValue == 3? @"礼品卡" : [NSString stringWithFormat:@"共%@课时",orderListM.paySearModel.episodes];
        }

    }

    _moneyL.attributedText = [DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"¥%@",orderListM.fee] setColor:[UIColor colorWithHexString:@"#14151A"] setSize:16 setLengthString:@"¥" beginSize:0];
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
