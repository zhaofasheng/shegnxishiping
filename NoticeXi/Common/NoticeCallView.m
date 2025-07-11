//
//  NoticeCallView.m
//  NoticeXi
//
//  Created by li lei on 2023/3/24.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeCallView.h"
#import "NoticeXi-Swift.h"
#import "NoticeShopJubaoView.h"
#import "NoticeShopjuBuView.h"
#import "SXTcallTimer.h"
#import <Bugly/Bugly.h>

@interface NoticeCallView()

@property (nonatomic, strong) StarsOverlay *starsView;
@property (nonatomic, strong) NSMutableDictionary *parm;
@property (nonatomic, strong) UILabel *jubaoL;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *goodNameL;
@end

@implementation NoticeCallView

{
    UIView *_volumeView;
    UIView *_userVolumeView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor blackColor];
        //设备踢下线
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherlogin) name:@"otherLoginClearDataNOTICATION" object:nil];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        imageView.image = UIImageNamed(@"calling_backimg");
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        self.starsView = [[StarsOverlay alloc] initWithFrame:imageView.bounds];
        [imageView addSubview:self.starsView];
        
        
        self.endButton = [[UIButton alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2, 60, 32)];
        self.endButton.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.endButton.layer.cornerRadius = 16;
        self.endButton.layer.masksToBounds = YES;
        self.endButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.endButton setTitle:@"结束" forState:UIControlStateNormal];
        [self.endButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self addSubview:self.endButton];
        [self.endButton addTarget:self action:@selector(endCall) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMiseeShow) name:@"SHOPOVERCHATORDER" object:nil];
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errroOver) name:@"NEEDOVERVOICECHAT" object:nil];
        //SHOPFINISHEDHOUTAI
        
        self.goodNameL = [[UILabel  alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+19, DR_SCREEN_WIDTH, 21)];
        self.goodNameL.textColor = [UIColor colorWithHexString:@"#CECCE1"];
        self.goodNameL.font = FIFTHTEENTEXTFONTSIZE;
        self.goodNameL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.goodNameL];
        
        self.shopIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-88*2-8)/2, NAVIGATION_BAR_HEIGHT+66, 88, 88)];
        self.shopIconImageView.layer.cornerRadius = 44;
        self.shopIconImageView.layer.masksToBounds = YES;
        self.shopIconImageView.userInteractionEnabled = YES;
        [self addSubview:self.shopIconImageView];
        self.shopIconImageView.image = UIImageNamed(@"call_iconshop");
        
        _volumeView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, 88, 0)];
        _volumeView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0.2];
        [self.shopIconImageView addSubview:_volumeView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shopIconImageView.frame)-8, NAVIGATION_BAR_HEIGHT+66, 88, 88)];
        self.iconImageView.layer.cornerRadius = 44;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.userInteractionEnabled = YES;
        self.iconImageView.image = UIImageNamed(@"call_iconuser");
        [self addSubview:self.iconImageView];
        
        _userVolumeView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, 88, 0)];
        _userVolumeView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0.2];
        [self.iconImageView addSubview:_userVolumeView];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.iconImageView.frame)+30, DR_SCREEN_WIDTH, 22)];
        self.markL.textColor = [UIColor whiteColor];
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        self.markL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.markL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.markL.frame)+6, DR_SCREEN_WIDTH, 22)];
        self.timeL.textColor = [UIColor whiteColor];
        self.timeL.font = XGTwentyEigthBoldFontSize;
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.text = @"00:00:00";
        [self addSubview:self.timeL];
        
        UIView *markView = [[UIView  alloc] initWithFrame:CGRectMake(30, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-56, DR_SCREEN_WIDTH-60, 56)];
        markView.backgroundColor = [UIColor whiteColor];
        [markView setAllCorner:16];
        [self addSubview:markView];
        
        UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake(12, markView.frame.origin.y-16, 80, 80)];
        imageV.image = UIImageNamed(@"sx_voicechatmark_img");
        [self addSubview:imageV];
        
        self.markLabel = [[UILabel  alloc] initWithFrame:CGRectMake(62, 8, markView.frame.size.width-65, 40)];
        self.markLabel.numberOfLines = 2;
        self.markLabel.font = THRETEENTEXTFONTSIZE;
        self.markLabel.textColor = [UIColor colorWithHexString:@"#14151A"];
        [markView addSubview:self.markLabel];
        
        self.timeOutL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeL.frame)+10, DR_SCREEN_WIDTH, 20)];
        self.timeOutL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.timeOutL.font = FOURTHTEENTEXTFONTSIZE;
        self.timeOutL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeOutL];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.timeL.frame)+(ISIPHONEXORLATER? 60 : 45), DR_SCREEN_WIDTH-60, 106)];
        contentView.backgroundColor = [[UIColor colorWithHexString:@"#373451"] colorWithAlphaComponent:0.8];
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
        
        CGFloat height = GET_STRHEIGHT(@"·通话期间请勿离开此页面，通话可能会中断\n\n·禁止政治敏感、色情暴力等内容，违规将封号处理", 12, DR_SCREEN_WIDTH-90);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,(106-height)/2, DR_SCREEN_WIDTH-90, height)];
        label.font = TWOTEXTFONTSIZE;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithHexString:@"#CECCE1"];
        label.text = @"·通话期间请勿离开此页面，通话可能会中断\n\n·禁止政治敏感、色情暴力等内容，违规将封号处理";
        [contentView addSubview:label];
        self.noticeL = label;
        
        self.muteButton = [[FSCustomButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-212)/2, CGRectGetMaxY(contentView.frame)+(ISIPHONEXORLATER? 45 : 35), 56, 82)];
        [self.muteButton setImage:UIImageNamed(@"tencent_openmuteimg") forState:UIControlStateNormal];//tencent_closemuteimg
        [self.muteButton setTitle:@"关麦" forState:UIControlStateNormal];
        self.muteButton.buttonImagePosition = FSCustomButtonImagePositionTop;
        [self.muteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.muteButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.muteButton addTarget:self action:@selector(mutClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.muteButton];
        
        self.mirButton = [[FSCustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.muteButton.frame)+100, CGRectGetMaxY(contentView.frame)+(ISIPHONEXORLATER? 45 : 35), 56, 82)];
        [self.mirButton setImage:UIImageNamed(@"tencent_openmirimg") forState:UIControlStateNormal];//tencent_closemirimg
        [self.mirButton setTitle:@"扩音" forState:UIControlStateNormal];
        self.mirButton.buttonImagePosition = FSCustomButtonImagePositionTop;
        [self.mirButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.mirButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.mirButton addTarget:self action:@selector(mirClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mirButton];
        
        UILabel *jubaoL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-60, STATUS_BAR_HEIGHT, 60, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        jubaoL.text = @"举报";
        jubaoL.font = SIXTEENTEXTFONTSIZE;
        jubaoL.textColor = [UIColor whiteColor];
        jubaoL.textAlignment = NSTextAlignmentRight;
        jubaoL.userInteractionEnabled = YES;
        UITapGestureRecognizer *jubaoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jubaoClick)];
        [jubaoL addGestureRecognizer:jubaoTap];
        [self addSubview:jubaoL];
        self.closeMicrophone = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasKillApp) name:@"APPWASKILLED" object:nil];
        self.jubaoL = jubaoL;
        
    }
    return self;
}


