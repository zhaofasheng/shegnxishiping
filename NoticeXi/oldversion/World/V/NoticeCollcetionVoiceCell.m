//
//  NoticeCollcetionVoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2023/2/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeCollcetionVoiceCell.h"
#import "NoticeBingGanListView.h"
#import "NoticerTopicSearchResultNewController.h"
#import "UIView+Shadow.h"
@implementation NoticeCollcetionVoiceCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        [self.contentView addSubview:self.backView];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 8;
        self.backView.layer.masksToBounds = YES;


        self.infoView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        [self.backView addSubview:self.infoView];
        self.infoView.userInteractionEnabled = YES;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 20, 20)];
        self.iconImageView.layer.cornerRadius = 10;
        self.iconImageView.layer.masksToBounds = YES;
        [self.infoView addSubview:self.iconImageView];
        self.iconImageView.userInteractionEnabled = YES;
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, self.infoView.frame.size.width-34, 40)];
        self.nickNameL.font = THRETEENTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.infoView addSubview:self.nickNameL];

        UITapGestureRecognizer *userCenterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userCenter)];
        [self.infoView addGestureRecognizer:userCenterTap];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 16)];
        self.markL.font = [UIFont systemFontOfSize:10];
        self.markL.textColor = [UIColor whiteColor];
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.layer.cornerRadius = 2;
        self.markL.layer.masksToBounds = YES;
        [self.backView addSubview:self.markL];

        
        self.contentL = [[UILabel alloc] init];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.numberOfLines = 0;
        [self.backView addSubview:self.contentL];
        self.contentL.hidden = YES;
        
        self.voicePlayView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, self.backView.frame.size.width-50, 32)];
        [self.voicePlayView setAllCorner:16];
        self.voicePlayView.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        self.voicePlayView.userInteractionEnabled = YES;
        [self.backView addSubview:self.voicePlayView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [self.voicePlayView addGestureRecognizer:tap];
        
        self.voiceLenL = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, self.voicePlayView.frame.size.width-32-6, 32)];
        self.voiceLenL.font = TWOTEXTFONTSIZE;
        self.voiceLenL.textAlignment = NSTextAlignmentRight;
        self.voiceLenL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.voicePlayView addSubview:self.voiceLenL];
        
        
        UIImageView *voiceBoImg = [[UIImageView alloc] initWithFrame:CGRectMake(3, 4, 24, 24)];
        voiceBoImg.image = UIImageNamed(@"newbtnplay");
        [self.voicePlayView addSubview:voiceBoImg];
        self.playImageV = voiceBoImg;
        voiceBoImg.userInteractionEnabled = YES;

        self.contentView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT.minimumPressDuration = 0.3;
        [self.contentView addGestureRecognizer:longPressDeleT];
        
        //屏蔽别人心情
        self.pinbTools = [[NoticeVoicePinbi alloc] init];
        
        self.pinbTools.isNeedManagerHot = YES;
        self.pinbTools.delegate = self;
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height-36, self.backView.frame.size.width, 36)];
        [self.backView addSubview:self.buttonView];
        
        UIButton *likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.infoView.frame.size.width-56, 0, 56, 36)];
        [likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:likeBtn];
        
        self.dataButton = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 16, 16)];
        self.dataButton.userInteractionEnabled = NO;
        [likeBtn addSubview:self.dataButton];
    
        
        UIImageView *lyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-56-16, 10, 16, 16)];
        lyImageView.userInteractionEnabled = NO;
        lyImageView.image = UIImageNamed(@"voicelistpbcom_img");
        [self.buttonView addSubview:lyImageView];
        
        self.liuynumL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lyImageView.frame)+2, 0, 30, 36)];
        self.liuynumL.font = ELEVENTEXTFONTSIZE;
        self.liuynumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.buttonView addSubview:self.liuynumL];
        
        
        UIImageView *comImageView = [[UIImageView alloc] initWithFrame:CGRectMake(lyImageView.frame.origin.x-46, 10, 16, 16)];
        comImageView.userInteractionEnabled = NO;
        comImageView.image = UIImageNamed(@"voicelistpbliuy_img");
        [self.buttonView addSubview:comImageView];
        
        self.comNumL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(comImageView.frame)+2, 0, 30, 36)];
        self.comNumL.font = ELEVENTEXTFONTSIZE;
        self.comNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.buttonView addSubview:self.comNumL];
        
        self.topicL = [[UILabel alloc] init];
        self.topicL.font = FOURTHTEENTEXTFONTSIZE;
        self.topicL.textColor = [UIColor colorWithHexString:@"#456DA0"];
        self.topicL.numberOfLines = 0;
        [self.backView addSubview:self.topicL];
        self.topicL.hidden = YES;
        self.topicL.userInteractionEnabled = YES;
        UITapGestureRecognizer *topicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTap)];
        [self.topicL addGestureRecognizer:topicTap];
    }
    return self;
}

