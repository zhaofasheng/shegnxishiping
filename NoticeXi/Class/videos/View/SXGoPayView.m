//
//  SXGoPayView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXGoPayView.h"

@implementation SXGoPayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        
        self.contentView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+277)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setCornerOnTop:20];
        [self addSubview:self.contentView];
                                
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(0,40,DR_SCREEN_WIDTH, 34)];
        _moneyL.font = SXNUMBERFONT(34);
        _moneyL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _moneyL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_moneyL];
        
        FSCustomButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, 13, 24, 24)];
        [btn setImage:UIImageNamed(@"sxpaycancel_img") forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *cancelTapView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.contentView.frame.size.height)];
        cancelTapView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        cancelTapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [cancelTapView addGestureRecognizer:tap];
        [self addSubview:cancelTapView];
        
        UIView *tap1V = [[UIView  alloc] initWithFrame:CGRectMake(0, 104, DR_SCREEN_WIDTH, 50)];
        tap1V.userInteractionEnabled = YES;
        [self.contentView addSubview:tap1V];
        UITapGestureRecognizer *paytap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weixinPay)];
        [tap1V addGestureRecognizer:paytap1];
        
        UIImageView *typeImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(20,13, 24, 24)];
        [tap1V addSubview:typeImageV];
        typeImageV.image = UIImageNamed(@"sxweixpay_img");
        
        UILabel *typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeImageV.frame)+10,13,150, 24)];
        typeL.font = SIXTEENTEXTFONTSIZE;
        typeL.text = @"微信支付";
        typeL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [tap1V addSubview:typeL];
        
        UIImageView *choiceImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40, 15, 20, 20)];
        [tap1V addSubview:choiceImageV];
        choiceImageV.image = UIImageNamed(@"sxpaysuccess_img");
        self.weixinChoiceV = choiceImageV;
        
        UIView *tap2V = [[UIView  alloc] initWithFrame:CGRectMake(0, 154, DR_SCREEN_WIDTH, 50)];
        tap2V.userInteractionEnabled = YES;
        [self.contentView addSubview:tap2V];
        UITapGestureRecognizer *paytap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliPay)];
        [tap2V addGestureRecognizer:paytap2];
        
        UIImageView *typeImageV1 = [[UIImageView  alloc] initWithFrame:CGRectMake(20,13, 24, 24)];
        [tap2V addSubview:typeImageV1];
        typeImageV1.image = UIImageNamed(@"sxalipay_img");
        
        UILabel *typeL1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeImageV.frame)+10,13,150, 24)];
        typeL1.font = SIXTEENTEXTFONTSIZE;
        typeL1.text = @"支付宝支付";
        typeL1.textColor = [UIColor colorWithHexString:@"#14151A"];
        [tap2V addSubview:typeL1];
        
        UIImageView *choiceImageV1 = [[UIImageView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40, 15, 20, 20)];
        [tap2V addSubview:choiceImageV1];
        choiceImageV1.image = UIImageNamed(@"sxnochoice_img");
        self.aliChoiceV = choiceImageV1;
        
        UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(20,277,DR_SCREEN_WIDTH-40, 40)];
        [button setAllCorner:20];
        button.backgroundColor = [UIColor colorWithHexString:@"#FF4B98"];
        [button setTitle:@"确认支付" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:button];
        [button addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.isWeixinPay = YES;
    }
    return self;
}

- (void)weixinPay{
    self.isWeixinPay = YES;
    self.aliChoiceV.image = UIImageNamed(@"sxnochoice_img");
    self.weixinChoiceV.image = UIImageNamed(@"sxpaysuccess_img");
}

- (void)aliPay{
    self.isWeixinPay = NO;
    self.weixinChoiceV.image = UIImageNamed(@"sxnochoice_img");
    self.aliChoiceV.image = UIImageNamed(@"sxpaysuccess_img");
}

- (void)setMoney:(NSString *)money{
    _money = money;
    self.moneyL.attributedText = [DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"¥%@",money] setColor:[UIColor colorWithHexString:@"#14151A"] setSize:20 setLengthString:@"¥" beginSize:0];
}

- (void)payClick{

    if (self.surePayBlock) {
        self.surePayBlock(self.isWeixinPay);
    }
    self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+277);
    [self removeFromSuperview];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+277);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showPayView{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.contentView.frame.size.height, DR_SCREEN_WIDTH,self.contentView.frame.size.height);

    } completion:^(BOOL finished) {

    }];
}


@end
