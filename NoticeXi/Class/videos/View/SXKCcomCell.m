//
//  SXKCcomCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKCcomCell.h"
#import "NoticeUserInfoCenterController.h"
@implementation SXKCcomCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
       
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 32, 32)];
        [_iconImageView setAllCorner:16];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+8,15, DR_SCREEN_WIDTH-56, 17)];
        _nickNameL.font = TWOTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:_nickNameL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(56, 37, DR_SCREEN_WIDTH-56-15, 0)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.numberOfLines = 0;
        [self.contentView addSubview:self.contentL];
        self.contentL.userInteractionEnabled = YES;
        
        self.bottomView = [[UIView  alloc] initWithFrame:CGRectMake(56, CGRectGetMaxY(self.contentL.frame), DR_SCREEN_WIDTH-56, 56)];
        [self.contentView addSubview:self.bottomView];
        
        self.videView = [[UIView  alloc] initWithFrame:CGRectMake(0, 4, 192, 28)];
        self.videView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        self.videView.layer.cornerRadius = 4;
        self.videView.layer.masksToBounds = YES;
        [self.bottomView addSubview:self.videView];
        
        UITapGestureRecognizer *voiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voideClick)];
        [self.videView addGestureRecognizer:voiceTap];
        
        UIImageView *videoImg = [[UIImageView  alloc] initWithFrame:CGRectMake(8, 6, 16, 16)];
        videoImg.image = UIImageNamed(@"sx_video_img");
        videoImg.userInteractionEnabled = YES;
        [self.videView addSubview:videoImg];
        
        self.viedoNameL = [[UILabel  alloc] initWithFrame:CGRectMake(28, 0, 100, 28)];
        self.viedoNameL.font = THRETEENTEXTFONTSIZE;
        self.viedoNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.videView addSubview:self.viedoNameL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(0,36,150, 20)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.bottomView addSubview:_timeL];
        
        _comNumL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 0, 20)];
        _comNumL.font = FOURTHTEENTEXTFONTSIZE;
        _comNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.bottomView addSubview:_comNumL];
        _comNumL.userInteractionEnabled = YES;

        
        self.comImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width-20, 0, 20, 20)];
        self.comImageView.userInteractionEnabled = YES;
        self.comImageView.image = UIImageNamed(@"sx_com_markimg");
        [self.bottomView addSubview:self.comImageView];

        
        _likeL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 0, 20)];
        _likeL.font = FOURTHTEENTEXTFONTSIZE;
        _likeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.bottomView addSubview:_likeL];
        _likeL.userInteractionEnabled = YES;
        UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [_likeL addGestureRecognizer:likeTap];
        
        self.likeImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width-20, 0, 20, 20)];
        self.likeImageView.userInteractionEnabled = YES;
        self.likeImageView.image = UIImageNamed(@"sx_like_noimgs");
        [self.bottomView addSubview:self.likeImageView];
        UITapGestureRecognizer *likeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [self.likeImageView addGestureRecognizer:likeTap1];
        
    }
    return self;
}

