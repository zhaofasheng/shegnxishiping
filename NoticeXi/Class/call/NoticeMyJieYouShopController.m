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
@interface NoticeMyJieYouShopController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NoticeShopCardController *cardVC;
@property (nonatomic, strong) NoticeCureentShopStatusModel *applyModel;
@property (nonatomic, strong) UIButton *editButton;
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
    
    self.backImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, imgHeight)];
    [self.view addSubview:self.backImageView];
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


    self.startView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-40-10, DR_SCREEN_WIDTH, 40)];
    [self.view addSubview:self.startView];
    self.startView.backgroundColor = self.view.backgroundColor;
    
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 112, 40)];
    self.editButton.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    [self.editButton setAllCorner:20];
    [self.editButton setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [self.editButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    [self.startView addSubview:self.editButton];
    [self.editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];

    self.workButton = [[UIButton alloc] initWithFrame:CGRectMake(147,0, DR_SCREEN_WIDTH-20-147, 40)];
    self.workButton.layer.cornerRadius = 20;
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
    [self getShopRequest];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"backwhtiess") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *ruleBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [ruleBtn setImage:UIImageNamed(@"sxwhiteshoprule_img") forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ruleBtn];
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


//获取店铺信息和状态
- (void)getShopRequest{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/ByUser" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.shopModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
           
            self.shopHeaderView.shopModel = self.shopModel;
            self.cardVC.shopModel = self.shopModel;

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

- (void)startClick{
    
    
    if(self.shopModel.myShopM.is_stop.integerValue){
        return;
    }

    if(self.shopModel.myShopM.operate_status.integerValue == 2){
        [self showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:@"99" forKey:@"goods_id"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/1",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if(success){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
                [self getShopRequest];
            }
            [self hideHUD];
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        return;
    }
    
    if(!self.sellGoodsArr.count){
        [self showToastWithText:@"请添加您要营业的商品"];
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

- (void)start{
    
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) { // 有使用麦克风的权限
                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                if(weakSelf.sellGoodsArr.count){
                    [parm setObject:@"99" forKey:@"goods_id"];
                }else{
                    [YZC_AlertView showViewWithTitleMessage:@"没有选择营业的商品"];
                    return;
                }
                
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/2",weakSelf.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
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
        
    }else{
        if(self.shopModel.myShopM.operate_status.integerValue == 2){
            self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FE827E"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#D84022"].CGColor];
            [self.workButton setTitle:@"结束营业" forState:UIControlStateNormal];
           
        }else if (self.shopModel.myShopM.role <=0 || !self.sellGoodsArr.count){
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
        _cardVC.refreshGoodsBlock = ^(NSMutableArray * _Nonnull goodsArr) {
            weakSelf.sellGoodsArr = goodsArr;
            [weakSelf refresButton];
        };
    }
    return _cardVC;
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
