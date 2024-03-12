//
//  NoticeDanMuController.m
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDanMuController.h"
#import "FDanmakuView.h"
#import "FDanmakuModel.h"
#import "NoticeDanMuHeaderView.h"
#import "NoticeDanMuInputView.h"
#import "NoticeDanMuListModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NoticeBoKeListView.h"
#import "NoticeBBSComentInputView.h"
#import "NoticeJuBaoBoKeTosatView.h"

#import "NoticeChangeBokeController.h"
#import "NoticeDownLoadBokeModel.h"
#import "NoticeMoreClickView.h"
@interface NoticeDanMuController ()<FDanmakuViewProtocol,NoticeDanMuDelegate,LCActionSheetDelegate,NoticeBBSComentInputDelegate>

@property(nonatomic,strong)FDanmakuView *danmakuView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) NoticeDanMuHeaderView *danmuHeaderView;
@property (nonatomic, strong) NoticeDanMuInputView *inputView;
@property (nonatomic, strong) NSArray *begTimeArr;
@property (nonatomic, strong) NSArray *liveTimeArr;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) BOOL isNoSetBackButton;//没有设置
@property (nonatomic, assign) BOOL isNextOrPre;
@property (nonatomic, assign) BOOL canReplay;//可以自动播放
@property (nonatomic, assign) BOOL firstGetIn;
@property (nonatomic, strong) NSMutableArray *danmArr;
@property (nonatomic, strong) NoticeBBSComentInputView *inputV;
@property (nonatomic, strong) NSMutableArray *shareArr;
@property (nonatomic, assign) CGFloat currentSendTime;
@property (nonatomic, assign) CGFloat sendTime;
@property (nonatomic, assign) NSInteger getTime;
@property (nonatomic, strong) NSMutableDictionary *showParm;
@property (nonatomic, strong) NoticeBoKeListView *listView;
@property (nonatomic, strong) UIImageView *bkFmimageView;
@property (nonatomic, strong) UIView *sendView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) NoticeDownLoadBokeModel *downBoKeTools;

@end

@implementation NoticeDanMuController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noNeedStop = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appdel.noNeedStop = NO;
    self.canReplay = NO;
}


- (void)stopPlayBoke{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.noRePlay = YES;
    [appdel.floatView.audioPlayer stopPlaying];
    self.isReplay = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.needHide = NO;
        appdel.floatView.hidden = NO;
    }
}

