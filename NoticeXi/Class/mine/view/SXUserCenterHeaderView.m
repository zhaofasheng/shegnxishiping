//
//  SXUserCenterHeaderView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXUserCenterHeaderView.h"

@implementation SXUserCenterHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        UIView *bacV = [[UIView  alloc] initWithFrame:CGRectMake(15, 65, 241, 241)];
        bacV.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.3];
        [self addSubview:bacV];
        
        UIView *bacV1 = [[UIView  alloc] initWithFrame:CGRectMake(25,55, 241, 241)];
        bacV1.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:0.5];
        [self addSubview:bacV1];
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35,45, 241, 241)];
        [self addSubview:_iconImageView];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(35,328,DR_SCREEN_WIDTH-35, 30)];
        _nickNameL.font = XGTwentyTwoBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:_nickNameL];
     

        self.freuView = [[FSCustomButton  alloc] init];
        self.freuView.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.freuView setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        [self.freuView setImage:UIImageNamed(@"Image_fuxuehao") forState:UIControlStateNormal];
        self.freuView.buttonImagePosition = FSCustomButtonImagePositionRight;
        [self addSubview:self.freuView];
        [self.freuView addTarget:self action:@selector(copyiDTap) forControlEvents:UIControlEventTouchUpInside];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(35,395,DR_SCREEN_WIDTH-70, 0)];
        _titleL.font = FIFTHTEENTEXTFONTSIZE;
        _titleL.numberOfLines = 0;
        _titleL.textColor = [UIColor colorWithHexString:@"#41434D"];
        [self addSubview:_titleL];
       
    }
    return self;
}

- (void)setUserM:(NoticeUserInfoModel *)userM{
    _userM = userM;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageAvoidDecodeImage];
    
    self.nickNameL.text = userM.nick_name;
    

    NSString *str = [NSString stringWithFormat:@"id：%@",userM.frequency_no];
    [self.freuView setTitle:str forState:UIControlStateNormal];
    self.freuView.frame = CGRectMake(self.nickNameL.frame.origin.x, 362, GET_STRWIDTH(str, 13, 18)+20, 18);
    
    if (userM.self_intro) {
        self.titleL.frame = CGRectMake(35, 395, DR_SCREEN_WIDTH-70, [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-70 string:userM.self_intro isJiacu:NO]);
        self.titleL.attributedText = [SXTools getStringWithLineHight:3 string:userM.self_intro];
    }

    
    self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 395+self.titleL.frame.size.height);
}


- (void)copyiDTap{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.userM.frequency_no];
    [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
}

@end
