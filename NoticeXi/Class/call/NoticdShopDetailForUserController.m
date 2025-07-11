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
#import "NoticeMoreClickView.h"
#import "NoticeActShowView.h"
#import "NoticeOtherShopCardController.h"
#import "NoticeJieYouShopHeaderView.h"
#import "SXAboutShoperController.h"
#import "SXShoperSayController.h"
#import "SXShopSayListModel.h"
@interface NoticdShopDetailForUserController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate,NoticeReceveMessageSendMessageDelegate,LCActionSheetDelegate>

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

@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) NoticeOtherShopCardController *cardVC;
@property (nonatomic, strong) SXAboutShoperController *aboutVC;
@property (nonatomic, strong) SXShoperSayController *sayVC;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) NoticeJieYouShopHeaderView *shopHeaderView;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIView *noWorkingView;
@property (nonatomic, assign) BOOL isExperince;
@property (nonatomic, assign) BOOL cancelAndAutoNext;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UILabel *infoButton;
@property (nonatomic, strong) UILabel *orderButton;
@property (nonatomic, strong) UILabel *comButton;
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
    
    if (!self.shopModel.is_collection.boolValue) {
        if (self.cancelLikeBolck) {
            self.cancelLikeBolck(self.shopModel.shopId);
        }
    }
    [self.shopHeaderView.headerView stopPlay];
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
    
    self.titles = @[@"",@"",@""];
    self.shopHeaderView = [[NoticeJieYouShopHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, imgHeight-NAVIGATION_BAR_HEIGHT-40-41-20+156)];
    self.shopHeaderView.islookSelf = NO;
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
    
    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    self.sectionView.backgroundColor = [UIColor whiteColor];
    [self.sectionView addSubview:self.infoButton];
    [self.sectionView addSubview:self.orderButton];
    [self.sectionView addSubview:self.comButton];

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
    //推荐通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getsaytuijianNotice:) name:@"SXtuijianshopsayNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopRequest) name:@"REFRESHSHOPDETAIL" object:nil];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"backwhtiess") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-32, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2,32, 32)];
    [shareBtn setImage:UIImageNamed(@"sx_funshop_img") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(funClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    self.likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-32-20-32, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2,32, 32)];
    [self.likeBtn setImage:UIImageNamed(@"sx_likeshop_img") forState:UIControlStateNormal];//sx_likeshopn_img
    [self.likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.likeBtn];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.shopOrderDelegate = self;
    
    self.categoryView.defaultSelectedIndex = 1;
    [self categoryCurentIndex:1];
}

- (void)getsaytuijianNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *shopid = nameDictionary[@"shopId"];
    NSString *isTuiJian = nameDictionary[@"is_tuijian"];
    if ([self.shopModel.shopId isEqualToString:shopid]) {
        self.shopModel.is_recommend = isTuiJian;
    }
}

- (void)didReceiveShopOrderStatus:(NSString *)shopId{
    if ([shopId isEqualToString:self.shopModel.shopId]) {
        [self getShopRequest];
    }
}

- (UIView *)noWorkingView{
    if (!_noWorkingView) {
        _noWorkingView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        _noWorkingView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
        [self.view addSubview:_noWorkingView];
        
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(0, 10, DR_SCREEN_WIDTH, 25)];
        label.text = @"店铺休息中，可先收藏店铺噢";
        label.font = EIGHTEENTEXTFONTSIZE;
        self.markL = label;
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.textAlignment = NSTextAlignmentCenter;
        [_noWorkingView addSubview:label];
    }
    return _noWorkingView;
}

- (void)funClick{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[@"分享给好友",self.shopModel.is_black.intValue==1?@"取消拉黑该店铺" : @"拉黑该店铺",self.shopModel.is_recommend.boolValue?@"取消推荐该店铺": @"推荐该店铺"]];
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self shareClick];
    }else if (buttonIndex == 2){
        if (self.shopModel.is_black.boolValue) {
            [self laheishop];
        }else{
            __weak typeof(self) weakSelf = self;
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定拉黑该店铺？" message:@"拉黑后，你们将互相看不到对方店铺相关内容，与对方的互动内容也会被清除，解除拉黑后不会恢复。。" sureBtn:@"取消" cancleBtn:@"拉黑" right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    [weakSelf laheishop];
                }
            };
            [alerView showXLAlertView];
        }

    }else if (buttonIndex == 3){
        [SXShopSayListModel tuijiandinapu:self.shopModel.shopId tuijian:self.shopModel.is_recommend.boolValue?NO:YES];
    }
}

