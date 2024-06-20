//
//  SXBuySearisSuccessView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuySearisSuccessView.h"

@implementation SXBuySearisSuccessView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *statusView = [[UIView  alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-30, 60)];
        statusView.backgroundColor = [UIColor whiteColor];
        [statusView setAllCorner:8];
        [self addSubview:statusView];
        
        self.statusImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
        [statusView addSubview:self.statusImageView];
        self.statusImageView.image = UIImageNamed(@"sxpaysuccess_img");
        
        self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(38,0,200, 60)];
        self.statusL.font = XGTwentyBoldFontSize;
        self.statusL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [statusView addSubview:self.statusL];
        
        self.reasonL = [[UILabel alloc] initWithFrame:CGRectMake(statusView.frame.size.width-20-120,0,120, 60)];
        self.reasonL.font = TWOTEXTFONTSIZE;
        self.reasonL.textAlignment = NSTextAlignmentRight;
        self.reasonL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [statusView addSubview:self.reasonL];
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(statusView.frame)+20, DR_SCREEN_WIDTH-30, 216)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView setAllCorner:8];
        [self addSubview:self.backView];
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 80, 106)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.backView addSubview:self.coverImageView];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(100,12,self.backView.frame.size.width-15-100, 22)];
        _titleL.font = XGSIXBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_titleL];
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(100,38,self.backView.frame.size.width-15-100, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.text = @"不支持无理由退款";
        _markL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [self.backView addSubview:_markL];
        
  
        _originmoneyL = [[UILabel alloc] initWithFrame:CGRectMake(100,92,self.backView.frame.size.width-100, 24)];
        _originmoneyL.font = SXNUMBERFONT(22);
        _originmoneyL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_originmoneyL];
        
        
        UILabel *redML = [[UILabel alloc] initWithFrame:CGRectMake(10,136,(DR_SCREEN_WIDTH-50)/2, 24)];
        redML.font = FOURTHTEENTEXTFONTSIZE;
        redML.text = @"专属优惠";
        redML.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:redML];
        
        self.reduceL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-100,136,100, 24)];
        self.reduceL.font = SXNUMBERFONT(16);
        self.reduceL.textAlignment = NSTextAlignmentRight;
        self.reduceL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:self.reduceL];
        
        UILabel *redPayL = [[UILabel alloc] initWithFrame:CGRectMake(10,180,(DR_SCREEN_WIDTH-50)/2, 24)];
        redPayL.font = FOURTHTEENTEXTFONTSIZE;
        redPayL.text = @"实付款";
        redPayL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:redPayL];
        
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-100,180,100, 24)];
        _moneyL.font = SXNUMBERFONT(22);
        _moneyL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        _moneyL.textAlignment = NSTextAlignmentRight;
        [self.backView addSubview:_moneyL];
        
        UIView *subView = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.backView.frame)+20, DR_SCREEN_WIDTH-30, 72)];
        subView.backgroundColor = [UIColor whiteColor];
        [self addSubview:subView];
        self.subBackView = subView;
        
        self.orderNoL = [[UILabel alloc] initWithFrame:CGRectMake(10,0,self.backView.frame.size.width-20, 36)];
        self.orderNoL.font = TWOTEXTFONTSIZE;
        self.orderNoL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [subView addSubview:self.orderNoL];
        
        UIButton *copyBtn = [[UIButton  alloc] initWithFrame:CGRectZero];
        [copyBtn setImage:UIImageNamed(@"Image_fuxuehao") forState:UIControlStateNormal];
        [subView addSubview:copyBtn];
        [copyBtn addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
        self.orderCopyBtn = copyBtn;
        
        self.payTimeL = [[UILabel alloc] initWithFrame:CGRectMake(10,36,self.backView.frame.size.width-20, 36)];
        self.payTimeL.font = TWOTEXTFONTSIZE;
        self.payTimeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [subView addSubview:self.payTimeL];
    }
    return self;
}

- (void)setPayStatusModel:(SXOrderStatusModel *)payStatusModel{
    
    self.orderNoL.text = [NSString stringWithFormat:@"订单编号：%@",payStatusModel.sn];
    self.orderCopyBtn.frame = CGRectMake(20+GET_STRWIDTH(self.orderNoL.text, 12, 36), 8, 20, 20);
    
    _payStatusModel = payStatusModel;
    if (payStatusModel.pay_status.intValue == 2) {
        self.statusL.text = @"交易成功";
        self.statusImageView.image = UIImageNamed(@"sxpaysuccess_img");
        self.statusL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.reasonL.text = @"";
        
        self.subBackView.frame = CGRectMake(15, CGRectGetMaxY(self.backView.frame)+20, DR_SCREEN_WIDTH-30, 72);
        self.payTimeL.text = [NSString stringWithFormat:@"交易时间：%@",payStatusModel.pay_time];
    }else{
        self.statusL.text = @"交易失败";
        self.statusImageView.image = UIImageNamed(@"sxpayfail_img");
        self.statusL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.reasonL.text = @"订单已取消";
        
        self.subBackView.frame = CGRectMake(15, CGRectGetMaxY(self.backView.frame)+20, DR_SCREEN_WIDTH-30, 36);
        self.payTimeL.text = @"";
    }
    [self.subBackView setAllCorner:8];
}

- (void)copyClick{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.payStatusModel.sn];
    [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
}

- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    _paySearModel = paySearModel;
    self.titleL.text = paySearModel.series_name;
    
    self.moneyL.attributedText = [DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"¥%@",paySearModel.price] setColor:[UIColor colorWithHexString:@"#FF68A3"] setSize:16 setLengthString:@"¥" beginSize:0];
    
    self.originmoneyL.attributedText = [DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"¥%@",paySearModel.original_price] setColor:[UIColor colorWithHexString:@"#14151A"] setSize:16 setLengthString:@"¥" beginSize:0];
    
    self.reduceL.text = [NSString stringWithFormat:@"- ¥%d",paySearModel.original_price.intValue-paySearModel.price.intValue];
    

    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:paySearModel.simple_cover_url]];
}
@end
