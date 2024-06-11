//
//  SXOrderChatCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/11.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXOrderChatCell.h"

@implementation SXOrderChatCell
{
    UIButton *_rePlayView;//重播点击,点击重播，就重头开始播放
    UIButton *_tapBtn;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;

        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,14, 35, 35)];
        _iconImageView.layer.cornerRadius = 35/2;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        [self.contentView addSubview:_iconImageView];
        

        
        self.contentVL = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame), _iconImageView.frame.origin.y, 0, 0)];
        self.contentVL.backgroundColor = [NoticeTools getWhiteColor:@"#F7F7F7" NightColor:@"#212137"];
        [self.contentView addSubview:self.contentVL];
        self.contentVL.layer.cornerRadius = 5;
        self.contentVL.layer.masksToBounds = YES;
        self.contentVL.userInteractionEnabled = YES;
        self.contentVL.hidden = YES;
  
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contentVL.frame.size.width-20, self.contentVL.frame.size.height-20)];
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentL.numberOfLines = 0;
        self.contentL.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *textlongPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        textlongPressDeleT.minimumPressDuration = 0.5;
        [_contentL addGestureRecognizer:textlongPressDeleT];
        self.contentL.textColor = [UIColor whiteColor];
        self.contentL.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.contentVL addSubview:self.contentL];
        self.contentL.hidden = YES;
        
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,14,125, 35)];
        _playerView.delegate = self;
        _playerView.isThird = YES;
        [self.contentView addSubview:_playerView];
        
        _rePlayView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playerView.frame), _playerView.frame.origin.y,_playerView.frame.size.height, _playerView.frame.size.height)];
        [_rePlayView addTarget:self action:@selector(playReplay) forControlEvents:UIControlEventTouchUpInside];
        [_rePlayView setImage:UIImageNamed(@"Imag_reply_img") forState:UIControlStateNormal];
        
        _rePlayView.hidden = YES;
        [self.contentView addSubview:_rePlayView];
        
        _sendImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 14, 100, 150)];
        _sendImageView.contentMode = UIViewContentModeScaleAspectFill;
        _sendImageView.clipsToBounds = YES;
        _sendImageView.userInteractionEnabled = YES;
        _sendImageView.layer.cornerRadius = 5;
        _sendImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTag)];
        [_sendImageView addGestureRecognizer:tapImg];
        [self.contentView addSubview:_sendImageView];
        
        self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        self.redView.backgroundColor = [UIColor redColor];
        self.redView.layer.cornerRadius = 4;
        self.redView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.redView];
        self.redView.hidden = YES;
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 30)];
        self.timeL.backgroundColor = self.backgroundColor;
        self.timeL.textColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.font = THRETEENTEXTFONTSIZE;
        [self.contentView addSubview:self.timeL];
        self.timeL.hidden = YES;
        
        self.userInteractionEnabled = YES;
   
      
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.5;
        [self.playerView addGestureRecognizer:longPress];
        
        UILongPressGestureRecognizer *longPressDeleT = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleTapT:)];
        longPressDeleT.minimumPressDuration = 0.5;
        [_sendImageView addGestureRecognizer:longPressDeleT];
        
        
        _tapBtn = [[UIButton alloc] initWithFrame:CGRectMake(17, 99, 66, 20)];
        [_tapBtn addTarget:self action:@selector(contiuneLook) forControlEvents:UIControlEventTouchUpInside];
        
        self.failButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.failButton setImage:UIImageNamed(@"Image_failimg") forState:UIControlStateNormal];
        [self.contentView addSubview:self.failButton];
        [self.failButton addTarget:self action:@selector(failClick) forControlEvents:UIControlEventTouchUpInside];
        self.failButton.hidden = YES;
        
        self.markImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.markImage];
    }
    return self;
}

- (UIView *)sendLevelView{
    if (!_sendLevelView) {
        _sendLevelView = [[UIView alloc] initWithFrame:CGRectMake(self.contentL.frame.origin.x,CGRectGetMaxY(self.contentL.frame), self.contentVL.frame.size.width-self.contentL.frame.origin.x*2, 48)];
        _sendLevelView.layer.cornerRadius = 4;
        _sendLevelView.layer.masksToBounds = YES;
        _sendLevelView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.sendIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
        self.sendIconImageView.layer.cornerRadius = 2;
        self.sendIconImageView.layer.masksToBounds = YES;
        _sendLevelView.userInteractionEnabled = YES;
        [_sendLevelView addSubview:self.sendIconImageView];
        
        self.sendNameL = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, _sendLevelView.frame.size.width-55, 48)];
        self.sendNameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.sendNameL.font = FOURTHTEENTEXTFONTSIZE;
        [_sendLevelView addSubview:self.sendNameL];
        
        [self.contentVL addSubview:_sendLevelView];
        _sendLevelView.hidden = YES;
    }
    return _sendLevelView;
}