- (NoticeBoKeListView *)listView{
    if (!_listView) {
        _listView = [[NoticeBoKeListView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _listView.isSClist = self.isSClist;
        _listView.choiceBoKeBlock = ^(NoticeDanMuModel * _Nonnull choiceModel) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdel.floatView.noRePlay = YES;
            [appdel.floatView.audioPlayer stopPlaying];
            weakSelf.bokeModel = choiceModel;
            weakSelf.listView.choiceModel = choiceModel;
            [weakSelf refreshBokeUI];
            [weakSelf playClick];
        };
    }
    return _listView;
}

- (void)refreshBokeUI{
  
    SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
    [self.bkFmimageView  sd_setImageWithURL:[NSURL URLWithString:self.bokeModel.cover_url] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       
    }];
    

    [self.backImageView  sd_setImageWithURL:[NSURL URLWithString:self.bokeModel.background_url] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       
    }];
    
    self.danmuHeaderView.bokeModel = self.bokeModel;
    self.danmuHeaderView.listView.bokeM = self.bokeModel;
    
    self.danmuHeaderView.playeBoKeView.slider.value = 0;
    self.danmuHeaderView.playeBoKeView.slider.maximumValue = self.bokeModel.total_time.integerValue;
    self.danmuHeaderView.playeBoKeView.slider.minimumValue = 0;
    self.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [self getMMSSFromSS:self.bokeModel.total_time.integerValue];
    self.isReplay = YES;
    
    [self.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokepause") forState:UIControlStateNormal];
    self.danmuHeaderView.playeBoKeView.minTimeLabel.text = @"00:00";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listView.choiceModel = self.bokeModel;
    
    self.bkFmimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.bkFmimageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bkFmimageView.clipsToBounds = YES;
    self.bkFmimageView.userInteractionEnabled = YES;
    [self.view addSubview:self.bkFmimageView];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = self.bkFmimageView.bounds;
    [self.bkFmimageView addSubview:visualView];
    
    self.firstGetIn = YES;
    self.getTime = 0;
    self.danmArr = [NSMutableArray new];
    self.showParm = [NSMutableDictionary new];
    [self requestDanMuWithTime:self.getTime];
    
    self.begTimeArr = @[@"3.2",@"2.6",@"3",@"2.8",@"3.7",@"3.4",@"3.1"];
    self.liveTimeArr = @[@"5",@"6",@"7",@"6.5",@"7.5",@"5.5",@"6.3"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-100, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    self.titleL.font = EIGHTEENTEXTFONTSIZE;
    self.titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.titleL];
    self.titleL.textAlignment = NSTextAlignmentCenter;

    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-10-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [moreBtn setImage:UIImageNamed(@"jubaoordelebk_Image") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,NAVIGATION_BAR_HEIGHT+10, DR_SCREEN_WIDTH-40, (((DR_SCREEN_WIDTH-40)*223)/335))];
    [self.view addSubview:self.backImageView];
    self.backImageView.layer.cornerRadius = 5;
    self.backImageView.layer.masksToBounds = YES;
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    self.backImageView.userInteractionEnabled = YES;
    
    FDanmakuView *danmaView = [[FDanmakuView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, ((DR_SCREEN_WIDTH-40)*223)/335-50)];
    danmaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    danmaView.delegate = self;
    self.danmakuView = danmaView;
    [self.view addSubview:danmaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
    [self.backImageView addGestureRecognizer:tap];
    
    self.danmuHeaderView = [[NoticeDanMuHeaderView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT+(DR_SCREEN_WIDTH*250)/375, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-((DR_SCREEN_WIDTH*250)/375))];
    [self.view addSubview:self.danmuHeaderView];


    __weak typeof(self) weakSelf = self;
    self.danmuHeaderView.hideKeyBordBlock = ^(BOOL isHide) {
        [weakSelf.inputView.contentView resignFirstResponder];
    };
    
    self.danmuHeaderView.playeBoKeView.playBlock = ^(BOOL clickPlay) {
        [weakSelf playClick];
      //
    };
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.danmuHeaderView.playeBoKeView.preBlock = ^(UISlider * _Nonnull slider) {
        if (weakSelf.isReplay) {//如果还没播放执行播放
            [weakSelf playClick];
            return ;
        }else{
            //如果在播放，执行暂停
            weakSelf.isPasue = YES;
            [appdel.floatView.audioPlayer pause:weakSelf.isPasue];
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(weakSelf.isPasue?@"Image_bokepause": @"Image_bokeplaying") forState:UIControlStateNormal];
        }
        [appdel.floatView.audioPlayer.player seekToTime:CMTimeMake((slider.value-15)>0?(slider.value-15):0, 1) completionHandler:^(BOOL finished) {
         
            if (finished) {
                weakSelf.isPasue = NO;
                [appdel.floatView.audioPlayer pause:weakSelf.isPasue];
                [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokeplaying") forState:UIControlStateNormal];
            }
        }];
    };

    self.danmuHeaderView.playeBoKeView.moveBlock = ^(UISlider * _Nonnull slider) {
        if (weakSelf.isReplay) {//如果还没播放执行播放
            [weakSelf playClick];
            return ;
        }else{
            //如果在播放，执行暂停
            weakSelf.isPasue = YES;
            [appdel.floatView.audioPlayer pause:weakSelf.isPasue];
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(weakSelf.isPasue?@"Image_bokepause": @"Image_bokeplaying") forState:UIControlStateNormal];
        }
        [appdel.floatView.audioPlayer.player seekToTime:CMTimeMake((slider.value+30)>slider.maximumValue?slider.maximumValue:(slider.value+30), 1) completionHandler:^(BOOL finished) {
         
            if (finished) {
                weakSelf.isPasue = NO;
                [appdel.floatView.audioPlayer pause:weakSelf.isPasue];
                [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokeplaying") forState:UIControlStateNormal];
            }
        }];
    };

    self.danmuHeaderView.playeBoKeView.sliderBlock = ^(UISlider * _Nonnull slider) {
        if (weakSelf.isReplay) {//如果还没播放执行播放
            [weakSelf playClick];
            return ;
        }else{
            //如果在播放，执行暂停
            weakSelf.isPasue = YES;
            [appdel.floatView.audioPlayer pause:weakSelf.isPasue];
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(weakSelf.isPasue?@"Image_bokepause": @"Image_bokeplaying") forState:UIControlStateNormal];
        }
        [appdel.floatView.audioPlayer.player seekToTime:CMTimeMake(slider.value, 1) completionHandler:^(BOOL finished) {
         
            if (finished) {
                weakSelf.isPasue = NO;
                [appdel.floatView.audioPlayer pause:weakSelf.isPasue];
                [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokeplaying") forState:UIControlStateNormal];
            }
        }];
    };
    
    self.danmuHeaderView.playeBoKeView.clickListBlock = ^(BOOL list) {
        [weakSelf.listView show];
    };
    
    self.danmuHeaderView.playeBoKeView.likeBokeBlock = ^(NoticeDanMuModel * _Nonnull boKeModel) {
        if(weakSelf.likeBokeBlock){
            weakSelf.likeBokeBlock(boKeModel);
        }
        
        for (int i = 0; i < weakSelf.listView.dataArr.count; i++) {
            NoticeDanMuModel *model = weakSelf.listView.dataArr[i];
            if ([model.podcast_no isEqualToString:weakSelf.bokeModel.podcast_no]) {
                model.count_like = weakSelf.bokeModel.count_like;
                [weakSelf.listView.tableView reloadData];
                break;
            }
        }
    };
    
    self.inputView = [[NoticeDanMuInputView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH,50)];
    self.inputView.delegate = self;
    [self.view addSubview:self.inputView];
    self.inputView.hidden = YES;

    [self refreshBokeUI];
    
    UIView *btnBackV = [[UIView alloc] initWithFrame:CGRectMake(self.backImageView.frame.size.width-40-76, self.backImageView.frame.size.height-8-32, 86, 32)];
    btnBackV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    btnBackV.layer.cornerRadius = 10;
    btnBackV.layer.masksToBounds = YES;
    [self.backImageView addSubview:btnBackV];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [sendBtn setTitle:@"点我发弹幕" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = TWOTEXTFONTSIZE;
    [btnBackV addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(faClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.isOpen = YES;
    self.openBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backImageView.frame.size.width-40,self.backImageView.frame.size.height-8-32, 32, 32)];
    [self.openBtn setBackgroundImage:UIImageNamed(self.isOpen? @"Image_openDanmu":@"Image_openDanmun") forState:UIControlStateNormal];
    [self.backImageView addSubview:self.openBtn];
    [self.openBtn addTarget:self action:@selector(openClick) forControlEvents:UIControlEventTouchUpInside];
    self.sendView = btnBackV;
    
    [self refresh];

    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayBoke) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
}

