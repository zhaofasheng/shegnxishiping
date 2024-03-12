//
//  NoticePlayerBokeView.m
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePlayerBokeView.h"
#import "NoticeMoreClickView.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeVoiceCommentView.h"
#import "NoticeChoiceIfAutoStopPlayView.h"
@implementation NoticePlayerBokeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

    
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10,DR_SCREEN_WIDTH,frame.size.height-87-30-35-24-15)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.titleL = [[UILabel alloc] init];
        self.titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.titleL.font = XGEightBoldFontSize;
        self.titleL.numberOfLines = 0;
        [self.scrollView addSubview:self.titleL];
        
        self.nameL = [[FSCustomButton alloc] init];
        [self.nameL setImage:UIImageNamed(@"bkuserinto_img") forState:UIControlStateNormal];
        self.nameL.buttonImagePosition = FSCustomButtonImagePositionRight;
        self.nameL.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.nameL setTitleColor:[[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [self.scrollView addSubview:self.nameL];
        [self.nameL addTarget:self action:@selector(userInfoTap) forControlEvents:UIControlEventTouchUpInside];
        
        self.introL = [[UILabel alloc] init];
        self.introL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        self.introL.font = FIFTHTEENTEXTFONTSIZE;
        self.introL.numberOfLines = 0;
        [self.scrollView addSubview:self.introL];
        
        self.userInteractionEnabled = YES;
        
    
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(20,frame.size.height-87-30, DR_SCREEN_WIDTH-40, 13)];
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _slider.maximumTrackTintColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.6];
        [_slider setThumbImage:UIImageNamed(@"Image_trak_sgj") forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(handleSlide:) forControlEvents:UIControlEventValueChanged];
    
        _minTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(_slider.frame)+9, GET_STRWIDTH(@"000:00", 10, 10), 10)];
        _minTimeLabel.text = @"00:00";
        _minTimeLabel.font = [UIFont systemFontOfSize:10];
        _minTimeLabel.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:_minTimeLabel];
        
        _maxTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-GET_STRWIDTH(@"00:000", 10, 10), CGRectGetMaxY(_slider.frame)+9, GET_STRWIDTH(@"00:000", 10, 10), 10)];
        _maxTimeLabel.text = @"00:00";
        _maxTimeLabel.font = [UIFont systemFontOfSize:10];
        _maxTimeLabel.textColor = [UIColor colorWithHexString:@"#E1E4F0"];
        [self addSubview:_maxTimeLabel];
                
        [self addSubview:_slider];
        
        CGFloat space1 = (DR_SCREEN_WIDTH-33*4-40)/6;
        
        //列表
        UIButton *buttonl = [[UIButton alloc] initWithFrame:CGRectMake(space1,CGRectGetMaxY(_slider.frame)+40, 33, 33)];
        [buttonl setImage:UIImageNamed(@"Image_boklb") forState:UIControlStateNormal];
        [buttonl addTarget:self action:@selector(listClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonl];
                
        //后退15秒
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttonl.frame)+space1,CGRectGetMaxY(_slider.frame)+40, 33, 33)];
        [button1 setImage:UIImageNamed(@"Image_back15sec") forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        
        //播放、暂停
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button1.frame)+space1,CGRectGetMaxY(_slider.frame)+40-3.5, 40, 40)];
        [button setImage:UIImageNamed(@"Image_bokepause") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionsClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.playBtn = button;
        
        //前进15秒
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+space1,CGRectGetMaxY(_slider.frame)+40, 33, 33)];
        [button2 setImage:UIImageNamed(@"Image_qianjin30sec") forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(preClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        
        self.rateButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button2.frame)+space1,CGRectGetMaxY(_slider.frame)+40+13/2, 33, 20)];
        [self.rateButton addTarget:self action:@selector(rateClick) forControlEvents:UIControlEventTouchUpInside];
        self.rateButton.layer.masksToBounds = YES;
        self.rateButton.layer.cornerRadius = 10;
        self.rateButton.layer.borderWidth = 1;
        self.rateButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.rateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rateButton.titleLabel.font = [UIFont systemFontOfSize:11];
        if ([NoticeTools voicePlayRate] == 1) {
            [self.rateButton setTitle:[NoticeTools chinese:@"倍速" english:@"1x" japan:@"速度"] forState:UIControlStateNormal];
        }else if ([NoticeTools voicePlayRate] == 2){
            [self.rateButton setTitle:@"1.25x" forState:UIControlStateNormal];
        }else if ([NoticeTools voicePlayRate] == 3){
            [self.rateButton setTitle:@"1.5x" forState:UIControlStateNormal];
        }else if ([NoticeTools voicePlayRate] == 4){
            [self.rateButton setTitle:@"2.0x" forState:UIControlStateNormal];
        }
        else{
            [self.rateButton setTitle:[NoticeTools chinese:@"倍速" english:@"1x" japan:@"速度"] forState:UIControlStateNormal];
        }
        [self addSubview:self.rateButton];
        
        [self bringSubviewToFront:_slider];
        
        //@"Image_boklb"
        NSArray *imgArr = @[@"Image_bokxh",@"Image_bokdm",@"shoucangbokeimg",@"setplayboktime_img"];
        CGFloat space = (DR_SCREEN_WIDTH-24*4)/5;
        for (int i = 0; i < 4; i++) {
            UIButton *funBtn = [[UIButton alloc] initWithFrame:CGRectMake(space+(24+space)*i, _slider.frame.origin.y-35-24, 24, 24)];
            funBtn.tag = i;
            [funBtn setBackgroundImage:UIImageNamed(imgArr[i]) forState:UIControlStateNormal];
            [self addSubview:funBtn];
            if (i == 0) {
                self.likeButton = funBtn;
                self.likeNumL = [[UILabel alloc] initWithFrame:CGRectMake(self.likeButton.frame.origin.x+14, self.likeButton.frame.origin.y-7, 70, 14)];
                self.likeNumL.font = [UIFont systemFontOfSize:10];
                self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
                [self addSubview:self.likeNumL];
            }
            if (i == 1) {
                self.comBtn = funBtn;
                self.comL = [[UILabel alloc] initWithFrame:CGRectMake(self.comBtn.frame.origin.x+14, self.comBtn.frame.origin.y-7, 70, 14)];
                self.comL.font = [UIFont systemFontOfSize:10];
                self.comL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
                [self addSubview:self.comL];
            }
            if(i == 2){
                self.scButton = funBtn;
            }
            if(i == 3){
                self.timeButton = funBtn;
                CGFloat wdith = GET_STRWIDTH(@"21:45:00", 10, 14)+10;
                self.stopTimeL = [[UILabel alloc] initWithFrame:CGRectMake(self.timeButton.frame.origin.x-(wdith-24)/2, self.timeButton.frame.origin.y+14, wdith, 14)];
                self.stopTimeL.textAlignment = NSTextAlignmentCenter;
                self.stopTimeL.font = [UIFont systemFontOfSize:10];
                self.stopTimeL.textColor = [UIColor whiteColor];
                [self addSubview:self.stopTimeL];
                self.stopTimeL.hidden = YES;
            }
            [funBtn addTarget:self action:@selector(funClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTime) name:@"REFRESHPLAYBOKETIME" object:nil];
        [self refreshTime];
    }
    return self;
}