- (void)deleTapT:(UILongPressGestureRecognizer *)tap{
    if (self.chat.isSaveCace) {
        return;
    }
    if (tap.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(longTapCancelWithSection:tag:tapView:)]) {
            [self.delegate longTapCancelWithSection:self.section tag:self.index tapView:tap.view];
        }
    }
}

- (void)longPressGestureRecognized:(id)sender{
    
    if (_chat.contentText && _chat.contentText.length && (_chat.from_user_id.intValue == 1125 || _chat.from_user_id.intValue == 684699)) {
        return;
    }
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    if (!_chat.isPlaying) {//只有在播放或者暂停的时候才可以拖拽
        if (self.chat.isSaveCace) {
            return;
        }
        if (longPress.state == UIGestureRecognizerStateBegan) {//执行一次
            if (self.delegate && [self.delegate respondsToSelector:@selector(longTapCancelWithSection:tag:tapView:)]) {
                [self.delegate longTapCancelWithSection:self.section tag:self.index tapView:longPress.view];
            }
        }
        return;
    }
    
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag: section:)]) {
                [self.delegate beginDrag:self.tag section:self.section];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index: section:)]) {
                [self.delegate dragingFloat:(_chat.resource_len.floatValue/self.playerView.frame.size.width)*p.x index:self.tag section:self.section];
            }
            break;
        }
        default: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag: section:)]) {
                [self.delegate endDrag:self.tag section:self.section];
            }
            break;
        }
    }
}

//点击了播放按钮
- (void)startPlay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop: section:)]) {
        [self.delegate startPlayAndStop:self.index section:self.section];
    }
}

//点击重播
- (void)playReplay{
    if (_chat.is_self.intValue && _chat.isFailed) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(failReSend:row:chatM:)]) {
            [self.delegate failReSend:self.section row:self.index chatM:self.chat];
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRePlayAndStop: section:)]) {
        [self.delegate startRePlayAndStop:self.index section:self.section];
    }
}

- (void)contiuneLook{
    _chat.garbage_type = @"0";
    self.refreshHeightBlock(self.currentPath);
    [_tapBtn removeFromSuperview];
}

- (void)setChat:(NoticeChats *)chat{
    _chat = chat;
    
    self.redView.hidden = YES;
    self.failButton.hidden = YES;
    self.timeL.text = chat.showTime;
    self.timeL.hidden = !chat.isShowTime;
 
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.shop_avatar]]
    placeholderImage:[UIImage imageNamed:@"Image_jynohe"]
             options:SDWebImageAvoidDecodeImage];

    [self refreVoiceUI:chat];
    
    [self refreshImgUI:chat];
    

    //官方标识
    if ([_chat.from_user_id isEqualToString:@"1"] || _chat.from_user_id.intValue == 684699) {
        self.markImage.hidden = NO;
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
    }
    else{
        self.markImage.hidden = YES;
    }
    
    if (!_sendImageView.hidden) {
        self.redView.hidden = YES;
    }
    
    //声昔卫士
    [self refreshWeiShi:chat];
    
    if (!self.markImage.hidden) {
        self.markImage.frame = CGRectMake(22+_iconImageView.frame.origin.x, 22+_iconImageView.frame.origin.y,15, 15);
    }
    
}