- (void)setFromUserId:(NSString *)fromUserId{
    _fromUserId = fromUserId;
    if (!_fromUserId) {
        return;
    }
    if([_fromUserId isEqualToString:[NoticeTools getuserId]]){//如果来电者是自己的，那么自己是买家，否则自己是卖家
        self.endButton.hidden = NO;
        self.markLabel.attributedText = [SXTools getStringWithLineHight:3 string:@"如遇异常情况，通话结束后，可在【买过的】找到此订单，点击「申请售后」"];
    }else{
        self.markLabel.attributedText = [SXTools getStringWithLineHight:3 string:@"订单结束后，如还有想对买家说的话\n可在【服务过的】找到订单「联系买家」"];
        
        self.endButton.hidden = YES;
        self.jubaoL.frame = CGRectMake(DR_SCREEN_WIDTH-15-102, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2, 102, 32);
        self.jubaoL.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.jubaoL.text = @"举报并结束";
        self.jubaoL.textAlignment = NSTextAlignmentCenter;
        [self.jubaoL setAllCorner:16];
    }
    DRLog(@"来电者%@  自己%@",fromUserId,[NoticeTools getuserId]);
}

- (void)setToUserId:(NSString *)toUserId{
    _toUserId = toUserId;
    if(!_toUserId){
        return;
    }
    if([_toUserId isEqualToString:[NoticeTools getuserId]]){//如果来电者是自己的，那么自己是买家，否则自己是卖家
        self.endButton.hidden = YES;
        self.jubaoL.frame = CGRectMake(DR_SCREEN_WIDTH-15-102, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2, 102, 32);
        self.jubaoL.backgroundColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.jubaoL.text = @"举报并结束";
        self.jubaoL.textAlignment = NSTextAlignmentCenter;
        [self.jubaoL setAllCorner:16];
        self.markLabel.attributedText = [SXTools getStringWithLineHight:3 string:@"订单结束后，如还有想对买家说的话\n可在【服务过的】找到订单「联系买家」"];
    }else{
        self.endButton.hidden = NO;
    }
    DRLog(@"打给%@ 自己%@",toUserId,[NoticeTools getuserId]);
}

