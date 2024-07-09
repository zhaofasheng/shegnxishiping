//
//  SXHasGetComCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/3.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasGetComCell.h"
#import "NoticeUserInfoCenterController.h"
#import "SXVideoUserCenterController.h"
#import "YYPersonItem.h"
@implementation SXHasGetComCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
       
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 32, 32)];
        [_iconImageView setAllCorner:16];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+8,12, DR_SCREEN_WIDTH-56-48-20, 21)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:_nickNameL];
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+8,33, DR_SCREEN_WIDTH-56-78, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:_markL];
        
        self.contentL = [[GZLabel alloc] initWithFrame:CGRectMake(56, 54, DR_SCREEN_WIDTH-56-17, 20)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.contentL];
        self.contentL.GZLabelNormalColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentL setHightLightLabelColor:[UIColor colorWithHexString:@"#FF2A6F"] forGZLabelStyle:GZLabelStyleTopic];
        self.contentL.numberOfLines = 0;
        self.contentL.userInteractionEnabled = NO;
        
        self.content1L = [[GZLabel alloc] initWithFrame:CGRectMake(56, 54, DR_SCREEN_WIDTH-56-17, 20)];
        self.content1L.font = FIFTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.content1L];
        self.content1L.GZLabelNormalColor = [UIColor colorWithHexString:@"#25262E"];
        [self.content1L setHightLightLabelColor:[UIColor colorWithHexString:@"#FF2A6F"] forGZLabelStyle:GZLabelStyleTopic];
        self.content1L.userInteractionEnabled = NO;
        [self.contentView addSubview:self.content1L];
        
        self.bottomView = [[UIView  alloc] initWithFrame:CGRectMake(56, CGRectGetMaxY(self.contentL.frame), DR_SCREEN_WIDTH-56-15, 90)];
        [self.contentView addSubview:self.bottomView];
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(0,64, 100, 16)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.bottomView addSubview:_timeL];
        
        //回复按钮
        _replyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeL.frame),self.timeL.frame.origin.y, 44, 20)];
        _replyL.font = TWOTEXTFONTSIZE;
        _replyL.text = @"回复";
        _replyL.userInteractionEnabled = YES;
        _replyL.textAlignment = NSTextAlignmentCenter;
        _replyL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.bottomView addSubview:_replyL];
        UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyClick)];
        [_replyL addGestureRecognizer:replyTap];
        
        self.videoView = [[UIView  alloc] initWithFrame:CGRectMake(0, 6, self.bottomView.frame.size.width, 48)];
        self.videoView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.bottomView addSubview:self.videoView];
        self.videoView.layer.cornerRadius = 4;
        self.videoView.layer.masksToBounds = YES;
        
        self.videoImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, 85, 48)];
        [self.videoView addSubview:self.videoImageView];
        self.videoImageView.userInteractionEnabled = YES;
        self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.videoImageView.clipsToBounds = YES;
        
        self.videoNameL = [[UILabel  alloc] initWithFrame:CGRectMake(88, 0, self.bottomView.frame.size.width-90, 48)];
        self.videoNameL.font = FOURTHTEENTEXTFONTSIZE;
        self.videoNameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.videoView addSubview:self.videoNameL];
    
        self.likeImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width-20, self.timeL.frame.origin.y-2, 20, 20)];
        self.likeImageView.userInteractionEnabled = YES;
        self.likeImageView.image = UIImageNamed(@"sx_like_noimg");
        [self.bottomView addSubview:self.likeImageView];
        UITapGestureRecognizer *likeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [self.likeImageView addGestureRecognizer:likeTap1];
        
        UITapGestureRecognizer *goTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goClick)];
        [self.videoView addGestureRecognizer:goTap1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getlikeNotice:) name:@"COMMENTLIKENotification" object:nil];
    }
    return self;
}




