//
//  SXTeleListBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXTeleListBaseController.h"
#import "NoticeTelController.h"
#import "SXGoodsInfoModel.h"
#import "SXsearchShopController.h"
#import "NoticeLoginViewController.h"
@interface SXTeleListBaseController ()
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *controllArr;
@property (nonatomic, strong) NSMutableArray *cataArr;
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
    self.cataArr = [[NSMutableArray alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/category/list" Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            NoticeTelController *ctl1 = [[NoticeTelController alloc] init];
            ctl1.category_Id = @"0";
            [self.controllArr addObject:ctl1];
            [self.titleArr addObject:@"全部"];
            
            for (NSDictionary *dic in dict[@"data"]) {
                SXGoodsInfoModel *cataM = [SXGoodsInfoModel mj_objectWithKeyValues:dic];
                NoticeTelController *ctl = [[NoticeTelController alloc] init];
                ctl.category_Id = cataM.category_Id;
                [self.controllArr addObject:ctl];
                [self.titleArr addObject:cataM.category_name];
            }
            self.titles = [NSArray arrayWithArray:self.titleArr];
            [self.menuView reload];
            [self reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,4, DR_SCREEN_WIDTH-30, 36)];
    [searchBtn setAllCorner:18];
    searchBtn.backgroundColor = [[UIColor colorWithHexString:@"#F0F1F5"] colorWithAlphaComponent:1];
    UIImageView *searImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 20)];
    searImg.image = UIImageNamed(@"Image_newsearchss");
    [searchBtn addSubview:searImg];
    [self.view addSubview:searchBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, searchBtn.frame.size.width-40, 36)];
    label.text = @"搜索店铺";
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
    [searchBtn addSubview:label];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)searchClick{

    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    SXsearchShopController *ctl = [[SXsearchShopController alloc] init];
 
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,44, DR_SCREEN_WIDTH, 43);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,43, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-44);
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
