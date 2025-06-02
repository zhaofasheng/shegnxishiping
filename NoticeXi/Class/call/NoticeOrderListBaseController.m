//
//  NoticeOrderListBaseController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeOrderListBaseController.h"
#import "NoticeOrderListController.h"

@interface NoticeOrderListBaseController ()
@property (nonatomic, strong) NoticeOrderListController *finishVC;
@property (nonatomic, strong) NoticeOrderListController *noFinishVC;
@end

@implementation NoticeOrderListBaseController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[@"已完成",@"已失效"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"已完成", 20, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 18;
        self.titleSizeSelected = 18;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#25262E"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.view addSubview:self.navBarView];
    
    if(self.isExpre){
        self.selectIndex = 1;
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(@"已完成", 20, 18)+5;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{

    return (DR_SCREEN_WIDTH- GET_STRWIDTH(@"已完成", 20, 18)*2)/3;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#25262E"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.7];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.finishVC;
    }else{
        return self.noFinishVC;
    }
}


- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        _navBarView.titleL.text = @"服务过的";
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [_navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _navBarView;
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NoticeOrderListController *)finishVC{
    if (!_finishVC) {
        _finishVC = [[NoticeOrderListController alloc] init];
        _finishVC.userType = @"1";
        _finishVC.isFinished = YES;
        _finishVC.type = @"1";
    }
    return _finishVC;
}


- (NoticeOrderListController *)noFinishVC{
    if (!_noFinishVC) {
        _noFinishVC = [[NoticeOrderListController alloc] init];
        _noFinishVC.userType = @"1";
        _noFinishVC.type = @"2";
    }
    return _noFinishVC;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

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


@end
