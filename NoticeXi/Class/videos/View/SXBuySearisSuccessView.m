//
//  SXBuySearisSuccessView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuySearisSuccessView.h"
#import "NoticeSCViewController.h"
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
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(statusView.frame)+20, DR_SCREEN_WIDTH-30, 262)];
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
        
        _videoNumL = [[UILabel alloc] initWithFrame:CGRectMake(100,38,self.backView.frame.size.width-15-100, 17)];
        _videoNumL.font = TWOTEXTFONTSIZE;
        _videoNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:_videoNumL];
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(100,59,self.backView.frame.size.width-15-100, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.text = @"不支持无理由退款";
        _markL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [self.backView addSubview:_markL];
        
  
        _originmoneyL = [[UILabel alloc] initWithFrame:CGRectMake(100,92,self.backView.frame.size.width-100, 24)];
        _originmoneyL.font = SXNUMBERFONT(22);
        _originmoneyL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_originmoneyL];
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(10,128,(DR_SCREEN_WIDTH-50)/2, 44)];
        numL.font = FOURTHTEENTEXTFONTSIZE;
        numL.text = @"课时";
        numL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:numL];
        
        self.videoNumL1 = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-100,128,100, 44)];
        self.videoNumL1.font = SXNUMBERFONT(16);
        self.videoNumL1.textAlignment = NSTextAlignmentRight;
        self.videoNumL1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:self.videoNumL1];
        
        UILabel *redML = [[UILabel alloc] initWithFrame:CGRectMake(10,172,(DR_SCREEN_WIDTH-50)/2, 44)];
        redML.font = FOURTHTEENTEXTFONTSIZE;
        redML.text = @"专属优惠";
        redML.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:redML];
        
        self.reduceL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-100,172,100, 44)];
        self.reduceL.font = SXNUMBERFONT(16);
        self.reduceL.textAlignment = NSTextAlignmentRight;
        self.reduceL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:self.reduceL];
        
        UILabel *redPayL = [[UILabel alloc] initWithFrame:CGRectMake(10,216,(DR_SCREEN_WIDTH-50)/2, 44)];
        redPayL.font = FOURTHTEENTEXTFONTSIZE;
        redPayL.text = @"实付款";
        redPayL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:redPayL];
        
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-10-100,216,100, 44)];
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
    
    _connectView.hidden = YES;
    _payStatusModel = payStatusModel;
    if (payStatusModel.pay_status.intValue == 2) {
        self.statusL.text = @"交易成功";
        self.statusImageView.image = UIImageNamed(@"sxpaysuccess_img");
        self.statusL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.reasonL.text = @"";
        
        self.subBackView.frame = CGRectMake(15, CGRectGetMaxY(self.backView.frame)+12, DR_SCREEN_WIDTH-30, 72);
        self.payTimeL.text = [NSString stringWithFormat:@"交易时间：%@",payStatusModel.pay_time];
        
        self.connectView.hidden = NO;
        
    }else{
        self.statusL.text = @"交易失败";
        self.statusImageView.image = UIImageNamed(@"sxpayfail_img");
        self.statusL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.reasonL.text = @"订单已取消";
        
        self.subBackView.frame = CGRectMake(15, CGRectGetMaxY(self.backView.frame)+12, DR_SCREEN_WIDTH-30, 36);
        self.payTimeL.text = @"";
    }
    
    [self.subBackView setAllCorner:8];
}

- (UIView *)connectView{
    if (!_connectView) {
        _connectView = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.subBackView.frame)+12, DR_SCREEN_WIDTH-30, 65)];
        _connectView.backgroundColor = [UIColor whiteColor];
        [_connectView setAllCorner:8];
        
        UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(12, 12, 80, 20)];
        titleL.text = @"订单服务";
        titleL.font = XGFourthBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [_connectView addSubview:titleL];
        
        UILabel *titleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(12, 36, 240, 17)];
        titleL1.text = @"订单疑问、申请退款，请联系客服";
        titleL1.font = TWOTEXTFONTSIZE;
        titleL1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_connectView addSubview:titleL1];
        
        UIButton *connectBtn = [[UIButton  alloc] initWithFrame:CGRectMake(_connectView.frame.size.width-72-12, 16, 72, 32)];
        connectBtn.layer.cornerRadius = 16;
        connectBtn.layer.masksToBounds = YES;
        connectBtn.layer.borderWidth = 1;
        connectBtn.layer.borderColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.2].CGColor;
        [connectBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [connectBtn setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
        connectBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [connectBtn addTarget:self action:@selector(connectClick) forControlEvents:UIControlEventTouchUpInside];
        [_connectView addSubview:connectBtn];
        
        [self addSubview:_connectView];
    }
    return _connectView;
}

- (void)connectClick{

    NoticeSCViewController *ctl = [[NoticeSCViewController alloc] init];
    ctl.navigationItem.title = @"声昔小二";
    ctl.toUser = [NSString stringWithFormat:@"%@1",socketADD];
    ctl.toUserId = @"1";
    ctl.paySearModel = self.paySearModel;
    ctl.payStatusModel = self.payStatusModel;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)copyClick{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.payStatusModel.sn];
    [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
}

- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    
    _paySearModel = paySearModel;
    
    self.titleL.text = paySearModel.series_name;
    if (self.isCard) {
        self.titleL.text = [NSString stringWithFormat:@"(礼品卡)%@",paySearModel.series_name];
    }
    
    self.moneyL.attributedText = [DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"¥%@",self.orderModel.fee] setColor:[UIColor colorWithHexString:@"#FF68A3"] setSize:16 setLengthString:@"¥" beginSize:0];
    


    
    if (self.orderModel.product_type.intValue == 4) {
        self.reduceL.text = @"- ¥0";
    }else{
        self.reduceL.text = [NSString stringWithFormat:@"- ¥%d",paySearModel.original_price.intValue-self.orderModel.fee.intValue];
    }
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:paySearModel.simple_cover_url]];
    
    if (self.orderModel.product_type.intValue == 4) {
        if (self.orderModel.quantity.intValue == 0) {
            self.videoNumL.text = @"购买单节";
            self.videoNumL1.text = @"1节";
        }else{
            self.videoNumL.text = [NSString stringWithFormat:@"共%@课时",self.orderModel.quantity];
            self.videoNumL1.text = [NSString stringWithFormat:@"%@节",self.orderModel.quantity];
        }
        self.originmoneyL.attributedText = [DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"¥%@",self.orderModel.fee] setColor:[UIColor colorWithHexString:@"#14151A"] setSize:16 setLengthString:@"¥" beginSize:0];
    }else{
        self.originmoneyL.attributedText = [DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"¥%@",paySearModel.original_price] setColor:[UIColor colorWithHexString:@"#14151A"] setSize:16 setLengthString:@"¥" beginSize:0];
        self.videoNumL.text = [NSString stringWithFormat:@"共%@课时",self.paySearModel.episodes];
        self.videoNumL1.text = [NSString stringWithFormat:@"%@节",self.paySearModel.episodes];
    }
}
@end
