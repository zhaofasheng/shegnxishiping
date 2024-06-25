//
//  NoticeMyJieYouShopController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyJieYouShopController.h"
#import "NoticeXi-Swift.h"
#import "NoticeJieYouShopHeaderView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "NoticeShopRuleController.h"
#import "NoticeShopCardController.h"
#import "NoticeEditShopInfoController.h"
#import "NoticeJieYouGoodsComController.h"
#import "NoticeJieYouGoodsController.h"
#import "SXShopOpenTypeView.h"
#import "NoticeMoreClickView.h"
@interface NoticeMyJieYouShopController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NoticeShopCardController *cardVC;
@property (nonatomic, strong) NoticeJieYouGoodsComController *comVC;
@property (nonatomic, strong) NoticeJieYouGoodsController *goodsVC;
@property (nonatomic, strong) NoticeCureentShopStatusModel *applyModel;
@property (nonatomic, strong) FSCustomButton *editButton;
@property (nonatomic, strong) UIButton *workButton;
@property (nonatomic, strong) NSMutableArray *sellGoodsArr;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) NSMutableArray *goodsArr;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) NoticeJieYouShopHeaderView *shopHeaderView;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) UIView *startView;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, strong) UIView *backV;

@property (nonatomic, strong) UILabel *infoButton;
@property (nonatomic, strong) UILabel *orderButton;
@property (nonatomic, strong) UILabel *comButton;

@property (nonatomic, strong) SXShopOpenTypeView *typeView;
@end

@implementation NoticeMyJieYouShopController

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
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat imgHeight = (DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)/2+NAVIGATION_BAR_HEIGHT;
    self.originY = imgHeight - 30;
    self.backV = [[UIView  alloc] initWithFrame:CGRectMake(0, self.originY, DR_SCREEN_WIDTH, 30)];
    self.backV.backgroundColor = [UIColor whiteColor];
    
    
    self.backImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, imgHeight)];
    [self.view addSubview:self.backImageView];
    self.backImageView.image = UIImageNamed(@"shopgroundback_img");
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backImageView.clipsToBounds = YES;
    
    UIView *blackV = [[UIView  alloc] initWithFrame:self.backImageView.bounds];
    blackV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.backImageView addSubview:blackV];
    
    [self.backImageView addSubview:self.backV];
    
    self.titles = @[@"",@"",@""];
    self.shopHeaderView = [[NoticeJieYouShopHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, imgHeight-NAVIGATION_BAR_HEIGHT-40-41-20)];
    self.shopHeaderView.detailHeader.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    self.shopHeaderView.choiceUrlBlock = ^(NSString * _Nonnull choiceUrl) {
        [weakSelf.backImageView sd_setImageWithURL:[NSURL URLWithString:choiceUrl]];
    };

    self.shopHeaderView.detailHeader.refreshShopModel = ^(BOOL refresh) {
        [weakSelf getShopRequest];
    };
    
    self.shopHeaderView.detailHeader.editshShopModel = ^(BOOL edit) {
        [weakSelf editClick];
    };
    
    CGFloat width1 = GET_STRWIDTH(@"个人资料", 16, 50);
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,width1*2+40,51)];
    self.categoryView.titles = self.titles;
    self.categoryView.delegate = self;

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
    [self.sectionView setCornerOnTopRight:25];
    [self.sectionView addSubview:self.categoryView];

    self.startView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-44-10, DR_SCREEN_WIDTH, 44)];
    [self.view addSubview:self.startView];
    self.startView.backgroundColor = self.view.backgroundColor;
    
    self.editButton = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, 74, 44)];
    [self.editButton setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = ELEVENTEXTFONTSIZE;
    [self.editButton setTitle:@"营业模式" forState:UIControlStateNormal];
    self.editButton.buttonImagePosition = FSCustomButtonImagePositionTop;
    [self.editButton setImage:UIImageNamed(@"sx_shopopentype") forState:UIControlStateNormal];
    [self.startView addSubview:self.editButton];
    [self.editButton addTarget:self action:@selector(typeClick) forControlEvents:UIControlEventTouchUpInside];

    self.workButton = [[UIButton alloc] initWithFrame:CGRectMake(74,0, DR_SCREEN_WIDTH-74-15, 44)];
    self.workButton.layer.cornerRadius = 22;
    self.workButton.layer.masksToBounds = YES;
    
    //渐变色
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FE827E"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#D84022"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.workButton.frame), CGRectGetHeight(self.workButton.frame));
    self.gradientLayer = gradientLayer;
    [self.workButton.layer addSublayer:self.gradientLayer];
    [self.workButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.workButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.startView addSubview:self.workButton];
    [self.workButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopRequest) name:@"REFRESHMYWALLECT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopRequestForCheck) name:@"REFRESHMYSHOP" object:nil];
    
    [self getShopRequest];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"backwhtiess") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *ruleBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-32-15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2,32, 32)];
    [ruleBtn setImage:UIImageNamed(@"sxwhiteshoprule_img") forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ruleBtn];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-32-20-32, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2,32, 32)];
    [shareBtn setImage:UIImageNamed(@"sx_shareshop_img") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    

    
    [self.sectionView addSubview:self.infoButton];
    [self.sectionView addSubview:self.orderButton];
    [self.sectionView addSubview:self.comButton];
}

