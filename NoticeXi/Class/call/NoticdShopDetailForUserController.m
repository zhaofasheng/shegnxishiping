//
//  NoticdShopDetailForUserController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/11.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticdShopDetailForUserController.h"
#import "NoticeByOfOrderModel.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "NoticeXi-Swift.h"
#import "NoticeJieYouGoodsComController.h"

#import "NoticeActShowView.h"
#import "NoticeOtherShopCardController.h"
#import "NoticeJieYouShopHeaderView.h"


@interface NoticdShopDetailForUserController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NoticeMyShopModel *timeModel;
@property (nonatomic, strong) NoticeMyShopModel *shopDetailM;
@property (nonatomic, strong) NoticeGoodsModel *choiceGoods;
@property (nonatomic, strong) NoticeByOfOrderModel *orderM;
@property (nonatomic, strong) NoticeActShowView *showView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, assign) BOOL isBuying;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIButton *freeButton;
@property (nonatomic, strong) UIButton *workButton;
@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) NoticeOtherShopCardController *cardVC;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) NoticeJieYouShopHeaderView *shopHeaderView;
@property (nonatomic, strong) UIView *sectionView;

@end

@implementation NoticdShopDetailForUserController

- (NoticeActShowView *)showView{
    if (!_showView) {
        _showView = [[NoticeActShowView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _showView.titleL.text = @"正在为您匹配新的店铺...";
    }
    return _showView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    appdel.noPop = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
    [self.shopHeaderView.timer invalidate];
    self.shopHeaderView.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat imgHeight = (DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)/2+NAVIGATION_BAR_HEIGHT;
    
    self.backImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, imgHeight)];
    [self.view addSubview:self.backImageView];
   // [self.view sendSubviewToBack:self.backImageView];
    self.backImageView.image = UIImageNamed(@"shopgroundback_img");
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    
    self.titles = @[@""];
    self.shopHeaderView = [[NoticeJieYouShopHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, imgHeight-NAVIGATION_BAR_HEIGHT-40-41-20)];
    
    __weak typeof(self) weakSelf = self;
    self.shopHeaderView.choiceUrlBlock = ^(NSString * _Nonnull choiceUrl) {
        [weakSelf.backImageView sd_setImageWithURL:[NSURL URLWithString:choiceUrl]];
    };
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,GET_STRWIDTH(@"商品的", 18, 50)*2+40,10)];
    self.categoryView.titles = self.titles;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#25262E"];
    self.categoryView.titleColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleFont = SIXTEENTEXTFONTSIZE;
    self.categoryView.titleSelectedFont = XGEightBoldFontSize;
    self.categoryView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
        _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:self.pagerView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 10)];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasKillApp) name:@"APPWASKILLED" object:nil];
    [self getShopRequest];
    [self getTime];
    
    //收到语音通话请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:@"HASGETSHOPVOICECHANTTOTICE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noAccepectOrder) name:@"SHOPNOACCEPECT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overFinish) name:@"SHOPFINISHEDHOUTAI" object:nil];//后台告知结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overFinish) name:@"SHOPHASJUBAOED" object:nil];//举报结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overFinish) name:@"SHOPFINISHED" object:nil];//买家结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopRequest) name:@"REFRESHMYWALLECT" object:nil];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"backwhtiess") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.startView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-10, DR_SCREEN_WIDTH, 40)];
    [self.view addSubview:self.startView];
    self.startView.backgroundColor = self.view.backgroundColor;
    
    self.freeButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 112, 40)];
    self.freeButton.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    [self.freeButton setAllCorner:20];
    [self.freeButton setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
    self.freeButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [self.freeButton setTitle:@"免费试聊" forState:UIControlStateNormal];
    [self.startView addSubview:self.freeButton];
    [self.freeButton addTarget:self action:@selector(freeClick) forControlEvents:UIControlEventTouchUpInside];

    self.workButton = [[UIButton alloc] initWithFrame:CGRectMake(147,0, DR_SCREEN_WIDTH-20-147, 40)];
    self.workButton.layer.cornerRadius = 20;
    self.workButton.layer.masksToBounds = YES;
    //渐变色
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF3C92"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FF68A3"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.workButton.frame), CGRectGetHeight(self.workButton.frame));
    self.gradientLayer = gradientLayer;
    [self.workButton.layer addSublayer:self.gradientLayer];
    [self.workButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.workButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.startView addSubview:self.workButton];
    [self.workButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];


}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getTime{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"adminConfig/1" Accept:@"application/vnd.shengxi.v5.4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.timeModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
        }
    } fail:^(NSError * _Nullable error) {
     
    }];
}

