//
//  SXTelBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXTelBaseController.h"
#import "NoticeTelController.h"
#import "NoticeCureentShopStatusModel.h"
#import "NoticeMyShopModel.h"
#import "SXSpulyShopView.h"
#import "NoticeMyJieYouShopController.h"
@interface SXTelBaseController ()

@property (nonatomic, strong) NoticeTelController *freeVC;
@property (nonatomic, strong) NoticeTelController *payVC;
@property (nonatomic, strong) SXSpulyShopView *supplyView;
@property (nonatomic, strong) UIImageView *shopIconImageView;
@property (nonatomic, strong) UILabel *shopStatusL;
@property (nonatomic, strong) UIView *shopStatusView;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) NoticeCureentShopStatusModel *applyModel;//申请状态
@property (nonatomic, strong) UIView *redCirView;
@property (nonatomic, assign) BOOL needAutoShowSupply;
@end

@implementation SXTelBaseController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[@"免费",@"付费"];
        self.menuViewStyle = WMMenuViewStyleDefault;
        self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.titleSizeNormal = 22;
        self.titleSizeSelected = 22;
        self.titleColorNormal = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
        self.titleColorSelected = [UIColor colorWithHexString:@"#14151A"];
  
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStatusRequest) name:@"REFRESHMYWALLECT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStatusRequest) name:@"HASSUPPLYSHOPNOTICE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStatusRequest) name:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStatusRequest) name:@"outLoginClearDataNOTICATION" object:nil];


    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.menuView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    if (self.needAutoShowSupply) {
        self.needAutoShowSupply = NO;
        [self myShopTap];
    }
    
    [self  getStatusRequest];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(10,STATUS_BAR_HEIGHT,GET_STRWIDTH(@"免费", 22, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)*2+22*2,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(self.titles[index], 22, 50);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    if(index == 0){
        return 0;
    }
    return 22;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#14151A"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.freeVC;
    }
    else{
        return self.payVC;
    }
}

- (NoticeTelController *)freeVC{
    if (!_freeVC) {
        _freeVC = [[NoticeTelController alloc] init];
        _freeVC.isFree = YES;
    }
    return _freeVC;
}

- (NoticeTelController *)payVC{
    if (!_payVC) {
        _payVC = [[NoticeTelController alloc] init];
    }
    return _payVC;
}


- (void)myShopTap{
    if (self.applyModel.status == 6) {//有店铺了
        NoticeMyJieYouShopController *ctl = [[NoticeMyJieYouShopController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if(self.applyModel.status == 4){//待审核
        self.supplyView.canSupply = NO;
        [self.supplyView showSupplyView];
    }else if(self.applyModel.status < 4 || self.applyModel.status == 5){//没店铺
        
        self.supplyView.canSupply = YES;
        [self.supplyView showSupplyView];
    }
}

- (SXSpulyShopView *)supplyView{
    if (!_supplyView) {
        _supplyView = [[SXSpulyShopView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _supplyView.lookRuleBlock = ^(BOOL lookRule) {
            weakSelf.needAutoShowSupply = YES;
        };
    }
    return _supplyView;
}

- (UIView *)shopStatusView{
    if (!_shopStatusView) {
        _shopStatusView = [[UIView  alloc] initWithFrame:CGRectZero];
        _shopStatusView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myShopTap)];
        [_shopStatusView addGestureRecognizer:tap];
        
        self.shopIconImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, (NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
        [self.shopIconImageView setAllCorner:12];
        [_shopStatusView addSubview:self.shopIconImageView];
        self.shopIconImageView.userInteractionEnabled = YES;
        
        self.shopStatusL = [[UILabel  alloc] initWithFrame:CGRectMake(28, 0, 0, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        self.shopStatusL.font = FOURTHTEENTEXTFONTSIZE;
        [_shopStatusView addSubview:self.shopStatusL];
        
        self.redCirView = [[UIView  alloc] initWithFrame:CGRectMake(14, self.shopIconImageView.frame.origin.y-2, 10, 10)];
        self.redCirView.backgroundColor = [UIColor colorWithHexString:@"#E64424"];
        self.redCirView.layer.cornerRadius = 5;
        self.redCirView.layer.masksToBounds = YES;
        self.redCirView.layer.borderWidth = 2;
        self.redCirView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_shopStatusView addSubview:self.redCirView];
        self.redCirView.hidden = YES;
        
        [self.view addSubview:_shopStatusView];
    }
    return _shopStatusView;
}


//获取是否申请了店铺
- (void)getStatusRequest{
    
    if (![NoticeTools getuserId]) {
        _shopStatusView.hidden = YES;
        return;
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/getApplyStage" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {

        if(success){
            self.applyModel = [NoticeCureentShopStatusModel mj_objectWithKeyValues:dict[@"data"]];
            
            if(self.applyModel.status < 4 || self.applyModel.status == 5){//1未实名 2未绑定提现方式 3未设置店名 4待审核 5审核失败 6审核通过
                //没有申请店铺，或者店铺审核失败，申请店铺
                [self refreshShopStatus];
            }else if (self.applyModel.status == 4) {//待审核
                [self refreshShopStatus];
            }else if (self.applyModel.status == 6) {//审核通过
        
                [self getShopRequest];
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] showToastWithText:error.debugDescription];
    }];
}

- (void)refreshShopStatus{
    
    self.shopStatusView.hidden = NO;
    self.redCirView.hidden = YES;
    if (self.applyModel.status == 6) {//店铺审核通过了，有店铺
        [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:self.shopModel.myShopM.shop_avatar_url] placeholderImage:UIImageNamed(@"sxshopdefaulticon_img")];
        
        if (self.shopModel.myShopM.is_stop.intValue || self.shopModel.myShopM.operate_status.integerValue == 1) {//被官方叫停或者自己处于休息状态
            self.shopStatusL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            self.shopStatusL.text = @"休息中";
        }else if (self.shopModel.myShopM.operate_status.intValue == 2 || self.shopModel.myShopM.operate_status.intValue == 3){//营业中
            self.shopStatusL.textColor = [UIColor colorWithHexString:@"#E64424"];
            self.shopStatusL.text = @"营业中";
            self.redCirView.hidden = NO;
        }
    }else{//没有店铺
        self.shopIconImageView.image = UIImageNamed(@"sxshopdefaulticon_img");
        self.shopStatusL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.shopStatusL.text = @"我的店铺";
    }
    
    self.shopStatusL.frame = CGRectMake(28, 0, GET_STRWIDTH(self.shopStatusL.text, 14, 30), NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    CGFloat width = self.shopStatusL.frame.size.width+28;
    self.shopStatusView.frame = CGRectMake(DR_SCREEN_WIDTH-width-15, STATUS_BAR_HEIGHT, width, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
}

//获取店铺信息
- (void)getShopRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/ByUser" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.shopModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            
            [self refreshShopStatus];
        }
    } fail:^(NSError * _Nullable error) {
        [self refreshShopStatus];
        [self hideHUD];
        [self showToastWithText:error.debugDescription];
    }];
    
}

@end
