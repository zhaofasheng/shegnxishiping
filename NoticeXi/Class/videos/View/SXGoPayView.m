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
        
        UIImageView *typeImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(20, 120, 24, 24)];
        [self.contentView addSubview:typeImageV];
        typeImageV.image = UIImageNamed(@"sxweixpay_img");
        
        UILabel *typeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeImageV.frame)+10,121,150, 22)];
        typeL.font = SIXTEENTEXTFONTSIZE;
        typeL.text = @"微信支付";
        typeL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:typeL];
        
        UIImageView *choiceImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40, 121, 20, 20)];
        [self.contentView addSubview:choiceImageV];
        choiceImageV.image = UIImageNamed(@"sxpaysuccess_img");
        
        UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(20,277,DR_SCREEN_WIDTH-40, 40)];
        [button setAllCorner:20];
        button.backgroundColor = [UIColor colorWithHexString:@"#FF4B98"];
        [button setTitle:@"确认支付" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:button];
        [button addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setMoney:(NSString *)money{
    _money = money;
    self.moneyL.attributedText = [DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"¥%@",money] setColor:[UIColor colorWithHexString:@"#14151A"] setSize:20 setLengthString:@"¥" beginSize:0];
}

- (void)payClick{

    if (self.surePayBlock) {
        self.surePayBlock(YES);
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