- (void)setLikeComM:(SXVideoCommentBeModel *)likeComM{
    _likeComM = likeComM;
    if (self.isLike) {
        self.contentL.numberOfLines = 1;
        self.contentL.hidden = YES;
        self.content1L.hidden = NO;
    }else{
        self.contentL.hidden = NO;
        self.content1L.hidden = YES;
    }
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:likeComM.fromUserInfo.avatar_url]];

    self.nickNameL.text = likeComM.fromUserInfo.nick_name;
    
    self.timeL.text = likeComM.created_at;
    
    self.videoNameL.text = likeComM.videoModel.title;
    
    if (likeComM.sysStatus.intValue == 1) {
        self.replyL.hidden = NO;
        self.likeImageView.hidden = NO;
        if (likeComM.replyContent) {
            self.contentL.frame = CGRectMake(56, 54, DR_SCREEN_WIDTH-56-15, likeComM.replytHeight1);
            self.contentL.text = likeComM.replyContent;
            self.content1L.text = likeComM.replyContent;
        }else{
            self.contentL.frame = CGRectMake(56, 54, DR_SCREEN_WIDTH-56-15, likeComM.commentHeight1);
            self.contentL.text = likeComM.commentContent;
            self.content1L.text = likeComM.commentContent;
        }
    }else{
        self.likeImageView.hidden = YES;
        self.replyL.hidden = YES;
        self.content1L.text = @"该内容已删除";
        self.contentL.text = @"该内容已删除";
    }
    
    if (likeComM.replyContent) {
        self.markL.text = [NSString stringWithFormat:@"%@“%@”",likeComM.tips,likeComM.commentContent];
    }else{
        self.markL.text = likeComM.tips;
    }
  
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:likeComM.videoModel.series_images]];
    
    self.nickNameL.frame = CGRectMake(56, 12, GET_STRWIDTH(self.nickNameL.text, 16, 21), 21);
    if (self.isLike) {
        self.bottomView.frame = CGRectMake(56, 80, DR_SCREEN_WIDTH-56-15, 90);
    }else{
        self.bottomView.frame = CGRectMake(56, CGRectGetMaxY(self.contentL.frame), DR_SCREEN_WIDTH-56-15, 90);
    }
   
    
    _authorL.hidden = YES;
    if (likeComM.is_author.boolValue) {
        self.authorL.hidden = NO;
        self.authorL.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame), 15, 30, 15);
    }
    self.likeImageView.image = likeComM.is_like.boolValue?UIImageNamed(@"sx_like_img"): UIImageNamed(@"sx_like_noimg");
    self.timeL.frame = CGRectMake(0, 64, GET_STRWIDTH(self.timeL.text, 12, 20), 20);
    self.replyL.frame = CGRectMake(CGRectGetMaxX(_timeL.frame),self.timeL.frame.origin.y, 44, 20);
    
    if (self.isLike) {
        self.likeImageView.hidden = YES;
        self.replyL.hidden = YES;
        self.contentL.numberOfLines = 1;
    }
}

- (void)goClick{
    if (self.goVideoBlock) {
        self.goVideoBlock(self.likeComM);
    }
}

- (void)likeClick{
    if (self.likeComM.sysStatus.intValue != 1) {
        [[NoticeTools getTopViewController] showToastWithText:@"该内容删除"];
        return;
    }
    NSString *commentId = nil;
    if (self.likeComM.replyId.intValue) {
        commentId = self.likeComM.replyId;
    }else if (self.likeComM.commentId.intValue){
        commentId = self.likeComM.commentId;
    }
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoCommontZan/%@/%@",commentId,self.likeComM.is_like.boolValue?@"0":@"1"] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.likeComM.is_like = self.likeComM.is_like.boolValue?@"0":@"1";
            self.likeImageView.image = self.likeComM.is_like.boolValue?UIImageNamed(@"sx_like_img"): UIImageNamed(@"sx_like_noimg");
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)getlikeNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *comId = nameDictionary[@"commentId"];
    NSString *isLike = nameDictionary[@"is_like"];
    
    NSString *commentId = nil;
    if (self.likeComM.replyId.intValue) {
        commentId = self.likeComM.replyId;
    }else if (self.likeComM.commentId.intValue){
        commentId = self.likeComM.commentId;
    }
    if ([commentId isEqualToString:comId]) {
        self.likeComM.is_like = isLike;
        self.likeImageView.image = self.likeComM.is_like.boolValue?UIImageNamed(@"sx_like_img"): UIImageNamed(@"sx_like_noimg");
    }
}

- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId linkArr:(nonnull NSMutableArray *)linkArr{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:comment forKey:@"content"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (YYPersonItem *item in linkArr) {
        if (item.user_id && item.name) {
            NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
            [parm1 setObject:item.user_id forKey:@"id"];
            [parm1 setObject:item.name forKey:@"name"];
            [arr addObject:parm1];
        }
    }
    
    if (arr.count) {
        [parm setObject:[NoticeTools arrayToJSONString:arr] forKey:@"toSeries"];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoCommont/%@/%@",self.likeComM.videoModel.vid,commentId.intValue?commentId:@"0"] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [[NoticeTools getTopViewController] showToastWithText:@"发送成功"];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)replyClick{
    if (self.likeComM.sysStatus.intValue != 1) {
        [[NoticeTools getTopViewController] showToastWithText:@"该内容删除"];
        return;
    }
    self.inputView.plaStr = [NSString stringWithFormat:@"回复 %@",self.likeComM.fromUserInfo.nick_name];
    if (self.likeComM.replyId.intValue) {
        [self.inputView showJustComment:self.likeComM.replyId];
    }else if (self.likeComM.commentId.intValue){
        [self.inputView showJustComment:self.likeComM.commentId];
    }
}

- (SXVideoComInputView *)inputView{
    if (!_inputView) {
        _inputView = [[SXVideoComInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-44, DR_SCREEN_WIDTH, 50+44)];
        _inputView.delegate = self;
        _inputView.limitNum = 500;
        _inputView.plaStr = @"成为第一条评论…";
        _inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        _inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    return _inputView;
}

- (void)userInfoTap{
    if (self.likeComM.is_author.boolValue) {
        SXVideoUserCenterController *ctl = [[SXVideoUserCenterController alloc] init];
        ctl.userModel = self.likeComM.fromUserInfo;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        return;
    }

    
    if ([self.likeComM.fromUserInfo.userId isEqualToString:[NoticeTools getuserId]]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = self.likeComM.fromUserInfo.userId;
        ctl.isOther = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
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


@end