- (UIImageView *)voiceImageView1{
    if(!_voiceImageView1){
        _voiceImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, (self.backView.frame.size.width-20)/2, (self.backView.frame.size.width-20)/2)];
        _voiceImageView1.contentMode = UIViewContentModeScaleAspectFill;
        _voiceImageView1.clipsToBounds = YES;
        _voiceImageView1.userInteractionEnabled = YES;
        [self.backView addSubview:_voiceImageView1];
        _voiceImageView1.hidden = YES;
    }
    return _voiceImageView1;
}

- (UIImageView *)voiceImageView2{
    if(!_voiceImageView2){
        _voiceImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10+(self.backView.frame.size.width-20)/2, 40, (self.backView.frame.size.width-20)/2, (self.backView.frame.size.width-20)/2)];
        _voiceImageView2.contentMode = UIViewContentModeScaleAspectFill;
        _voiceImageView2.clipsToBounds = YES;
        _voiceImageView2.userInteractionEnabled = YES;
        [self.backView addSubview:_voiceImageView2];
        _voiceImageView2.hidden = YES;
    }
    return _voiceImageView2;
}


- (UIImageView *)voiceImageView3{
    if(!_voiceImageView3){
        _voiceImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40+(self.backView.frame.size.width-20)/2, (self.backView.frame.size.width-20)/2, (self.backView.frame.size.width-20)/2)];
        _voiceImageView3.contentMode = UIViewContentModeScaleAspectFill;
        _voiceImageView3.clipsToBounds = YES;
        _voiceImageView3.userInteractionEnabled = YES;
        [self.backView addSubview:_voiceImageView3];
        _voiceImageView3.hidden = YES;
    }
    return _voiceImageView3;
}


- (void)deleTapT:(UILongPressGestureRecognizer *)tap{

    if (tap.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hasClickMoreWith:)]) {//更多点击
            [self.delegate hasClickMoreWith:self.index];
        }
        
        if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
            [self.pinbTools pinbiWithModel:_voiceM];
        }
    }
}

//屏蔽成功回调
- (void)pinbiSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(otherPinbSuccess)]) {
        [self.delegate otherPinbSuccess];
    }
}

- (void)markSucess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreMarkSuccess)]) {
        [self.delegate moreMarkSuccess];
    }
}

//点击播放
- (void)playNoReplay{
    DRLog(@"点击播放区域");
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop:)]) {
        [self.delegate startPlayAndStop:self.index];
    }
}