- (void)jubaoClick{
    if(!self.roomId){
        return;
    }
    __weak typeof(self) weakSelf = self;
    if(self.fromUserId){//有来电者，说明自己是店主
        NoticeShopjuBuView *jubaoView = [[NoticeShopjuBuView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [jubaoView showJuBao];
        jubaoView.shopjubaoBlock = ^(NSInteger tag) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:weakSelf.roomId forKey:@"roomId"];
            [parm setObject:[NSString stringWithFormat:@"%ld",weakSelf.totalTime] forKey:@"second"];
            [parm setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"typeId"];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/report" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if(success){
                    DRLog(@"店主举报用户成功");
                    [weakSelf hanUp];
                    [weakSelf dissMiseeShow];
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"已举报，订单结束" message:@"收到举报，管理员会尽快处理，鲸币明细具体以审核结果为准，将通过「声昔小助手」告知，请注意查收！" cancleBtn:@"我知道了"];
                    [alerView showXLAlertView];
                }
            } fail:^(NSError * _Nullable error) {
            }];
        };
    }else{//没有来电者，有去电者，说明自己是买家
        if(self.toUserId){
            NoticeShopJubaoView *jubaoView = [[NoticeShopJubaoView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            [jubaoView showJuBao];
            jubaoView.shopjubaoBlock = ^(NSInteger tag) {
                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                [parm setObject:weakSelf.roomId forKey:@"roomId"];
                [parm setObject:[NSString stringWithFormat:@"%ld",weakSelf.totalTime] forKey:@"second"];
                [parm setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"typeId"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder/report" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if(success){
                        DRLog(@"用户举报店主成功");
                        [weakSelf hanUp];
                        [weakSelf dissMiseeShow];
                        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"已举报，订单结束" message:@"收到举报，管理员会尽快处理，鲸币明细具体以审核结果为准，将通过「声昔小助手」告知，请注意查收！" cancleBtn:@"我知道了"];
                        [alerView showXLAlertView];
                    }
                } fail:^(NSError * _Nullable error) {
                }];
            };
        }
    }
}

- (void)setRoomId:(NSString *)roomId{
    _roomId = roomId;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopGoodsOrder/getOrder/%@",roomId] Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.chatInfoModel = [NoticeChatingInfoModel mj_objectWithKeyValues:dict[@"data"]];
            self.chatInfoModel.secondOrign = self.chatInfoModel.second;
            [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:self.chatInfoModel.seller_img_url]];
            self.markL.text = [NSString stringWithFormat:@"可通话%@分钟 已通话",self.chatInfoModel.goods_duration];
            self.goodNameL.text = self.chatInfoModel.goods_name;
            if (self.fromUserId){//有来电者，说明自己是店主
                self.markLabel.attributedText = [SXTools getStringWithLineHight:3 string:@"订单结束后，如还有想对买家说的话\n可在【服务过的】找到订单「联系买家」"];
                if (self.chatInfoModel.is_experience.boolValue) {
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NSString stringWithFormat:@"当前通话为“语音通话·体验版”，用户可免费试聊%@分钟",self.chatInfoModel.goods_duration] message:nil cancleBtn:@"我知道了"];
                    [alerView showXLAlertView];
                }
                NSString *str = @"·通话期间请勿离开此页面，通话可能会中断\n·禁止政治敏感、色情暴力等内容，违规将封号处理";
                CGFloat height = GET_STRHEIGHT(str, 12, DR_SCREEN_WIDTH-90);
                self.noticeL.frame = CGRectMake(15,(106-height)/2, DR_SCREEN_WIDTH-90, height);
                self.noticeL.text = str;
            }else if(self.toUserId){//有去电者，说明自己是买家
                self.markLabel.attributedText = [SXTools getStringWithLineHight:3 string:@"如遇异常情况，通话结束后，可在【买过的】找到此订单，点击「申请售后」"];
                if (self.chatInfoModel.is_experience.boolValue) {//如果是免费时长，第一次没充值和付费之前聊天时长赋值为免费时长
                    self.chatInfoModel.second = self.chatInfoModel.experience_time;
                }
                
                self.iconImageView.image = UIImageNamed(@"selfisbuy_img");
                NSString *str = [NSString stringWithFormat:@"·聊天时长最多%@分钟，超时自动结束通话\n\n·通话期间请勿离开此页面，通话可能会中断\n\n·禁止政治敏感、色情暴力等内容，违规将封号处理",self.chatInfoModel.goods_duration];
                CGFloat height = GET_STRHEIGHT(str, 12, DR_SCREEN_WIDTH-90);
                self.noticeL.frame = CGRectMake(15,(106-height)/2, DR_SCREEN_WIDTH-90, height);
                self.noticeL.text = str;
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}