- (void)shareClick{
    NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    moreView.isShare = YES;
    moreView.shareUrl = self.shopModel.myShopM.shopShareUrl;
    moreView.wechatShareUrl = self.shopModel.myShopM.wechatShareUrl;
    moreView.name = @"快来声昔找我聊聊吧";
    moreView.imgUrl = self.shopModel.myShopM.shop_avatar_url;
    moreView.title = [NSString stringWithFormat:@"%@的咨询主页",self.shopModel.myShopM.shop_name];
    [moreView showTost];
}

- (void)editClick{
    NoticeEditShopInfoController *ctl = [[NoticeEditShopInfoController alloc] init];
    ctl.shopModel = self.shopModel;
    __weak typeof(self) weakSelf = self;
    ctl.refreshShopModel = ^(BOOL refresh) {
        [weakSelf getShopRequest];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getShopRequestForCheck{
    self.shopModel.myShopM.is_submit_authentication = @"1";
    [self getShopRequest];
}

//获取店铺信息和状态
- (void)getShopRequest{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/ByUser" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            
            self.shopModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
        
            self.shopHeaderView.shopModel = self.shopModel;
            self.shopHeaderView.detailHeader.shopModel = self.shopModel;
            self.cardVC.shopModel = self.shopModel;
            self.goodsVC.shopModel = self.shopModel;
            self.comVC.shopId = self.shopModel.myShopM.shopId;
            if (self.shopModel.myShopM.comment_num.intValue) {
                self.comButton.text = [NSString stringWithFormat:@"评论%@",self.shopModel.myShopM.comment_num.intValue?self.shopModel.myShopM.comment_num:@""];
            }else{
                self.comButton.text = @"评价";
            }
            
            [self refresButton];
            
            if (!self.shopModel.myShopM.photowallArr.count) {
                self.backImageView.image = UIImageNamed(@"shopgroundback_img");
            }
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self showToastWithText:error.debugDescription];
    }];
}

- (NSMutableArray *)sellGoodsArr{
    if(!_sellGoodsArr){
        _sellGoodsArr = [[NSMutableArray alloc] init];
    }
    return _sellGoodsArr;
}


- (void)ruleClick{
    NoticeShopRuleController *ctl = [[NoticeShopRuleController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)typeClick{
    if (!self.sellGoodsArr.count) {
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"管理服务列表添加收费服务后，才能设置营业时间" message:nil sureBtn:@"再想想" cancleBtn:@"添加" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                weakSelf.categoryView.defaultSelectedIndex = 1;
                [weakSelf categoryCurentIndex:1];
                [weakSelf.categoryView reloadData];
                [weakSelf.goodsVC manageGoods];
            }
        };
        [alerView showXLAlertView];
      
        return;
    }
    if (self.shopModel.myShopM.is_stop.integerValue > 0) {
        [self showToastWithText:@"店铺当前无法营业，暂不能使用此功能"];
        return;
    }
    

    
    self.typeView.shopModel = self.shopModel;
    [self.typeView showATView];
}

- (void)startClick{
    
    
    if(self.shopModel.myShopM.is_stop.integerValue || (self.shopModel.myShopM.is_timing.boolValue && self.shopModel.myShopM.operate_status.intValue == 1)){
        return;
    }

    if (self.shopModel.myShopM.is_timing.boolValue && self.shopModel.myShopM.operate_status.integerValue == 2) {
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NSString stringWithFormat:@"你设置的营业时间为「%@-%@」，确定提前结束营业吗？",self.shopModel.myShopM.start_time,self.shopModel.myShopM.end_time] message:nil sureBtn:@"再想想" cancleBtn:@"结束营业" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf endWork];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    if(self.shopModel.myShopM.operate_status.integerValue == 2){
        [self endWork];
        return;
    }
    
    if(!self.sellGoodsArr.count){
        [self showToastWithText:@"请进入咨询服务页面添加您要营业的商品"];
        return;
    }
   
    if(self.shopModel.myShopM.operate_status.integerValue == 1 && self.shopModel.myShopM.role.intValue && self.sellGoodsArr.count){
        
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"营业中，店铺有新订单时，声昔会通过手机短信提示你" message:nil sureBtn:@"再想想" cancleBtn:@"开始营业" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf start];
            }
        };
        [alerView showXLAlertView];
    }
}

