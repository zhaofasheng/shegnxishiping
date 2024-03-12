//
//  NoticeZongJieController.m
//  NoticeXi
//
//  Created by li lei on 2023/12/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeZongJieController.h"
#import "NoticeChengJiuCell.h"
#import "NoticeLetterView.h"
#import "SCImageView.h"

@interface NoticeZongJieController ()<NewSendTextDelegate>

@property (nonatomic, strong) NoticeAllZongjieModel *dataModel;
@property (nonatomic, strong) SCImageView *playImageView;
@property (nonatomic, assign) BOOL replay;
@property (nonatomic, assign) BOOL firstPlay;
@property (nonatomic, assign) BOOL Pasue;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong,nullable) LGAudioPlayer *musicPlayer;
@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UIButton *msgButton;
@property (nonatomic, strong) NoticeAllZongjieModel *letterModel;
@property (nonatomic, strong) NoticeLetterView *letterView;
@property (nonatomic, strong) UILabel *timeL;
@end

@implementation NoticeZongJieController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.replay = YES;
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self.navBarView.backButton setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.navBarView];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    self.tableView.backgroundColor = [UIColor blackColor];
    

    self.playImageView = [[SCImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-36-15, NAVIGATION_BAR_HEIGHT+10,36, 36)];
    self.playImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(musicClick)];
    [self.playImageView addGestureRecognizer:tap];
    self.playImageView.image = UIImageNamed(@"playzongjie_img");
    [self.view addSubview:self.playImageView];
    
    self.currentIndex = 0;
    
    UIButton *upBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-44)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-44,44, 44)];
    [upBtn setImage:UIImageNamed(@"uppage_img") forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(upBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBtn];
    self.upButton = upBtn;
    
    [self.tableView registerClass:[NoticeChengJiuCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = DR_SCREEN_HEIGHT;
    self.tableView.pagingEnabled = YES;
    
    //canmsg_img寄信  hadmsg_im已寄出 getmsg_img收信 nomsg_img活动结束
    self.msgButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-175)/2, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-48,175, 48)];
    [self.msgButton setImage:UIImageNamed(@"canmsg_img") forState:UIControlStateNormal];
    [self.msgButton addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.msgButton];
    self.msgButton.hidden = YES;
    
    self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.msgButton.frame)+15,DR_SCREEN_WIDTH, 22)];
    self.timeL.font = FOURTHTEENTEXTFONTSIZE;
    self.timeL.textAlignment = NSTextAlignmentCenter;
    self.timeL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
    [self.view addSubview:self.timeL];
    self.timeL.hidden = YES;
    
    self.firstPlay = YES;
    [self requestData];
}

