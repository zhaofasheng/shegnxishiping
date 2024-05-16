//
//  NoticeSCViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSCViewController.h"
#import "NoticeSCCell.h"
#import "NoticeXi-Swift.h"
#import "NoticeSetYuReplyController.h"
#import "NoticeYuSetModel.h"
#import "NoticeChatTitleView.h"
#import "NoticeAction.h"
#import "NoticeClipImage.h"
#import "NoticeCustumeButton.h"
#import "NoticeNoReandView.h"
#import "NoticeSaveVoiceTools.h"
#import "NoticeHasCenterData.h"
#import "NoticeDefaultMessageView.h"
#import "NoticeAddEmtioTools.h"
#import "SXChatInputView.h"
#import "RXPopMenu.h"
#import "SXSendChatTools.h"
@interface NoticeSCViewController ()<NoticeReceveMessageSendMessageDelegate,NoticeSCDeledate,LCActionSheetDelegate,NewSendTextDelegate,NoticeSendDefaultClickDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) SXChatInputView *chatInputView;

@property (nonatomic, strong) SXSendChatTools *sendTools;

@property (nonatomic, assign) NSInteger oldSection;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSMutableArray *nolmorLdataArr;
@property (nonatomic, strong) NSMutableArray *localdataArr;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, assign) BOOL hasTips;
@property (nonatomic, assign) BOOL hasHobbys;
@property (nonatomic, strong) NoticeChats *tapChat;
@property (nonatomic, strong) NoticeChats *oldModel;
@property (nonatomic, assign) BOOL noAuto;
@property (nonatomic, strong) NoticeChats *currentModel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) NSInteger currentAutoIndex;
@property (nonatomic, assign) NSInteger currentAutoSection;
@property (nonatomic, assign) BOOL isAuto;
@property (nonatomic, assign) BOOL isoffline;
@property (nonatomic, assign) NSInteger reSendTime;
@property (nonatomic, strong) NSString *autoId;
@property (nonatomic, assign) BOOL firstIn;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, assign) NSInteger sendTimeNum;
@property (nonatomic, assign) BOOL isClickChongBo;
@property (nonatomic, strong) UILabel *deveceinfoL;
@property (nonatomic, strong) NSString *tipStr;
@property (nonatomic, strong) LCActionSheet *cellSheet;
@property (nonatomic, strong) LCActionSheet *failSheet;
@property (nonatomic, strong) LCActionSheet *moreSheet;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) NSMutableArray *yuseStrArr;
@property (nonatomic, strong) NSMutableArray *cacheArr;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *chatTiemId;
@property (nonatomic, strong) NoticeChatTitleView *ttitleV;


@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, assign) NSInteger messageNum;

@property (nonatomic, assign) CGFloat tableViewOrinY;
@property (nonatomic, strong) NoticeChats *reSendChat;
@property (nonatomic, assign) BOOL isLinkUrl;
@property (nonatomic, strong)UIImagePickerController *imagePickerController;


@property (nonatomic, strong) NSMutableArray *yuseArr;
@property (nonatomic, strong) NSString *yuseLastId;
@property (nonatomic, strong) NSMutableArray *yuseImgArr;

@property (nonatomic, assign) NSInteger oldSelectIndex;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@end

@implementation NoticeSCViewController

