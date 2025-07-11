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
#import "NoticeXi-Swift.h"
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
        
        self.contentL = [[GZLabel alloc] initWithFrame:CGRectMake(56, 31, DR_SCREEN_WIDTH-56-15, 0)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.GZLabelNormalColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentL setHightLightLabelColor:[UIColor colorWithHexString:@"#FF4A98"] forGZLabelStyle:GZLabelStyleTopic];
        self.contentL.numberOfLines = 0;
        self.contentL.delegate = self;
        [self.contentView addSubview:self.contentL];
        self.contentL.userInteractionEnabled = YES;
//        UITapGestureRecognizer *replyTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyClick)];
//        [_contentL addGestureRecognizer:replyTap1];
        
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
        
        UILongPressGestureRecognizer *longDleTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longDeleteVoice:)];
        longDleTap.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longDleTap];
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
    
    self.contentL.text = commentM.content;
    self.contentL.frame = CGRectMake(56, 31, DR_SCREEN_WIDTH-56-15, commentM.firstContentHeight);
    
    self.bottomView.frame = CGRectMake(56, CGRectGetMaxY(self.contentL.frame)+2, DR_SCREEN_WIDTH-56-15, 20);
    self.timeL.text = commentM.created_at;
    self.timeL.frame = CGRectMake((commentM.top_at.intValue?34:0), 0, GET_STRWIDTH(self.timeL.text, 12,20), 20);
    self.replyL.frame = CGRectMake(CGRectGetMaxX(_timeL.frame),0, 44, 20);
    
    _topL.hidden = YES;
    if (commentM.top_at.intValue) {
        self.topL.hidden = NO;
    }
    
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
        _authorHasReplyL.layer.cornerRadius = 15/2;
        _authorHasReplyL.layer.masksToBounds = YES;
        [self.contentView addSubview:_authorHasReplyL];
    }
    return _authorHasReplyL;
}

- (UILabel *)topL{
    if (!_topL) {
        _topL = [[UILabel  alloc] initWithFrame:CGRectMake(0,2, 30, 16)];
        _topL.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:0.1];
        _topL.font = [UIFont systemFontOfSize:12];
        _topL.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        _topL.textAlignment = NSTextAlignmentCenter;
        _topL.layer.cornerRadius = 15/2;
        _topL.layer.masksToBounds = YES;
        _topL.text = @"置顶";
        [self.bottomView addSubview:_topL];
    }
    return _topL;
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
            [[NSNotificationCenter defaultCenter]postNotificationName:@"COMMENTLIKENotification" object:self userInfo:@{@"commentId":self.commentM.commentId,@"is_like":self.commentM.is_like,@"zan_num":self.commentM.zan_num}];
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

-(void)GZLabel:(GZLabel *)label didSelectedString:(NSString *)selectedString forGZLabelStyle:(GZLabelStyle *)style onRange:(NSRange)range{
    DRLog(@"点击的链接是%@",selectedString);
    for (SXPayForVideoModel *model in self.commentM.seariesArr) {
        if ([model.name isEqualToString:selectedString] || [selectedString containsString:model.name]) {
            if (self.linkClickBlock) {
                self.linkClickBlock(model.seriesId);
            }
            break;
        }
    }
}

- (void)didSelecteNomer{
    [self replyClick];
}

