//
//  NoticeGetVipCardView.m
//  NoticeXi
//
//  Created by li lei on 2023/9/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeGetVipCardView.h"

@implementation NoticeGetVipCardView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 390+48)];
        self.contentView.center = self.center;
        
        [self addSubview:self.contentView];
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 358)];
        imageView1.image = UIImageNamed(@"vipRouteimg6");
        [self.contentView addSubview:imageView1];
        
        self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 100, 168, 114)];
        self.cardImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.cardImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.cardImageView];
        
    
        self.numberL = [[UILabel alloc] initWithFrame:CGRectMake(0, 58,self.contentView.frame.size.width, 28)];
        
        self.numberL.font = XGEightBoldFontSize ;
        self.numberL.textAlignment = NSTextAlignmentCenter;
        self.numberL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.numberL];
        
        UILabel *ruleL = [[UILabel alloc] initWithFrame:CGRectMake(25, 250,self.contentView.frame.size.width-50, 108)];
        ruleL.text = [NoticeTools chinese:@"会员卡可以领取自用，也可以赠送给别人。领取后立即生效，如果你已是会员，会在原有有效期上延长天数。" english:@"You can use this gift for yourself or give away to others. Current Limited Pro users can use this gift to extend membership dates." japan:@"会員カードは個人使用のために収集したり、他人に贈ったりすることができます。有効期間は日数単位で延長できます。"];
        ruleL.font = FOURTHTEENTEXTFONTSIZE;
        ruleL.textAlignment = NSTextAlignmentCenter;
        ruleL.numberOfLines = 0;
        ruleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:ruleL];
        
         
        UIButton *getButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 390, 128, 48)];
        [getButton setBackgroundImage:UIImageNamed(@"vipRouteimg7") forState:UIControlStateNormal];
        [getButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        getButton.titleLabel.font = XGSIXBoldFontSize;
        [getButton setTitle:[NoticeTools chinese:@"领取" english:@"Get" japan:@"受け取る"] forState:UIControlStateNormal];
        [getButton addTarget:self action:@selector(getClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:getButton];
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(152, 390, 128, 48)];
        [sendButton setBackgroundImage:UIImageNamed(@"vipRouteimg7") forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        sendButton.titleLabel.font = XGSIXBoldFontSize;
        [sendButton setTitle:[NoticeTools getLocalStrWith:@"chant.sendss"] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:sendButton];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(244, 12,24, 24)];
        [backBtn setImage:UIImageNamed(@"Image_closepic") forState:UIControlStateNormal];
        [self.contentView addSubview:backBtn];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)backClick{
    [self removeFromSuperview];
}

- (void)getClick{
    if(self.getOrSendBlock){
        self.getOrSendBlock(YES);
    }
    [self backClick];
}

- (void)sendClick{
    if(self.getOrSendBlock){
        self.getOrSendBlock(NO);
    }
    [self backClick];
}
    

#pragma mark - 弹出 -
- (void)showGetView
{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.contentView.layer.position = self.center;
    self.contentView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

@end