- (SXSendChatTools *)sendTools{
    if (!_sendTools) {
        _sendTools = [[SXSendChatTools alloc] init];
        _sendTools.toUser = self.toUser;
    }
    return _sendTools;
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [NoticeTools setSHAKE:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NoticeTools setSHAKE:YES];
    self.noAuto = YES;
    [self.audioPlayer pause:YES];
    [self.audioPlayer stopPlaying];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];


    if (![[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICION" object:nil];//刷新私聊会话列表
    }
    [self.chatInputView regFirst];
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    
}

- (void)sendVoiceAndStopPlay{

    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSection = 10032;
    self.oldSelectIndex = 4324;
    for (NoticeChats * chat in self.dataArr) {
        if (chat.isPlaying) {
            chat.isPlaying = NO;
            break;
        }
    }
    for (NoticeChats * chat in self.localdataArr) {
        if (chat.isPlaying) {
            chat.isPlaying = NO;
            break;
        }
    }
    [self.tableView reloadData];

}


- (void)funForInputView{
    
    __weak typeof(self) weakSelf = self;
    self.chatInputView.startRecoderOrPzStopPlayBlock = ^(BOOL stopPlay) {
        [weakSelf onStartRecording];
    };
    
    //发送音频
    self.chatInputView.uploadVoiceBlock = ^(NSString * _Nonnull localPath, NSString * _Nonnull timeLength, NSString * _Nonnull upSuccessPath, BOOL upSuccess,NSString *bucketId) {
     
     
        if(upSuccess){
            [weakSelf.sendTools sendVocieWith:localPath time:timeLength upSuccessPath:upSuccessPath success:upSuccess bucketid:bucketId];
        }else{
            [weakSelf showToastWithText:@"上传失败，请重试"];
        }
        
    };
    //发送图片
    self.chatInputView.uploadimgBlock = ^(NSData * _Nonnull imgData, NSString * _Nonnull upSuccessPath, BOOL upSuccess, NSString * _Nonnull bucketId) {
        if(upSuccess){
            [weakSelf.sendTools sendImgWithPath:upSuccessPath success:upSuccess bucketid:bucketId];
        }else{
            [weakSelf showToastWithText:@"上传失败，请重试"];
        }
        
    };
    
    //发送表情包
    self.chatInputView.emtionBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {

        [weakSelf.sendTools sendemtionWithPath:url bucketid:buckId pictureId:pictureId isHot:isHot];
    };
    
    //发送文字
    self.chatInputView.sendTextBlock = ^(NSString * _Nonnull sendText) {
        [weakSelf.sendTools sendTextWith:sendText];
    };


    
    self.chatInputView.orignYBlock = ^(CGFloat y) {
        weakSelf.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, y-NAVIGATION_BAR_HEIGHT);
        weakSelf.canLoad = YES;
        [weakSelf scroToBottom];
    };
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, BOTTOM_HEIGHT)];
    bottomV.backgroundColor = self.chatInputView.backgroundColor;
    [self.view addSubview:bottomV];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.canLoad = YES;
    [self request];
    self.view.backgroundColor = [UIColor whiteColor];
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        DRLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
    }];
    
    
    self.firstIn = YES;
    self.oldSection = 10000;
    self.isFirst = YES;
    self.dataArr = [NSMutableArray new];
    self.nolmorLdataArr = [NSMutableArray new];
    self.localdataArr = [NSMutableArray new];
    

    [self.tableView registerClass:[NoticeSCCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-91-NAVIGATION_BAR_HEIGHT);
    self.chatInputView = [[SXChatInputView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-91, DR_SCREEN_WIDTH, 91)];

    [self.view addSubview:self.chatInputView];
    
    [self funForInputView];
    
    [self createRefesh];


    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (self.chatDetailId) {
        //[_sendView removeFromSuperview];
    }
    
    appdel.socketManager.chatDelegate = self;
    
    if ([self.toUserId isEqualToString:@"1"]) {//如果是客服，则不显示举报按钮
        self.navigationItem.title = @"声昔小二";
    }
    
    if (self.chatDetailId) {//如果自己是声昔小二  自己内测使用
        [self requestData];
    }else{
        if (self.toUserId) {
            [self.tableView.mj_header beginRefreshing];
        }
        if (![self.toUserId isEqualToString:@"1"]) {//如果是客服，则不显示举报按钮
            
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-30,STATUS_BAR_HEIGHT, 30,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
            [moreBtn setImage: [UIImage imageNamed:@"img_scb_b"]  forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(actionClick) forControlEvents:UIControlEventTouchUpInside];
            [self.navBarView addSubview:moreBtn];
            
        }else{
            self.isKeFu = YES;
        }
    }
    
    self.navBarView.hidden = NO;
    self.navBarView.titleL.text = self.navigationItem.title;
    
    if ([NoticeTools isManager]) {
        UILabel *deveceinfoL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,100)];
        deveceinfoL.font = ELEVENTEXTFONTSIZE;
        deveceinfoL.numberOfLines = 0;
        deveceinfoL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        deveceinfoL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.deveceinfoL = deveceinfoL;
        self.tableView.tableHeaderView = deveceinfoL;
        [self requestDevoice];
    }
}

- (void)clickCanLoadTap{

    self.messageNum = 0;
    self.canLoad = YES;
    [self scroToBottom];
}

