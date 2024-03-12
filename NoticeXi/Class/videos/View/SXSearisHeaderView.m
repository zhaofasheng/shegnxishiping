//
//  SXSearisHeaderView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSearisHeaderView.h"

@implementation SXSearisHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 20,DR_SCREEN_WIDTH-20, 28)];
        self.titleL.font = XGTwentyBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:self.titleL];
        self.titleL.numberOfLines = 0;
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.titleL.frame)+4 ,DR_SCREEN_WIDTH-20, 17)];
        self.numL.font = TWOTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self addSubview:self.numL];
    }
    return self;
}

- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    _paySearModel = paySearModel;
 
    self.titleL.attributedText = [SXTools getStringWithLineHight:3 string:paySearModel.series_name];
    self.titleL.frame = CGRectMake(15, 20, DR_SCREEN_WIDTH-20, [SXTools getHeightWithLineHight:3 font:20 width:DR_SCREEN_WIDTH-20 string:paySearModel.series_name isJiacu:YES]);
    
    self.numL.frame = CGRectMake(15,CGRectGetMaxY(self.titleL.frame)+4 ,DR_SCREEN_WIDTH-20, 17);
    self.numL.text = [NSString stringWithFormat:@"共%@课时  |  已更新%@课时",paySearModel.episodes,paySearModel.published_episodes];
    
    self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 48+self.numL.frame.size.height+self.titleL.frame.size.height);
}

- (void)refresUI{
    if (self.paySearModel.hasBuy) {
        if ([SXTools getPayPlayLastsearisId:self.paySearModel.seriesId]) {
            self.hasReviewView.hidden = NO;
            
            self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 48+self.numL.frame.size.height+self.titleL.frame.size.height+74+20);
            
            self.hasLookVideoNameL.text = [SXTools getPayPlayLastsearisId:self.paySearModel.seriesId];
        }else{
            _hasReviewView.hidden = YES;
            self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 48+self.numL.frame.size.height+self.titleL.frame.size.height);
        }
    }
}

- (void)befreTap{
    if (self.choiceBeforeLookBlock) {
        self.choiceBeforeLookBlock(self.hasLookVideoNameL.text);
    }
}

- (UIView *)hasReviewView{
    if (!_hasReviewView) {
        _hasReviewView = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.numL.frame)+24, DR_SCREEN_WIDTH-30, 74)];
        _hasReviewView.layer.cornerRadius = 8;
        _hasReviewView.layer.masksToBounds = YES;
        _hasReviewView.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
        _hasReviewView.layer.borderWidth = 1;
        
        UIImageView *markImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 15, 32, 32)];
        markImageV.image = UIImageNamed(@"sxhasseevideosave_img");
        [_hasReviewView addSubview:markImageV];
        markImageV.userInteractionEnabled = YES;
        
        UIImageView *markImageV1 = [[UIImageView  alloc] initWithFrame:CGRectMake(_hasReviewView.frame.size.width-15-20, 27, 20, 20)];
        markImageV1.image = UIImageNamed(@"sxhasseevideosave1_img");
        [_hasReviewView addSubview:markImageV1];
        markImageV1.userInteractionEnabled = YES;
        
        UILabel *redPayL = [[UILabel alloc] initWithFrame:CGRectMake(53,15,_hasReviewView.frame.size.width-53-40,20)];
        redPayL.font = FIFTHTEENTEXTFONTSIZE;
        redPayL.text = @"上次看到：";
        redPayL.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [_hasReviewView addSubview:redPayL];
        
        UILabel *redPayL1 = [[UILabel alloc] initWithFrame:CGRectMake(53,39,_hasReviewView.frame.size.width-53-40,20)];
        redPayL1.font = FOURTHTEENTEXTFONTSIZE;
        self.hasLookVideoNameL = redPayL1;
        redPayL1.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [_hasReviewView addSubview:redPayL1];
        
        [self addSubview:_hasReviewView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(befreTap)];
        [_hasReviewView addGestureRecognizer:tap];
    }
    return _hasReviewView;
}
@end
