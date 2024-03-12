//
//  NoticeBaseListController.m
//  NoticeXi
//
//  Created by li lei on 2022/11/9.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeClockPyModel.h"
@interface NoticeBaseListController ()<NoticeReceveMessageSendMessageDelegate>
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation NoticeBaseListController

- (void)didReceiveMemoryWarning{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReplay = YES;
    if (!self.useSystemeNav) {
        self.navBarView.hidden = NO;
        [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];

    }

    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;

    self.view.backgroundColor =  [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView = [[UITableView alloc] init];

    self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0,self.useSystemeNav?0: NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NoticeTitleAndImageCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 65;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.tableView];
   
    //进入后台停止播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayingNotice) name:@"backgroundstopPlayervoice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVoiceTopSet:) name:@"SETTOPNOTICENTERION" object:nil];//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getcancelCollection:) name:@"cancelCollectionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCollection:) name:@"collectionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"RefreshTableForVoiceContent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editVoiceNotice:) name:@"NOTICEREEDITVOICENotification" object:nil];
    self.lastPlayerTag = 0;
    self.isAutoPlayer = [NoticeTools isAutoPlayer];
    
    self.floatView = appdel.floatView;
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow bringSubviewToFront:appdel.floatView];
    
    appdel.socketManager.delegate = self;
}

- (void)editVoiceNotice:(NSNotification*)notification{
    NSDictionary *Dictionary = [notification userInfo];
    NSDictionary *voiceDic = Dictionary[@"data"];
    NoticeVoiceListModel *voiceM = [NoticeVoiceListModel mj_objectWithKeyValues:voiceDic];
    if (voiceM.voice_id && self.dataArr.count) {
    
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (int i = 0; i < self.dataArr.count; i++) {
                NoticeVoiceListModel *oldM = self.dataArr[i];
                if ([oldM.voice_id isEqualToString:voiceM.voice_id]) {
                
                    [self.dataArr replaceObjectAtIndex:i withObject:voiceM];
                    [self.tableView reloadData];
                    break;
                }
            }
        }
    }
}

- (void)didReceiveComment:(NSDictionary *)commentVoiceDic{
    NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:commentVoiceDic];
    
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if ([voiceM.voice_id isEqualToString:model.voice_id]) {
                    voiceM.comment_count = model.comment_count;
                    voiceM.first_comment = model.first_comment;
                    [self.tableView reloadData];
                    break;
                }
            }
        }
    }
}


- (NoticeNoNetWorkView *)noNetWorkView{
    if (!_noNetWorkView) {
        _noNetWorkView = [[NoticeNoNetWorkView alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+20, DR_SCREEN_WIDTH-40, 60)];
    }
    return _noNetWorkView;
}

- (void)backClick{
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:_navBarView];
        _navBarView.hidden = YES;
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _navBarView.titleL.text = self.navigationItem.title;
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}

- (void)refreshTableView{
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.stopAutoPlayerForDissapear = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //加上这句话，防止回到跟视图页面卡
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
  
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = true;
       
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.stopAutoPlayerForDissapear = YES;

    [_noNetWorkView dissMiss];
    
    if (self.dataArr.count && self.floatView.isPlaying) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            self.canReoadData = NO;
            self.isReplay = YES;
            self.oldSelectIndex = 678;
            self.floatView.currentModel.isPlaying = NO;
            self.floatView.currentModel.nowPro = 0;
            self.floatView.currentModel.nowTime = self.floatView.currentModel.voice_len;
        }
        [self.tableView reloadData];
    }
    
    if (self.noNeedAssestPlay) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
    }
}




- (void)getCollection:(NSNotification*)notification{

    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.is_collected = @"1";
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}

- (void)getcancelCollection:(NSNotification*)notification{
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.is_collected = @"0";
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}

- (void)getVoiceTopSet:(NSNotification*)notification{
    if (self.dataArr.count) {
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (NoticeVoiceListModel *voiceM in self.dataArr) {
                if (voiceM.voice_id) {
                    NSDictionary *nameDictionary = [notification userInfo];
                    NSString *voiceId = nameDictionary[@"voiceId"];
                    if ([voiceM.voice_id isEqualToString:voiceId]) {
                        voiceM.is_top = nameDictionary[@"isTop"];
                        voiceM.voiceIdentity = nameDictionary[@"voiceIdentity"];
                        [self.tableView reloadData];
                        break;
                    }
                }
            }
        }
    }
}

- (void)stopPlayingNotice{
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    [self.tableView reloadData];
}

- (void)setNeedPasue:(BOOL)needPasue{
    if (needPasue) {
        [self.audioPlayer stopPlaying];
    }
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (NoticeClickVoiceMore *)clickMore{
    if (!_clickMore) {
        _clickMore = [[NoticeClickVoiceMore alloc] init];
        _clickMore.delegate = self;
    }
    return _clickMore;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTitleAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (void)backToTopForAssest{
    if (self.dataArr.count) {
        BOOL isPalying = NO;
        if ([self.dataArr[0] isKindOfClass:[NoticeVoiceListModel class]]) {//判断是否是心情模型
            for (int i = 0; i < self.dataArr.count; i++) {
                NoticeVoiceListModel *voiceM = self.dataArr[i];
                if (voiceM.isPlaying) {
                    if (self.isSection) {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }
                    isPalying = YES;
                    break;
                }
            }
            if (!isPalying) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }else if([self.dataArr[0] isKindOfClass:[NoticeClockPyModel class]]){
            for (int i = 0; i < self.dataArr.count; i++) {
                NoticeClockPyModel *voiceM = self.dataArr[i];
                if (voiceM.isPlaying) {
                    if (self.isSection) {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }
                    isPalying = YES;
                    break;
                }
            }
            if (!isPalying) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }
}


- (void)iconTapAssest{
    
}

- (void)clickStopOrPlayAssest:(BOOL)pause playing:(BOOL)playing{
    
}


- (void)reSetPlayerData{
    
    self.lastPlayerTag = 0;
    self.isrefreshNewToPlayer = YES;
    self.canReoadData = NO;
    if (self.dataArr.count) {
        self.isReplay = YES;
       // [self.audioPlayer stopPlaying];
        self.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
    }
    [self.tableView reloadData];
}

- (void)reStopPlay{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
}

- (void)addPlayNum:(NoticeVoiceListModel *)model{
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:model.voice_id forKey:@"voiceId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"voices/addReading" Accept:@"application/vnd.shengxi.v5.3.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            model.reading_num = [NSString stringWithFormat:@"%d",model.reading_num.intValue+1];
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}



- (NoticeNoDataView *)queshenView{
    if (!_queshenView) {
        _queshenView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height)];
        _queshenView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    }
    return _queshenView;
}


- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel alloc] initWithFrame:self.tableView.bounds];
        _defaultL.textAlignment = NSTextAlignmentCenter;
        _defaultL.font = FOURTHTEENTEXTFONTSIZE;
        _defaultL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    return _defaultL;
}
@end