- (void)scroToBottom{
    if (!self.canLoad) {
        return;
    }

    if (self.dataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    if (self.localdataArr.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.localdataArr.count-1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
//开始录音
- (void)onStartRecording{
    
    if (self.oldModel) {
        self.oldModel.isPlaying = NO;
        [self.tableView reloadData];
    }
    
    self.noAuto = YES;
    [self.audioPlayer pause:YES];
    self.isReplay = YES;
    self.oldSelectIndex = 1000000;
    self.oldSection = 1000000000;
    [self.audioPlayer stopPlaying];
}

- (void)onStopRecording{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)onCancelRecording{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.localdataArr.count;
    }
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChats *chat =  indexPath.section == 1 ? self.localdataArr[indexPath.row] : self.dataArr[indexPath.row];

    if ([self.toUserId isEqualToString:@"1"]) {
        if ([[NoticeTimeTools needShowTimeMark] isEqualToString:@"开发者等下就来"] && !chat.needMarkAuto) {
            chat.needMarkAuto = NO;
        }else{
            chat.needMarkAuto = [NoticeTimeTools needShowTimeMark];
        }
    }
    
    if (indexPath.section == 0) {//第一组
        if (indexPath.row == 0) {//第一个要显示时间
            chat.isShowTime = YES;
        }else{
            if (indexPath.row > 0) {//第二个开始做前一个比较
                NoticeChats *beChat = self.dataArr[indexPath.row-1];
                chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
            }
        }
    }else{
        if (!self.dataArr.count) {//如果不存在第一组数据
            if (indexPath.row == 0) {//第一个要显示时间
                chat.isShowTime = YES;
            }else{
                if (indexPath.row > 0) {//第二个开始做前一个比较
                    NoticeChats *beChat = self.localdataArr[indexPath.row-1];
                    chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                }
            }
        }else{//存在第一组数据
            if (indexPath.row == 0) {
                NoticeChats *firdtChat = self.dataArr[0];
                chat.isShowTime = (chat.created_at.integerValue - firdtChat.created_at.integerValue)>60 ? YES : NO;
            }else{
                if (indexPath.row > 0) {//第二个开始做前一个比较
                    NoticeChats *beChat = self.localdataArr[indexPath.row-1];
                    chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                }
            }
        }
    }
        
    if (chat.contentText && chat.contentText.length) {//显示文案
        
        if (chat.content_type.intValue == 9 && chat.toUserInfo) {//有文案
            return 28+chat.textHeight+58+16+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
        }
        
        return 28+chat.textHeight+16+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    
    if (chat.content_type.intValue == 5) {//显示分享链接
        return 28+53+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    if (chat.content_type.intValue == 6){//显示分享的心情
        if (chat.shareVoiceM.show_status.intValue > 1 ) {
            return 28+98+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
        }
        
        if (chat.shareVoiceM.voiceM.img_list.count) {
            if (chat.shareVoiceM.voiceM.img_list.count == 3) {
                return 28+166+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
            }else if (chat.shareVoiceM.voiceM.img_list.count == 2){
                return 28+186+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
            }else{
                return 28+226+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
            }
        }else{
            return 28+98+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
        }
    }
    if (chat.content_type.intValue == 4) {//显示白噪声卡
        return 28+260+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    if (chat.content_type.intValue == 7) {//显示配音
        return 28+120+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    if (chat.content_type.intValue == 8) {//显示台词
        return 28+117+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    if (chat.isShowTime) {
      
        if (chat.content_type.intValue == 1) {
            return 45+28+16+(chat.needMarkAuto ? 30 : 0) + (chat.offline_prompt ? 55 : 0) + ([[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"] ? ((chat.dialog_content.length? (chat.contentHeight+15) : 0)) : 0);
            
        }
        return 28+(chat.imgCellHeight?chat.imgCellHeight: 138)+16+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
    }
    

    if (chat.content_type.intValue == 1) {
        return 35+28+(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);//最后一个表示是客服的同时，存在语音转文字
    }
    return 28+ (chat.imgCellHeight?chat.imgCellHeight: 138) +(chat.needMarkAuto ? 30 : 0)+ (chat.offline_prompt ? 55 : 0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.currentPath = indexPath;
    __weak typeof(self) weakSelf = self;
    cell.refreshHeightBlock = ^(NSIndexPath * _Nonnull indxPath) {
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        [weakSelf scroToBottom];
    };
    
    cell.needHelp = self.isNeedHelp;
    NoticeChats *chat = nil;
    if (indexPath.section == 0) {
        if ((indexPath.row <= self.dataArr.count-1) && self.dataArr.count) {
            chat = self.dataArr[indexPath.row];
        }
        
    }else{
        if ((indexPath.row <= self.localdataArr.count-1) && self.localdataArr.count) {
            chat = self.localdataArr[indexPath.row];
        }
    }
    if (!chat) {
        return cell;
    }
    cell.toUserId = self.toUserId;
    if (indexPath.section == 0) {//第一组
        if (indexPath.row == 0) {//第一个要显示时间
            chat.isShowTime = YES;
        }else{
            if (indexPath.row > 0) {//第二个开始做前一个比较
                NoticeChats *beChat = self.dataArr[indexPath.row-1];
                chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
            }
        }
    }else{
        if (!self.dataArr.count) {//如果不存在第一组数据
            if (indexPath.row == 0) {//第一个要显示时间
                chat.isShowTime = YES;
            }else{
                if (indexPath.row > 0) {//第二个开始做前一个比较
                    NoticeChats *beChat = self.localdataArr[indexPath.row-1];
                    chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                }
            }
        }else{//存在第一组数据
            if (indexPath.row == 0) {
                NoticeChats *firdtChat = self.dataArr[0];
                chat.isShowTime = (chat.created_at.integerValue - firdtChat.created_at.integerValue)>60 ? YES : NO;
            }else{
                if (indexPath.row > 0) {//第二个开始做前一个比较
                    NoticeChats *beChat = self.localdataArr[indexPath.row-1];
                    chat.isShowTime = (chat.created_at.integerValue - beChat.created_at.integerValue)>60 ? YES : NO;
                }
            }
        }
    }
    
    if (!chat.is_self.integerValue) {
        chat.identity_type = self.identType;
    }else{
        chat.identity_type = [[NoticeSaveModel getUserInfo] identity_type];
    }
    
    cell.chat = chat;
    cell.playerView.timeLen = chat.resource_len;
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.section = indexPath.section;
    cell.playerView.slieView.progress = 0;
    if (chat.isSelf) {
        [cell.playerView.playButton setImage:UIImageNamed(!chat.isPlaying ? @"Image_newplay" : @"newbtnplay") forState:UIControlStateNormal];
    }else{
        [cell.playerView.playButton setImage:UIImageNamed(!chat.isPlaying ? @"oImage_newplay" : @"onewbtnplay") forState:UIControlStateNormal];
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isAuto && !self.dataArr.count && section == 0) {
        return 26;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isAuto && !self.dataArr.count && section == 0) {
        UILabel * _markL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH,30)];
        _markL.textColor = [NoticeTools isWhiteTheme] ? [UIColor colorWithHexString:@"#B5B5B5"]:[UIColor colorWithHexString:@"#72727F"];
        _markL.textAlignment = NSTextAlignmentCenter;
        _markL.font = ELEVENTEXTFONTSIZE;
        _markL.text = [NoticeTools isSimpleLau]? @"对方可能不方便立刻回复":@"對方可能不方便立刻回復";
        _markL.numberOfLines = 0;
        return _markL;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//等待时间超过五秒标记为失败
- (void)waitMessage{
    self.sendTimeNum++;
    if (self.sendTimeNum == 5) {
        for (NoticeChats *chat in self.localdataArr) {
            if (chat.isLocal) {
                chat.isFailed = YES;
            }
        }
        [self.tableView reloadData];
        self.sendTimeNum = 0;
        [self.timer invalidate];
    }
}


- (void)requestData{
    NSString *url = nil;
    
    if (self.chatDetailId) {
        if (!self.isDown) {
            url = [NSString stringWithFormat:@"admin/chats/%@?confirmPasswd=%@",self.chatDetailId,self.managerCode];
        }else{
            url = [NSString stringWithFormat:@"admin/chats/%@?confirmPasswd=%@&lastId=%@",self.chatDetailId,self.managerCode,self.lastId];
        }
        [self requestWith:url];
        return;
    }
    
    if (!self.isFirst && !self.toUserId) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    if (self.isFirst) {
        url = [NSString stringWithFormat:@"chats/2/%@/0",self.toUserId];
    }else{
        if (!self.isDown) {
            url = [NSString stringWithFormat:@"chats/2/%@/0",self.toUserId];
        }else{
            if (self.lastId) {
                url = [NSString stringWithFormat:@"chats/2/%@/0?lastId=%@",self.toUserId,self.lastId];
            }else{
                self.isDown = NO;
                url = [NSString stringWithFormat:@"chats/2/%@/0",self.toUserId];
            }
        }
    }
    
    [self requestWith:url];
}

- (void)requestWith:(NSString *)url{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:self.chatDetailId?nil: @"application/vnd.shengxi.v5.0.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
        
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeChats *model = [NoticeChats mj_objectWithKeyValues:dic];
                
                if (model.globText && model.globText.length && model.content_type.intValue != 2) {
                    model.contentText = model.globText;
                }
                
                if (model.content_type.intValue > 11) {
                    model.content_type = @"10";
                    model.contentText = @"请更新到最新版本";
                }

                 
                BOOL alerady = NO;
                for (NoticeChats *olM in self.localdataArr) {//判断是否有重复数据
                    if ([olM.dialog_id isEqualToString:model.dialog_id]) {
                        alerady = YES;
                        break;
                    }
                }
                
                if (!alerady) {
                    [self.nolmorLdataArr addObject:model];
                    [newArr addObject:model];
                }
            }
            if (self.nolmorLdataArr.count) {
                //2.倒序的数组
                NSArray *reversedArray = [[self.nolmorLdataArr reverseObjectEnumerator] allObjects];
                self.dataArr = [NSMutableArray arrayWithArray:reversedArray];
                NoticeChats *lastM = self.dataArr[0];
                self.chatId = lastM.chat_id;
                self.lastId = lastM.dialog_id;
                
                if (self.isAuto) {//判断对方是否在线
                    if (self.firstIn) {//第一次进来获取第一个id
                        NoticeChats *newM = self.dataArr[self.dataArr.count-1];
                        newM.needMarkAuto = YES;
                        self.autoId = newM.dialog_id;
                        self.firstIn = NO;
                    }else{
                        for (NoticeChats *allM in self.dataArr) {
                            if ([allM.dialog_id isEqualToString:self.autoId]) {
                                allM.needMarkAuto = YES;
                                break;
                            }
                        }
                    }
                }else{
                    for (NoticeChats *allM in self.dataArr) {
                        allM.needMarkAuto = NO;
                    }
                }
            }
            
            //加载缓存数据
//            if (self.isFirst) {
//                NSMutableArray *localArr = [NoticeTools getChatArrarychatId:self.toUserId];
//                if ([localArr count]) {
//                    NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
//                    for (NoticeChatSaveModel *chatM in localArr) {
//                        NoticeChats *locaChat = [[NoticeChats alloc] init];
//                        locaChat.from_user_id = selfUser.user_id;
//                        locaChat.content_type = chatM.type;
//                        locaChat.resource_url = chatM.type.intValue==1? chatM.voiceFilePath:chatM.imgUpPath;
//                        locaChat.isSaveCace = YES;
//                        locaChat.avatar_url = selfUser.avatar_url;
//                        locaChat.resource_type = chatM.type;
//                        locaChat.resource_len = chatM.voiceTimeLen;
//                        locaChat.isText = chatM.type.intValue==2?@"1":@"0";
//                        locaChat.saveId = chatM.saveId;
//                        locaChat.text = chatM.text;
//                        [self.localdataArr addObject:locaChat];
//                    }
//                }
//            }

            [self.tableView reloadData];
            if (self.isDown && !self.isFirst) {
                if (newArr.count) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:newArr.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
            
            if (self.dataArr.count && self.isFirst) {
                self.isFirst = NO;
                [self scroToBottom];
            }
            if (!self.chatTiemId) {
                self.chatTiemId = self.chatId;
                [self getTimeLast];
            }
        }
    } fail:^(NSError *error) {
        if ([NoticeComTools pareseError:[NSError new]]) {
//            if (self.isFirst) {
//                self.isFirst = NO;
//                NSMutableArray *localArr = [NoticeTools getChatArrarychatId:self.toUserId];
//                if ([localArr count]) {
//                    NoticeUserInfoModel *selfUser = [NoticeSaveModel getUserInfo];
//                    for (NoticeChatSaveModel *chatM in localArr) {
//                        NoticeChats *locaChat = [[NoticeChats alloc] init];
//                        locaChat.from_user_id = selfUser.user_id;
//                        locaChat.content_type = chatM.type;
//                        locaChat.resource_url = chatM.type.intValue==1? chatM.voiceFilePath:chatM.imgUpPath;
//                        locaChat.isSaveCace = YES;
//                        locaChat.avatar_url = selfUser.avatar_url;
//                        locaChat.resource_type = chatM.type;
//                        locaChat.resource_len = chatM.voiceTimeLen;
//                        locaChat.isText = chatM.type.intValue==2?@"1":@"0";
//                        locaChat.saveId = chatM.saveId;
//                        locaChat.text = chatM.text;
//                        [self.localdataArr addObject:locaChat];
//                    }
//                }
//            }
        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)getTimeLast{
    if ([self.navigationItem.title isEqualToString:@"私聊完整对话"] || [self.navigationItem.title isEqualToString:@"悄悄话完整对话"] || self.toUserId.intValue == 1) {
        return;
    }
}

- (void)createRefesh{
    
    __weak NoticeSCViewController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        [ctl requestData];
    }];
    // 设置颜色
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
}

- (void)palyWithModel:(NoticeChats *)model{
    
    if (self.oldModel) {
        self.oldModel.isPlaying = NO;
        [self.tableView reloadData];
    }
    
    self.oldModel = model;
    
    if ((self.currentIndex != self.oldSelectIndex) || (self.currentSection!= self.oldSection)) {//判断点击的是否是当前视图
        self.oldSelectIndex = self.currentIndex;
        self.oldSection = self.currentSection;
        self.isReplay = YES;
        DRLog(@"点击的不是当前视图");
    }else{
        DRLog(@"点击的是当前视图");
    }
    if (!model.read_at.integerValue && !model.is_self.integerValue) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:self.currentSection];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self setAleryRead:model];
    }
    
    if (self.isReplay || model.resource_len.integerValue == 1) {
        [self.audioPlayer startPlayWithUrl:model.resource_url isLocalFile:model.isSaveCace?YES: NO];
        self.isReplay = NO;
        self.isPasue = NO;
    }else{
        self.isPasue = !self.isPasue;
        model.isPlaying = !self.isPasue;
        [self.tableView reloadData];
        [self.audioPlayer pause:self.isPasue];
    }

    __weak typeof(self) weakSelf = self;
    self.audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
        if (status == AVPlayerItemStatusFailed) {
            [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"em.voiceLoading"]];
        }else{
            model.isPlaying = YES;
            [weakSelf.tableView reloadData];
        }
    };
    
    self.audioPlayer.playComplete = ^{
        if (!weakSelf.isTap) {
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            model.nowPro = 0;
            model.nowTime = model.resource_len;
            if (!model.is_self.integerValue) {
                if (!weakSelf.isClickChongBo) {
                    [weakSelf audioNextPlayer];
                }else{
                    weakSelf.isClickChongBo = NO;
                }
            }
        }
        weakSelf.isTap = NO;
        [weakSelf.tableView reloadData];
    };

    self.audioPlayer.playingBlock = ^(CGFloat currentTime) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.currentIndex inSection:weakSelf.currentSection];
        
        NoticeSCCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%.f",currentTime]integerValue] > model.resource_len.integerValue) {
            currentTime = model.resource_len.integerValue;
        }
        if ([[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"0"]||[[NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime] isEqualToString:@"-0"] ||  ((model.resource_len.integerValue-currentTime)<1)) {
            cell.playerView.timeLen = model.resource_len;
            weakSelf.isReplay = YES;
            model.isPlaying = NO;
            cell.playerView.slieView.progress = 0;
            weakSelf.oldSelectIndex = 1000000;//设置个很大 数值以免冲突
            weakSelf.oldSection = 1000000;
            if ((model.resource_len.integerValue-currentTime)<-1) {
                [weakSelf.audioPlayer stopPlaying];
                [weakSelf.tableView reloadData];
            }
            model.nowPro = 0;
            model.nowTime = model.resource_len;
        }
        weakSelf.isTap = NO;
        cell.playerView.timeLen = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        cell.playerView.slieView.progress = currentTime/model.resource_len.floatValue;
        model.nowTime = [NSString stringWithFormat:@"%.f",model.resource_len.integerValue-currentTime];
        model.nowPro = currentTime/model.resource_len.floatValue;
    };
}

- (void)audioNextPlayer{
    
    if (self.noAuto) {
        self.noAuto = NO;
        return;
    }
    
    if (self.currentSection == 0) {//在第一组的时候
        if (self.dataArr.count-1 > self.currentIndex) {//如果第一组还没到最后一条消息
            NoticeChats *model = self.dataArr[self.currentIndex+1];//获取最后一条信息
            if (([model.resource_type isEqualToString:@"4"] || [model.resource_type isEqualToString:@"1"]) && !model.read_at.integerValue && !model.is_self.integerValue) {//判断是否是音频消息并且未读则继续自动播放
                self.currentIndex ++;
                self.currentSection = 0;
                self.currentModel = model;
                [self palyWithModel:self.currentModel];
            }else if ([model.resource_type isEqualToString:@"2"] || model.is_self.integerValue){//如果是图片，继续往下跳过
                self.currentIndex ++;
                self.currentSection = 0;
                self.currentModel = model;
                [self audioNextPlayer];
            }
        }else{//到了最后一条的时候，查询第二组是否存在未读消息
            if (self.localdataArr.count) {//如果第二组存在
                self.currentIndex = 0;
                self.currentSection = 1;
                NoticeChats *model = self.localdataArr[0];//获取第二组第一条信息
                if (([model.resource_type isEqualToString:@"4"] || [model.resource_type isEqualToString:@"1"]) && !model.read_at.integerValue && !model.is_self.integerValue) {//判断是否是音频消息并且未读则继续自动播放
                    self.currentModel = model;
                    [self palyWithModel:self.currentModel];
                }else if ([model.resource_type isEqualToString:@"2"] || model.is_self.integerValue){//如果是图片，继续往下跳过
                    self.currentIndex ++;
                    self.currentSection = 1;
                    self.currentModel = model;
                    [self audioNextPlayer];
                }
            }
        }
    }else{//直接在第二组
        if (self.localdataArr.count-1 > self.currentIndex) {//如果第一组还没到最后一条消息
            NoticeChats *model = self.localdataArr[self.currentIndex+1];//获取最后一条信息
            if (([model.resource_type isEqualToString:@"4"] || [model.resource_type isEqualToString:@"1"]) && !model.read_at.integerValue && !model.is_self.integerValue) {//判断是否是音频消息并且未读则继续自动播放
                self.currentIndex ++;
                self.currentSection = 1;
                self.currentModel = model;
                [self palyWithModel:self.currentModel];
            }else if ([model.resource_type isEqualToString:@"2"] || model.is_self.integerValue){//如果是图片，继续往下跳过
                self.currentIndex ++;
                self.currentSection = 1;
                self.currentModel = model;
                [self audioNextPlayer];
            }
        }
    }
}
- (void)beginDrag:(NSInteger)tag section:(NSInteger)section{
    self.tableView.scrollEnabled = NO;
    [self.audioPlayer pause:YES];
}

- (void)endDrag:(NSInteger)tag section:(NSInteger)section{
    self.tableView.scrollEnabled = YES;
    [self.audioPlayer pause:self.isPasue];
}

- (void)dragingFloat:(CGFloat)dratNum index:(NSInteger)tag section:(NSInteger)section{
    // 跳转
    [self.audioPlayer.player seekToTime:CMTimeMake(dratNum, 1) completionHandler:^(BOOL finished) {
        if (finished) {
        }
    }];
}

#pragma Mark - 音频播放模块
- (void)startPlayAndStop:(NSInteger)tag section:(NSInteger)section{
    [self.tableView reloadData];
    self.currentIndex = tag;
    self.currentSection = section;
    self.isTap = YES;
    self.currentModel = section == 0? self.dataArr[tag] : self.localdataArr[tag];
    [self palyWithModel:self.currentModel];
}

- (void)startRePlayAndStop:(NSInteger)tag section:(NSInteger)section{
    self.isClickChongBo = YES;
    [self.audioPlayer stopPlaying];
    self.isReplay = YES;
    self.oldSelectIndex = 10040000;//设置个很大 数值以免冲突
    self.oldSection = 10004000;
    self.currentIndex = tag;
    self.currentSection = section;
    self.currentModel = section == 0? self.dataArr[tag] : self.localdataArr[tag];
    [self palyWithModel:self.currentModel];
}

- (void)actionClick{
    if([[NoticeTools getuserId] isEqualToString:@"1"]){
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[@"预设回复语",@"发送密码"]];
        self.moreSheet = sheet;
        sheet.delegate = self;
        [sheet show];
        return;
    }
    if (self.isKeFu) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[@"删除交流记录(对方记录也会删除)"]];
        sheet.delegate = self;
        [sheet show];
    }else{
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[@"删除交流记录(对方记录也会删除)",@"举报"]];
        sheet.delegate = self;
        [sheet show];
    }
}