- (void)refreshTime{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(appdel.floatView.stopBoKeTime > 0){
        self.stopTimeL.hidden = NO;
        self.stopTimeL.text = appdel.floatView.stopBoKeFormortTime;
        [self.timeButton setBackgroundImage:UIImageNamed(@"setplayboktime1_img") forState:UIControlStateNormal];
    }else{
        self.stopTimeL.hidden = YES;
        [self.timeButton setBackgroundImage:UIImageNamed(@"setplayboktime_img") forState:UIControlStateNormal];
    }
}

- (void)rateClick{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex > 0) {
            [NoticeTools voicePlayRate:[NSString stringWithFormat:@"%ld",buttonIndex]];
            if ([NoticeTools voicePlayRate] == 1) {
                [self.rateButton setTitle:[NoticeTools chinese:@"倍速" english:@"1x" japan:@"速度"] forState:UIControlStateNormal];
            }else if ([NoticeTools voicePlayRate] == 2){
                [self.rateButton setTitle:@"1.25x" forState:UIControlStateNormal];
            }else if ([NoticeTools voicePlayRate] == 3){
                [self.rateButton setTitle:@"1.5x" forState:UIControlStateNormal];
            }else if ([NoticeTools voicePlayRate] == 4){
                [self.rateButton setTitle:@"2.0x" forState:UIControlStateNormal];
            }
            else{
                [self.rateButton setTitle:[NoticeTools chinese:@"倍速" english:@"1x" japan:@"速度"] forState:UIControlStateNormal];
            }
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.audioPlayer setPlayRate];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHPLAYRATE" object:nil];
            
        }
    } otherButtonTitleArray:@[@"1.0x",@"1.25x",@"1.5x",@"2.0x"]];
    [sheet show];
}

