//
//  SXBuyKcCardHeaderView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuyKcCardHeaderView.h"

@implementation SXBuyKcCardHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backView1 = [[UIView  alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-30, 387)];
        self.backView1.backgroundColor = [UIColor whiteColor];
        self.backView1.layer.cornerRadius = 10;
        self.backView1.layer.masksToBounds = YES;
        [self addSubview:self.backView1];
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30-168)/2, 20, 168, 223)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.backView1 addSubview:self.coverImageView];
        
        UIImageView *markImageV = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-30-218)/2, 224, 218, 56)];
        markImageV.image = UIImageNamed(@"sx_buycardmark_img");
        [self.backView1 addSubview:markImageV];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,285,DR_SCREEN_WIDTH-30-30, 25)];
        _titleL.font = XGEightBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView1 addSubview:_titleL];
        _titleL.numberOfLines = 0;
        
    
        _moneyL = [[UILabel alloc] initWithFrame:CGRectZero];
        _moneyL.font = SXNUMBERFONT(22);
        _moneyL.textColor = [UIColor colorWithHexString:@"#FF569F"];
        [self.backView1 addSubview:_moneyL];
        
        _orginMoneyL = [[UILabel alloc] initWithFrame:CGRectZero];
        _orginMoneyL.font = SXNUMBERFONT(14);
        _orginMoneyL.textColor = [UIColor colorWithHexString:@"#FF569F"];
        [self.backView1 addSubview:_orginMoneyL];
        
        self.line = [[UIView  alloc] initWithFrame:CGRectMake(0, 23/2, _orginMoneyL.frame.size.width, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#FF569F"];
        [_orginMoneyL addSubview:self.line];
        
        _buyNumL = [[UILabel alloc] initWithFrame:CGRectZero];
        _buyNumL.font = TWOTEXTFONTSIZE;
        _buyNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView1 addSubview:_buyNumL];
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_buyNumL.frame)+10,235, 25)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.textColor = [UIColor colorWithHexString:@"#FF4B98"];
        _markL.text = @"购买后，赠送礼品卡时可送上对好友的祝福";
        [_markL setAllCorner:4];
        _markL.backgroundColor = [[UIColor colorWithHexString:@"#FD569E"] colorWithAlphaComponent:0.05];
        [self.backView1 addSubview:_markL];

        self.backView2 = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.backView1.frame)+10, DR_SCREEN_WIDTH-30, 387)];
        self.backView2.backgroundColor = [UIColor whiteColor];
        self.backView2.layer.cornerRadius = 10;
        self.backView2.layer.masksToBounds = YES;
        [self addSubview:self.backView2];
        
        UILabel *explainL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 22)];
        explainL.text = @"购买赠送说明：";
        explainL.font = XGFourthBoldFontSize;
        explainL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView2 addSubview:explainL];
        
        self.buyExplainL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 40, DR_SCREEN_WIDTH-60, 0)];
        self.buyExplainL.numberOfLines = 0;
        self.buyExplainL.font = FOURTHTEENTEXTFONTSIZE;
        self.buyExplainL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView2 addSubview:self.buyExplainL];
    }
    return self;
}

//继续购课
- (void)buyClick{
    
}

- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    _paySearModel = paySearModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:paySearModel.simple_cover_url]];
    
    self.titleL.attributedText = [SXTools getStringWithLineHight:3 string:paySearModel.series_name];
    self.titleL.frame = CGRectMake(15, 285, DR_SCREEN_WIDTH-60, [SXTools getHeightWithLineHight:3 font:18 width:DR_SCREEN_WIDTH-60 string:paySearModel.series_name isJiacu:YES]);
    
    NSString *price = [NSString stringWithFormat:@"¥%@",_paySearModel.price];
    NSString *oriprice = [NSString stringWithFormat:@"¥%@",_paySearModel.original_price];
    _moneyL.text = price;
    _orginMoneyL.text = oriprice;
    
    _buyNumL.text = [NSString stringWithFormat:@"共%@课时",paySearModel.episodes];
    
    _moneyL.frame = CGRectMake(15,CGRectGetMaxY(self.titleL.frame)+4, GET_STRWIDTH(_moneyL.text, 22, 24), 24);
    _orginMoneyL.frame = CGRectMake(CGRectGetMaxX(_moneyL.frame),CGRectGetMaxY(self.titleL.frame)+4, GET_STRWIDTH(_orginMoneyL.text, 14, 24), 24);
    self.line.frame = CGRectMake(0, 23/2, _orginMoneyL.frame.size.width, 1);
    _buyNumL.frame = CGRectMake(CGRectGetMaxX(_orginMoneyL.frame)+5, CGRectGetMaxY(self.titleL.frame)+4, GET_STRWIDTH(_buyNumL.text, 12, 24), 24);
    
    
    self.markL.frame = CGRectMake(15,CGRectGetMaxY(_buyNumL.frame)+10,235, 25);
    

    self.backView1.frame = CGRectMake(15, 20, DR_SCREEN_WIDTH-30, CGRectGetMaxY(self.markL.frame)+15);
    
    NSString *explain = @"1.【课程礼品卡】仅可用于赠送，购买者无法观看该课程内容，请谨慎购买。\n2.【课程礼品卡】购买后，不支持退订、退换。\n3.【课程礼品卡】可通过链接赠送给好友，需要好友手动操作领取，领取时间无限制。\n4.同一张礼品卡，可多次分享链接，但只有1人能成功领取，先到先得，一旦被领取，不可反悔。\n5.获赠人需通过“手机号”领取礼品卡，领取后使用该手机号登录【声昔】，即可查看课程内容和祝福。";
    self.buyExplainL.attributedText = [SXTools getStringWithLineHight:3 string:explain];
    self.buyExplainL.frame = CGRectMake(15, 40, DR_SCREEN_WIDTH-60, [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-60 string:explain isJiacu:NO]);
    self.backView2.frame = CGRectMake(15, CGRectGetMaxY(self.backView1.frame)+10, DR_SCREEN_WIDTH-30,CGRectGetMaxY(self.buyExplainL.frame)+15);
    
    self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, CGRectGetMaxY(self.backView2.frame)+20);
}
@end
