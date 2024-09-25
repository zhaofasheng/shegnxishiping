//
//  SXBuyKcMarkView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuyKcMarkView.h"

@implementation SXBuyKcMarkView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(25, 0, 100, 44)];
        self.titleL1.font = FOURTHTEENTEXTFONTSIZE;
        self.titleL1.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:self.titleL1];
        self.titleL1.text = @"课时";
        
        self.numL = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-25-100, 0, 100, 44)];
        self.numL.font = FOURTHTEENTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:self.numL];
        self.numL.textAlignment = NSTextAlignmentRight;
        
        self.titleL2 = [[UILabel  alloc] initWithFrame:CGRectMake(25, 44, 100, 44)];
        self.titleL2.font = FOURTHTEENTEXTFONTSIZE;
        self.titleL2.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:self.titleL2];
        self.titleL2.text = @"已省";
        
        self.moneyL = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-25-100, 44, 100, 44)];
        self.moneyL.font = XGFourthBoldFontSize;;
        self.moneyL.textColor = [UIColor colorWithHexString:@"#FF4B98"];
        [self addSubview:self.moneyL];
        self.moneyL.textAlignment = NSTextAlignmentRight;
        
        self.selfBuyBtn = [[FSCustomButton  alloc] initWithFrame:CGRectMake(15, 98, (DR_SCREEN_WIDTH-30-25)/2, 44)];
        self.selfBuyBtn.layer.cornerRadius = 8;
        self.selfBuyBtn.layer.masksToBounds = YES;
        self.selfBuyBtn.layer.borderWidth = 2;
        [self.selfBuyBtn setTitle:@" 给自己买" forState:UIControlStateNormal];
        [self.selfBuyBtn setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
        self.selfBuyBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self addSubview:self.selfBuyBtn];
        self.selfBuyBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [self.selfBuyBtn addTarget:self action:@selector(buyself) forControlEvents:UIControlEventTouchUpInside];
        
        self.sendBtn = [[FSCustomButton  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selfBuyBtn.frame)+25, 98, (DR_SCREEN_WIDTH-30-25)/2, 44)];
        self.sendBtn.layer.cornerRadius = 8;
        self.sendBtn.layer.masksToBounds = YES;
        self.sendBtn.layer.borderWidth = 2;
        [self.sendBtn setTitle:@" 课程卡送好友" forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
        self.sendBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
        self.sendBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self addSubview:self.sendBtn];
        [self.sendBtn addTarget:self action:@selector(buySend) forControlEvents:UIControlEventTouchUpInside];
        
        self.selfBuyBtn.hidden = YES;
        self.sendBtn.hidden = YES;
        
        self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(20, 98, DR_SCREEN_WIDTH-40, 44)];
        self.markL.font = TWOTEXTFONTSIZE;
        self.markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.markL.numberOfLines = 0;
        [self addSubview:self.markL];
        NSString *str = @"1. 本产品为付费课程，购买成功后，永久有效。\n2. 本产品购买后不支持退订、转让、退换，请你谅解。";
        self.markL.attributedText = [SXTools getStringWithLineHight:3 string:str];
    }
    return self;
}

- (void)buyself{
    self.sendBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.sendBtn.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
    [self.sendBtn setImage:UIImageNamed(@"Image_buykctypechoiceno") forState:UIControlStateNormal];
    
    self.selfBuyBtn.backgroundColor = [[UIColor colorWithHexString:@"#FF4B98"] colorWithAlphaComponent:0.1];
    self.selfBuyBtn.layer.borderColor = [UIColor colorWithHexString:@"#FF4B98"].CGColor;
    [self.selfBuyBtn setImage:UIImageNamed(@"Image_buykctypechoice") forState:UIControlStateNormal];
    if (self.buyTypeBlock) {
        self.buyTypeBlock(NO);
    }
}

- (void)buySend{
    self.selfBuyBtn.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.selfBuyBtn.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
    [self.selfBuyBtn setImage:UIImageNamed(@"Image_buykctypechoiceno") forState:UIControlStateNormal];
    
    self.sendBtn.backgroundColor = [[UIColor colorWithHexString:@"#FF4B98"] colorWithAlphaComponent:0.1];
    self.sendBtn.layer.borderColor = [UIColor colorWithHexString:@"#FF4B98"].CGColor;
    [self.sendBtn setImage:UIImageNamed(@"Image_buykctypechoice") forState:UIControlStateNormal];
    if (self.buyTypeBlock) {
        self.buyTypeBlock(YES);
    }
}

- (void)setBuyType:(NSInteger)buyType{
    _buyType = buyType;
    self.markL.hidden = YES;
    if (buyType == 0) {
        self.markL.hidden = NO;
        self.selfBuyBtn.hidden = YES;
        self.sendBtn.hidden = YES;
    }else if (buyType == 1){
        self.selfBuyBtn.hidden = NO;
        self.sendBtn.hidden = NO;
    }else if (buyType == 2){
        self.selfBuyBtn.hidden = NO;
        self.sendBtn.hidden = YES;
    }else if (buyType == 3){
        self.selfBuyBtn.hidden = YES;
        self.sendBtn.hidden = NO;
        self.sendBtn.frame = CGRectMake(15, 98, (DR_SCREEN_WIDTH-30-25)/2, 44);
    }
}

- (void)setShowMoney:(BOOL)showMoney{
    _showMoney = showMoney;
    if (showMoney) {
        self.titleL2.hidden = NO;
        self.moneyL.hidden = NO;
    }else{
        self.titleL2.hidden = YES;
        self.moneyL.hidden = YES;
    }
}
@end
