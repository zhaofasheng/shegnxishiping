//
//  SXShoperChatToUseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShoperChatToUseController.h"
#import "SXShopChatTouserHeadere.h"
#import "SXOrderChatCell.h"
#import "NoticeXi-Swift.h"
#import "NoticeYuSetModel.h"
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
#import "NoticdShopDetailForUserController.h"
@interface SXShoperChatToUseController ()<NoticeReceveMessageSendMessageDelegate,NoticeOrderChatDeledate,LCActionSheetDelegate,NewSendTextDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) SXShopChatTouserHeadere *headerView;
@property (nonatomic, strong) SXChatInputView *chatInputView;

@property (nonatomic, strong) SXSendChatTools *sendTools;

@property (nonatomic, assign) NSInteger oldSection;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) NSMutableArray *nolmorLdataArr;
@property (nonatomic, strong) NSMutableArray *localdataArr;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSString *chatId;
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
@property (nonatomic, strong) NSString *toUser;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, assign) NSInteger messageNum;

@property (nonatomic, assign) CGFloat tableViewOrinY;
@property (nonatomic, strong) NoticeChats *reSendChat;

@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;

@property (nonatomic, assign) NSInteger oldSelectIndex;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@end

@implementation SXShoperChatToUseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = [[SXShopChatTouserHeadere  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 117)];
    self.headerView.orderModel = self.orderModel;
    self.tableView.tableHeaderView = self.headerView;

    self.canLoad = YES;
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

    [self.tableView registerClass:[SXOrderChatCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+(self.isbuyer?50:0), DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-91-NAVIGATION_BAR_HEIGHT-(self.isbuyer?50:0));
    
    if (!self.isbuyer) {
        self.chatInputView = [[SXChatInputView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-91, DR_SCREEN_WIDTH, 91)];
        [self.view addSubview:self.chatInputView];
    }

    
    if (self.isbuyer) {
        self.headerView.orderL.text = [NSString stringWithFormat:@"下单时间：%@",self.orderModel.created_at];
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+(self.isbuyer?50:0), DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-(self.isbuyer?0:91)-NAVIGATION_BAR_HEIGHT-(self.isbuyer?50:0));
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+8, DR_SCREEN_WIDTH, 32)];
        markL.text = @"添加陌生人聊天账号需谨慎，请勿随意向陌生人转账";
        markL.textAlignment = NSTextAlignmentCenter;
        markL.font = TWOTEXTFONTSIZE;
        markL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        markL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        [self.view addSubview:markL];
        
        _userView = [[UIView  alloc] initWithFrame:CGRectMake(59, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-69, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [self.navBarView addSubview:_userView];
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,(_userView.frame.size.height-44)/2,44, 44)];
        _iconImageView.layer.cornerRadius = 22;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.orderModel.shop_avatar_url]];
        [_userView addSubview:_iconImageView];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-16, CGRectGetMaxY(_iconImageView.frame)-16,16, 16)];
        self.markImage.image = UIImageNamed(@"sxrenztub_img");
        [_userView addSubview:self.markImage];
        self.markImage.hidden = self.orderModel.is_certified.boolValue?NO:YES;
                
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+8,0,180, _userView.frame.size.height)];
        _nickNameL.font = XGEightBoldFontSize;
        _nickNameL.text = self.orderModel.shop_user_id;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [_userView addSubview:_nickNameL];
        
        UIButton *lookBtn = [[UIButton  alloc] initWithFrame:CGRectMake(_userView.frame.size.width-72-15, (_userView.frame.size.height-32)/2, 72, 32)];
        lookBtn.layer.cornerRadius = 16;
        lookBtn.layer.masksToBounds = YES;
        //渐变色
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FFA2CC"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FF60B3"].CGColor];//#FF3C92
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(lookBtn.frame), CGRectGetHeight(lookBtn.frame));
        [lookBtn.layer addSublayer:gradientLayer];
        [lookBtn setTitle:@"进店看看" forState:UIControlStateNormal];
        [lookBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        lookBtn.titleLabel.font = TWOTEXTFONTSIZE;
        [_userView addSubview:lookBtn];
        [lookBtn addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self funForInputView];
    
    self.pageNo = 1;
    [self createRefesh];
    [self requestData];

    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.orderChatDelegate = self;
    
    if ([self.toUserId isEqualToString:@"1"]) {//如果是客服，则不显示举报按钮
        self.navigationItem.title = @"声昔小二";
    }
    
    if (self.toUserId) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)lookClick{
    NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
    NoticeMyShopModel *model = [[NoticeMyShopModel alloc] init];
    model.shopId = self.orderModel.shop_id;
    ctl.shopModel = model;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (SXSendChatTools *)sendTools{
    if (!_sendTools) {
        _sendTools = [[SXSendChatTools alloc] init];
        _sendTools.orderId = self.orderModel.orderId;
        _sendTools.toUser = self.orderModel.user_id;
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
        weakSelf.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+(self.isbuyer?50:0), DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-(self.isbuyer?0:91)-NAVIGATION_BAR_HEIGHT-(self.isbuyer?50:0));
        weakSelf.canLoad = YES;
        [weakSelf scroToBottom];
    };
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, BOTTOM_HEIGHT)];
    bottomV.backgroundColor = self.chatInputView.backgroundColor;
    [self.view addSubview:bottomV];
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

        return 28+chat.textHeight+16;
    }
    
   
    if (chat.isShowTime) {
        if (chat.resource_type.intValue == 3) {
            return 45+28+16;
            
        }
        return 28+(chat.imgCellHeight?chat.imgCellHeight: 138)+16;
    }
    

    if (chat.resource_type.intValue == 3) {
        return 35+28;
    }
    return 28+ (chat.imgCellHeight?chat.imgCellHeight: 138);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXOrderChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.currentPath = indexPath;
    __weak typeof(self) weakSelf = self;
    cell.refreshHeightBlock = ^(NSIndexPath * _Nonnull indxPath) {
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        [weakSelf scroToBottom];
    };
    
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


