//
//  NoticeAlreadlyUserView.m
//  NoticeXi
//
//  Created by li lei on 2021/5/28.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeAlreadlyUserView.h"

@implementation NoticeAlreadlyUserView

- (instancetype)initWithShowUserInfo{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissView)];
        [self addGestureRecognizer:tap];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2, (DR_SCREEN_HEIGHT-343)/2, 335, 343)];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = YES;
        self.contentView = contentView;
        [self addSubview:contentView];
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContent)];
        [contentView addGestureRecognizer:contentTap];
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 335, 22)];
        self.nickNameL.textAlignment = NSTextAlignmentCenter;
        self.nickNameL.font = SIXTEENTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [contentView addSubview:self.nickNameL];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width-75)/2, 109, 75, 75)];
        self.iconImageView.layer.cornerRadius = 75/2;
        self.iconImageView.layer.masksToBounds = YES;
        [contentView addSubview:self.iconImageView];
        
        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((contentView.frame.size.width-244)/2, 222, 244, 50)];
        loginBtn.layer.cornerRadius = 25;
        loginBtn.layer.masksToBounds = YES;
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        loginBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:loginBtn];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginBtn.frame)+20, contentView.frame.size.width, 30)];
        [cancelBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancelBtn];
    }
    return self;
}

- (void)cancelClick{
    if (self.choicebtnTag) {
        self.choicebtnTag(2);
    }
    [self dissMissView];
}

- (void)loginClick{
    if (self.choicebtnTag) {
        self.choicebtnTag(1);
    }
    [self dissMissView];
}

- (void)showInfoView{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.contentView.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
}

- (void)dissMissView{
    [self removeFromSuperview];
}


- (void)tapContent{
    
}
@end