- (void)hasKillApp{
    DRLog(@"程序杀死");
    [self cancelOrder];
}

//取消订单
- (void)cancelOrder{
    if(self.isBuying && self.orderM.room_id){
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:@"2" forKey:@"orderType"];
        [parm setObject:self.orderM.room_id forKey:@"roomId"];
        [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                self.isBuying = NO;
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
    }
}

//获取店铺信息
- (void)getShopRequest{
  
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopInfo/%@",self.shopModel.shopId] Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.shopDetailM = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            self.shopModel = self.shopDetailM.myShopM;
            self.shopHeaderView.shopModel = self.shopDetailM;
            self.shopHeaderView.labelArr = self.shopDetailM.labelArr;
            self.cardVC.shopModel = self.shopDetailM;
   
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self showToastWithText:error.debugDescription];
    }];
}

- (void)overFinish{
    DRLog(@"刷新店铺鲸币数据");
    [self getShopRequest];
}

//通话无响应
- (void)noAccepectOrder{
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"订单已超时失效，请尝试其它店铺" message:nil cancleBtn:@"知道了"];
    [alerView showXLAlertView];
    if(!self.orderM.room_id){
        return;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.orderM.room_id forKey:@"roomId"];
    [parm setObject:@"4" forKey:@"orderType"];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            DRLog(@"商家无响应");
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)stopPlay{
    [self.cardVC stopPlay];
}

