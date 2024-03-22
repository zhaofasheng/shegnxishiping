//
//  NoticeManagerController.m
//  NoticeXi
//
//  Created by li lei on 2019/6/26.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeManagerController.h"
#import "NoticeMangerVoiceController.h"
#import "NoticeAboutGroupController.h"
#import "NoticeTcWarnWordController.h"
#import "NoticeXi-Swift.h"
#import "NoticeMoveRecoderController.h"
#import "NoticeBannerController.h"
#import "NoticeManagerChangePhoneController.h"
#import "NoticeSysNewsManagerController.h"
#import "NoticeQuestionBaseController.h"
#import "NoticeWorldVoiceListViewController.h"
#import "NoticeNewReadEveryDayController.h"
#import "NoticeShopSupplyManController.h"
#import "NoticeOrderJubaoBaseController.h"
#import "NoticeManageBoKeBaseController.h"
@interface NoticeManagerController ()
@property (nonatomic, strong) NoticeManageBoKeBaseController *bokeVC;
@property (nonatomic, strong) NoticeMangerVoiceController *replyVC;
@property (nonatomic, strong) NoticeMangerVoiceController *chatVC;
@property (nonatomic, strong) NoticeAboutGroupController *teamVC;
@property (nonatomic, strong) NoticeManagerMBSController *mbsVC;
@property (nonatomic, strong) NoticeManagerWaitWorkController *waitWorkVC;
@property (nonatomic, strong) NoticeManagerWaitCheckController *checkVC;
@property (nonatomic, strong) NoticeWorkedAlreadyController *workedVC;
@property (nonatomic, strong) NoticeTcWarnWordController *warnVC;
@property (nonatomic, strong) NoticeManagerCenterController *centerVC;
@property (nonatomic, strong) NoticeShopSupplyManController *groupVC;
@property (nonatomic, strong) NoticeMoveRecoderController *moveVC;
@property (nonatomic, strong) NoticeBannerController *bannerVC;
@property (nonatomic, strong) NoticeManagerChangePhoneController *changePhoneVC;
@property (nonatomic, strong) NoticeQuestionBaseController *questionVC;
@property (nonatomic, strong) NoticeWorldVoiceListViewController *hotPlanVC;
@property (nonatomic, strong) NoticeWorldVoiceListViewController *hotMarkVC;
@property (nonatomic, strong) NoticeNewReadEveryDayController *readVC;
@property (nonatomic, strong) NoticeOrderJubaoBaseController *shopVC;
@end

@implementation NoticeManagerController


- (instancetype)init {
    if (self = [super init]) {
       // 6.7.8  10 11 13
        self.titles = @[@"举报待处理",@"举报待调查",@"举报已处理",@"店铺请求",@"订单审核",@"找回账号"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        //self.progressWidth = GET_STRWIDTH(@"首3条私聊", 16, 16);
        self.automaticallyCalculatesItemWidths = YES;
        self.progressHeight = 2;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 16;
        self.progressViewBottomSpace = 5;
        self.progressColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.titleColorNormal = [UIColor colorWithHexString:@"#14151A"];
        self.titleColorSelected = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"emtion.manager"];
    
    UIButton *btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn11.frame = CGRectMake(DR_SCREEN_WIDTH-50-5, STATUS_BAR_HEIGHT, 70, 50);
    [btn11 setTitle:[NoticeTools getLocalStrWith:@"push.ce9"] forState:UIControlStateNormal];
    [btn11 setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    btn11.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn11 addTarget:self action:@selector(newsClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itme1 = [[UIBarButtonItem alloc] initWithCustomView:btn11];
    
    UIButton *btn12 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn12.frame = CGRectMake(DR_SCREEN_WIDTH-50-5, STATUS_BAR_HEIGHT, 60, 50);
    [btn12 setTitle:@"定时" forState:UIControlStateNormal];
    [btn12 setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    btn12.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    [btn12 addTarget:self action:@selector(dsClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itme2 = [[UIBarButtonItem alloc] initWithCustomView:btn12];
    
    self.navigationItem.rightBarButtonItems = @[itme1,itme2];
}

- (void)dsClick{
    NoticeSysNewsManagerController *ctl = [[NoticeSysNewsManagerController alloc] init];
    ctl.managerCode = self.mangagerCode;
    ctl.isDs = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)newsClick{
    NoticeSysNewsManagerController *ctl = [[NoticeSysNewsManagerController alloc] init];
    ctl.managerCode = self.mangagerCode;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 50);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,58+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-58);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

//- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
//    return GET_STRWIDTH(self.titles[index], 16, 16);
//}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 10;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor blackColor];
        case WMMenuItemStateNormal: return [UIColor blackColor];
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if(index == 0){
        return self.waitWorkVC;
    }else if(index == 1){
        return self.checkVC;
    }else if(index == 2){
        return self.workedVC;
    }else if(index == 3){
        return self.groupVC;
    }else if(index == 4){
        return self.shopVC;
    }else{
        return self.changePhoneVC;
    }
}



- (NoticeManagerChangePhoneController *)changePhoneVC{
    if (!_changePhoneVC) {
        _changePhoneVC = [[NoticeManagerChangePhoneController alloc] init];
        _changePhoneVC.managerCode = self.mangagerCode;
    }
    return _changePhoneVC;
}


- (NoticeManagerWaitWorkController *)waitWorkVC{
    if (!_waitWorkVC) {
        _waitWorkVC = [[NoticeManagerWaitWorkController alloc] init];
        _waitWorkVC.mangagerCode = self.mangagerCode;
        _waitWorkVC.type = @"1";
    }
    return _waitWorkVC;
}

- (NoticeManagerWaitCheckController *)checkVC{
    if (!_checkVC) {
        _checkVC = [[NoticeManagerWaitCheckController alloc] init];
        _checkVC.mangagerCode = self.mangagerCode;
        _checkVC.type = @"0";
    }
    return _checkVC;
}

- (NoticeWorkedAlreadyController *)workedVC{
    if (!_workedVC) {
        _workedVC = [[NoticeWorkedAlreadyController alloc] init];
        _workedVC.mangagerCode = self.mangagerCode;
        _workedVC.type = @"2";
    }
    return _workedVC;
}


- (NoticeOrderJubaoBaseController *)shopVC{
    if (!_shopVC) {
        _shopVC = [[NoticeOrderJubaoBaseController alloc] init];
        _shopVC.mangagerCode = self.mangagerCode;
    }
    return _shopVC;
}

- (NoticeShopSupplyManController *)groupVC{
    if (!_groupVC) {
        _groupVC = [[NoticeShopSupplyManController alloc] init];
        _groupVC.managerCode = self.mangagerCode;
    }
    return _groupVC;
}




@end