//发弹幕输入框
- (void)faClick{
    self.inputView.hidden = NO;
    [self.inputView.contentView becomeFirstResponder];
}

//是否开启弹幕
- (void)openClick{
    self.isOpen = !self.isOpen;
    [self.openBtn setBackgroundImage:UIImageNamed(self.isOpen? @"Image_openDanmu":@"Image_openDanmun") forState:UIControlStateNormal];
    self.danmakuView.hidden = !self.isOpen;
    self.sendView.hidden = self.danmakuView.hidden;
    if (!self.isOpen) {
        [self.inputView.contentView resignFirstResponder];
        self.inputView.hidden = YES;
    }
}

- (void)moreClick{
    
    NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    
    NSArray *titleArr = [self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]?@[[NoticeTools chinese:@"修改播客" english:@"Edit" japan:@"変更"],[NoticeTools getLocalStrWith:@"py.dele"]]:@[[NoticeTools getLocalStrWith:@"chat.jubao"],@"下载本地"];
    NSArray *imgArr = [self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]?@[@"xiugaiboke_img",@"shanchuboke_img"]:@[@"jubaoboke_img",[self.bokeModel.user_id isEqualToString:@"785776"]?@"xiazaiboketobendi_img":@"xiazaiboketobendi_imgno"];
    if([NoticeTools isManager]){
        titleArr = @[@"下架",self.bokeModel.is_hot.intValue?@"取消热门": @"设为热门"];
        imgArr = @[@"xiajiaboke_img",self.bokeModel.is_hot.intValue?@"quxiaoremen_img": @"setremen_img"];
    }
    
    moreView.buttonImgArr = imgArr;
    moreView.buttonNameArr = titleArr;
    moreView.isShare = YES;
    moreView.isShareBoKeAndMore = YES;
    moreView.voiceUrl = self.bokeModel.audio_url;
    moreView.name = self.bokeModel.nick_name?self.bokeModel.nick_name:@"声昔播客";
    moreView.title = self.bokeModel.podcast_title;
    moreView.bokeId = self.bokeModel.bokeId;
    __weak typeof(self) weakSelf = self;
    moreView.clickIndexBlock = ^(NSInteger buttonIndex) {
        [weakSelf funClick:buttonIndex+1];
    };
    [moreView showTost];
    
}