- (void)longDeleteVoice:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;

    //py.dele  删除  chat.jubao 举报
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
    
            NSArray *arr = nil;
            if ([NoticeTools isManager]) {//管理员长按操作
                arr = @[self.commentM.top_at.intValue?@"取消置顶": @"置顶",@"回复",@"复制",@"删除"];
            }else if ([[NoticeTools getuserId] isEqualToString:self.videoUser.userId]){//视频发布者长按操作
                
                if ([self.commentM.fromUserInfo.userId isEqualToString:[NoticeTools getuserId]]) {//视频发布者长按自己的评论
                    arr = @[self.commentM.top_at.intValue?@"取消置顶": @"置顶",@"回复",@"复制",@"删除"];
                }else{//视频发布者长按别人的评论
                    arr = @[self.commentM.top_at.intValue?@"取消置顶": @"置顶",@"回复",@"复制",@"举报",@"删除"];
                }
            }else if ([self.commentM.fromUserInfo.userId isEqualToString:[NoticeTools getuserId]]){//普通用户长按自己的评论
                arr = @[@"回复",@"复制",@"删除"];
            }else{//普通用户长按别人的评论
                arr = @[@"回复",@"复制",@"举报"];
            }
            
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:arr];
            sheet.delegate = self;
            [sheet show];

            break;
        }
        default:
            break;
    }
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([NoticeTools isManager]) {//管理员长按操作
        if (buttonIndex == 1) {
            [self setTopComment];
        }else if (buttonIndex == 2){
            [self replyClick];
        }else if (buttonIndex == 3){
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            [pastboard setString:self.commentM.content];
            [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
        }else if (buttonIndex == 4){
            [self deleteComment];
        }
    }else if ([[NoticeTools getuserId] isEqualToString:self.videoUser.userId]){//视频发布者长按操作
        
        if ([self.commentM.fromUserInfo.userId isEqualToString:[NoticeTools getuserId]]) {//视频发布者长按自己的评论
            if (buttonIndex == 1) {
                [self setTopComment];
            }else if (buttonIndex == 2){
                [self replyClick];
            }else if (buttonIndex == 3){
                UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
                [pastboard setString:self.commentM.content];
                [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
            }else if (buttonIndex == 4){
                [self deleteComment];
            }
        }else{//视频发布者长按别人的评论
            
            if (buttonIndex == 1) {
                [self setTopComment];
            }else if (buttonIndex == 2){
                [self replyClick];
            }else if (buttonIndex == 3){
                UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
                [pastboard setString:self.commentM.content];
                [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
            }else if (buttonIndex == 4){
                [self jubaoComment];
            }
            else if (buttonIndex == 5){
                [self deleteComment];
            }
        }
    }else if ([self.commentM.fromUserInfo.userId isEqualToString:[NoticeTools getuserId]]){//普通用户长按自己的评论
        if (buttonIndex == 1){
            [self replyClick];
        }else if (buttonIndex == 2){
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            [pastboard setString:self.commentM.content];
            [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
        }else if (buttonIndex == 3){
            [self deleteComment];
        }
    }else{//普通用户长按别人的评论
        
        if (buttonIndex == 1){
            [self replyClick];
        }else if (buttonIndex == 2){
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            [pastboard setString:self.commentM.content];
            [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
        }else if (buttonIndex == 3){
            [self jubaoComment];
        }
    }
}

//置顶评论
- (void)setTopComment{
    [[NoticeTools getTopViewController] showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.commentM.commentId forKey:@"parentId"];
    [parm setObject:self.commentM.top_at.intValue?@"0":@"1" forKey:@"type"];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"videoComment/setTop" Accept:@"application/vnd.shengxi.v5.8.1+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.commentM.top_at = self.commentM.top_at.intValue?@"0":@"1";
            if (self.topClickBlock) {
                self.topClickBlock(self.commentM);
            }
            if (self.commentM.top_at.intValue) {
                [[NoticeTools getTopViewController] showToastWithText:@"已置顶"];
            }else{
                [[NoticeTools getTopViewController] showToastWithText:@"已取消置顶"];
            }
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

//删除评论
- (void)deleteComment{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定删除吗？" message:@"该内容下的回复内容也会被删除" sureBtn:@"取消" cancleBtn:@"删除" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"videoCommont/%@",weakSelf.commentM.commentId] Accept:@"application/vnd.shengxi.v5.8.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    if (weakSelf.deleteClickBlock) {
                        weakSelf.deleteClickBlock(weakSelf.commentM);
                    }
                }
            } fail:^(NSError * _Nullable error) {
            }];
        }
    };
    [alerView showXLAlertView];
}

//举报评论
- (void)jubaoComment{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.commentM.commentId;
    juBaoView.reouceType = @"149";
    [juBaoView showView];
}
@end
