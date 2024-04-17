//
//  SXVideoCmmentFirstCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCmmentFirstCell.h"
#import "NoticeUserInfoCenterController.h"
#import "SXVideoUserCenterController.h"
@implementation SXVideoCmmentFirstCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
       
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 32, 32)];
        [_iconImageView setAllCorner:16];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+8,10, DR_SCREEN_WIDTH-56, 17)];
        _nickNameL.font = TWOTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:_nickNameL];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(56, 31, DR_SCREEN_WIDTH-56-15, 0)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.numberOfLines = 0;
        [self.contentView addSubview:self.contentL];
        
        self.bottomView = [[UIView  alloc] initWithFrame:CGRectMake(56, CGRectGetMaxY(self.contentL.frame)+2, DR_SCREEN_WIDTH-56-15, 20)];
        [self.contentView addSubview:self.bottomView];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 0, 20)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.bottomView addSubview:_timeL];
        
        //回复按钮
        _replyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeL.frame),0, 44, 20)];
        _replyL.font = TWOTEXTFONTSIZE;
        _replyL.text = @"回复";
        _replyL.userInteractionEnabled = YES;
        _replyL.textAlignment = NSTextAlignmentCenter;
        _replyL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.bottomView addSubview:_replyL];
        UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyClick)];
        [_replyL addGestureRecognizer:replyTap];
        
        _likeL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 0, 20)];
        _likeL.font = FOURTHTEENTEXTFONTSIZE;
        _likeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.bottomView addSubview:_likeL];
        _likeL.hidden = YES;
        _likeL.userInteractionEnabled = YES;
        UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [_likeL addGestureRecognizer:likeTap];
        
        self.likeImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width-20, 0, 20, 20)];
        self.likeImageView.userInteractionEnabled = YES;
        self.likeImageView.image = UIImageNamed(@"sx_like_noimg");
        [self.bottomView addSubview:self.likeImageView];
        UITapGestureRecognizer *likeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [self.likeImageView addGestureRecognizer:likeTap1];
    }
    return self;
}


- (void)setCommentM:(SXVideoCommentModel *)commentM{
    _commentM = commentM;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:commentM.fromUserInfo.avatar_url]];
    
    self.nickNameL.text = commentM.fromUserInfo.nick_name;
    self.nickNameL.frame = CGRectMake(56, 10, GET_STRWIDTH(self.nickNameL.text, 12, 17), 17);
    _authorL.hidden = YES;
    
    if ([commentM.fromUserInfo.userId isEqualToString:self.videoUser.userId]) {
        self.authorL.hidden = NO;
        self.authorL.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame), 11, 30, 15);
    }
    
    self.contentL.attributedText = commentM.firstAttr;
    self.contentL.frame = CGRectMake(56, 31, DR_SCREEN_WIDTH-56-15, commentM.firstContentHeight);
    
    self.bottomView.frame = CGRectMake(56, CGRectGetMaxY(self.contentL.frame)+2, DR_SCREEN_WIDTH-56-15, 20);
    self.timeL.text = commentM.created_at;
    self.timeL.frame = CGRectMake(0, 0, GET_STRWIDTH(self.timeL.text, 12,20), 20);
    self.replyL.frame = CGRectMake(CGRectGetMaxX(_timeL.frame),0, 44, 20);
    
    [self refreshLikeUI:commentM];
    
    _authorHasReplyL.hidden = YES;
    if (commentM.author_reply.boolValue || commentM.author_zan.boolValue) {
        self.authorHasReplyL.hidden = NO;
        if (commentM.author_reply.boolValue) {
            self.authorHasReplyL.text = @"作者回复过";
            self.authorHasReplyL.frame = CGRectMake(56,CGRectGetMaxY(self.bottomView.frame)+8, 60, 15);
        }else if (commentM.author_zan.boolValue){
            self.authorHasReplyL.text = @"作者赞过";
            self.authorHasReplyL.frame = CGRectMake(56,CGRectGetMaxY(self.bottomView.frame)+8, 50, 15);
        }
        [_authorHasReplyL setAllCorner:15/2];
    }
}

- (void)refreshLikeUI:(SXVideoCommentModel *)commentM{
    self.likeImageView.image = UIImageNamed(@"sx_like_noimg");
    _likeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    if (commentM.zan_num.intValue) {//有点赞的时候
        self.likeL.hidden = NO;
        self.likeL.text = commentM.zan_num;
        self.likeL.frame = CGRectMake(self.bottomView.frame.size.width-GET_STRWIDTH(commentM.zan_num, 14, 20), 0, GET_STRWIDTH(commentM.zan_num, 14, 20), 20);
        self.likeImageView.frame = CGRectMake(self.bottomView.frame.size.width-20-2-self.likeL.frame.size.width, 0, 20, 20);
        if (commentM.is_like.boolValue) {//自己点赞过
            self.likeL.textColor = [UIColor colorWithHexString:@"#FF2A6F"];
            self.likeImageView.image = UIImageNamed(@"sx_like_img");
        }
    }else{
        self.likeL.hidden = YES;
        self.likeImageView.frame = CGRectMake(self.bottomView.frame.size.width-20, 0, 20, 20);
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

- (UILabel *)authorHasReplyL{
    if (!_authorHasReplyL) {
        _authorHasReplyL = [[UILabel  alloc] initWithFrame:CGRectMake(56,CGRectGetMaxY(self.bottomView.frame)+8, 60, 15)];
        _authorHasReplyL.backgroundColor = [[UIColor colorWithHexString:@"#FF2A6F"] colorWithAlphaComponent:0.1];
        _authorHasReplyL.font = [UIFont systemFontOfSize:10];
        _authorHasReplyL.textColor = [UIColor colorWithHexString:@"#FF2A6F"];
        _authorHasReplyL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_authorHasReplyL];
    }
    return _authorL;
}

- (void)replyClick{
    if (self.replyClickBlock) {
        self.replyClickBlock(self.commentM);
    }
}

//点赞，取消点赞
- (void)likeClick{

    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoCommontZan/%@/%@",self.commentM.commentId,self.commentM.is_like.boolValue?@"0":@"1"] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.commentM.is_like = self.commentM.is_like.boolValue?@"0":@"1";
            if (self.commentM.is_like.boolValue) {
                self.commentM.zan_num = [NSString stringWithFormat:@"%d",self.commentM.zan_num.intValue+1];
            }else{
                if (self.commentM.zan_num.intValue) {
                    self.commentM.zan_num = [NSString stringWithFormat:@"%d",self.commentM.zan_num.intValue-1];
                }
            }
            [self refreshLikeUI:self.commentM];
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)userInfoTap{
    if ([self.commentM.fromUserInfo.userId isEqualToString:self.videoUser.userId]) {
        SXVideoUserCenterController *ctl = [[SXVideoUserCenterController alloc] init];
        ctl.userModel = self.videoUser;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        return;
    }

    
    if ([self.commentM.fromUserInfo.userId isEqualToString:[NoticeTools getuserId]]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.commentM.fromUserInfo.userId;
        ctl.isOther = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

@end