//声昔小卫士
- (void)refreshWeiShi:(NoticeChats *)chat{
    //声昔小卫士显示文案
    _sendLevelView.hidden = YES;
    if (_chat.contentText && _chat.contentText.length) {
        self.contentVL.hidden = NO;
        self.contentL.hidden = NO;
        self.sendImageView.hidden = YES;
        _contentL.textColor = [UIColor whiteColor];
        _contentL.attributedText = _chat.attStr;
        
        if (_chat.resource_type.intValue == 1) {
            
            if (_chat.is_self.boolValue) {//自己的消息
                self.contentVL.backgroundColor = [UIColor colorWithHexString:@"#1DBDF2"];
                self.contentL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                self.contentVL.frame = CGRectMake(_iconImageView.frame.origin.x-10-_chat.textWidth-15, _iconImageView.frame.origin.y, _chat.textWidth+15, _chat.textHeight);
                self.contentL.frame = CGRectMake(_chat.contentText.length<4?7: 10,0, _chat.textWidth, _chat.textHeight);
            }else{//别人的消息
                self.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
                self.contentVL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
                _iconImageView.frame = CGRectMake(15,30, 35, 35);
                self.contentVL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, _iconImageView.frame.origin.y, _chat.textWidth+15, _chat.textHeight+58);
                self.contentL.frame = CGRectMake(_chat.contentText.length<4?7: 10,0, _chat.textWidth, _chat.textHeight);
            }
            self.sendLevelView.frame = CGRectMake(self.contentL.frame.origin.x,CGRectGetMaxY(self.contentL.frame), self.contentVL.frame.size.width-self.contentL.frame.origin.x*2, 48);
            [self.sendIconImageView sd_setImageWithURL:[NSURL URLWithString:_chat.sendUserM.avatar_url]];
            self.sendNameL.text = _chat.sendUserM.nick_name;
            self.sendLevelView.hidden = NO;
        }else{
            if (_chat.is_self.boolValue) {//自己的消息
                self.contentVL.backgroundColor = [UIColor colorWithHexString:@"#1DBDF2"];
                self.contentL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                self.contentVL.frame = CGRectMake(_iconImageView.frame.origin.x-10-_chat.textWidth-15, _iconImageView.frame.origin.y, _chat.textWidth+15, _chat.textHeight);
                self.contentL.frame = CGRectMake(_chat.contentText.length<4?7: 10,0, _chat.textWidth, self.contentVL.frame.size.height);
            }else{//别人的消息
                self.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
                self.contentVL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
                _iconImageView.frame = CGRectMake(15,30, 35, 35);
                self.contentVL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, _iconImageView.frame.origin.y, _chat.textWidth+15, _chat.textHeight);
                self.contentL.frame = CGRectMake(_chat.contentText.length<4?7: 10,0, _chat.textWidth, self.contentVL.frame.size.height);
            }
        }
    }else{
        _sendImageView.hidden = chat.resource_type.intValue==2?NO:YES;
 
        self.contentVL.hidden = YES;
        self.contentL.hidden = YES;
    }

}

//图片视图
- (void)refreshImgUI:(NoticeChats *)chat{
    _sendImageView.hidden = chat.resource_type.intValue == 2?NO:YES;
    if(chat.resource_type.intValue == 2){
         
        __weak typeof(self) weakSelf = self;
        if ([chat.resource_url containsString:@".gif"] || [chat.resource_url containsString:@".GIF"]) {//如果是动图，才有yy加载，否则用sd加载
            [_sendImageView setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.resource_url]] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                [weakSelf setImageViewFrame:image];
              
            }];
        }else{
            SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
            [_sendImageView sd_setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:chat.resource_url]] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
                [weakSelf setImageViewFrame:image];
            }];
        }
     }
}