- (void)chongzhiView{
    NoticeChongZhiTosatView *payV = [[NoticeChongZhiTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    [payV showView];
}


- (void)hasMicBuyVoice:(NoticeGoodsModel *)goodM{
    self.choiceGoods = goodM;
    [self.cardVC stopPlay];
    if ([self.shopModel.user_id isEqualToString:[NoticeTools getuserId]]) {
        [self showToastWithText:@"不能给自己下单哦~"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    if((self.shopDetailM.jingbi.intValue < goodM.price.intValue) && !goodM.is_experience.boolValue){
        [NoticeQiaojjieTools showWithTitle:@"你的鲸币余额不足，无法使用此功能~" msg:@"" button1:@"再想想" button2:@"充值" clickBlcok:^(NSInteger tag) {
            [weakSelf chongzhiView];
        }];
        return;
    }
    
    NSString *titleStr = [NSString stringWithFormat:@"本次咨询可通话%@分钟，提前结束费用不退回，确定下单？",goodM.duration];
    NSString *markStr = [NSString stringWithFormat:@"·聊天最多%@分钟\n·聊天双方都是匿名的\n·聊天记录不会保留",goodM.duration];
    if (goodM.is_experience.boolValue) {
        titleStr = [NSString stringWithFormat:@"当前店铺还有%@次“免费\n试聊%d分钟”的机会，确定下单？",goodM.experience_times,goodM.experience_time.intValue/60];
        markStr =  [NSString stringWithFormat:@"·免费试聊%d分钟\n·聊天双方都是匿名的\n·聊天记录不会保留",goodM.experience_time.intValue/60];
    }
    NoticeShopXiaDanTostaView *sureView = [[NoticeShopXiaDanTostaView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    sureView.titleL.text = titleStr;
    sureView.titleL.frame = CGRectMake(10, 15, 260, GET_STRHEIGHT(sureView.titleL.text, 16, sureView.titleL.frame.size.width-20)+10);
    sureView.contentL.text = markStr;
    sureView.contentL.frame = CGRectMake(48,CGRectGetMaxY(sureView.titleL.frame)+5, 280-48, 108);
    sureView.sureXdBlock = ^(NSInteger index) {
        [weakSelf buyVoice:goodM autoNext:NO needAudo:NO];
    };
    if (goodM.is_experience.boolValue) {
        sureView.autoButton.hidden = YES;
    }
    [sureView showView];
    if (goodM.is_experience.boolValue) {//如果是体验版，强行不自动匹配
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.audioChatTools.autoCallNexttext = NO;
        appdel.audioChatTools.autoCallNext = NO;
    }
}

- (void)buyVoice:(NoticeGoodsModel *)goodM autoNext:(BOOL)autoNext needAudo:(BOOL)needAudo{
    __weak typeof(self) weakSelf = self;
    self.choiceGoods = goodM;
    
    [self showHUD];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:weakSelf.choiceGoods.goodId forKey:@"goodsId"];
    [parm setObject:weakSelf.choiceGoods.shop_id forKey:@"shopId"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [weakSelf hideHUD];
        if(success){
            weakSelf.orderM = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
            weakSelf.isBuying = YES;
            
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            if(!weakSelf.shopDetailM.myShopM.user_id && !autoNext){
                [weakSelf showToastWithText:@"找不到店主Id"];
                return;
            }
            if (needAudo) {
                appdel.audioChatTools.autoCallNext = YES;
            }
            
            [appdel.audioChatTools callToUserId:@"2" roomId:weakSelf.orderM.room_id.intValue getOrderTime:autoNext?weakSelf.choiceGoods.match_time : weakSelf.orderM.get_order_time nickName:weakSelf.orderM.user_nick_name autoNext:autoNext];
            
            //[appdel.audioChatTools callToUserId:autoNext?weakSelf.choiceGoods.shop_user_id: weakSelf.shopDetailM.myShopM.user_id roomId:weakSelf.orderM.room_id.intValue getOrderTime:autoNext?weakSelf.choiceGoods.match_time : weakSelf.orderM.get_order_time nickName:weakSelf.orderM.user_nick_name autoNext:autoNext];
            
            appdel.audioChatTools.cancelBlcok = ^(BOOL cancel) {
                [weakSelf cancelOrder];
            };
            
            appdel.audioChatTools.autoNextBlcok = ^(BOOL next) {
                [weakSelf autoNext];
            };
            
            appdel.audioChatTools.repjectBlcok = ^(BOOL cancel) {
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"对方暂无法接单\n请尝试其他店铺" message:nil cancleBtn:@"知道了"];
                [alerView showXLAlertView];
            };
            
            appdel.audioChatTools.repjectautoNextBlcok = ^(BOOL next) {
                weakSelf.isBuying = NO;
                [weakSelf.showView show];
                [weakSelf getNextVoiceShop];
            };
        }else{
            NoticeOneToOne *allM = [NoticeOneToOne mj_objectWithKeyValues:dict];
            if(allM.code.intValue == 288){//用户余额不足
                [NoticeQiaojjieTools showWithTitle:@"你的鲸币余额不足，需要充值才能继续下单噢" msg:@"" button1:@"再想想" button2:@"充值" clickBlcok:^(NSInteger tag) {
                    [weakSelf chongzhiView];
                }];
            }else{
                [NoticeQiaojjieTools showWithTitle:allM.msg];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [weakSelf hideHUD];
        [weakSelf showToastWithText:error.description];
    }];
}

//取消当前订单之后自动匹配下一单
- (void)autoNext{
    //自动拨打之前，取消上一单
    [self.showView show];
    if(self.isBuying && self.orderM.room_id){
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:@"2" forKey:@"orderType"];
        [parm setObject:self.orderM.room_id forKey:@"roomId"];
        [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            self.isBuying = NO;
            [self getNextVoiceShop];
        } fail:^(NSError * _Nullable error) {
            self.isBuying = NO;
            [self getNextVoiceShop];
        }];
    }else{
        [self.showView disMiss];
    }
}

- (void)getNextVoiceShop{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"matchShop/%@/%@",self.choiceGoods.shop_id,self.choiceGoods.goodId] Accept:@"application/vnd.shengxi.v5.5.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.showView disMiss];
        if (success) {
            NoticeGoodsModel *goodsM = [NoticeGoodsModel mj_objectWithKeyValues:dict[@"data"]];
            if (goodsM.goods_id.intValue > 0 && goodsM.shop_id.intValue > 0) {
                goodsM.goodId = goodsM.goods_id;
                goodsM.type = @"2";
                [self buyVoice:goodsM autoNext:YES needAudo:YES];
            }else{
                appdel.audioChatTools.autoCallNext = NO;
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"当前没有空闲店铺" message:nil cancleBtn:@"好的，知道了"];
                [alerView showXLAlertView];
            }
           
        }else{
            appdel.audioChatTools.autoCallNext = NO;
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"当前没有空闲店铺" message:nil cancleBtn:@"好的，知道了"];
            [alerView showXLAlertView];
        }
    } fail:^(NSError * _Nullable error) {
        appdel.audioChatTools.autoCallNext = NO;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"当前没有空闲店铺" message:nil cancleBtn:@"好的，知道了"];
        [alerView showXLAlertView];
        [self.showView disMiss];
    }];
}

