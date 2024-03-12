//
//  SXSureBuySearisView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSureBuySearisView.h"

@implementation SXSureBuySearisView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-30, 126)];
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
        
        UILabel *moneyML = [[UILabel alloc] initWithFrame:CGRectMake(100,92,GET_STRWIDTH(@"¥", 17, 24), 24)];
        moneyML.font = XGSIXBoldFontSize;
        moneyML.text = @"¥";
        moneyML.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:moneyML];
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moneyML.frame),92,self.backView.frame.size.width-15-CGRectGetMaxX(moneyML.frame), 24)];
        _moneyL.font = SXNUMBERFONT(22);
        _moneyL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_moneyL];
        
        UIView *subView = [[UIView  alloc] initWithFrame:CGRectMake(15, 156, DR_SCREEN_WIDTH-30, 44)];
        subView.backgroundColor = [UIColor whiteColor];
        [subView setAllCorner:8];
        [self addSubview:subView];
        
        UILabel *redML = [[UILabel alloc] initWithFrame:CGRectMake(10,0,(DR_SCREEN_WIDTH-50)/2, 44)];
        redML.font = FOURTHTEENTEXTFONTSIZE;
        redML.text = @"专属优惠";
        redML.textColor = [UIColor colorWithHexString:@"#14151A"];
        [subView addSubview:redML];
        
        self.reduceL = [[UILabel alloc] initWithFrame:CGRectMake(subView.frame.size.width-10-100,0,100, 44)];
        self.reduceL.font = SXNUMBERFONT(16);
        self.reduceL.textAlignment = NSTextAlignmentRight;
        self.reduceL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        [subView addSubview:self.reduceL];
        
        self.introL = [[UILabel alloc] initWithFrame:CGRectMake(15,224,DR_SCREEN_WIDTH-30,0)];
        self.introL.numberOfLines = 0;
        self.introL.font = TWOTEXTFONTSIZE;
        self.introL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:self.introL];
    }
    return self;
}


- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    _paySearModel = paySearModel;
    
    self.titleL.text = paySearModel.series_name;
    self.moneyL.text = paySearModel.original_price;
    self.reduceL.text = [NSString stringWithFormat:@"- ¥%d",paySearModel.original_price.intValue-paySearModel.price.intValue];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:paySearModel.simple_cover_url]];
    
    self.introL.attributedText = [SXTools getStringWithLineHight:3 string:paySearModel.pay_tip];
    self.introL.frame = CGRectMake(15,224,DR_SCREEN_WIDTH-30, [SXTools getHeightWithLineHight:3 font:12 width:DR_SCREEN_WIDTH-30 string:paySearModel.pay_tip isJiacu:NO]);
}

@end
