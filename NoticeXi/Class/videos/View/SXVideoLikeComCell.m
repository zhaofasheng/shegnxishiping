//
//  SXVideoLikeComCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/18.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoLikeComCell.h"
#import "NoticeUserInfoCenterController.h"
#import "SXVideoUserCenterController.h"
#import "NoticdShopDetailForUserController.h"
@implementation SXVideoLikeComCell

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
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+8,33, DR_SCREEN_WIDTH-56-68, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:_markL];
        
        self.contentL = [[GZLabel alloc] initWithFrame:CGRectMake(56, 54, DR_SCREEN_WIDTH-56-68, 20)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.GZLabelNormalColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentL setHightLightLabelColor:[UIColor colorWithHexString:@"#FF2A6F"] forGZLabelStyle:GZLabelStyleTopic];
        [self.contentView addSubview:self.contentL];
        
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

    if ([likeComM.tips containsString:@"你的动态"]) {
        self.contentL.hidden = YES;
    }else{
        self.contentL.hidden = NO;
    }
    
    self.markL.text = likeComM.tips;
    self.timeL.text = likeComM.created_at;
    if (likeComM.sysStatus.intValue == 1) {
        if (likeComM.replyContent) {
            self.contentL.text = likeComM.replyContent;
        }else{
            self.contentL.text = likeComM.commentContent;
        }
    }else{
        self.contentL.text = @"该内容已删除";
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
        self.videoImageView.hidden = NO;
        if (likeComM.videoModel.screen.intValue == 1) {
            self.videoImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 36);
        }else{
            self.videoImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 64);
        }
        [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:likeComM.videoModel.video_cover_url]];
    }
    
    self.contentL.lineBreakMode = NSLineBreakByTruncatingTail;
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

- (UIView *)grayView{
    if (!_grayView) {
        _grayView = [[UIView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-48, 15, 48, 48)];
        [_grayView setAllCorner:4];
        _grayView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [self.contentView addSubview:_grayView];
    }
    return _grayView;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