- (void)requestData{
    NSString *url = nil;

  
    if (self.isFirst) {
        url = [NSString stringWithFormat:@"orderComment/%@?pageNo=1",self.orderModel.orderId];
    }else{
        url = [NSString stringWithFormat:@"orderComment/%@?pageNo=%ld",self.orderModel.orderId,self.pageNo];
    }
    
    [self requestWith:url];
}

- (void)requestWith:(NSString *)url{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
        
            NSMutableArray *newArr = [NSMutableArray new];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeChats *model = [NoticeChats mj_objectWithKeyValues:dic];
                if (model.resource_type.intValue == 1) {
                    model.contentText = model.resource_uri;
                }
                if (model.resource_type.intValue > 3) {
                    model.resource_type = @"1";
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
            }
            
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
         
        }
    } fail:^(NSError *error) {
        if ([NoticeComTools pareseError:[NSError new]]) {

        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
    
    __weak SXShoperChatToUseController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo ++;
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
        
        SXOrderChatCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
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

- (void)backChatMsg{
    
    if ([self.currentModel.dialog_id isEqualToString:self.tapChat.dialog_id]) {
        [self.audioPlayer stopPlaying];
    }
    self.noAuto = YES;
    
    NSMutableDictionary * dsendDic = [NSMutableDictionary new];
    [dsendDic setObject:[NSString stringWithFormat:@"%@%@",socketADD,self.orderModel.user_id] forKey:@"to"];
    [dsendDic setObject:@"orderComment" forKey:@"flag"];
    [dsendDic setObject:@"delete" forKey:@"action"];
    
    NSMutableDictionary *messageDic = [NSMutableDictionary new];

    [messageDic setObject:self.tapChat.tuyaDiaLogId forKey:@"id"];
    [dsendDic setObject:messageDic forKey:@"data"];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel.socketManager sendMessage:dsendDic];
    
    
    for (NoticeChats *chatAll in self.dataArr) {
        if ([chatAll.tuyaDiaLogId isEqualToString:self.tapChat.tuyaDiaLogId] || [chatAll.tuyaDiaLogId isEqualToString:self.tapChat.tuyaDiaLogId]) {
            [self.dataArr removeObject:chatAll];
            break;
        }
    }
    
    for (NoticeChats *chatAll in self.localdataArr) {
        if ([chatAll.tuyaDiaLogId isEqualToString:self.tapChat.tuyaDiaLogId] || [chatAll.tuyaDiaLogId isEqualToString:self.tapChat.tuyaDiaLogId]) {
            [self.localdataArr removeObject:chatAll];
            break;
        }
    }
    
    for (NoticeChats *norChat in self.nolmorLdataArr) {
        if ([norChat.tuyaDiaLogId isEqualToString:self.tapChat.tuyaDiaLogId] || [norChat.tuyaDiaLogId isEqualToString:self.tapChat.tuyaDiaLogId]) {
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
        if (self.tapChat.resource_type.intValue == 1) {
            arr = @[[RXPopMenuItem itemTitle:@"撤回"],[RXPopMenuItem itemTitle:@"复制"]];
        }
    }else{
        if (self.tapChat.resource_type.intValue == 1) {
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
        }else if([item.title isEqualToString:@"举报"]){
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = weak.tapChat.tuyaDiaLogId;
            juBaoView.reouceType = @"150";
            [juBaoView showView];
        }else if([item.title isEqualToString:@"复制"]){
            [self showToastWithText:@"已复制"];
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            [pastboard setString:self.tapChat.contentText];
        }
    };
}

- (void)setAleryRead:(NoticeChats *)chat{
   
    chat.read_at = [NoticeTools getNowTimeTimestamp];
    [self.tableView reloadData];

    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"orderComment/read/%@",chat.tuyaDiaLogId] Accept:@"application/vnd.shengxi.v5.8.3+json" parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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

- (void)didReceiveOrderChatMessage:(id)message{
  
    NoticeAction *ifDelegate = [NoticeAction mj_objectWithKeyValues:message];
    NoticeChats *chat = [ NoticeChats mj_objectWithKeyValues:message[@"data"]];

    if ([chat.flag isEqualToString:@"1"]) {
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
    
    
    chat.read_at = @"0";
    if (![chat.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo]user_id]]) {//当发送人不是自己的时候，需要判断是否是当前会话人发来的消息，不然容易消息错误
        if (![chat.to_user_id isEqualToString:[NoticeTools getuserId]]) {//别人发来的消息，判断是否是当前对话人
   
            return;
        }
    }else{//发送人是自己的时候
        self.noAuto = NO;
    }
    
    BOOL alerady = NO;
    for (NoticeChats *olM in self.localdataArr) {//判断是否有重复数据
        if ([olM.tuyaDiaLogId isEqualToString:chat.tuyaDiaLogId]) {
            alerady = YES;
            break;
        }
    }
    
    if (!alerady) {
        self.chatId = chat.chat_id;

        if(chat.resource_type.intValue == 1){
            chat.contentText = chat.resource_uri;
        }
        [self.localdataArr addObject:chat];
        [self.tableView reloadData];
        
        if (!self.canLoad) {
            self.messageNum++;
        }
    }
    [self scroToBottom];
}


- (NSMutableArray *)cacheArr{
    if (!_cacheArr) {
        _cacheArr = [NSMutableArray new];
    }
    return _cacheArr;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.chatInputView regFirst];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+(self.isbuyer?50:0), DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-(self.isbuyer?0:91)-NAVIGATION_BAR_HEIGHT-(self.isbuyer?50:0));
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
