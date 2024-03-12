//
//  NoticeEditCard2Cell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeEditCard2Cell.h"

@implementation NoticeEditCard2Cell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        self.noVoiceL = [[FSCustomButton alloc] initWithFrame:CGRectMake(20, 0, 104, 36)];
        [self.noVoiceL setTitle:@"添加声音" forState:UIControlStateNormal];
        self.noVoiceL.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.noVoiceL setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        self.noVoiceL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.noVoiceL setAllCorner:18];
        [self.noVoiceL addTarget:self action:@selector(recoderClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.noVoiceL];
        self.noVoiceL.hidden = YES;
        
        self.voicePlayView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 120, 36)];
        [self.voicePlayView setAllCorner:18];
        self.voicePlayView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        self.voicePlayView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.voicePlayView];
        self.voicePlayView.hidden = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [self.voicePlayView addGestureRecognizer:tap1];
        
        self.voiceLenL = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, self.voicePlayView.frame.size.width-32-10, 36)];
        self.voiceLenL.font = FOURTHTEENTEXTFONTSIZE;
        self.voiceLenL.textAlignment = NSTextAlignmentRight;
        self.voiceLenL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.voicePlayView addSubview:self.voiceLenL];
        
        
        UIImageView *voiceBoImg = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 28, 28)];
        voiceBoImg.image = UIImageNamed(@"stopimg_shop");
        [self.voicePlayView addSubview:voiceBoImg];
        self.playImageV = voiceBoImg;
        voiceBoImg.userInteractionEnabled = YES;
        
        self.isReplay = YES;
        
        UIButton *reBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.voicePlayView.frame)+8,0, 16+28, 36)];
        [reBtn setTitle:@"重录" forState:UIControlStateNormal];
        [reBtn setTitleColor:[UIColor colorWithHexString:@"#00ABE4"] forState:UIControlStateNormal];
        reBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        reBtn.backgroundColor = self.backgroundColor;
        [self.contentView addSubview:reBtn];
        self.rebutton = reBtn;
        reBtn.hidden = YES;
        [reBtn addTarget:self action:@selector(recoderClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setStopPlay:(BOOL)stopPlay{
    _stopPlay = stopPlay;
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;

    if(shopModel.myShopM.introduce_len.intValue){
        self.voicePlayView.hidden = NO;
        self.voiceLenL.text = [NSString stringWithFormat:@"%@s",shopModel.myShopM.introduce_len];
        self.noVoiceL.hidden = YES;
    }else{
        self.voicePlayView.hidden = YES;
        self.noVoiceL.hidden = NO;
    }
    self.rebutton.hidden = self.voicePlayView.hidden;
}

- (void)playNoReplay{
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:self.shopModel.myShopM.introduce_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
        self.playImageV.image = UIImageNamed(@"playimg_shop");
    }else{
        self.isPasue = !self.isPasue;
        [self.audioPlayer pause:self.isPasue];
        self.playImageV.image = self.isPasue?UIImageNamed(@"stopimg_shop") :UIImageNamed(@"playimg_shop");
    }
    
    __weak typeof(self) weakSelf = self;

    self.audioPlayer.playComplete = ^{
        weakSelf.voiceLenL.text = [NSString stringWithFormat:@"%@s",weakSelf.shopModel.myShopM.introduce_len];
        weakSelf.isReplay = YES;
        weakSelf.playImageV.image = UIImageNamed(@"stopimg_shop");
    };
    
    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] >weakSelf.shopModel.myShopM.introduce_len.integerValue) {
            currentTime = weakSelf.shopModel.myShopM.introduce_len.integerValue;
        }

        if ([[NSString stringWithFormat:@"%.f",weakSelf.shopModel.myShopM.introduce_len.integerValue-currentTime] isEqualToString:@"0"] ||  ((weakSelf.shopModel.myShopM.introduce_len.integerValue-currentTime)<1) || [[NSString stringWithFormat:@"%.f",weakSelf.shopModel.myShopM.introduce_len.integerValue-currentTime] isEqualToString:@"-0"]) {
            weakSelf.isReplay = YES;
            weakSelf.playImageV.image = UIImageNamed(@"stopimg_shop");
            if ((weakSelf.shopModel.myShopM.introduce_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
            }
        }
        weakSelf.voiceLenL.text = [[NSString stringWithFormat:@"%.fs",weakSelf.shopModel.myShopM.introduce_len.integerValue-currentTime] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    };
}

- (void)recoderClick{
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    NoticeRecoderView * recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.needCancel = YES;
    recodeView.delegate = self;
    recodeView.isDb = YES;
    recodeView.titleL.text = @"";
    [recodeView show];
}


//重新上传语音
- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    if (!locaPath) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,locaPath]],[locaPath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"85" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
    

    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:locaPath parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            //所有文件上传成功回调
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:Message forKey:@"introduce"];
            [parm setObject:timeLength forKey:@"introduce_len"];
            [[NoticeTools getTopViewController] showHUD];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
                [[NoticeTools getTopViewController] hideHUD];
                if (success1) {
                    if(self.refreshShopModel){
                        self.refreshShopModel(YES);
                    }
                }
            } fail:^(NSError * _Nullable error) {
                [[NoticeTools getTopViewController] hideHUD];
            }];
        }else{
            [[NoticeTools getTopViewController] showToastWithText:Message];
            [[NoticeTools getTopViewController] hideHUD];
        }
    }];
    
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
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