- (void)funClick:(NSInteger)buttonIndex{
    __weak typeof(self) weakSelf = self;
    if (buttonIndex == 1) {
        
        if ([NoticeTools isManager]) {
            if (!self.inputV) {
                NoticeBBSComentInputView *inputView = [[NoticeBBSComentInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
                inputView.delegate = self;
                inputView.isRead = YES;
                inputView.ismanager = YES;
                inputView.limitNum = 100;
                inputView.needClear = YES;
                inputView.plaStr = @"输入下架理由";
                [inputView.sendButton setTitle:@"下架" forState:UIControlStateNormal];
                inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
                inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
                inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
                [inputView showJustComment:nil];
                self.inputV = inputView;
            }
            [self.inputV showJustComment:nil];
            [self.inputV.contentView becomeFirstResponder];
            [self.inputV.backView removeFromSuperview];
            UIWindow *rootWindow = [SXTools getKeyWindow];
            [rootWindow addSubview:self.inputV.backView];
            self.inputV.backView.hidden = NO;
            return;
        }
        
        if ([self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]) {
            [self changeIntro];
        }else{
            NoticeJuBaoBoKeTosatView *jubaoV = [[NoticeJuBaoBoKeTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            [jubaoV showView];
            jubaoV.jubaoBlock = ^(NSString * _Nonnull content) {
                NSMutableDictionary *parm = [NSMutableDictionary new];
                [parm setObject:@"143" forKey:@"resourceType"];
                [parm setObject:self.bokeModel.bokeId forKey:@"resourceId"];
                [parm setObject:content forKey:@"reason"];
                [weakSelf showHUD];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"reports" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [weakSelf hideHUD];
                    if (success) {
                        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"举报成功" message:@"声昔君正火速赶来，你的举报\n将保护更多的小伙伴免受伤害" cancleBtn:@"知道了"];
                        [alerView showXLAlertView];
                    }
                } fail:^(NSError * _Nullable error) {
                    [weakSelf hideHUD];
                }];
            };
        }
    }else if (buttonIndex == 2){
        if ([NoticeTools isManager]) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"849527" forKey:@"confirmPasswd"];
            [parm setObject:self.bokeModel.is_hot.intValue?@"0": @"1" forKey:@"isHot"];
            [self showHUD];
            
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/podcast/hot/%@",self.bokeModel.podcast_no] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    [self showToastWithText:self.bokeModel.is_hot.intValue?@"已取消热门": @"已设置为热门"];
                    self.bokeModel.is_hot = self.bokeModel.is_hot.intValue?@"0":@"5678";
                }
                [self hideHUD];
            } fail:^(NSError * _Nullable error) {
                [self hideHUD];
            }];
            return;
        }
        if ([self.bokeModel.user_id isEqualToString:[NoticeTools getuserId]]){
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"确定删除此播客吗？" english:@"Delete this podcast?" japan:@"このポッドキャストを削除しますか?"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"py.dele"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 1) {
                    [[NoticeTools getTopViewController] showHUD];
                    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"podcast/%@",weakSelf.bokeModel.podcast_no] Accept:@"application/vnd.shengxi.v5.4.4+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                        [[NoticeTools getTopViewController] hideHUD];
                        if (success) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleteBoKeNotification" object:self userInfo:@{@"danmuNumber":self.bokeModel.podcast_no}];
                            [weakSelf backClick];
                        }
                    } fail:^(NSError * _Nullable error) {
                        [[NoticeTools getTopViewController] hideHUD];
                    }];
                }
            };
            [alerView showXLAlertView];
        }else{//下载到手机文件夹
            
            if([self.bokeModel.user_id isEqualToString:@"785776"]){
                [self.downBoKeTools downBoKeToPhone:YES boke:self.bokeModel];
            }else{
                [self showToastWithText:@"下载到手机文件仅限于声昔官方播客哦~"];
            }
        
        }
    }
}


- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"849527" forKey:@"confirmPasswd"];
    [parm setObject:comment forKey:@"remarks"];
    [self showHUD];
    
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/podcast/%@",self.bokeModel.podcast_no] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
    [self.inputV clearView];
}

- (NoticeDownLoadBokeModel *)downBoKeTools{
    if(!_downBoKeTools){
        _downBoKeTools = [[NoticeDownLoadBokeModel alloc] init];
    }
    return _downBoKeTools;
}

- (void)changeIntro{
    NoticeChangeBokeController *ctl = [[NoticeChangeBokeController alloc] init];
    ctl.bokeId = self.bokeModel.podcast_no;
    ctl.induce = self.bokeModel.podcast_intro;
    ctl.coverUrl = self.bokeModel.cover_url;
    __weak typeof(self) weakSelf = self;
    ctl.changeBokeIntroBlock = ^(NSString * _Nonnull intro, NSString * _Nonnull bokeId, NSString * _Nonnull coverUrl) {
        
        if(intro && intro.length){
            weakSelf.bokeModel.podcast_intro = intro;
        }
        if(coverUrl && coverUrl.length > 6){
            weakSelf.bokeModel.cover_url = coverUrl;
            weakSelf.bokeModel.background_url = coverUrl;
        }
        if(weakSelf.reloadBlock){
            weakSelf.reloadBlock(YES);
        }
        if(weakSelf.changeBokeIntroBlock){
            weakSelf.changeBokeIntroBlock(intro, bokeId, coverUrl);
        }
        [weakSelf refreshBokeUI];
    };

    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)clickStopOrPlayAssest:(BOOL)pause playing:(BOOL)playing{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if([self.bokeModel.podcast_no isEqualToString:appdel.floatView.currentbokeModel.podcast_no]){
        self.isPasue = pause;
    }
}