- (void)userInfoTap{
    if (self.bokeModel.user_id) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        if (![self.bokeModel.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
            ctl.isOther = YES;
            ctl.userId = self.bokeModel.user_id;
        }
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}


- (void)setBokeModel:(NoticeDanMuModel *)bokeModel{
    _bokeModel = bokeModel;
    self.likeNumL.hidden = bokeModel.count_like.intValue?NO:YES;
    self.likeNumL.text = bokeModel.count_like;
    if (bokeModel.count_like.intValue) {
        [self.likeButton setBackgroundImage:UIImageNamed(!bokeModel.is_podcast_like.boolValue?@"Image_bokxhs":@"Image_bokxhss") forState:UIControlStateNormal];
        
        if (bokeModel.is_podcast_like.boolValue) {
            self.likeNumL.textColor = [UIColor colorWithHexString:@"#F47070"];
        }else{
            self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        }
    }else{
        [self.likeButton setBackgroundImage:UIImageNamed(@"Image_bokxh") forState:UIControlStateNormal];
    }
    
    NSString *url = nil;
    url = [NSString stringWithFormat:@"podcast/comment/%@?pageNo=1",self.bokeModel.bokeId];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.4.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {

            NoticeMJIDModel *allM = [NoticeMJIDModel mj_objectWithKeyValues:dict[@"data"]];
            if (allM.total.intValue) {
                [self.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdms") forState:UIControlStateNormal];
                self.comL.text = allM.total;
            }else{
                [self.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdm") forState:UIControlStateNormal];
                self.comL.text = @"";
            }
        }
    } fail:^(NSError * _Nullable error) {
    }];
    
    self.titleL.attributedText = bokeModel.allTitleAttStr1;
    self.titleL.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, bokeModel.titleHeight1);
    
    [self.nameL setTitle:bokeModel.nick_name forState:UIControlStateNormal];
    self.nameL.frame = CGRectMake(13, CGRectGetMaxY(self.titleL.frame)+4, 24+GET_STRWIDTH(bokeModel.nick_name, 14, 26)+2, 26);
    
    self.introL.attributedText = bokeModel.allTextAttStr;
    self.introL.frame = CGRectMake(15, CGRectGetMaxY(self.nameL.frame)+10, DR_SCREEN_WIDTH-30, bokeModel.textHeight);
    self.scrollView.contentSize = CGSizeMake(0,CGRectGetMaxY(self.introL.frame));
    
    [self.scButton setBackgroundImage:bokeModel.is_collect.intValue?UIImageNamed(@"shoucangbokeimg"):UIImageNamed(@"shoucangbokeimgno") forState:UIControlStateNormal];

}