- (void)setVoiceM:(NoticeVoiceListModel *)voiceM{
    _voiceM = voiceM;
 
    self.backView.frame =  CGRectMake(0, 0,self.frame.size.width, voiceM.height);
    self.buttonView.frame = CGRectMake(0, self.backView.frame.size.height-36, self.backView.frame.size.width, 36);
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:voiceM.subUserModel.avatar_url]
                          placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
                                   options:SDWebImageAvoidDecodeImage];
    self.nickNameL.text = voiceM.subUserModel.nick_name;
    
    SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
    _voiceImageView1.hidden = YES;
    _voiceImageView2.hidden = YES;
    _voiceImageView3.hidden = YES;
    if(voiceM.img_list.count){
        self.voiceImageView1.hidden = NO;
        if ([voiceM.img_list[0] containsString:@".gif"] || [voiceM.img_list[0] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
            
            [self.voiceImageView1 setImageWithURL:[NSURL URLWithString:voiceM.img_list[0]] placeholder:UIImageNamed(@"Image_pubumoren") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
           
            }];
        }else{
            [self.voiceImageView1 sd_setImageWithURL:[NSURL URLWithString:_voiceM.img_list[0]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
        }
        
        
        if(voiceM.img_list.count > 1){
            self.voiceImageView1.frame = CGRectMake(10, 40, (self.backView.frame.size.width-20)/2, (self.backView.frame.size.width-20)/2);
        }else{
            self.voiceImageView1.frame = CGRectMake(10, 40, _voiceM.imgPbheight, _voiceM.imgPbheight);
        }
        
        if(voiceM.img_list.count >= 2){
            self.voiceImageView2.hidden = NO;
        
            if ([voiceM.img_list[1] containsString:@".gif"] || [voiceM.img_list[1] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [self.voiceImageView2 setImageWithURL:[NSURL URLWithString:voiceM.img_list[1]] placeholder:UIImageNamed(@"Image_pubumoren") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [self.voiceImageView2 sd_setImageWithURL:[NSURL URLWithString:_voiceM.img_list[1]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
            }
        }
        
        if (voiceM.img_list.count == 3){
            self.voiceImageView3.hidden = NO;
            if ([voiceM.img_list[2] containsString:@".gif"] || [voiceM.img_list[2] containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
                [self.voiceImageView3 setImageWithURL:[NSURL URLWithString:voiceM.img_list[2]] placeholder:UIImageNamed(@"Image_pubumoren") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               
                }];
            }else{
                [self.voiceImageView3 sd_setImageWithURL:[NSURL URLWithString:_voiceM.img_list[2]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
            }
        }
    }
    
    self.dataButton.image = UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbgs": @"Ima_sendbgnws");

    //对话或者悄悄话数量
    if ([_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.chat_num.integerValue > 0) {
            self.liuynumL.text = _voiceM.chat_num;
        }else{
            self.liuynumL.text = @"";
        }
    }else{
        if (_voiceM.dialog_num.integerValue > 0) {
            self.liuynumL.text = _voiceM.dialog_num;
        }else{
            self.liuynumL.text = @"";
        }
    }
    self.comNumL.text = _voiceM.comment_count.intValue?_voiceM.comment_count:@"";
    
    self.markL.hidden = YES;
    if (voiceM.isTop) {
        self.markL.hidden = NO;
        self.markL.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        self.markL.text = [NoticeTools chinese:@"声昔pick" english:@"pick" japan:@"入選"];
        self.markL.frame = CGRectMake(0, 0, GET_STRWIDTH(self.markL.text, 10, 16)+8, 16);
    }
    
    self.contentL.hidden = YES;
    self.voicePlayView.hidden = YES;
    if (voiceM.content_type.intValue == 2) {
        self.contentL.hidden = NO;
        self.contentL.frame = CGRectMake(10, 40+(voiceM.img_list.count?(voiceM.imgPbheight+10):0), self.backView.frame.size.width-20, voiceM.textPbheight);
        self.contentL.text = voiceM.voice_content;
    }else{
        self.voicePlayView.frame = CGRectMake(10, 50+voiceM.imgPbheight, self.backView.frame.size.width-50, 32);
        self.voicePlayView.hidden = NO;
        self.voiceLenL.text = [NSString stringWithFormat:@"%@s",_voiceM.voice_len];
    }
    
    _topicL.hidden = YES;
    if(voiceM.topicName && voiceM.topicName.length){//存在话题
        _topicL.hidden = NO;
        _topicL.attributedText = voiceM.topicAttTextStr;
        _topicL.frame = CGRectMake(10, self.backView.frame.size.height-36-voiceM.textTopicheight-4, self.backView.frame.size.width-20, voiceM.textTopicheight);
    }
}

- (void)userCenter{
    NSString *userId = _voiceM.subUserModel.userId;

    NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
    ctl.userId = userId;
    ctl.isOther = [userId isEqualToString:[NoticeTools getuserId]] ? NO : YES;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)topTap{
    if (_voiceM.topic_name && _voiceM.topic_name.length) {
        NoticerTopicSearchResultNewController *ctl = [[NoticerTopicSearchResultNewController alloc] init];
        ctl.topicName = _voiceM.topic_name;
        ctl.topicId = _voiceM.topic_id;
        if (_voiceM.content_type.intValue == 2) {
            ctl.isTextVoice = YES;
        }
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)likeClick{

    if (![_voiceM.subUserModel.userId isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]){
        if (_voiceM.is_collected.boolValue) {//取消「有启发」
            _voiceM.likeNoMove = YES;
            _voiceM.canTapLike = YES;
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.is_collected = @"0";

                    self.voiceM.zaned_num = [NSString stringWithFormat:@"%d",self.voiceM.zaned_num.intValue-1];
                    if (self.voiceM.zaned_num.intValue < 0) {
                        self.voiceM.zaned_num = @"0";
                    }
                    self.dataButton.image = UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbgs": @"Ima_sendbgnws");
        
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelCollectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
                }
                self->_voiceM.canTapLike = NO;
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
            }];
        }else{
            _voiceM.canTapLike = YES;
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:@"5" forKey:@"needDelay"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/voices/%@/collection",_voiceM.user_id,_voiceM.voice_id] Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                if (success) {
                    self->_voiceM.canTapLike = NO;
                    self->_voiceM.is_collected = @"1";
                    self.voiceM.zaned_num = [NSString stringWithFormat:@"%d",self.voiceM.zaned_num.intValue+1];
                    [[NoticeTools getTopViewController] showToastWithText:[NoticeTools getLocalStrWith:@"em.senbgt"]];
                    self.dataButton.image = UIImageNamed(_voiceM.is_collected.intValue?@"Image_songbgs": @"Ima_sendbgnws");
    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"collectionNotification" object:self userInfo:@{@"voiceId":_voiceM.voice_id}];
                }
            } fail:^(NSError *error) {
                self->_voiceM.canTapLike = NO;
                [[NoticeTools getTopViewController] hideHUD];
            }];
        }
        return;
    }
    
    if (!self.voiceM.zaned_num.intValue) {
        [[NoticeTools getTopViewController] showToastWithText:[NoticeTools getLocalStrWith:@"py.noBg"]];
        return;
    }
    
    NoticeBingGanListView *listView = [[NoticeBingGanListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    listView.voiceM = self.voiceM;
    [listView showTost];
}

@end