- (void)jubao{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"举报用户或者消息" message:@"举报用户：进入用户个人主页可进行举报\n举报消息：长按消息可进行举报" cancleBtn:@"知道了"];
    [alerView showXLAlertView];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.failSheet) {
        return;
    }
    if([[NoticeTools getuserId] isEqualToString:@"1"] && actionSheet == self.moreSheet){
        if(buttonIndex == 1){
            [self sendDefault];
        }else if (buttonIndex == 2){
            [self sendpasswordMsg];
        }
        return;
    }


    if (self.isKeFu) {
        if (buttonIndex == 1) {
            [self clearMemory];
        }
    }else{
        if (buttonIndex == 1) {
            [self clearMemory];
        }else if (buttonIndex == 2){
            [self jubao];
        }
    }

}


- (void)backChatMsg{
    
    if ([self.currentModel.dialog_id isEqualToString:self.tapChat.dialog_id]) {
        [self.audioPlayer stopPlaying];
    }
    self.noAuto = YES;
    
    NSMutableDictionary * dsendDic = [NSMutableDictionary new];
    [dsendDic setObject:self.toUser ? self.toUser : @"noNet" forKey:@"to"];
    [dsendDic setObject:@"singleChat" forKey:@"flag"];
    [dsendDic setObject:@"delete" forKey:@"action"];
    
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:@"2" forKey:@"chatType"];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:self.tapChat.chat_id?self.tapChat.chat_id:@"7777777" forKey:@"chatId"];
    [messageDic setObject:self.tapChat.dialog_id forKey:@"dialogId"];
    [dsendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:dsendDic];
    
    
    for (NoticeChats *chatAll in self.dataArr) {
        if ([chatAll.dialog_id isEqualToString:self.tapChat.dialogId] || [chatAll.dialog_id isEqualToString:self.tapChat.dialog_id]) {
            [self.dataArr removeObject:chatAll];
 
            break;
        }
    }
    
    for (NoticeChats *chatAll in self.localdataArr) {
        if ([chatAll.dialog_id isEqualToString:self.tapChat.dialog_id] || [chatAll.dialog_id isEqualToString:self.tapChat.dialogId]) {
            [self.localdataArr removeObject:chatAll];
   
            break;
        }
    }
    
    for (NoticeChats *norChat in self.nolmorLdataArr) {
        if ([norChat.dialog_id isEqualToString:self.tapChat.dialog_id] || [norChat.dialog_id isEqualToString:self.tapChat.dialogId]) {
            [self.nolmorLdataArr removeObject:norChat];
            break;
        }
    }
    
    [self.tableView reloadData];
}

