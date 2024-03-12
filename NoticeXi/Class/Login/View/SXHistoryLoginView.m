//
//  SXHistoryLoginView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/27.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHistoryLoginView.h"

@implementation SXHistoryLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        backImageView.image = UIImageNamed(@"Image_loginback");
        backImageView.contentMode = UIViewContentModeScaleAspectFill;
        backImageView.clipsToBounds = YES;
        [self addSubview:backImageView];
        
        backImageView.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIImageView *titlImageView = [[UIImageView alloc] initWithFrame:CGRectMake(48,NAVIGATION_BAR_HEIGHT+84, 158, 42)];
        [backImageView addSubview:titlImageView];
        titlImageView.image = UIImageNamed(@"Image_loginsubtitle");
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [backImageView addSubview:backBtn];
        [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-88-43-40-20, DR_SCREEN_WIDTH-40, 88)];
        infoView.backgroundColor = [[UIColor colorWithHexString:@"#F0F1F5"] colorWithAlphaComponent:1];
        [infoView setAllCorner:8];
        [backImageView addSubview:infoView];
        
        NoticeSaveLoginStory *info = [NoticeSaveModel getLoginInfo];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 56, 56)];
        [iconImageView setAllCorner:10];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:info.avatar_url]] placeholderImage:[UIImage imageNamed:@"Image_jynohe"] options:SDWebImageAvoidDecodeImage];
        [infoView addSubview:iconImageView];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(79, 20, infoView.frame.size.width-79-50-15, 22)];
        nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        nameL.font = XGSIXBoldFontSize;
        nameL.text = info.nick_name?info.nick_name:@"这个默认名字不适合我";
        [infoView addSubview:nameL];
        
        UILabel *typeL = [[UILabel alloc] initWithFrame:CGRectMake(79, 50, nameL.frame.size.width, 17)];
        typeL.font = TWOTEXTFONTSIZE;
        typeL.textColor = [UIColor colorWithHexString:@"#25262E"];
        typeL.text = info.loginType;
        [infoView addSubview:typeL];
        
        UIButton *loginB = [[UIButton alloc] initWithFrame:CGRectMake(infoView.frame.size.width-15-50, 19, 50, 50)];
        [loginB setBackgroundImage:UIImageNamed(@"Image_fastlogin") forState:UIControlStateNormal];
        [infoView addSubview:loginB];
        [loginB addTarget:self action:@selector(fastLoginClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *otherLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(infoView.frame)+10, DR_SCREEN_WIDTH, 43)];
        [otherLogin setTitle:@"其他登录方式" forState:UIControlStateNormal];
        [otherLogin setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        otherLogin.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [otherLogin addTarget:self action:@selector(otherClick) forControlEvents:UIControlEventTouchUpInside];
        [backImageView addSubview:otherLogin];
    }
    return self;
}

- (void)otherClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)fastLoginClick{
    if (self.funClickBlock) {
        self.funClickBlock(2);
    }
}

- (void)backclick{
    if (self.funClickBlock) {
        self.funClickBlock(1);
    }
}

@end
