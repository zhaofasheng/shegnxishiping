//
//  SXKcCardlistBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcCardlistBaseController.h"
#import "SXKcCardListController.h"
@interface SXKcCardlistBaseController ()
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, strong) SXKcCardListController *buyVC;
@property (nonatomic, strong) SXKcCardListController *getVC;
@end

@implementation SXKcCardlistBaseController


- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[@"购买的",@"收到的"];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH(@"完成", 15, 18);
        self.progressHeight = 4;
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 16;
        self.progressViewBottomSpace = 10;
        self.progressColor = [UIColor colorWithHexString:@"#1FC7FF"];
        self.titleColorNormal = [UIColor colorWithHexString:@"#14151A"];;
        self.titleColorSelected = [UIColor colorWithHexString:@"#14151A"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.view addSubview:self.navBarView];
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH(@"收到的", 16, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{

    return 80;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#14151A"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.7];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.buyVC;
    }else{
        return self.getVC;
    }
}



- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        _navBarView.titleL.text = @"礼品卡";
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [_navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _navBarView;
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}




- (SXKcCardListController *)buyVC{
    if (!_buyVC) {
        _buyVC = [[SXKcCardListController alloc] init];
    }
    return _buyVC;
}

- (SXKcCardListController *)getVC{
    if (!_getVC) {
        _getVC = [[SXKcCardListController alloc] init];
        _getVC.isGet = YES;
    }
    return _getVC;
}
@end