- (void)refresh{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __weak typeof(self) weakSelf = self;
    appdel.floatView.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf hideHUD];
            [weakSelf showToastWithText:@"播放失败"];
        }else{
            DRLog(@"播放%@",weakSelf.bokeModel.podcast_title);
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokeplaying") forState:UIControlStateNormal];
            [weakSelf hideHUD];
        }
    };
    
    appdel.floatView.playNext = ^{//播放下一个播客
        AppDelegate *appdel1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
        weakSelf.bokeModel = appdel1.floatView.currentbokeModel;
        weakSelf.listView.choiceModel = weakSelf.bokeModel;
        [weakSelf refreshBokeUI];
    };
 
    appdel.floatView.playComplete = ^{
        [weakSelf refreshBokeUI];
    };
    
    appdel.floatView.playingBlock = ^(CGFloat currentTime) {
        if(!(appdel.floatView.bokeArr.count && [appdel.floatView.currentbokeModel.podcast_no isEqualToString:weakSelf.bokeModel.podcast_no])){
            return;
        }
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > weakSelf.bokeModel.total_time.integerValue) {
            currentTime = weakSelf.bokeModel.total_time.integerValue;
        }
        
        weakSelf.currentSendTime = currentTime;
        if (weakSelf.currentSendTime > weakSelf.bokeModel.total_time.intValue) {
            weakSelf.currentSendTime = weakSelf.bokeModel.total_time.intValue;
        }
        
        if ((currentTime - weakSelf.getTime >= 60) || (weakSelf.getTime-currentTime >= 60)) {//每一分钟秒获取一次
            weakSelf.getTime = currentTime;
            [weakSelf requestDanMuWithTime:weakSelf.getTime];
            DRLog(@"获取弹幕");
        }
        
        if ([[NSString stringWithFormat:@"%.f",weakSelf.bokeModel.total_time.integerValue-currentTime] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%.f",weakSelf.bokeModel.total_time.integerValue-currentTime] isEqualToString:@"-0"] ||  !((weakSelf.bokeModel.total_time.integerValue-currentTime)>0) || [[NSString stringWithFormat:@"%.f",weakSelf.bokeModel.total_time.integerValue-currentTime] isEqualToString:@"-1"] || ([[NSString stringWithFormat:@"%.f",weakSelf.bokeModel.total_time.integerValue-currentTime] isEqualToString:@"0"] && [weakSelf.bokeModel.total_time isEqualToString:@"1"])) {
            weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue];
            [weakSelf.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(@"Image_bokepause") forState:UIControlStateNormal];
            weakSelf.isReplay = YES;
        }
        
        if (currentTime > weakSelf.bokeModel.total_time.integerValue) {
            weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue];
            weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text = [weakSelf getMMSSFromSS:0];
        }else{
            weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue-currentTime];
            weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text = [weakSelf getMMSSFromSS:currentTime];
        }
        
        if ([weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text isEqualToString:@"00:00"]) {
            weakSelf.danmuHeaderView.playeBoKeView.slider.value =weakSelf.bokeModel.total_time.integerValue;
            weakSelf.danmuHeaderView.playeBoKeView.maxTimeLabel.text = [weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue];
        }
        
        if ([weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text isEqualToString:[weakSelf getMMSSFromSS:weakSelf.bokeModel.total_time.integerValue]]) {
            weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text = @"00:00";
        }
                
        weakSelf.danmuHeaderView.playeBoKeView.slider.value = currentTime;
        
        if ([weakSelf.showParm objectForKey:weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text]) {//如果存在这个时间段的弹幕
           
            NSMutableArray *arr = [weakSelf.showParm objectForKey:weakSelf.danmuHeaderView.playeBoKeView.minTimeLabel.text];
            
            for (NoticeDanMuListModel *danmM in arr) {
                FDanmakuModel *model1 = [[FDanmakuModel alloc]init];
                int i = arc4random() % weakSelf.begTimeArr.count;
                int j = arc4random() % weakSelf.liveTimeArr.count;
                model1.beginTime = [weakSelf.begTimeArr[i] floatValue];
                model1.liveTime = [weakSelf.liveTimeArr[j] floatValue];
                model1.content = danmM.barrage_content;
                model1.color = danmM.barrage_colour;
                model1.contentId = danmM.danmuId;
                [weakSelf.danmakuView.modelsArr addObject:model1];
            }
        }
    };
}

