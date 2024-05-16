//
//  SXTeleListBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXTeleListBaseController.h"
#import "NoticeTelController.h"
@interface SXTeleListBaseController ()
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *controllArr;
@end

@implementation SXTeleListBaseController

- (instancetype)init {
    if (self = [super init]) {
       // 6.7.8  10 11 13
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        //self.progressWidth = GET_STRWIDTH(@"首3条私聊", 16, 16);
        self.automaticallyCalculatesItemWidths = YES;
        self.progressHeight = 8;
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 16;
        self.progressViewBottomSpace = 8;
        self.progressColor = [UIColor colorWithHexString:@"#D8F361"];
        self.titleColorNormal = [UIColor colorWithHexString:@"#14151A"];
        self.titleColorSelected = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    self.controllArr = [[NSMutableArray alloc] init];
    self.titleArr = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSArray *arr = @[@"全部",@"MBTI",@"心理咨询",@"原生家庭",@"学业咨询",@"MBTI",@"心理咨询",@"原生家庭",@"学业咨询"];
    for (int i = 0; i < arr.count; i++) {
        NoticeTelController *ctl = [[NoticeTelController alloc] init];
        [self.controllArr addObject:ctl];
        [self.titleArr addObject:arr[i]];
    }
    self.titles = [NSArray arrayWithArray:self.titleArr];
    [self.menuView reload];
    [self reloadData];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,0, DR_SCREEN_WIDTH, 43);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,43, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-43-TAB_BAR_HEIGHT);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return GET_STRWIDTH(self.titles[index], 16, 16)+4;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 10;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor blackColor];
        case WMMenuItemStateNormal: return [UIColor colorWithHexString:@"#5C5F66"];
    }
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    return self.controllArr[index];
}
@end
