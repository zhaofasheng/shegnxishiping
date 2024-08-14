//
//  SXKcComScoreListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcComScoreListCell.h"
#import "NoticeUserInfoCenterController.h"
@implementation SXKcComScoreListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 124)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 32, 32)];
        [_iconImageView setAllCorner:16];
        [self.backView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+8,13, DR_SCREEN_WIDTH-56-30, 20)];
        _nickNameL.font = XGFourthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_nickNameL];
        
        self.scoreImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-37-16, 16, 16, 16)];
        [self.backView addSubview:self.scoreImageView];
        
        self.scoreNameL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scoreImageView.frame)+1, 15, 36, 17)];
        self.scoreNameL.font = XGTWOBoldFontSize;
        [self.backView addSubview:self.scoreNameL];
        
        self.timeL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+8, 33, 120, 16)];
        self.timeL.font = ELEVENTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.backView addSubview:self.timeL];
        
        self.tagLabeL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 57, DR_SCREEN_WIDTH-60, 0)];
        self.tagLabeL.font = ELEVENTEXTFONTSIZE;
        self.tagLabeL.numberOfLines = 0;
        self.tagLabeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:self.tagLabeL];
        
        self.contentL = [[UILabel  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tagLabeL.frame)+10, DR_SCREEN_WIDTH-60, 0)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.numberOfLines = 0;
        self.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.contentL];
        
        _likeL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-34,self.backView.frame.size.height-15-20, 34, 20)];
        _likeL.font = FOURTHTEENTEXTFONTSIZE;
        _likeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:_likeL];
        _likeL.userInteractionEnabled = YES;
        UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [_likeL addGestureRecognizer:likeTap];
        
        self.likeImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-20-34,self.backView.frame.size.height-15-20, 20, 20)];
        self.likeImageView.userInteractionEnabled = YES;
        self.likeImageView.image = UIImageNamed(@"sx_like_noimgs");
        [self.backView addSubview:self.likeImageView];
        UITapGestureRecognizer *likeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [self.likeImageView addGestureRecognizer:likeTap1];
    }
    return self;
}

- (void)setComModel:(SXKcComDetailModel *)comModel{
    _comModel = comModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:comModel.userModel.avatar_url]];
    
    if ([[NoticeTools getuserId] isEqualToString:comModel.userModel.userId]) {
        self.nickNameL.text = @"我的评价";
    }else{
        self.nickNameL.text = comModel.userModel.nick_name;
    }
    
    self.scoreNameL.text = comModel.scoreName;
    if (comModel.score.intValue > 3) {
        self.scoreNameL.textColor = [UIColor colorWithHexString:@"#F29900"];
    }else{
        self.scoreNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
    }
    NSString *imageNmae = [NSString stringWithFormat:@"sxkcscore%d_img1",comModel.score.intValue-1];
    self.scoreImageView.image = UIImageNamed(imageNmae);
    
    self.timeL.text = comModel.created_at;
    if (comModel.label_info.count) {
        self.tagLabeL.attributedText = [SXTools getStringWithLineHight:3 string:comModel.labelName];
        self.tagLabeL.frame = CGRectMake(15, 57, DR_SCREEN_WIDTH-60, comModel.labelHeight);
    }else{
        self.tagLabeL.text = @"";
        self.tagLabeL.frame = CGRectMake(15, 57, DR_SCREEN_WIDTH-60, 0);
    }
    
    if (comModel.content.length && comModel.contentHeight > 0) {
        self.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.contentL.attributedText = [SXTools getStringWithLineHight:3 string:comModel.content];
        self.contentL.frame = CGRectMake(15, CGRectGetMaxY(self.tagLabeL.frame)+10, DR_SCREEN_WIDTH-60, comModel.contentHeight);
    }else{
        if (!comModel.label_info.count) {
            self.contentL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
            self.contentL.text = @"用户未添加其他评价";
            self.contentL.frame = CGRectMake(15, CGRectGetMaxY(self.tagLabeL.frame)+10, DR_SCREEN_WIDTH-60, 20);
        }
    }
    
    CGFloat backViewHeight = 124;
    if (comModel.label_info.count || comModel.content) {
        backViewHeight = 57+45+10+comModel.labelHeight+comModel.contentHeight;
    }else{
        backViewHeight = 57+45+20;
    }
    self.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, backViewHeight);
    
    self.likeL.text = comModel.zan_num.intValue?comModel.zan_num:@"0";
    if (comModel.is_zan.boolValue) {//自己点赞过
        self.likeImageView.image = UIImageNamed(@"sx_like_imgs");
    }else{
        self.likeImageView.image = UIImageNamed(@"sx_like_noimgs");
    }
    
    if (self.seeSelf) {
        self.deleteBtn.hidden = NO;
        self.likeL.frame = CGRectMake(37,self.backView.frame.size.height-15-20, 34, 20);
        self.likeImageView.frame = CGRectMake(15,self.backView.frame.size.height-15-20, 20, 20);
    }else{
        self.likeL.frame = CGRectMake(self.backView.frame.size.width-34,self.backView.frame.size.height-15-20, 34, 20);
        self.likeImageView.frame = CGRectMake(self.backView.frame.size.width-20-34,self.backView.frame.size.height-15-20, 20, 20);
    }
}

- (void)likeClick{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoSeriesRemark/zan/%@/%@",self.comModel.comId,self.comModel.is_zan.boolValue?@"2":@"1"] Accept:@"application/vnd.shengxi.v5.8.6+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.comModel.is_zan = self.comModel.is_zan.boolValue?@"0":@"1";
            if (self.comModel.is_zan.boolValue) {
                self.comModel.zan_num = [NSString stringWithFormat:@"%d",self.comModel.zan_num.intValue+1];
            }else{
                if (self.comModel.zan_num.intValue) {
                    self.comModel.zan_num = [NSString stringWithFormat:@"%d",self.comModel.zan_num.intValue-1];
                }
            }
            self.likeL.text = self.comModel.zan_num.intValue?self.comModel.zan_num:@"0";
            if (self.comModel.is_zan.boolValue) {//自己点赞过
                self.likeImageView.image = UIImageNamed(@"sx_like_imgs");
            }else{
                self.likeImageView.image = UIImageNamed(@"sx_like_noimgs");
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SXZANKCoNotification" object:self userInfo:@{@"comId":self.comModel.comId,@"is_zan":self.comModel.is_zan,@"zan_num":self.comModel.zan_num}];
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-20, self.backView.frame.size.height-15-20, 20, 20)];
        [_deleteBtn setBackgroundImage:UIImageNamed(@"sxdeletekcscore_img") forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

- (void)deleteClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"删除后不能再次评价" message:nil sureBtn:@"再想想" cancleBtn:@"删除" right:NO];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"videoSeriesRemark/delete/%@",self.comModel.comId] Accept:@"application/vnd.shengxi.v5.8.6+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    if (weakSelf.deleteScoreBlock) {
                        weakSelf.comModel.status = @"2";
                        weakSelf.deleteScoreBlock(weakSelf.comModel);
                    }
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)userInfoTap{
    if (![NoticeTools getuserId]) {
        [[NoticeTools getTopViewController] showToastWithText:@"没有登录或者游客账号无法查看用户信息哦"];
        return;
    }
    if ([self.comModel.userModel.userId isEqualToString:[NoticeTools getuserId]]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.comModel.userModel.userId;
        ctl.isOther = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

@end
