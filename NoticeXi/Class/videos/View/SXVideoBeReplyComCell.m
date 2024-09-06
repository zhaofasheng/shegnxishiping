//
//  SXVideoBeReplyComCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/18.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoBeReplyComCell.h"
#import "NoticeUserInfoCenterController.h"
#import "SXVideoUserCenterController.h"
#import "YYPersonItem.h"
#import "NoticdShopDetailForUserController.h"
@implementation SXVideoBeReplyComCell


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
        
        self.contentL = [[GZLabel alloc] initWithFrame:CGRectMake(56, 54, DR_SCREEN_WIDTH-56-68, 20)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.contentL];
        self.contentL.GZLabelNormalColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentL setHightLightLabelColor:[UIColor colorWithHexString:@"#FF2A6F"] forGZLabelStyle:GZLabelStyleTopic];
        self.contentL.numberOfLines = 0;
        self.contentL.userInteractionEnabled = NO;
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(56,82, 100, 16)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:_timeL];
        
        self.videoImageView = [[UIImageView  alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.videoImageView];
        self.videoImageView.userInteractionEnabled = YES;
        self.videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.videoImageView.clipsToBounds = YES;
        self.videoImageView.layer.cornerRadius = 4;
        self.videoImageView.layer.masksToBounds = YES;
        
        //回复按钮
        _replyL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeL.frame),self.timeL.frame.origin.y, 44, 20)];
        _replyL.font = TWOTEXTFONTSIZE;
        _replyL.text = @"回复";
        _replyL.userInteractionEnabled = YES;
        _replyL.textAlignment = NSTextAlignmentCenter;
        _replyL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:_replyL];
        UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyClick)];
        [_replyL addGestureRecognizer:replyTap];
        
        self.likeImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-78, self.timeL.frame.origin.y, 20, 20)];
        self.likeImageView.userInteractionEnabled = YES;
        self.likeImageView.image = UIImageNamed(@"sx_like_noimg");
        [self.contentView addSubview:self.likeImageView];
        UITapGestureRecognizer *likeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [self.likeImageView addGestureRecognizer:likeTap1];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getlikeNotice:) name:@"COMMENTLIKENotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getsaycomlikeNotice:) name:@"SHOPSAYCOMMENTLIKENotification" object:nil];
    }
    return self;
}

- (void)setLikeComM:(SXVideoCommentBeModel *)likeComM{
    _likeComM = likeComM;
    if (likeComM.dynamicModel.dongtaiId.intValue && [likeComM.dynamicModel.shopModel.user_id isEqualToString:likeComM.fromUserInfo.userId]) {//如果是动态并且是店主点赞
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:likeComM.dynamicModel.shopModel.shop_avatar_url]];
        self.nickNameL.text = likeComM.dynamicModel.shopModel.shop_name;
    }else{
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:likeComM.fromUserInfo.avatar_url]];
        self.nickNameL.text = likeComM.fromUserInfo.nick_name;
    }
    
    self.timeL.text = likeComM.created_at;
    
    if (likeComM.sysStatus.intValue == 1) {
        self.replyL.hidden = NO;
        self.likeImageView.hidden = NO;
        if (likeComM.replyContent) {
            self.contentL.frame = CGRectMake(56, 54, DR_SCREEN_WIDTH-56-78, likeComM.replytHeight);
            self.contentL.text = likeComM.replyContent;
        }else{
            self.contentL.frame = CGRectMake(56, 54, DR_SCREEN_WIDTH-56-78, likeComM.commentHeight);
            self.contentL.text = likeComM.commentContent;
        }
    }else{
        self.likeImageView.hidden = YES;
        self.replyL.hidden = YES;
        self.contentL.text = @"该内容已删除";
    }
    
    if (likeComM.replyContent) {
        self.markL.text = [NSString stringWithFormat:@"%@“%@”",likeComM.tips,likeComM.commentContent];
    }else{
        self.markL.text = likeComM.tips;
    }

    
    self.nickNameL.frame = CGRectMake(56, 12, GET_STRWIDTH(self.nickNameL.text, 16, 21), 21);
    _authorL.hidden = YES;
    if (likeComM.is_author.boolValue) {
        self.authorL.hidden = NO;
        self.authorL.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame), 15, 30, 15);
    }
    

    self.videoImageView.hidden = YES;
    _shopL.hidden = YES;
    if (likeComM.dynamicModel.dongtaiId.intValue && [likeComM.dynamicModel.shopModel.user_id isEqualToString:likeComM.fromUserInfo.userId]) {
        self.shopL.hidden = NO;
        self.shopL.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+2, 15, 30, 15);
    }
    
    _grayView.hidden = YES;
    _beRelyL.hidden = YES;
    if (likeComM.dynamicModel.dongtaiId.intValue) {
        if (likeComM.dynamicModel.img_list.count) {
            self.videoImageView.hidden = NO;
            self.videoImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 48);
            [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:likeComM.dynamicModel.img_list[0]]];
        }else{
            self.beRelyL.hidden = NO;
            self.beRelyL.text = likeComM.dynamicModel.content;
        }
        if (likeComM.sysStatus.intValue != 1) {
            self.grayView.hidden = NO;
        }
    }else{
        
        if (likeComM.videoModel.screen.intValue == 1) {
            self.videoImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 36);
        }else{
            self.videoImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 64);
        }
        [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:likeComM.videoModel.video_cover_url]];
    }
    
    
    self.likeImageView.image = likeComM.is_like.boolValue?UIImageNamed(@"sx_like_img"): UIImageNamed(@"sx_like_noimg");
    self.timeL.frame = CGRectMake(56, CGRectGetMaxY(self.contentL.frame)+8, GET_STRWIDTH(self.timeL.text, 12, 20), 20);
    self.replyL.frame = CGRectMake(CGRectGetMaxX(_timeL.frame),self.timeL.frame.origin.y, 44, 20);
    self.likeImageView.frame = CGRectMake(DR_SCREEN_WIDTH-20-78, self.timeL.frame.origin.y, 20, 20);
}