//播放UI
- (void)refreVoiceUI:(NoticeChats *)chat{
    _playerView.hidden = chat.resource_type.intValue == 3?NO:YES;
    _rePlayView.hidden = YES;
    _playerView.voiceUrl = chat.resource_url;
    _playerView.timeLen = chat.resource_len;
    CGFloat orineY = chat.isShowTime ? CGRectGetMaxY(self.timeL.frame) : 14;
    if (!chat.is_self.integerValue) {
        
        _iconImageView.frame = CGRectMake(15, orineY, 35, 35);
        _sendImageView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, orineY, 100, 138);
        
        if (chat.resource_type.intValue == 3) {//语音
            if (chat.resource_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, orineY, 120, 40);
                [self.playerView refreWithFrame];
            }else if (chat.resource_len.integerValue >= 5 && chat.resource_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, orineY, 120+chat.resource_len.integerValue, 40);
                [self.playerView refreWithFrame];
            }else{
                self.playerView.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12,orineY, 120+chat.resource_len.integerValue, 40);
                [self.playerView refreWithFrame];
            }
            self.playerView.isSelf = NO;
            
            self.redView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame)+5, self.playerView.frame.origin.y+40/2, 8, 8);
            if (chat.resource_type.intValue == 3) {
            
                if (!chat.read_at.integerValue) {
                    self.redView.hidden = NO;
                }else{
                    self.redView.hidden = YES;
                }
            }else{
                self.redView.hidden = YES;
            }
            
            self.playerView.timeLen = chat.nowTime.integerValue?chat.nowTime: chat.resource_len;
            self.playerView.slieView.progress = chat.nowPro >0 ?chat.nowPro:0;
            

            [_rePlayView setImage:UIImageNamed(@"Imag_reply_img") forState:UIControlStateNormal];
            _rePlayView.frame = CGRectMake(CGRectGetMaxX(self.playerView.frame)+5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
            if (chat.resource_type.intValue == 3) {//重播按钮位置

                if (chat.isPlaying) {
                    _rePlayView.hidden = NO;
                }else{
                    _rePlayView.hidden = YES;
                }
    
            }else{
                _rePlayView.hidden = YES;
            }
        }
    }else{
        _iconImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35, orineY, 35, 35);
        _sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35-12-100, orineY, 100, 138);
        if (chat.resource_type.intValue == 3) {
          

            self.playerView.timeLen = chat.nowTime.integerValue?chat.nowTime: chat.resource_len;
            self.playerView.slieView.progress = chat.nowPro >0 ?chat.nowPro:0;
            
            self.redView.hidden = YES;
            
            _sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35-12-100, orineY, 100, 138);
            
            if (chat.resource_len.integerValue < 5) {
                self.playerView.frame = CGRectMake(DR_SCREEN_WIDTH-50-12-120, orineY, 120, 40);
                [self.playerView refreWithFrame];
            }else if (chat.resource_len.integerValue >= 5 && chat.resource_len.integerValue <= 105){
                self.playerView.frame = CGRectMake(DR_SCREEN_WIDTH-50-12-120-chat.resource_len.integerValue, orineY, 120+chat.resource_len.integerValue, 40);
                [self.playerView refreWithFrame];
            }else{
                self.playerView.frame = CGRectMake(DR_SCREEN_WIDTH-50-12-120-chat.resource_len.integerValue, orineY, 120+chat.resource_len.integerValue, 40);
                [self.playerView refreWithFrame];
            }

            self.playerView.isSelf = YES;
            [_rePlayView setImage:UIImageNamed(@"Imag_reply_imgRight") forState:UIControlStateNormal];
            _rePlayView.frame = CGRectMake(self.playerView.frame.origin.x-self.playerView.frame.size.height-5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
            if (chat.resource_type.intValue == 3) {//重播按钮位置
                
                if (chat.isPlaying) {
                    _rePlayView.hidden = NO;
                }else{
                    _rePlayView.hidden = YES;
                }
                
            }else{
                _rePlayView.hidden = YES;
            }
            if (chat.isFailed) {
                _rePlayView.hidden = NO;
                [_rePlayView setImage:UIImageNamed(@"Image_senFailed_b") forState:UIControlStateNormal];
            }
            
            
            if (chat.isSaveCace) {
                _rePlayView.hidden = YES;
                self.failButton.hidden = NO;
                self.failButton.frame = CGRectMake(self.playerView.frame.origin.x-self.playerView.frame.size.height-5, self.playerView.frame.origin.y, self.playerView.frame.size.height, self.playerView.frame.size.height);
            }
        }
    }
 
}

//根据图片尺寸设置图片比例
- (void)setImageViewFrame:(UIImage *)image{
    self.chat.isFinish = YES;
    CGFloat orineY = self.chat.isShowTime ? CGRectGetMaxY(self.timeL.frame) : 14;
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    CGFloat beishu = imageHeight/imageWidth;
    if (beishu < 0.86){
        if (self.chat.is_self.intValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-172,_iconImageView.frame.origin.y, 172, 172*beishu);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, _iconImageView.frame.origin.y,172,172*beishu);
        }
    }else if (beishu <= 1.15 && beishu > 0.95) {
        if (self.chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-120,_iconImageView.frame.origin.y, 120, 120*beishu);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, _iconImageView.frame.origin.y,120,120*beishu);
        }
    }else if (beishu >= 2.76) {
        if (self.chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-12-35-15-50,_iconImageView.frame.origin.y, 50,138);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, _iconImageView.frame.origin.y,50,138);
        }
    }
    else  if (beishu <= 1.38) {
        if (self.chat.is_self.integerValue) {
            self.sendImageView.frame = CGRectMake(DR_SCREEN_WIDTH-15-35-12-100,orineY, 100, 100*beishu);
        }else{
            self.sendImageView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+12, orineY,100,100*beishu);
        }
    }
    if (_chat.isSaveCace) {
        self.failButton.hidden = NO;
        self.failButton.frame = CGRectMake(self.sendImageView.frame.origin.x-35-5, self.sendImageView.frame.origin.y+(self.sendImageView.frame.size.height-35)/2, 35, 35);
    }
}

- (void)failClick{

}

//查看大图
- (void)bigTag{
    NSArray *array = [_chat.resource_url componentsSeparatedByString:@"?"];
    if (!array.count) {
        return;
    }
   

    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.sendImageView;
    item.largeImageURL     = [NSURL URLWithString:array[0]];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [photoView presentFromImageView:_sendImageView toContainer:toView animated:YES completion:nil];
}

//点击头像
- (void)userInfoTap{

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