- (void)playClick{
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.noRePlay = NO;
    if (self.isReplay) {
        [self showHUD];
        self.canReplay = YES;
        self.isReplay = NO;
        self.isPasue = NO;
  
        NSInteger curNum = 0;
        for (int i = 0; i < self.listView.dataArr.count; i++) {
            NoticeDanMuModel *model = self.listView.dataArr[i];
            if ([model.podcast_no isEqualToString:self.bokeModel.podcast_no]) {
                curNum = i;//当前歌曲位置
                break;
            }
        }
        
        appdel.floatView.bokeArr = self.listView.dataArr.count?self.listView.dataArr:[NSMutableArray arrayWithArray:@[self.bokeModel]];
        appdel.floatView.currentTag = curNum;
        appdel.floatView.currentbokeModel = self.bokeModel;
        appdel.floatView.isPasue = self.isPasue;
        appdel.floatView.isReplay = YES;
        appdel.floatView.isNoRefresh = YES;//276800
        [appdel.floatView playClick];
        DRLog(@"重新播放");
    }else{
        DRLog(@"暂停或者播放");
        self.canReplay = NO;
        self.isPasue = !self.isPasue;
        [appdel.floatView playClick];
        [self.danmuHeaderView.playeBoKeView.playBtn setImage:UIImageNamed(self.isPasue?@"Image_bokepause": @"Image_bokeplaying") forState:UIControlStateNormal];
    }
}

- (void)requestDanMuWithTime:(NSInteger)time{
    if (self.firstGetIn) {
 
        self.firstGetIn = NO;
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@/barrage?barrageAt=%ld&type=2&pageSize=100",self.bokeModel.podcast_no,self.getTime] Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.danmArr removeAllObjects];
            [self.shareArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDanMuListModel *model = [NoticeDanMuListModel mj_objectWithKeyValues:dic];
                [self.danmArr addObject:model];
            
                if (![self.showParm objectForKey:model.barrageTime]) {//如果还没有数据，直接添加一个数组，然后取出数组
                    NSMutableArray *arr = [NSMutableArray new];
                    [arr addObject:model];
                    [self.showParm setObject:arr forKey:model.barrageTime];
                  
                }else{//已经存在当前key值
                    NSMutableArray *arr = [self.showParm objectForKey:model.barrageTime];
                    if (arr.count < 5) {
                        [arr addObject:model];
                    }
                }
            }
//            self.danmuHeaderView.listView.dataArr = self.danmArr;
//            [self.danmuHeaderView.listView.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

//播放模块
-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
    
    NSInteger seconds = totalTime;
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    if (seconds <0) {
        return format_time = @"00:00";
    }
    return format_time;
}

- (void)sendContent:(NSString *)content color:(NSString * _Nullable)color isTop:(BOOL)isTop{
    
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.bokeModel.podcast_no forKey:@"podcastNo"];
    [parm setObject:@"1" forKey:@"contentType"];
    [parm setObject:content forKey:@"barrageContent"];
    [parm setObject:isTop?@"2":@"1" forKey:@"barragePosition"];
    [parm setObject:color forKey:@"barrageColour"];
    [parm setObject:[NSString stringWithFormat:@"%.f",self.sendTime] forKey:@"barrageAt"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"podcast/barrage" Accept:@"application/vnd.shengxi.v4.9.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            FDanmakuModel *model1 = [[FDanmakuModel alloc]init];
            int i = arc4random() % self.begTimeArr.count;
            int j = arc4random() % self.liveTimeArr.count;
            model1.beginTime = [self.begTimeArr[i] floatValue];
            model1.liveTime = [self.liveTimeArr[j] floatValue];
            model1.content = content;
            model1.color = color;
            [self.danmakuView.modelsArr addObject:model1];
            self.danmuHeaderView.listView.isDown = YES;
            [self.danmuHeaderView.listView requestVoice];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)keyboderDidShow{
    self.sendTime = self.currentSendTime;
    self.inputView.timeL.text = self.danmuHeaderView.playeBoKeView.minTimeLabel.text;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSTimeInterval)currentTime {
    static double time = 0;
    time += 0.1 ;
    return time;
}

//设置弹幕视图
- (UIView *)danmakuViewWithModel:(FDanmakuModel*)model {

    UILabel *label = [UILabel new];
    label.text = model.content;
    label.textColor = [UIColor colorWithHexString:model.color?model.color:@"#FFFFFF"];
    [label sizeToFit];
    return label;

}

- (void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point {
    DRLog(@"%@ %@",danmuView,NSStringFromCGPoint(point));
}

- (void)refreDanmuText{
    [self.danmakuView.modelsArr removeAllObjects];
    self.getTime = 0;
    [self requestDanMuWithTime:self.getTime];
}

@end