- (UILabel *)shopL{
    if (!_shopL) {
        _shopL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameL.frame), 11, 30, 15)];
        _shopL.backgroundColor = [[UIColor colorWithHexString:@"#F0F1F5"] colorWithAlphaComponent:1];
        [_shopL setAllCorner:15/2];
        _shopL.text = @"店主";
        _shopL.font = [UIFont systemFontOfSize:10];
        _shopL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        _shopL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_shopL];
    }
    return _shopL;
}

- (UILabel *)beRelyL{
    if (!_beRelyL) {
        _beRelyL = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 48)];
        _beRelyL.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        [_beRelyL setAllCorner:2];
        _beRelyL.font = [UIFont systemFontOfSize:11];
        _beRelyL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _beRelyL.numberOfLines = 0;
        _beRelyL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_beRelyL];
    }
    return _beRelyL;
}

- (UIView *)grayView{
    if (!_grayView) {
        _grayView = [[UIView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 48)];
        [_grayView setAllCorner:4];
        _grayView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [self.contentView addSubview:_grayView];
    }
    return _grayView;
}

- (void)likeClick{
    NSString *commentId = nil;
    if (self.likeComM.replyId.intValue) {
        commentId = self.likeComM.replyId;
    }else if (self.likeComM.commentId.intValue){
        commentId = self.likeComM.commentId;
    }
    NSString *url = nil;
    if (self.likeComM.dynamicModel.dongtaiId.intValue) {
        url = [NSString stringWithFormat:@"shopDynamicCommontZan/%@/%@",commentId,self.likeComM.is_like.boolValue?@"0":@"1"];
    }else{
        url = [NSString stringWithFormat:@"videoCommontZan/%@/%@",commentId,self.likeComM.is_like.boolValue?@"0":@"1"];
    }

    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.likeComM.dynamicModel.dongtaiId.intValue?@"application/vnd.shengxi.v5.8.7+json": @"application/vnd.shengxi.v5.8.1+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.likeComM.is_like = self.likeComM.is_like.boolValue?@"0":@"1";
            self.likeImageView.image = self.likeComM.is_like.boolValue?UIImageNamed(@"sx_like_img"): UIImageNamed(@"sx_like_noimg");
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

//视频评论回复点赞通知
- (void)getlikeNotice:(NSNotification*)notification{
    if (self.likeComM.dynamicModel.dongtaiId.intValue) {
        return;
    }
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

//动态评论回复点赞通知
- (void)getsaycomlikeNotice:(NSNotification*)notification{
    if (!self.likeComM.dynamicModel.dongtaiId.intValue) {
        return;
    }
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

//

- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId linkArr:(nonnull NSMutableArray *)linkArr{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:comment forKey:@"content"];
    
    
    if (self.likeComM.dynamicModel.dongtaiId.intValue) {
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopDynamicCommont/%@/%@",self.likeComM.dynamicModel.dongtaiId,commentId.intValue?commentId:@"0"] Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                
                [[NoticeTools getTopViewController] showToastWithText:@"发送成功"];
                
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
        return;
    }
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
    if (self.likeComM.dynamicModel.dongtaiId.intValue) {
        self.inputView.addStudyView.hidden = YES;
        self.inputView.noNeedkC = YES;
        if ([self.likeComM.dynamicModel.shopModel.user_id isEqualToString:self.likeComM.fromUserInfo.userId]) {
            self.inputView.plaStr = [NSString stringWithFormat:@"回复 %@",self.likeComM.dynamicModel.shopModel.shop_name];
        }else{
            self.inputView.plaStr = [NSString stringWithFormat:@"回复 %@",self.likeComM.fromUserInfo.nick_name];
        }
        
        if (self.likeComM.replyId.intValue) {
            [self.inputView showJustComment:self.likeComM.replyId];
        }else if (self.likeComM.commentId.intValue){
            [self.inputView showJustComment:self.likeComM.commentId];
        }
        return;
    }
    self.inputView.addStudyView.hidden = NO;
    self.inputView.noNeedkC = NO;
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
    
    if (self.likeComM.dynamicModel.dongtaiId.intValue && [self.likeComM.dynamicModel.shopModel.user_id isEqualToString:self.likeComM.fromUserInfo.userId]) {
        NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
        ctl.shopModel = self.likeComM.dynamicModel.shopModel;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        return;
    }
    
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
