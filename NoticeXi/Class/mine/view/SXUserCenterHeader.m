//
//  SXUserCenterHeader.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/21.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXUserCenterHeader.h"
#import "NoticeShopMyWallectController.h"
#import "NoticeMyWallectModel.h"
@implementation SXUserCenterHeader


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,10, 72, 72)];
        [_iconImageView setAllCorner:72/2];
        [self addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10,21,DR_SCREEN_WIDTH-105, 28)];
        _nickNameL.font = XGTwentyBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:_nickNameL];
     
        self.freuView = [[FSCustomButton  alloc] init];
        self.freuView.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.freuView setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
        [self.freuView setImage:UIImageNamed(@"Image_fuxuehao") forState:UIControlStateNormal];
        self.freuView.buttonImagePosition = FSCustomButtonImagePositionRight;
        [self addSubview:self.freuView];
        [self.freuView addTarget:self action:@selector(copyiDTap) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserInfo) name:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
        
        self.jinbiView = [[UIView  alloc] initWithFrame:CGRectMake(20, 135, DR_SCREEN_WIDTH-40, 80)];
        self.jinbiView.backgroundColor = [UIColor whiteColor];
        [self.jinbiView setAllCorner:8];
        [self addSubview:self.jinbiView];
        
        self.titleImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 28, 24, 24)];
        self.titleImageView.image = UIImageNamed(@"sxwallect_img");
        [self.jinbiView addSubview:self.titleImageView];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(48,29,self.jinbiView.frame.size.width-48-100, 21)];
        _titleL.font = XGFifthBoldFontSize;
        _titleL.text = @"我的鲸币";
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.jinbiView addSubview:_titleL];
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(self.jinbiView.frame.size.width - 170,27,150, 26)];
        _moneyL.font = SXNUMBERFONT(24);

        _moneyL.textAlignment = NSTextAlignmentRight;
        _moneyL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.jinbiView addSubview:_moneyL];
        
        self.jinbiView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jingbiTap)];
        [self.jinbiView addGestureRecognizer:tap];
        
        [self requestUserInfo];
    }
    return self;
}

- (void)jingbiTap{
    NoticeShopMyWallectController *ctl = [[NoticeShopMyWallectController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)copyiDTap{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.userM.frequency_no];
    [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
}

- (void)requestUserInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
       
            self.userM = userIn;
            if (userIn.token) {
              [NoticeSaveModel saveToken:userIn.token];
            }
            [NoticeSaveModel saveUserInfo:userIn];

        }
    } fail:^(NSError *error) {
     
    }];
}



- (void)setUserM:(NoticeUserInfoModel *)userM{
    _userM = userM;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]
                      placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                               options:SDWebImageAvoidDecodeImage];
    
    self.nickNameL.text = userM.nick_name;
    

    NSString *str = [NSString stringWithFormat:@"id：%@",userM.frequency_no];
    [self.freuView setTitle:str forState:UIControlStateNormal];
    self.freuView.frame = CGRectMake(self.nickNameL.frame.origin.x, CGRectGetMaxY(self.nickNameL.frame)+4, GET_STRWIDTH(str, 13, 18)+20, 18);
}
@end