- (void)buyVoiceChat:(NoticeGoodsModel *)goodM{
    if ([self.shopModel.user_id isEqualToString:[NoticeTools getuserId]]) {
        [self showToastWithText:@"不能给自己下单哦~"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) { // 有使用麦克风的权限
                [weakSelf hasMicBuyVoice:goodM];
            }else { // 没有麦克风权限
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.kaiqire"] message:@"有麦克风权限才可以语音通话功能哦~" sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        UIApplication *application = [UIApplication sharedApplication];
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([application canOpenURL:url]) {
                            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                if (@available(iOS 10.0, *)) {
                                    [application openURL:url options:@{} completionHandler:nil];
                                }
                            } else {
                                [application openURL:url options:@{} completionHandler:nil];
                            }
                        }
                    }
                };
                [alerView showXLAlertView];
            }
        });
    }];
}

- (NoticeOtherShopCardController *)cardVC{
    
    if(!_cardVC){
        _cardVC = [[NoticeOtherShopCardController alloc] init];
        __weak typeof(self) weakSelf = self;
        _cardVC.refreshShopModel = ^(BOOL refresh) {
            [weakSelf getShopRequest];
        };
  
        _cardVC.buyGoodsBlock = ^(NoticeGoodsModel * _Nonnull buyGood) {
            buyGood.shop_id = weakSelf.shopModel.shopId;
            [weakSelf buyVoiceChat:buyGood];
        };
        
        _cardVC.refreshGoodsBlock = ^(NSMutableArray * _Nonnull goodsArr) {
            weakSelf.goodsArr = goodsArr;
            
            if (weakSelf.goodsArr.count) {
                weakSelf.startView.hidden = NO;
                BOOL hasFree = NO;
                for (NoticeGoodsModel *goods in goodsArr) {
                    if (goods.is_experience.boolValue) {
                        hasFree = YES;
                    }else{
                        NSString *str1 = [NSString stringWithFormat:@"%@",goods.price];
                        NSString *str2 = [NSString stringWithFormat:@"鲸币/%@分钟",goods.duration];
                        [weakSelf.workButton setAttributedTitle:[DDHAttributedMode setString:[NSString stringWithFormat:@"%@%@",str1,str2] setSize:12 setLengthString:str2 beginSize:str1.length] forState:UIControlStateNormal];
                        
                    }
                }
                if (hasFree) {
                    weakSelf.freeButton.hidden = NO;
                    weakSelf.workButton.frame = CGRectMake(147,0, DR_SCREEN_WIDTH-20-147, 40);
                }else{
                    weakSelf.freeButton.hidden = YES;
                    weakSelf.workButton.frame = CGRectMake(20,0, DR_SCREEN_WIDTH-40, 40);
                }
                
                weakSelf.gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(weakSelf.workButton.frame), CGRectGetHeight(weakSelf.workButton.frame));
            }else{
                weakSelf.startView.hidden = YES;
            }
        };
    }
    return _cardVC;
}

- (void)freeClick{
    for (NoticeGoodsModel *goods in _goodsArr) {
        if (goods.is_experience.boolValue) {
            goods.shop_id = self.shopModel.shopId;
            [self buyVoiceChat:goods];
            break;
        }
    }
}

- (void)startClick{
    for (NoticeGoodsModel *goods in _goodsArr) {
        if (!goods.is_experience.boolValue) {
            goods.shop_id = self.shopModel.shopId;
            [self buyVoiceChat:goods];
            break;
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    self.pagerView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+40, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT-50-40);
    self.pagerView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.shopHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.shopHeaderView.frame.size.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView.frame.size.height;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
    
    
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    return self.cardVC;
}


#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
