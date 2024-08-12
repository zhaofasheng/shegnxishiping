//
//  SXKcScoreBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcScoreBaseController.h"
#import "SXKcScoreListController.h"
@interface SXKcScoreBaseController ()
@property (nonatomic, strong) NoticeCustumeNavView *navBarView;//是否需要自定义导航栏
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *controllArr;
@end

@implementation SXKcScoreBaseController

- (instancetype)init {
    if (self = [super init]) {
       // 6.7.8  10 11 13
        self.menuViewStyle = WMMenuViewStyleFlood;
        self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.automaticallyCalculatesItemWidths = YES;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.progressHeight = 32;
        self.progressColor = [UIColor colorWithHexString:@"#1FC7FF"];
        self.titleColorNormal = [UIColor colorWithHexString:@"#14151A"];
        self.titleColorSelected = [UIColor whiteColor];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.navBarView];
    
    NSArray *titleArr = @[@"全部",@"超满意",@"挺不错",@"一般吧",@"挺难评"];
    self.titleArr = [NSMutableArray arrayWithArray:titleArr];
    [self refreshController];
}

- (void)refreshController{
    SXKcScoreListController *ctl1 = [[SXKcScoreListController alloc] init];
    [self.controllArr addObject:ctl1];
    
    for (NSString *category_name in self.titleArr) {
        SXKcScoreListController *ctl = [[SXKcScoreListController alloc] init];
        [self.controllArr addObject:ctl];
    }
    
    self.titles = [NSArray arrayWithArray:self.titleArr];
    [self.menuView reload];
    [self reloadData];
}


- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        _navBarView.titleL.text = @"评价";
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [_navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _navBarView;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-43, 43);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,43+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-43-TAB_BAR_HEIGHT);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    if (index >= self.titleArr.count) {
        return 30;
    }
    return GET_STRWIDTH(self.titles[index], 16, 16)+10;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 10;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor whiteColor];
        case WMMenuItemStateNormal: return [UIColor colorWithHexString:@"#14151A"];
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index >= self.controllArr.count) {
        return [[UIViewController alloc] init];
    }
    return self.controllArr[index];
}

@end
