//
//  SXVideoUserCenterView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/28.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoUserCenterView.h"

@implementation SXVideoUserCenterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-160)/2, 16, 160,160)];
        [self.iconImageView setAllCorner:15];
        [self addSubview:self.iconImageView];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 232,DR_SCREEN_WIDTH-40, 50)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;
        [self addSubview:self.backView];
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(16, 0,0, 50)];
        self.nickNameL.font = XGTwentyBoldFontSize;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.nickNameL];
        
        self.markImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameL.frame), 15, 20, 20)];
        self.markImageView.image = UIImageNamed(@"Image_guanfang_b");
        [self.backView addSubview:self.markImageView];
        self.markImageView.hidden = YES;
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(16, 50,self.backView.frame.size.width, 0)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [UIColor colorWithHexString:@"#41434D"];
        [self.backView addSubview:self.contentL];
    }
    return self;
}

- (void)setUserModel:(SXUserModel *)userModel{
    _userModel = userModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar_url] placeholderImage:UIImageNamed(@"noImage_jynohe")];
    
    CGFloat height = GET_STRHEIGHT(userModel.user_introduce, 14, DR_SCREEN_WIDTH-40-30);
    self.backView.frame = CGRectMake(20, 232, DR_SCREEN_WIDTH-40, 50+20+height);
    
    self.nickNameL.text = userModel.nick_name;
    self.nickNameL.frame = CGRectMake(16, 0, GET_STRWIDTH(userModel.nick_name, 21, 50), 50);
    self.markImageView.hidden = userModel.is_official.boolValue?NO:YES;
    self.markImageView.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame), 15, 20, 20);
    
    self.contentL.frame = CGRectMake(15, 50, self.backView.frame.size.width-30, height);
    self.contentL.text = userModel.user_introduce;
    self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 232+self.backView.frame.size.height+30);
}

@end