//拉黑店铺
- (void)laheishop{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopBlack/%@/%@",self.shopModel.shopId,self.shopModel.is_black.boolValue?@"0":@"1"] Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.shopModel.is_black.intValue == 1) {
                [[NoticeTools getTopViewController] showToastWithText:@"已取消拉黑"];
            }else{
                [[NoticeTools getTopViewController] showToastWithText:@"已拉黑"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SXlaheishopNotification" object:self userInfo:@{@"shopId":self.shopModel.shopId}];
            }
            [self getShopRequest];
           
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)refreshLhaeiUI{
    if (self.shopModel.operate_status.intValue > 1) {
        _noWorkingView.hidden = YES;
    }else{
        self.noWorkingView.hidden = NO;
        self.markL.text = @"店铺休息中，可先收藏店铺噢";
    }
    if (self.shopModel.is_black.boolValue) {
        self.noWorkingView.hidden = NO;
        [self.categoryView setDefaultSelectedIndex:0];
        self.comButton.hidden = YES;
        self.infoButton.hidden = YES;
        self.orderButton.hidden = YES;
        [self.categoryView reloadData];
        if (self.shopModel.is_black.intValue == 1) {
            self.markL.text = @"已拉黑对方，无法查看店铺内容";
        }else if (self.shopModel.is_black.intValue == 2){
            self.markL.text = @"对方已拉黑你，无法查看店铺内容";
        }
        
    }else{
        [self.categoryView setDefaultSelectedIndex:1];
        self.comButton.hidden = NO;
        self.infoButton.hidden = NO;
        self.orderButton.hidden = NO;
        [self.categoryView reloadData];
    }
}


//分享店铺
- (void)shareClick{
    if (!self.shopDetailM) {
        return;
    }
    
    NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    moreView.isShare = YES;
    moreView.imgUrl = self.shopModel.shop_avatar_url;
    moreView.shareUrl = self.shopModel.shopShareUrl;
    moreView.wechatShareUrl = self.shopModel.wechatShareUrl;
    moreView.image = self.shopHeaderView.headerView.iconImageView.image;
    moreView.name = @"快来声昔找我聊聊吧";
    moreView.title = [NSString stringWithFormat:@"%@的咨询主页",self.shopModel.shop_name];
    [moreView showTost];
}

//收藏店铺
- (void)likeClick{
    if (!self.shopDetailM) {
        return;
    }
    
    if ([self.shopModel.user_id isEqualToString:[NoticeTools getuserId]]) {
        [self showToastWithText:@"不能收藏自己的店铺哦~"];
        return;
    }
    
    [self showHUD];
    self.shopModel.is_collection = self.shopModel.is_collection.boolValue?@"0":@"1";
    [self.likeBtn setImage:self.shopModel.is_collection.boolValue?UIImageNamed(@"sx_likeshopn_img"): UIImageNamed(@"sx_likeshop_img") forState:UIControlStateNormal];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.shopModel.shopId forKey:@"shopId"];
    [parm setObject:self.shopModel.is_collection.boolValue?@"1":@"2" forKey:@"type"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopCollection/collect" Accept:@"application/vnd.shengxi.v5.8.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.shopModel.is_collection.boolValue) {
                [self showToastWithText:@"收藏成功"];
            }
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)dealloc{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"leaveShopInfo/%@",self.shopModel.shopId] Accept:@"application/vnd.shengxi.v5.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
    } fail:^(NSError * _Nullable error) {
    }];
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
                if (!self.cancelAndAutoNext) {
                    self.isBuying = NO;
                }
                
            }
            if (self.cancelAndAutoNext) {
                self.cancelAndAutoNext = NO;
                [self autoNext];
            }
            
        } fail:^(NSError * _Nullable error) {
            if (self.cancelAndAutoNext) {
                self.cancelAndAutoNext = NO;
                [self autoNext];
            }
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
            self.aboutVC.shopModel = self.shopDetailM.myShopM;
            self.sayVC.shopModel = self.shopDetailM.myShopM;
            [self.likeBtn setImage:self.shopModel.is_collection.boolValue?UIImageNamed(@"sx_likeshopn_img"): UIImageNamed(@"sx_likeshop_img") forState:UIControlStateNormal];
            if (self.shopModel.operate_status.intValue > 1) {
                _noWorkingView.hidden = YES;
            }else{
                self.noWorkingView.hidden = NO;
                self.markL.text = @"店铺休息中，可先收藏店铺噢";
            }
            [self refreshLhaeiUI];
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
    [self.shopHeaderView.headerView stopPlay];
}