//长按删除
- (void)longTapCancelWithSection:(NSInteger)section tag:(NSInteger)tag tapView:(nonnull UIView *)tapView{
   
    NoticeChats *chat = nil;
    
    if (section == 0) {
        if (self.dataArr.count-1 >= tag) {
            chat = self.dataArr[tag];
        }
    }else{
        if (self.localdataArr.count-1 >= tag) {
            chat = self.localdataArr[tag];
        }
    }
    
    if (!chat) {
        return;
    }
    
    self.tapChat = chat;
    
    NSArray *arr = nil;

    if (chat.is_self.intValue) {//自己的消息
        arr = @[[RXPopMenuItem itemTitle:@"撤回"]];
        if (self.tapChat.content_type.intValue == 11) {
            arr = @[[RXPopMenuItem itemTitle:@"撤回"],[RXPopMenuItem itemTitle:@"复制"]];
        }
    }else{
        if (chat.content_type.intValue == 3) {//图片
            arr = @[[RXPopMenuItem itemTitle:@"添加表情"],[RXPopMenuItem itemTitle:@"举报"]];
        }if (self.tapChat.content_type.intValue == 11) {
            arr = @[[RXPopMenuItem itemTitle:@"举报"],[RXPopMenuItem itemTitle:@"复制"]];
        }
        else{
            arr = @[[RXPopMenuItem itemTitle:@"举报"]];
        }
    }
    
    RXPopMenu * menu = [RXPopMenu menuWithType:RXPopMenuBox];
    [menu showBy:tapView withItems:arr];

    __weak typeof(self) weak = self;
    menu.itemActions = ^(RXPopMenuItem *item) {
        if([item.title isEqualToString:@"撤回"]){
            [weak backChatMsg];
        }else if([item.title isEqualToString:@"添加表情"]){
            [NoticeAddEmtioTools addEmtionWithUri:weak.tapChat.resource_uri bucktId:weak.tapChat.bucket_id url:weak.tapChat.resource_url];
        }else if([item.title isEqualToString:@"举报"]){
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = weak.tapChat.dialog_id;
            juBaoView.reouceType = @"3";
            [juBaoView showView];
        }else if([item.title isEqualToString:@"复制"]){
            [self showToastWithText:@"已复制"];
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            [pastboard setString:self.tapChat.contentText];
        }
    };
}