- (void)listClick{
    if (self.clickListBlock) {
        self.clickListBlock(YES);
    }
}

- (void)funClick:(UIButton *)btn{
    if (btn.tag == 1) {
        NoticeVoiceCommentView *comView = [[NoticeVoiceCommentView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        comView.bokeModel = self.bokeModel;
        __weak typeof(self) weakSelf = self;
        comView.numBlock = ^(NSString * _Nonnull num) {
            if (num.intValue) {
                [weakSelf.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdms") forState:UIControlStateNormal];
                weakSelf.comL.text = num;
            }else{
                [weakSelf.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdm") forState:UIControlStateNormal];
                weakSelf.comL.text = @"";
            }
        };
        [comView show];
    }else if (btn.tag == 0){
        [[NoticeTools getTopViewController] showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@",self.bokeModel.podcast_no] Accept:@"application/vnd.shengxi.v5.4.3+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if (success) {
                self.bokeModel.is_podcast_like = self.bokeModel.is_podcast_like.boolValue?@"0":@"1";
                if (self.bokeModel.is_podcast_like.boolValue) {
                    self.bokeModel.count_like = [NSString stringWithFormat:@"%ld",self.bokeModel.count_like.integerValue+1];
              
                }else{
                    self.bokeModel.count_like = [NSString stringWithFormat:@"%ld",self.bokeModel.count_like.integerValue-1];
                }
                
                self.likeNumL.hidden = self.bokeModel.count_like.intValue?NO:YES;
                self.likeNumL.text = self.bokeModel.count_like;
                if (self.bokeModel.count_like.intValue) {
                    [self.likeButton setBackgroundImage:UIImageNamed(!self.bokeModel.is_podcast_like.boolValue?@"Image_bokxhs":@"Image_bokxhss") forState:UIControlStateNormal];
                    if (self.bokeModel.is_podcast_like.boolValue) {
                        self.likeNumL.textColor = [UIColor colorWithHexString:@"#F47070"];
                    }else{
                        self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
                    }
                }else{
                    [self.likeButton setBackgroundImage:UIImageNamed(@"Image_bokxh") forState:UIControlStateNormal];
                }
                
                if(self.likeBokeBlock){
                    self.likeBokeBlock(self.bokeModel);
                }
            }
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
        
    }else if (btn.tag == 2){//收藏播客和取消收藏播客
        [[NoticeTools getTopViewController] showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:self.bokeModel.is_collect.intValue?@"2":@"1" forKey:@"type"];
        [parm setObject:self.bokeModel.bokeId forKey:@"podcastId"];
        [[DRNetWorking shareInstance] requestWithPatchPath:@"podcastCollect" Accept:@"application/vnd.shengxi.v5.5.8+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if(success){
                self.bokeModel.is_collect = self.bokeModel.is_collect.intValue?@"0":@"1";
                [self.scButton setBackgroundImage:self.bokeModel.is_collect.intValue?UIImageNamed(@"shoucangbokeimg"):UIImageNamed(@"shoucangbokeimgno") forState:UIControlStateNormal];
            }
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
       
    }
    else if (btn.tag == 3){
        NoticeChoiceIfAutoStopPlayView *timeView = [[NoticeChoiceIfAutoStopPlayView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [timeView showTost];
    }
}
//滑动进度条
- (void)handleSlide:(UISlider *)slider{

    if (self.sliderBlock) {
        self.sliderBlock(slider);
    }
}

//后退
- (void)backClick{
    if (self.preBlock) {
        self.preBlock(self.slider);
    }
}

//前进
- (void)preClick{
    if (self.moveBlock) {
        self.moveBlock(self.slider);
    }
}

- (void)actionsClick{
    if (self.playBlock) {
        self.playBlock(YES);
    }
    
}

@end