- (void)chongzhiView{
    NoticeChongZhiTosatView *payV = [[NoticeChongZhiTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    [payV showView];
}


- (void)hasMicBuyVoice:(NoticeGoodsModel *)goodM{
    self.choiceGoods = goodM;
    [self.shopHeaderView.headerView stopPlay];
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
    self.isExperince = NO;
    NSString *titleStr = [NSString stringWithFormat:@"本次咨询可通话%@分钟，提前结束费用不退回，确定下单？",goodM.duration];
    NSString *markStr = [NSString stringWithFormat:@"·聊天最多%@分钟\n·聊天双方都是匿名的\n·聊天记录不会保留",goodM.duration];
    if (goodM.is_experience.boolValue) {
        self.isExperince = YES;
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
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
            
            [appdel.audioChatTools callToUserId:[NSString stringWithFormat:@"%@%@",socketADD,autoNext?weakSelf.choiceGoods.shop_user_id: weakSelf.shopDetailM.myShopM.user_id] roomId:weakSelf.orderM.room_id.intValue getOrderTime:autoNext?weakSelf.choiceGoods.match_time : weakSelf.orderM.get_order_time nickName:weakSelf.orderM.user_nick_name autoNext:autoNext averageTime:weakSelf.orderM.average_waiting_time.intValue>0?weakSelf.orderM.average_waiting_time.intValue:120 isExperince:self.isExperince];
            
            appdel.audioChatTools.cancelBlcok = ^(BOOL cancel) {
                weakSelf.cancelAndAutoNext = NO;
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
            
            appdel.audioChatTools.cancelAndAutoNextBlcok = ^(BOOL cancelAndNext) {
                weakSelf.cancelAndAutoNext = YES;
                [weakSelf cancelOrder];
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
            weakSelf.shopHeaderView.headerView.goodsNum = goodsArr.count;

        };
    }
    return _cardVC;
}

- (SXAboutShoperController *)aboutVC{
    if (!_aboutVC) {
        _aboutVC = [[SXAboutShoperController alloc] init];
    }
    return _aboutVC;
}

- (SXShoperSayController *)sayVC{
    if (!_sayVC) {
        _sayVC = [[SXShoperSayController alloc] init];
    }
    return _sayVC;
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
    [self.pagerView.mainTableView setContentOffset:CGPointMake(0, self.shopHeaderView.frame.size.height)];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    self.pagerView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+40, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40);
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
    if (self.shopModel.is_black.boolValue) {
        return 1;
    }
    return self.titles.count;
    
    
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.aboutVC;
    }else if (index == 1){
        return self.cardVC;
    }else{
        return self.sayVC;
    }
}


#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


- (void)indexTap:(UITapGestureRecognizer *)tap{
    UILabel *tapV = (UILabel *)tap.view;
    
    self.categoryView.defaultSelectedIndex = tapV.tag;
    [self categoryCurentIndex:tapV.tag];
    [self.categoryView reloadData];
}

- (void)categoryCurentIndex:(NSInteger)index{
    self.infoButton.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.orderButton.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.comButton.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    self.comButton.font = SIXTEENTEXTFONTSIZE;
    self.infoButton.font = SIXTEENTEXTFONTSIZE;
    self.orderButton.font = SIXTEENTEXTFONTSIZE;
    if (index == 0) {
        self.infoButton.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.infoButton.font = XGSIXBoldFontSize;
    }else if (index == 1){
        self.orderButton.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.orderButton.font = XGSIXBoldFontSize;
    }else if (index == 2){
        self.comButton.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.comButton.font = XGSIXBoldFontSize;
    }

}


- (UILabel *)infoButton{
    if (!_infoButton) {
        _infoButton = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, GET_STRWIDTH(@"个人资料得", 16, 50), 50)];
        _infoButton.font = SIXTEENTEXTFONTSIZE;
        _infoButton.textColor = [UIColor colorWithHexString:@"#14151A"];
        _infoButton.userInteractionEnabled = YES;
        _infoButton.tag = 0;
        _infoButton.text = @"关于店主";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexTap:)];
        [_infoButton addGestureRecognizer:tap];
    }
    return _infoButton;
}

- (UILabel *)orderButton{
    if (!_orderButton) {
        _orderButton = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.infoButton.frame)+25, 0, GET_STRWIDTH(@"个人资料得", 16, 50), 50)];
        _orderButton.font = SIXTEENTEXTFONTSIZE;
        _orderButton.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        _orderButton.userInteractionEnabled = YES;
        _orderButton.tag = 1;
        _orderButton.text = @"咨询服务";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexTap:)];
        [_orderButton addGestureRecognizer:tap];
    }
    return _orderButton;
}

- (UILabel *)comButton{
    if (!_comButton) {
        _comButton = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.orderButton.frame)+25, 0, GET_STRWIDTH(@"评价9999", 16, 50), 50)];
        _comButton.font = SIXTEENTEXTFONTSIZE;
        _comButton.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        _comButton.userInteractionEnabled = YES;
        _comButton.tag = 2;
        _comButton.text = @"动态";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexTap:)];
        [_comButton addGestureRecognizer:tap];
    }
    return _comButton;
}
@end