- (void)setComModel:(SXVideoCommentModel *)comModel{
    _comModel = comModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:comModel.fromUserInfo.avatar_url]];
    
    self.nickNameL.text = comModel.fromUserInfo.nick_name;
    self.nickNameL.frame = CGRectMake(56, 15, GET_STRWIDTH(self.nickNameL.text, 12, 17), 17);
    
    _authorL.hidden = YES;
    
    if ([comModel.fromUserInfo.userId isEqualToString:comModel.authUserInfo.userId]) {
        self.authorL.hidden = NO;
        self.authorL.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame), 16, 30, 15);
    }
    
    if (!self.hasBuy && comModel.isMoreFiveLines) {
        self.contentL.attributedText = comModel.fiveAttTextStr;
        self.contentL.frame = CGRectMake(56, 37, DR_SCREEN_WIDTH-56-15, comModel.fiveTextHeight);
    }else{
        self.contentL.attributedText = comModel.firstAttr;
        self.contentL.frame = CGRectMake(56, 37, DR_SCREEN_WIDTH-56-15, comModel.firstContentHeight);
    }

    
    self.viedoNameL.text = comModel.video_title;
    self.viedoNameL.frame = CGRectMake(28, 0, GET_STRWIDTH(self.viedoNameL.text, 13, 28), 28);
    self.videView.frame = CGRectMake(0, 4, 28+self.viedoNameL.frame.size.width+10, 28);
    
    [self refreshLikeUI:comModel];
    
    self.timeL.text = comModel.created_at;
    self.bottomView.frame = CGRectMake(56, CGRectGetMaxY(self.contentL.frame), DR_SCREEN_WIDTH-56, 56);
    
    if (!self.hasBuy) {
        self.comNumL.userInteractionEnabled = NO;
        self.comImageView.userInteractionEnabled = NO;
        self.likeL.userInteractionEnabled = NO;
        self.likeImageView.userInteractionEnabled = NO;
        self.videView.userInteractionEnabled = NO;
    }else{
        self.comNumL.userInteractionEnabled = YES;
        self.comImageView.userInteractionEnabled = YES;
        self.likeL.userInteractionEnabled = YES;
        self.likeImageView.userInteractionEnabled = YES;
        self.videView.userInteractionEnabled = YES;
    }
}

- (UILabel *)authorL{
    if (!_authorL) {
        _authorL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameL.frame), 11, 30, 15)];
        _authorL.backgroundColor = [[UIColor colorWithHexString:@"#FF2A6F"] colorWithAlphaComponent:0.1];
        [_authorL setAllCorner:15/2];
        _authorL.text = @"作者";
        _authorL.font = [UIFont systemFontOfSize:10];
        _authorL.textColor = [UIColor colorWithHexString:@"#FF2A6F"];
        _authorL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_authorL];
    }
    return _authorL;
}

- (void)voideClick{
    if (self.clickVideoIdBlock) {
        self.clickVideoIdBlock(self.comModel.video_id);
    }
}

- (void)userInfoTap{

    if ([self.comModel.from_user_id isEqualToString:[NoticeTools getuserId]]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.comModel.from_user_id;
        ctl.isOther = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)refreshLikeUI:(SXVideoCommentModel *)comModel{
    self.likeImageView.image = UIImageNamed(@"sx_like_noimgs");
    _likeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    
    self.likeL.text = comModel.zan_num.intValue?comModel.zan_num:@"0";
    self.likeL.frame = CGRectMake(self.bottomView.frame.size.width-GET_STRWIDTH(comModel.zan_num, 14, 20)-15, 36, GET_STRWIDTH(comModel.zan_num, 14, 20), 20);
    self.likeImageView.frame = CGRectMake(self.likeL.frame.origin.x-20,36, 20, 20);
    if (comModel.is_like.boolValue) {//自己点赞过
        self.likeL.textColor = [UIColor colorWithHexString:@"#FF2A6F"];
        self.likeImageView.image = UIImageNamed(@"sx_like_imgs");
    }
    
    self.comNumL.text = comModel.reply_num.intValue?comModel.reply_num:@"0";
    self.comNumL.frame = CGRectMake(self.likeImageView.frame.origin.x-GET_STRWIDTH(self.comNumL.text, 14, 20)-15, 36, GET_STRWIDTH(self.comNumL.text, 14, 20), 20);
    self.comImageView.frame = CGRectMake(self.comNumL.frame.origin.x-20,36, 20, 20);
}

- (void)likeClick{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoCommontZan/%@/%@",self.comModel.commentId,self.comModel.is_like.boolValue?@"0":@"1"] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.comModel.is_like = self.comModel.is_like.boolValue?@"0":@"1";
            if (self.comModel.is_like.boolValue) {
                self.comModel.zan_num = [NSString stringWithFormat:@"%d",self.comModel.zan_num.intValue+1];
            }else{
                if (self.comModel.zan_num.intValue) {
                    self.comModel.zan_num = [NSString stringWithFormat:@"%d",self.comModel.zan_num.intValue-1];
                }
            }
            [self refreshLikeUI:self.comModel];
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
