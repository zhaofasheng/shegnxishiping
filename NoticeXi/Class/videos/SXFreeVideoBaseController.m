//
//  SXFreeVideoBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXFreeVideoBaseController.h"
#import "NoticeVideosController.h"
#import "SXGoodsInfoModel.h"
#import "SXUserHowController.h"
#import "SXHowToUseView.h"
#import "SXSearchVideoController.h"
#import "NoticeLoginViewController.h"
#import "SXVideoTagsView.h"
@interface SXFreeVideoBaseController ()
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *controllArr;
@property (nonatomic, strong) NSMutableArray *cataArr;
@property (nonatomic, strong) SXVideoTagsView *tagsView;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation SXFreeVideoBaseController

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
    [[LogManager sharedInstance] checkLogNeedUpload];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    self.controllArr = [[NSMutableArray alloc] init];
    self.titleArr = [[NSMutableArray alloc] init];
    self.cataArr = [[NSMutableArray alloc] init];
    
    self.controllArr = [[NSMutableArray alloc] init];
    self.titleArr = [[NSMutableArray alloc] init];
    self.cataArr = [[NSMutableArray alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/category/list" Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            

            NoticeVideosController *ctl1 = [[NoticeVideosController alloc] init];
         
            [self.controllArr addObject:ctl1];
            [self.titleArr addObject:@"全部"];
            
            for (NSDictionary *dic in dict[@"data"]) {
                SXGoodsInfoModel *cataM = [SXGoodsInfoModel mj_objectWithKeyValues:dic];
                NoticeVideosController *ctl = [[NoticeVideosController alloc] init];
                [self.controllArr addObject:ctl];
                [self.titleArr addObject:cataM.category_name];
            }
            
            self.titles = [NSArray arrayWithArray:self.titleArr];
            [self.menuView reload];
        
            [self reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    
    //谁在首页谁需要实现这个功能
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outLogin) name:@"outLoginClearDataNOTICATION" object:nil];
    
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-36-STATUS_BAR_HEIGHT)/2, DR_SCREEN_WIDTH-30, 36)];
    [searchBtn setAllCorner:18];
    searchBtn.backgroundColor = [[UIColor colorWithHexString:@"#F0F1F5"] colorWithAlphaComponent:1];
    UIImageView *searImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 20)];
    searImg.image = UIImageNamed(@"Image_newsearchss");
    [searchBtn addSubview:searImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, searchBtn.frame.size.width-40, 36)];
    label.text = @"搜索视频";
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
    [searchBtn addSubview:label];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchBtn];
    

    if ([SXTools isHowTouseOnThisDeveice]) {//执行引导页
        SXHowToUseView *useView = [[SXHowToUseView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [useView showInfoView];
        [SXTools setKnowUse];
    }
    
    UIView *tagsView = [[UIView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-43,NAVIGATION_BAR_HEIGHT, 43, 43)];
    [self.view addSubview:tagsView];
    
    tagsView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagsClick)];
    [tagsView addGestureRecognizer:tap];
    
    UIImageView *tagsImg = [[UIImageView  alloc] initWithFrame:CGRectMake(19/2, 19/2, 24, 24)];
    tagsImg.userInteractionEnabled = YES;
    tagsImg.image = UIImageNamed(@"sx_videotags_img");
    [tagsView addSubview:tagsImg];
    
}

- (void)tagsClick{
    if (!self.titleArr.count) {
        return;
    }
    
    self.tagsView = [[SXVideoTagsView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    
    [self.tagsView showTagsView];
    
    self.tagsView.currentIndex = self.selectIndex;
    self.tagsView.titleArr = self.titleArr;
    
    __weak typeof(self) weakSelf = self;
    self.tagsView.choiceTagBlock = ^(int tag) {
        weakSelf.selectIndex = (int)tag;
    };
}


- (void)searchClick{

    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    
    SXSearchVideoController *ctl = [[SXSearchVideoController alloc] init];
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}


- (void)outLogin{
    [self.navigationController popToRootViewControllerAnimated:NO];
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