- (NoticeLetterView *)letterView{
    if(!_letterView){
        _letterView = [[NoticeLetterView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _letterView;
}

- (void)msgClick{

    if(self.dataModel.activity_status.intValue == 2){//活动开始
        if(self.dataModel.letter_status.intValue == 1){//没寄信就寄信
            [self sendMsg];
        }
    }else if (self.dataModel.activity_status.intValue == 3){//活动结束
        if (self.dataModel.letter_status.intValue > 1){//寄信了就显示收信
            [self getMsg];
        }
    }
}

- (void)getMsg{
    if(self.letterModel){
        self.letterView.letterModel = self.letterModel;
        [self.letterView showLetterView];
        return;
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"annual/letter" Accept:@"application/vnd.shengxi.v5.5.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            return ;
        }
        self.letterModel = [NoticeAllZongjieModel mj_objectWithKeyValues:dict[@"data"]];
        if(self.letterModel.letter_content.length){
            self.letterView.letterModel = self.letterModel;
            [self.letterView showLetterView];
        }else{
            [self showToastWithText:@"还没有收到信哦~"];
        }

    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)sendMsg{
    VBAddStatusInputView *inputView = [[VBAddStatusInputView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    inputView.num = 5000;
    inputView.delegate = self;
    inputView.isReply = YES;
    inputView.saveKey = [NSString stringWithFormat:@"msgto%@",[NoticeTools getuserId]];
    inputView.titleL.text = @"致 素未谋面的你";
    inputView.plaStr = @"输入你想说的话…";
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:inputView];
    [inputView.contentView becomeFirstResponder];
}

- (void)sendTextDelegate:(NSString *)str{
    if(!str.length){
        return;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:str forKey:@"content"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"annual/letter" Accept:@"application/vnd.shengxi.v5.5.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            return ;
        }
        [self requestData];
        
    } fail:^(NSError * _Nullable error) {
    }];
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@时%@分%@秒",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
    }else{
        if(str_minute.intValue){
            return [NSString stringWithFormat:@"%@分%@秒",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
        }else{
            return [NSString stringWithFormat:@"%@秒",str_second.intValue?str_second:@"0"];
        }
    }
 
}

- (void)requestData{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"annual/data" Accept:@"application/vnd.shengxi.v5.5.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            return ;
        }
        self.timeL.hidden = YES;
        self.dataModel = [NoticeAllZongjieModel mj_objectWithKeyValues:dict[@"data"]];
        
        if(self.dataModel.activity_status.intValue == 2){//活动开始
            if(self.dataModel.letter_status.intValue == 1){//没寄信就显示寄信
                [self.msgButton setImage:UIImageNamed(@"canmsg_img") forState:UIControlStateNormal];
            }else if (self.dataModel.letter_status.intValue > 1){//寄信了就显示已寄信
                [self.msgButton setImage:UIImageNamed(@"hadmsg_img") forState:UIControlStateNormal];
                if(self.dataModel.letter_status.intValue == 2){
                    self.timeL.text = [NSString stringWithFormat:@"%@ 后可以收信",[self getMMSSFromSS:self.dataModel.last_letter_time]];
                    if(self.currentIndex == 4){
                        self.timeL.hidden = NO;
                    }else{
                        self.timeL.hidden = YES;
                    }
                }
         
            }
        }else if (self.dataModel.activity_status.intValue == 3){//活动结束
            if(self.dataModel.letter_status.intValue == 1){//没寄信就显示活动结束
                [self.msgButton setImage:UIImageNamed(@"nomsg_img") forState:UIControlStateNormal];
            }else if (self.dataModel.letter_status.intValue > 1){//寄信了就显示收信
                [self.msgButton setImage:UIImageNamed(@"getmsg_img") forState:UIControlStateNormal];
            }
        }
        if(self.firstPlay){
            [self musicClick];
            self.firstPlay = NO;
        }
        [self.tableView reloadData];
    } fail:^(NSError * _Nullable error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChengJiuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *imageName = [NSString stringWithFormat:@"chengjiuimg%ld",indexPath.row];
    cell.backImageView.image = UIImageNamed(imageName);
    cell.index = indexPath.row;
    cell.dataModel = self.dataModel;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //ScrollView中根据滚动距离来判断当前页数
    int page = (int)scrollView.contentOffset.y/DR_SCREEN_HEIGHT;
    // 设置页码
    self.currentIndex = page;
    self.upButton.hidden = self.currentIndex == 4 ? YES:NO;
    
    if(self.dataModel.activity_status.intValue > 1){
        self.msgButton.hidden = self.currentIndex == 4 ? NO:YES;
        if (self.dataModel.letter_status.intValue == 2 && self.dataModel.activity_status.intValue == 2){
            if(self.currentIndex == 4){
                self.timeL.hidden = NO;
            }else{
                self.timeL.hidden = YES;
            }
        }
    }else{
        self.msgButton.hidden = YES;
    }
}

- (void)musicClick{
    if(!self.dataModel){
        return;
    }
    if (self.replay) {
        [self.musicPlayer stopPlaying];
        [self.musicPlayer startPlayWithUrl:self.dataModel.music_url isLocalFile:NO];
        self.Pasue = NO;
        self.replay = NO;
        [self.playImageView resumeRotate];
    }else{
        self.Pasue = !self.Pasue;
        if (!self.Pasue) {
            [self.playImageView resumeRotate];
        }else{
            [self.playImageView stopRotating];
        }
        [self.musicPlayer pause:self.Pasue];
    }
    
    __weak typeof(self) weakSelf = self;
    self.musicPlayer.playComplete = ^{
        weakSelf.replay = YES;
        [weakSelf.playImageView stopRotating];
    };
}

- (LGAudioPlayer *)musicPlayer
{
    if (!_musicPlayer) {
        _musicPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _musicPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusFailed) {
                [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
                weakSelf.replay = YES;
                weakSelf.Pasue = NO;
                [weakSelf.playImageView stopRotating];
            }
        };
    }
    return _musicPlayer;
}

- (void)upBtnClick{
    if(self.currentIndex < 4){
        self.currentIndex += 1;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

@end
