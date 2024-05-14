//
//  MyCommentCell.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/4/10.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "MyCommentCell.h"
#import "NoticeUserInfoCenterController.h"
#import "SXVideoUserCenterController.h"
#import "NoticeXi-Swift.h"
@interface MyCommentCell ()

@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation MyCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
       
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 10, 24, 24)];
        [_iconImageView setAllCorner:12];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+8,10, DR_SCREEN_WIDTH-56, 17)];
        _nickNameL.font = TWOTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:_nickNameL];
        
        self.contentL = [[GZLabel alloc] initWithFrame:CGRectMake(88, 30, DR_SCREEN_WIDTH-88-15, 0)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.GZLabelNormalColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentL setHightLightLabelColor:[UIColor colorWithHexString:@"#FF2A6F"] forGZLabelStyle:GZLabelStyleTopic];
        self.contentL.numberOfLines = 0;
        [self.contentView addSubview:self.contentL];
        self.contentL.delegate = self;
        self.contentL.userInteractionEnabled = YES;
//        UITapGestureRecognizer *replyTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyClick)];
//        [_contentL addGestureRecognizer:replyTap1];
        
        self.bottomView = [[UIView  alloc] initWithFrame:CGRectMake(88, CGRectGetMaxY(self.contentL.frame)+2, DR_SCREEN_WIDTH-88-15, 20)];
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
    self.nickNameL.frame = CGRectMake(88, 10, GET_STRWIDTH(self.nickNameL.text, 12, 17), 17);

    
    self.contentL.text = commentM.content;
    self.contentL.frame = CGRectMake(88, 30, DR_SCREEN_WIDTH-88-15, commentM.secondContentHeight);
    
    self.bottomView.frame = CGRectMake(88, CGRectGetMaxY(self.contentL.frame)+2, DR_SCREEN_WIDTH-88-15, 20);
    self.timeL.text = commentM.created_at;
    self.timeL.frame = CGRectMake(0, 0, GET_STRWIDTH(self.timeL.text, 12,20), 20);
    self.replyL.frame = CGRectMake(CGRectGetMaxX(_timeL.frame),0, 44, 20);
    
    [self refreshLikeUI:commentM];
    

    if ([commentM.fromUserInfo.userId isEqualToString:self.videoUser.userId]) {
        self.authorL.hidden = NO;
        self.authorL.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame), 11, 30, 15);
    }else{
        self.authorL.hidden = YES;
    }
    
    //如果一级评论的id和回复对象的评论id不一样，代表是二级评论下面的回复
    _replyToView.hidden = YES;
    if (![commentM.parent_id isEqualToString:commentM.post_id]) {
        self.replyToView.hidden = NO;
        if (!_authorL.hidden) {
            self.replyToView.frame = CGRectMake(CGRectGetMaxX(self.authorL.frame)+4, 10, DR_SCREEN_WIDTH-CGRectGetMaxX(self.authorL.frame)-4-15, 17);
        }else{
            self.replyToView.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+4, 10, DR_SCREEN_WIDTH-CGRectGetMaxX(self.nickNameL.frame)-4-15, 17);
        }
        self.replyNameL.text = commentM.toUserInfo.nick_name;
        self.replyNameL.frame = CGRectMake(28, 0, _replyToView.frame.size.width-28, 17);
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

- (UIView *)replyToView{
    if (!_replyToView) {
        _replyToView = [[UIView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+4, 10, DR_SCREEN_WIDTH-CGRectGetMaxX(self.nickNameL.frame)-4-15, 17)];
        [self.contentView addSubview:_replyToView];
        
        UILabel *replyMarkL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, GET_STRWIDTH(@"回复", 12, 17), 17)];
        replyMarkL.font = TWOTEXTFONTSIZE;
        replyMarkL.text = @"回复";
        replyMarkL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [_replyToView addSubview:replyMarkL];
        
        self.replyNameL = [[UILabel  alloc] initWithFrame:CGRectMake(28, 0, _replyToView.frame.size.width-28, 17)];
        self.replyNameL.font = TWOTEXTFONTSIZE;
        self.replyNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [_replyToView addSubview:self.replyNameL];
    }
    return _replyToView;
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

- (void)replyClick{
    if (self.replyClickBlock) {
        self.replyClickBlock(self.commentM);
    }
}


- (void)longDeleteVoice:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;

    //py.dele  删除  chat.jubao 举报
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
    
            NSArray *arr = nil;
            if ([NoticeTools isManager]) {//管理员长按操作
                arr = @[@"回复",@"复制",@"删除"];
            }else if ([[NoticeTools getuserId] isEqualToString:self.videoUser.userId]){//视频发布者长按操作
                
                if ([self.commentM.fromUserInfo.userId isEqualToString:[NoticeTools getuserId]]) {//视频发布者长按自己的评论
                    arr = @[@"回复",@"复制",@"删除"];
                }else{//视频发布者长按别人的评论
                    arr = @[@"回复",@"复制",@"举报",@"删除"];
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
        if (buttonIndex == 1){
            [self replyClick];
        }else if (buttonIndex == 2){
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            [pastboard setString:self.commentM.content];
            [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
        }else if (buttonIndex == 3){
            [self deleteComment];
        }
    }else if ([[NoticeTools getuserId] isEqualToString:self.videoUser.userId]){//视频发布者长按操作
        
        if ([self.commentM.fromUserInfo.userId isEqualToString:[NoticeTools getuserId]]) {//视频发布者长按自己的评论
            if (buttonIndex == 1){
                [self replyClick];
            }else if (buttonIndex == 2){
                UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
                [pastboard setString:self.commentM.content];
                [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
            }else if (buttonIndex == 3){
                [self deleteComment];
            }
        }else{//视频发布者长按别人的评论
            if (buttonIndex == 1){
                [self replyClick];
            }else if (buttonIndex == 2){
                UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
                [pastboard setString:self.commentM.content];
                [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
            }else if (buttonIndex == 3){
                [self jubaoComment];
            }
            else if (buttonIndex == 4){
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

-(void)GZLabel:(GZLabel *)label didSelectedString:(NSString *)selectedString forGZLabelStyle:(GZLabelStyle *)style onRange:(NSRange)range{
    DRLog(@"点击的链接是%@",selectedString);
    for (SXPayForVideoModel *model in self.commentM.seariesArr) {
        if ([model.name isEqualToString:selectedString]) {
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
