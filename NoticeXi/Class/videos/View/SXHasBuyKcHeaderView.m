//
//  SXHasBuyKcHeaderView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasBuyKcHeaderView.h"
#import "SXKcBuyChoiceView.h"
@implementation SXHasBuyKcHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 10, 120, 160)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self addSubview:self.coverImageView];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(145,10,DR_SCREEN_WIDTH-150, 24)];
        _titleL.font = XGEightBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:_titleL];
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(145,38,self.frame.size.width-150, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:_markL];
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectZero];
        _moneyL.font = SXNUMBERFONT(20);
        _moneyL.textColor = [UIColor colorWithHexString:@"#FF569F"];
        [self addSubview:_moneyL];
        
        _orginMoneyL = [[UILabel alloc] initWithFrame:CGRectZero];
        _orginMoneyL.font = SXNUMBERFONT(14);
        _orginMoneyL.textColor = [UIColor colorWithHexString:@"#FF569F"];
        [self addSubview:_orginMoneyL];
        
        self.line = [[UIView  alloc] initWithFrame:CGRectMake(0, 23/2, _orginMoneyL.frame.size.width, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#FF569F"];
        [_orginMoneyL addSubview:self.line];
        
        _buyNumL = [[UILabel alloc] initWithFrame:CGRectZero];
        _buyNumL.font = TWOTEXTFONTSIZE;
        _buyNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:_buyNumL];
        
        _hasBuyTimeL = [[UILabel alloc] initWithFrame:CGRectZero];
        _hasBuyTimeL.font = FOURTHTEENTEXTFONTSIZE;
        _hasBuyTimeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self addSubview:_hasBuyTimeL];

        self.buyImg = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_hasBuyTimeL.frame)+3, 147, 16, 16)];
        self.buyImg.userInteractionEnabled = YES;
        self.buyImg.image = UIImageNamed(@"sx_hasbuykctime_img");
        [self addSubview:self.buyImg];
        
        if ([NoticeTools getuserId]) {
            self.contouinBtn = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-33-105, 138, 105, 32)];
            self.contouinBtn.backgroundColor = [UIColor colorWithHexString:@"#FF569F"];
            [self.contouinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.contouinBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
            [self.contouinBtn setTitle:@"继续购课" forState:UIControlStateNormal];
            [self addSubview:self.contouinBtn];
            [self.contouinBtn setAllCorner:16];
            [self.contouinBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
        }
       
    }
    return self;
}

//继续购课
- (void)buyClick{
    SXKcBuyChoiceView *choiceView = [[SXKcBuyChoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    choiceView.hasBuy = self.paySearModel.hasBuy;
    __weak typeof(self) weakSelf = self;
    choiceView.buyTypeBolck = ^(BOOL isSend) {
        if (weakSelf.buyTypeBolck) {
            weakSelf.buyTypeBolck(isSend);
        }
    };
    [choiceView show];
}

- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    _paySearModel = paySearModel;
    self.titleL.text = paySearModel.series_name;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:paySearModel.simple_cover_url]];
    self.markL.text = [NSString stringWithFormat:@"共%@课时  |  已更新%@课时",paySearModel.episodes,paySearModel.published_episodes];
    
    NSString *price = [NSString stringWithFormat:@"¥%@",_paySearModel.price];
    NSString *oriprice = [NSString stringWithFormat:@"¥%@",_paySearModel.original_price];
    _moneyL.text = price;
    _orginMoneyL.text = oriprice;
    
    _buyNumL.text = [NSString stringWithFormat:@"%d人已报名",_paySearModel.buy_users_num.intValue];
    
    _moneyL.frame = CGRectMake(145, 67, GET_STRWIDTH(_moneyL.text, 20, 24), 24);
    _orginMoneyL.frame = CGRectMake(CGRectGetMaxX(_moneyL.frame), 67, GET_STRWIDTH(_orginMoneyL.text, 14, 24), 24);
    self.line.frame = CGRectMake(0, 23/2, _orginMoneyL.frame.size.width, 1);
    _buyNumL.frame = CGRectMake(CGRectGetMaxX(_orginMoneyL.frame)+8, 67, GET_STRWIDTH(_buyNumL.text, 12, 24), 24);
    
    self.hasBuyTimeL.text = @"已购1次";
    self.hasBuyTimeL.frame = CGRectMake(145, 145, GET_STRWIDTH(self.hasBuyTimeL.text, 14, 20), 20);
    self.buyImg.frame = CGRectMake(CGRectGetMaxX(_hasBuyTimeL.frame)+3, 147, 16, 16);
    
}

@end
