//
//  NoticeVipBaseController.m
//  NoticeXi
//
//  Created by li lei on 2023/8/30.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipBaseController.h"
#import "NoticeVipCenterController.h"
#import "NoticeVipLeadController.h"
#import "NoticeMerchantController.h"
#import "NoticePayView.h"
@interface NoticeVipBaseController ()
@property (nonatomic, strong) NoticeVipCenterController *centerVC;
@property (nonatomic, strong) NoticeVipLeadController *leadVC;
@property (nonatomic, strong) NoticePayView *payView;
@property (nonatomic, strong) UIImageView *backImageView;
@end

@implementation NoticeVipBaseController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools chinese:@"会员中心" english:@"Pro" japan:@"メンバー"],[NoticeTools chinese:@"会员攻略" english:@"Tips" japan:@"会員事項"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressHeight = 0;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 19;
        self.titleColorNormal = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*250/375)];
    backImageView.image = UIImageNamed(@"vipBackImg");
    [self.view addSubview:backImageView];
    self.backImageView = backImageView;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(7, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-50-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, BOTTOM_HEIGHT+50)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:bottomView];
    
    FSCustomButton *shopButton = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 5, 80, 40)];
    [shopButton setTitle:[NoticeTools getLocalStrWith:@"zb.zb"] forState:UIControlStateNormal];
    shopButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [shopButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    [shopButton setImage:UIImageNamed(@"voxShop_img") forState:UIControlStateNormal];
    shopButton.buttonImagePosition = FSCustomButtonImagePositionTop;
    [shopButton addTarget:self action:@selector(shopClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:shopButton];
    
    UIButton *goTbBtn = [[UIButton alloc] initWithFrame:CGRectMake(80,5,DR_SCREEN_WIDTH-100, 40)];
    goTbBtn.backgroundColor = [UIColor colorWithHexString:@"#F56499"];
    goTbBtn.layer.cornerRadius = 20;
    goTbBtn.layer.masksToBounds = YES;
    [goTbBtn setTitle:[NoticeTools getLocalStrWith:@"recoder.golv"] forState:UIControlStateNormal];
    [goTbBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    goTbBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [goTbBtn addTarget:self action:@selector(gotoClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:goTbBtn];
    
    //vipRouteimg5
}

- (void)gotoClick{
    [self.payView show];
}

- (void)shopClick{
    NoticeMerchantController *ctl = [[NoticeMerchantController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NoticePayView *)payView{
    if (!_payView) {
        _payView = [[NoticePayView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _payView;
}

- (void)getCurrentIndex:(NSInteger)currentIndex{
    if(currentIndex == 0){
        self.backImageView.frame =  CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*250/375);
        self.backImageView.image = UIImageNamed(@"vipBackImg");
    }else{
        self.backImageView.frame =  CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*812/375);
        self.backImageView.image = UIImageNamed(@"vipRouteimg5");
    }
    [self.view sendSubviewToBack:self.backImageView];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}




- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    return CGRectMake(0,STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 30;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return GET_STRWIDTH(@"会员中心", 20, 50)+5;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    if (index == 0) {
        return self.centerVC;
    }else{
        return self.leadVC;
    }
}


- (NoticeVipLeadController *)leadVC{
    if(!_leadVC){
        _leadVC = [[NoticeVipLeadController alloc] init];
    }
    return _leadVC;
}

- (NoticeVipCenterController *)centerVC{
    if(!_centerVC){
        _centerVC = [[NoticeVipCenterController alloc] init];
        __weak typeof(self)weakSelf = self;
        _centerVC.goUpLelveBlock = ^(BOOL up) {
            [weakSelf gotoClick];
        };
    }
    return _centerVC;
}
@end