- (void)clearMemory{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"songList.suredele"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
 
            [weakSelf showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"chats/%@",weakSelf.chatId] Accept:nil parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [weakSelf hideHUD];
                if (success) {
                    [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"zj.delsus"]];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            } fail:^(NSError *error) {
                [weakSelf hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (void)lahei{
    __weak typeof(self) weakSelf = self;
    NoticePinBiView *pinView = [[NoticePinBiView alloc] initWithPinBiView];
    pinView.ChoiceType = ^(NSInteger type) {
        [weakSelf showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:self.toUserId forKey:@"toUserId"];
        [parm setObject:[NSString stringWithFormat:@"%ld",(long)type] forKey:@"reasonType"];
        [parm setObject:@"4" forKey:@"resourceType"];
        [parm setObject:self.toUserId forKey:@"resourceId"];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/shield",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v3.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
            [weakSelf hideHUD];
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICION" object:nil];//刷新私聊会话列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCHATLISTNOTICIONHS" object:nil];//刷新悄悄话会话列表
                [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"intro.yibp"]];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"pingbiNotification" object:self userInfo:@{@"userId":self.toUserId}];
                NoticePinBiView *pinTostView = [[NoticePinBiView alloc] initWithTostViewType:type];
                pinTostView.ChoiceType = ^(NSInteger types) {
                    if (types == 5) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                };
                [pinTostView showTostView];
            }
        } fail:^(NSError *error) {
            [weakSelf hideHUD];
        }];
    };
    [pinView showPinbView];
}