- (void)endWork{
    [self showHUD];

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/1",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
            [self getShopRequest];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)start{
    
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) { // 有使用麦克风的权限
                if(weakSelf.sellGoodsArr.count){
                }else{
                    [YZC_AlertView showViewWithTitleMessage:@"没有选择营业的商品"];
                    return;
                }
                
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/2",weakSelf.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if(success){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
                        [weakSelf getShopRequest];
                    }
                } fail:^(NSError * _Nullable error) {
                    
                }];
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

- (void)refresButton{
    if(self.shopModel.myShopM.is_stop.integerValue > 0){
        if(self.shopModel.myShopM.is_stop.integerValue == 1){//店铺被永久关停
            [self.workButton setTitle:@"店铺已被永久关闭" forState:UIControlStateNormal];
        }else{
            [self.workButton setTitle:[NSString stringWithFormat:@"暂停营业中%@",[NoticeTools getDaoishi:self.shopModel.myShopM.is_stop]] forState:UIControlStateNormal];
            self.workButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#A1A7B3"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#A1A7B3"].CGColor];
        
    }else if (self.shopModel.myShopM.is_timing.boolValue){//定时营业
        if(self.shopModel.myShopM.operate_status.integerValue == 2){
            self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FE827E"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#D84022"].CGColor];
            [self.workButton setTitle:[NSString stringWithFormat:@"营业至：每天%@-%@",self.shopModel.myShopM.start_time,self.shopModel.myShopM.end_time] forState:UIControlStateNormal];
           
        }else if (self.shopModel.myShopM.role <=0 || !self.sellGoodsArr.count){
            [self.workButton setTitle:[NSString stringWithFormat:@"每天%@-%@",self.shopModel.myShopM.start_time,self.shopModel.myShopM.end_time] forState:UIControlStateNormal];
            self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#A1A7B3"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#A1A7B3"].CGColor];
        }else if (self.shopModel.myShopM.operate_status.integerValue == 1){
            [self.workButton setTitle:[NSString stringWithFormat:@"每天%@-%@",self.shopModel.myShopM.start_time,self.shopModel.myShopM.end_time] forState:UIControlStateNormal];
            self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#A1A7B3"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#A1A7B3"].CGColor];
        }
    }
    else{
        if(self.shopModel.myShopM.operate_status.integerValue == 2){
            self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FE827E"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#D84022"].CGColor];
            [self.workButton setTitle:@"结束营业" forState:UIControlStateNormal];
           
        }else if (!self.sellGoodsArr.count){
            [self.workButton setTitle:@"开始营业" forState:UIControlStateNormal];
            self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#A1A7B3"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#A1A7B3"].CGColor];
        }else if (self.shopModel.myShopM.operate_status.integerValue == 1){
            [self.workButton setTitle:@"开始营业" forState:UIControlStateNormal];
            self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#1FE4FB"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#1FC7FF"].CGColor];
        }
    }
}


- (NoticeShopCardController *)cardVC{
    if(!_cardVC){
        _cardVC = [[NoticeShopCardController alloc] init];
        __weak typeof(self) weakSelf = self;
        _cardVC.refreshShopModel = ^(BOOL refresh) {
            [weakSelf getShopRequest];
        };
        _cardVC.editShopModelBlock = ^(BOOL edit) {
            [weakSelf editClick];
        };
 
    }
    return _cardVC;
}

- (NoticeJieYouGoodsController *)goodsVC{
    if (!_goodsVC) {
        __weak typeof(self) weakSelf = self;
        _goodsVC = [[NoticeJieYouGoodsController alloc] init];
        _goodsVC.refreshGoodsBlock = ^(NSMutableArray * _Nonnull goodsArr) {
            if (goodsArr.count) {
                weakSelf.sellGoodsArr = goodsArr;
                weakSelf.shopHeaderView.detailHeader.goodsNum = goodsArr.count;
                [weakSelf refresButton];
            }
        };
    }
    return _goodsVC;
}

- (NoticeJieYouGoodsComController *)comVC{
    if (!_comVC) {
        _comVC = [[NoticeJieYouGoodsComController alloc] init];
        _comVC.isList = YES;
    }
    return _comVC;
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
    if (index == 1) {
        return self.goodsVC;
    }else if (index == 2){
        return self.comVC;
    }
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

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView{

    self.backV.frame = CGRectMake(0, self.originY-scrollView.contentOffset.y, DR_SCREEN_WIDTH, 50);
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
        _infoButton.text = @"个人资料";
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
        _comButton.text = @"评价";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexTap:)];
        [_comButton addGestureRecognizer:tap];
    }
    return _comButton;
}

- (SXShopOpenTypeView *)typeView{
    if (!_typeView) {
        _typeView = [[SXShopOpenTypeView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _typeView;
}


@end
