//
//  SXUserCenterHeader.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/21.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXUserCenterHeader.h"
#import "NoticeXi-Swift.h"
#import "NoticeMyWallectModel.h"
#import "NoticeChangePhoneViewController.h"
#import "NoticeUserInfoCenterController.h"
@implementation SXUserCenterHeader


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,10, 72, 72)];
        [_iconImageView setAllCorner:72/2];
        [self addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userCenter)];
        [_iconImageView addGestureRecognizer:tapp];
        
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
        
        self.jinbiView = [[UIView  alloc] initWithFrame:CGRectMake(20, 135, DR_SCREEN_WIDTH-40, 106)];
        self.jinbiView.backgroundColor = [UIColor whiteColor];
        [self.jinbiView setAllCorner:8];
        [self addSubview:self.jinbiView];
        
        UIView *jbView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, self.jinbiView.frame.size.width/2, 106)];
        [self.jinbiView addSubview:jbView];
        jbView.userInteractionEnabled = YES;
        [jbView setAllCorner:8];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jingbiTap)];
        [jbView addGestureRecognizer:tap];
        CGFloat width = 24+GET_STRWIDTH(@"我的鲸币", 14, 20);
        
        self.titleImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((jbView.frame.size.width-width)/2, 24, 20, 20)];
        self.titleImageView.image = UIImageNamed(@"sxwallect_img1");
        [jbView addSubview:self.titleImageView];
        self.titleImageView.userInteractionEnabled = YES;
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImageView.frame)+4,24,GET_STRWIDTH(@"我的鲸币", 14, 20), 20)];
        _titleL.font = FOURTHTEENTEXTFONTSIZE;
        _titleL.text = @"我的鲸币";
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [jbView addSubview:_titleL];
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(0,56,jbView.frame.size.width, 26)];
        _moneyL.font = SXNUMBERFONT(24);
        _moneyL.textAlignment = NSTextAlignmentCenter;
        _moneyL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [jbView addSubview:_moneyL];
        
    
        UIView *inView = [[UIView  alloc] initWithFrame:CGRectMake(self.jinbiView.frame.size.width/2, 0, self.jinbiView.frame.size.width/2, 106)];
        [self.jinbiView addSubview:inView];
        inView.userInteractionEnabled = YES;
        [inView setAllCorner:8];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(incomeTap)];
        [inView addGestureRecognizer:tap1];
        CGFloat width1 = 24+GET_STRWIDTH(@"收入", 14, 20);
        
        self.titleImageView1 = [[UIImageView  alloc] initWithFrame:CGRectMake((inView.frame.size.width-width1)/2, 24, 20, 20)];
        self.titleImageView1.image = UIImageNamed(@"sxwallect_img2");
        [inView addSubview:self.titleImageView1];
        self.titleImageView1.userInteractionEnabled = YES;
        
        _titleL1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImageView1.frame)+4,24,GET_STRWIDTH(@"收入", 14, 20), 20)];
        _titleL1.font = FOURTHTEENTEXTFONTSIZE;
        _titleL1.text = @"收入";
        _titleL1.textColor = [UIColor colorWithHexString:@"#14151A"];
        [inView addSubview:_titleL1];
        
        _incomeL = [[UILabel alloc] initWithFrame:CGRectMake(0,56,inView.frame.size.width, 26)];
        _incomeL.font = SXNUMBERFONT(24);
        _incomeL.textAlignment = NSTextAlignmentCenter;
        _incomeL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [inView addSubview:_incomeL];
        
        UIView *line = [[UIView  alloc] initWithFrame:CGRectMake((self.jinbiView.frame.size.width-1)/2, 43, 1, 25)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.jinbiView addSubview:line];
        
        self.checkL = [[UILabel  alloc] initWithFrame:CGRectMake(_nickNameL.frame.origin.x, 81, DR_SCREEN_WIDTH-102-10, 17)];
        self.checkL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.checkL.font = TWOTEXTFONTSIZE;
        [self addSubview:self.checkL];
    }
    return self;
}

- (void)incomeTap{
    if ([[NoticeTools getuserId] isEqualToString:@"2"]) {
        [[NoticeTools getTopViewController] showToastWithText:@"当前暂无收入，请踊跃开启店铺接单"];
        return;
    }
    NoticeShouRuShopController *ctl = [[NoticeShouRuShopController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)userCenter{
    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)refresh{
    [self requestUserInfo];
}

- (void)jingbiTap{
    NoticeChongzhiShopController *ctl = [[NoticeChongzhiShopController alloc] init];
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
       
            if (userIn.mobile.length < 6) {//没有绑定手机号
                 XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"未有绑定手机号" message:@"您未有绑定手机号，可能导致后期账号丢失，以及无法使用所有功能，我们将尊重用户的隐私权限，手机号仅用于账号登录以及需要手机验证的权限功能" sureBtn:@"取消" cancleBtn:@"去绑定" right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 2) {
                        NoticeChangePhoneViewController *vc = [[NoticeChangePhoneViewController alloc] init];
                        vc.hasPhone = NO;
                        [[NoticeTools getTopViewController].navigationController pushViewController:vc animated:YES];
                    }
                };
                [alerView showXLAlertView];
            }
            
            self.userM = userIn;
            if (userIn.token) {
              [NoticeSaveModel saveToken:userIn.token];
            }
            [NoticeSaveModel saveUserInfo:userIn];
        }
    } fail:^(NSError *error) {
     
    }];
}

- (void)setVerifyModel:(SXVerifyShopModel *)verifyModel{
    _verifyModel = verifyModel;
    self.checkL.text = @"";
    if (verifyModel.verify_status.intValue == 3) {
        if (verifyModel.authentication_type.intValue == 1) {//学历
            self.checkL.text = [NSString stringWithFormat:@"已实名 | %@ %@ %@",verifyModel.school_name,verifyModel.speciality_name,verifyModel.education_optionName];
        }else if (verifyModel.authentication_type.intValue == 2){
            self.checkL.text = [NSString stringWithFormat:@"已实名 | %@ %@",verifyModel.industry_name,verifyModel.position_name];
        }else if (verifyModel.authentication_type.intValue == 3){
            self.checkL.text = [NSString stringWithFormat:@"已实名 | %@",verifyModel.credentials_name];
        }
    }
   
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