- (void)refreshStars{
    [self.starsView randomizeEmitterPosition];
}

- (void)setUserVolume:(CGFloat)userVolume{

    CGFloat height1 = userVolume * 0.88;
    _userVolumeView.frame = CGRectMake(0, 88-height1, 88, height1);
}

- (void)setShopVolume:(CGFloat)shopVolume{
    CGFloat height = shopVolume * 0.88;
    _volumeView.frame = CGRectMake(0, 88-height, 88, height);
}

//是否开扬声器
- (void)mirClick{

    
}

//是否关麦
- (void)mutClick{

}

- (void)hanUp{

}

//结束通话
- (void)endCall{
    
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:self.chatInfoModel.is_experience.boolValue? @"确定结束通话吗？" : @"提前结束通话，费用不退回，确定结束吗？" message:nil sureBtn:@"再想想" cancleBtn:@"结束" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [[LogManager sharedInstance] logInfo:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] logStr:[NSString stringWithFormat:@"%@手动挂断电话房间号%@时间%@",[NoticeTools getuserId],self.roomId,[SXTools getCurrentTime]]];
            [self hanUp];
            [weakSelf dissMiseeShow];
        }
    };
    [alerView showXLAlertView];
}

- (void)hasKillApp{
    
    [self hanUp];
    NSException *exception = [NSException exceptionWithName:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] reason:[NSString stringWithFormat:@"%@杀死app挂电话\n房间号%@\n时间%@\n",[NoticeTools getuserId],self.roomId,[SXTools getCurrentTime]] userInfo:nil];//数据上报
    [Bugly reportException:exception];
    [[LogManager sharedInstance] logInfo:[NSString stringWithFormat:@"用户id%@-通话-%@",[NoticeTools getuserId],[NoticeTools getNowTime]] logStr:[NSString stringWithFormat:@"%@杀死app挂断电话房间号%@时间%@",[NoticeTools getuserId],self.roomId,[SXTools getCurrentTime]]];
}

- (void)otherlogin{
    [self hanUp];

}

- (void)showCallView{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [rootWindow bringSubviewToFront:self];
    if(!self.timerName.length){
        [self startTimer];
    }
    if (self.fromUserId) {//如果有来电者，代表自己是店主，店主不需要挂断电话的按钮
     //   self.endButton.hidden = YES;
    }
    [self creatShowAnimation];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
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
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
 
    return format_time;
 
}

- (void)creatShowAnimation
{
    self.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)dissMiseeShow{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [SXTcallTimer deleteTimer:self.timerName];
    self.timerName = nil;
    [self removeFromSuperview];

}

- (void)startTimer{
    self.totalTime = 0;
    NSTimeInterval interval = 1.0;
    __weak typeof(self) weakSelf = self;
    self.timerName = [SXTcallTimer timerTask:^{
        
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.totalTime += (NSInteger)interval;
        strongSelf.timeL.text = [weakSelf getMMSSFromSS:[NSString stringWithFormat:@"%ld",strongSelf.totalTime]];
        
        if (weakSelf.chatTimeBlock) {
            weakSelf.chatTimeBlock(strongSelf.totalTime);
        }
        
        if(weakSelf.roomId){
            [weakSelf.parm setObject:@"shopOrderRoom" forKey:@"flag"];
            [weakSelf.parm setObject:weakSelf.roomId forKey:@"roomId"];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.socketManager sendMessage:weakSelf.parm];
        }
        
        if(weakSelf.chatInfoModel.second.intValue){
            if (weakSelf.toUserId){//买家
                if(((weakSelf.chatInfoModel.goods_duration.intValue*60) - strongSelf.totalTime) <= 30){
                    weakSelf.timeOutL.text = [NSString stringWithFormat:@"%lds后订单即将自动结束",(weakSelf.chatInfoModel.goods_duration.intValue*60) - strongSelf.totalTime];
                }
                if(((weakSelf.chatInfoModel.goods_duration.intValue*60) - strongSelf.totalTime) <= 1){
                    [weakSelf hanUp];
                    [weakSelf dissMiseeShow];
                }
            }
        }
    } start:0 interval:interval repeats:YES async:NO];
}

//双方都网络等原因无法通话，后台自动结束订单
- (void)errroOver{
    [self hanUp];
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"由于双方设备网络无法链接等情况导致通话中断" message:nil cancleBtn:@"好的，知道了"];
    [alerView showXLAlertView];
    [self dissMiseeShow];
}

- (NSMutableDictionary *)parm{
    if(!_parm){
        _parm = [[NSMutableDictionary alloc] init];
    }
    return _parm;
}

@end
