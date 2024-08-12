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
   
    }
    return self;
}

- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    _paySearModel = paySearModel;
 
}

- (void)refresUI{
    if (self.paySearModel.hasBuy) {
        if ([SXTools getPayPlayLastsearisId:self.paySearModel.seriesId]) {
            self.hasReviewView.hidden = NO;
            self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 48+15+15);
            self.hasLookVideoNameL.text = [NSString stringWithFormat:@"上次看到：%@",[SXTools getPayPlayLastsearisId:self.paySearModel.seriesId]];
            
        }else{
            _hasReviewView.hidden = YES;
            self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 0);
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
        _hasReviewView = [[UIView  alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-30, 48+15)];
        _hasReviewView.backgroundColor = [UIColor whiteColor];
        [_hasReviewView setCornerOnTop:8];
        
        UIView *backV = [[UIView  alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-30-30, 48)];
        backV.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:0.05];
        [_hasReviewView addSubview:backV];
        [backV setAllCorner:8];
        
        UIImageView *markImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 12, 24, 24)];
        markImageV.image = UIImageNamed(@"sxhasseevideosave_img");
        [backV addSubview:markImageV];
        markImageV.userInteractionEnabled = YES;
        
        
        CBAutoScrollLabel *redPayL1 = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(38,14,backV.frame.size.width-38-10,20)];
        redPayL1.font = FOURTHTEENTEXTFONTSIZE;
        self.hasLookVideoNameL = redPayL1;
        redPayL1.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [backV addSubview:redPayL1];
        
        [self addSubview:_hasReviewView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(befreTap)];
        [_hasReviewView addGestureRecognizer:tap];
    }
    return _hasReviewView;
}
@end