- (void)setAleryRead:(NoticeChats *)chat{
    if (self.chatDetailId) {
        return;
    }
    chat.read_at = [NoticeTools getNowTimeTimestamp];
    [self.tableView reloadData];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:chat.read_at forKey:@"readAt"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"chats/%@/%@",chat.chat_id,chat.dialog_id] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
    } fail:^(NSError *error) {
        
    }];
}

// 将JSON串转化为字典或者数组
-(id)toArrayOrNSDictionary:(NSString *)JSONString{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSArray class]]){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

- (void)backClick{
    BOOL hasFail = NO;
    for (NoticeChats *chat in self.localdataArr) {
        if (chat.isFailed) {
            hasFail = YES;
            break;
        }
    }
    if (hasFail) {
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"离开对话后，发送失败的语音将不会保存" message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        
        [alerView showXLAlertView];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)request{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            [NoticeSaveModel saveUserInfo:userIn];
        }
    } fail:^(NSError *error) {
    }];
}

- (void)didReceiveMessage:(id)message{
  
    NoticeAction *ifDelegate = [NoticeAction mj_objectWithKeyValues:message];
    NoticeChats *chat = [ NoticeChats mj_objectWithKeyValues:message[@"data"]];
    if (chat.globText && chat.globText.length) {
        chat.contentText = chat.globText;
    }
    if (chat.dialog_content_type.intValue > 11) {
        chat.dialog_content_type = @"10";
        chat.contentText = @"请更新到最新版本";
    }
    
    if ([chat.flag isEqualToString:@"1"]) {
        return;
    }
    if ([ifDelegate.flag isEqualToString:@"receiveCard"]) {//领取白噪声
        if ([chat.from_user_id isEqualToString:[NoticeTools getuserId]] || [chat.to_user_id isEqualToString:[NoticeTools getuserId]]) {
            for (NoticeChats *achat in self.localdataArr) {
                if ([achat.dialog_id isEqualToString:chat.dialog_id]) {
                    achat.whiteModel.receive_status = chat.receive_status;
                    [self.tableView reloadData];
                    break;
                }
            }
            for (NoticeChats *achat in self.dataArr) {
                if ([achat.dialog_id isEqualToString:chat.dialog_id]) {
                    achat.whiteModel.receive_status = chat.receive_status;
                    [self.tableView reloadData];
                    break;
                }
            }
        }

        return;
    }
    if ([ifDelegate.action isEqualToString:@"delete"]) {

        self.noAuto = YES;//收到对方删除的时候，停止自动播放语音
        [self.audioPlayer stopPlaying];
        for (NoticeChats *chatAll in self.dataArr) {
            if ([chatAll.dialog_id isEqualToString:chat.dialogId] || [chatAll.dialog_id isEqualToString:chat.dialogId]) {
                [self.dataArr removeObject:chatAll];
     
                break;
            }
        }
        
        for (NoticeChats *chatAll in self.localdataArr) {
            if ([chatAll.dialog_id isEqualToString:chat.dialog_id] || [chatAll.dialog_id isEqualToString:chat.dialogId]) {
                [self.localdataArr removeObject:chatAll];
       
                break;
            }
        }
        
        for (NoticeChats *norChat in self.nolmorLdataArr) {
            if ([norChat.dialog_id isEqualToString:chat.dialog_id] || [norChat.dialog_id isEqualToString:chat.dialogId]) {
                [self.nolmorLdataArr removeObject:norChat];
                break;
            }
        }
        
        [self.tableView reloadData];
        return;
    }
    
    if (![chat.chat_type isEqualToString:@"2"]) {
        return;
    }
    
    chat.read_at = @"0";
    if (![chat.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {//当发送人不是自己的时候，需要判断是否是当前会话人发来的消息，不然容易消息错误
        if (![chat.from_user_id isEqualToString:self.toUserId]) {//别人发来的消息，判断是否是当前对话人
   
            return;
        }
    }else{//发送人是自己的时候
        self.noAuto = NO;
    }
    
    BOOL alerady = NO;
    for (NoticeChats *olM in self.localdataArr) {//判断是否有重复数据
        if ([olM.dialog_id isEqualToString:chat.dialog_id]) {
            alerady = YES;
            break;
        }
    }
    
    if (!alerady) {
        self.chatId = chat.chat_id;
        for (int i = 0; i < self.localdataArr.count; i++) {//替代本地音频
            NoticeChats *localChat = self.localdataArr[i];
            if (localChat.isLocal && [localChat.dialog_content_uri isEqualToString:chat.dialog_content_uri]) {
                [self.localdataArr removeObjectAtIndex:i];
                break;
            }
        }
        if(chat.resource_uri.length < 10 && chat.dialog_content_uri.length > 10){
            chat.resource_uri = chat.dialog_content_uri;
        }
        [self.localdataArr addObject:chat];
        [self.tableView reloadData];
        
        if (!self.canLoad) {
            self.messageNum++;
        }
    }
    
    if (!self.chatTiemId) {
        self.chatTiemId = self.chatId;
        [self getTimeLast];
    }
    
    [self scroToBottom];
}


- (NSMutableArray *)cacheArr{
    if (!_cacheArr) {
        _cacheArr = [NSMutableArray new];
    }
    return _cacheArr;
}

- (void)dealloc{
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGEYUSEREPLAY" object:nil];
}

//客服相关模块
//获取设备信息
- (void)requestDevoice{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@/statistics",self.toUserId] Accept:@"application/vnd.shengxi.v4.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeHasCenterData *model = [NoticeHasCenterData mj_objectWithKeyValues:dict[@"data"]];
            NSString *sex = nil;
            if ([model.gender isEqualToString:@"1"]) {
                sex = @"男";
            }else if ([model.gender isEqualToString:@"2"]){
                sex = @"女";
            }
            self.deveceinfoL.text = [NSString stringWithFormat:@"对方类型: %@/%@\n\n学号:%@ 来了%@天",model.last_login_device,model.app_version,model.frequency_no,model.comeHereTime];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)sendpasswordMsg{
   
}

//发送预设语音
- (void)sendDefault{
    NoticeDefaultMessageView *defautView = [[NoticeDefaultMessageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    defautView.delegate = self;
    defautView.dataArr = self.yuseArr;
    defautView.imgArr = self.yuseImgArr;
    [defautView.tableView reloadData];
    [defautView show];
}

- (void)sendMessageWithDefault:(NoticeYuSetModel *)model{
    NSMutableDictionary *messageDic = [NSMutableDictionary new];
    [messageDic setObject:@"0" forKey:@"voiceId"];
    [messageDic setObject:model.bucket_id?model.bucket_id:@"0" forKey:@"bucketId"];
    [messageDic setObject:model.resource_type forKey:@"dialogContentType"];
    [messageDic setObject:model.resource_uri forKey:@"dialogContentUri"];
    [messageDic setObject:model.resource_len forKey:@"dialogContentLen"];
    [self.sendTools.sendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:self.sendTools.sendDic];
}


//加载预设数据
- (void)requestYUse:(BOOL)neeShow{
    if (![[[NoticeSaveModel getUserInfo] user_id] isEqualToString:@"1"]) {
        return;
    }
    if (neeShow) {
        [self showHUD];
    }
    self.yuseImgArr = [[NSMutableArray alloc] init];
    self.yuseArr = [NSMutableArray new];
    self.yuseStrArr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/defaultReply",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            [self.yuseImgArr removeAllObjects];
            [self.yuseArr removeAllObjects];
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]){
                NoticeYuSetModel *model = [NoticeYuSetModel mj_objectWithKeyValues:dic];
                model.isTrueStr = YES;
                if (model.resource_type.intValue == 1) {
                    [self.yuseArr addObject:model];
                }else{
                    [self.yuseImgArr addObject:model];
                }
                [self.yuseStrArr addObject:model];
                hasData = YES;
            }
            
            if (self.yuseStrArr.count) {
                NoticeYuSetModel *lastM = self.yuseStrArr[self.yuseStrArr.count-1];
                self.yuseLastId = lastM.reply_sort;
            }
            if (hasData) {
                [self getMore];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)getMore{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/defaultReply?lastSort=%@",[[NoticeSaveModel getUserInfo] user_id],self.yuseLastId] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]){
                NoticeYuSetModel *model = [NoticeYuSetModel mj_objectWithKeyValues:dic];
                model.isTrueStr = YES;
                [self.yuseStrArr addObject:model];
                if (model.resource_type.intValue == 1) {
                    [self.yuseArr addObject:model];
                }else{
                    [self.yuseImgArr addObject:model];
                }
                hasData = YES;
            }
            
            if (self.yuseStrArr.count) {
                NoticeYuSetModel *lastM = self.yuseStrArr[self.yuseStrArr.count-1];
                self.yuseLastId = lastM.reply_sort;
            }
            if (hasData) {
                [self getMore];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)setYuseClick{
    NoticeSetYuReplyController *ctl = [[NoticeSetYuReplyController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)requestReplay{
    [self requestYUse:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.chatInputView regFirst];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-91-NAVIGATION_BAR_HEIGHT);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    if(y > h -50) {
        self.canLoad = YES;
    }else{
        self.canLoad = NO;
    }
}

@end
