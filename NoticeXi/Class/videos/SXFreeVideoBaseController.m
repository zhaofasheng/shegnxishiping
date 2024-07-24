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
#import "SXHasUpdateKcModel.h"
#import "SXStudyBaseController.h"
#import "SXGoodsInfoModel.h"
@interface SXFreeVideoBaseController ()
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *controllArr;
@property (nonatomic, strong) NSMutableArray *cataArr;
@property (nonatomic, strong) SXVideoTagsView *tagsView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *newKcL;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) SXHasUpdateKcModel *kcModel;


@end

@implementation SXFreeVideoBaseController

- (instancetype)init {
    if (self = [super init]) {
       // 6.7.8  10 11 13
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
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

    
    //谁在首页谁需要实现这个功能
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outLogin) name:@"outLoginClearDataNOTICATION" object:nil];
    
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-36-STATUS_BAR_HEIGHT)/2, DR_SCREEN_WIDTH-30, 36)];
    searchBtn.layer.cornerRadius = 18;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.backgroundColor = [[UIColor colorWithHexString:@"#F0F1F5"] colorWithAlphaComponent:1];
    UIImageView *searImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 20)];
    searImg.image = UIImageNamed(@"Image_newsearchss");
    [searchBtn addSubview:searImg];
    self.searchButton = searchBtn;
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCataName) name:@"NOTICEREFRESHCATANAME" object:nil];
    [self refreshCataName];
}

- (UILabel *)newKcL{
    if (!_newKcL) {
        _newKcL = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-96, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-36-STATUS_BAR_HEIGHT)/2, 96, 36)];
        _newKcL.backgroundColor = [UIColor colorWithHexString:@"#D8F361"];
        _newKcL.font = FOURTHTEENTEXTFONTSIZE;
        _newKcL.textAlignment = NSTextAlignmentCenter;
        _newKcL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [_newKcL setAllCorner:18];
        [self.view addSubview:_newKcL];
        _newKcL.text = @"开新课程啦";
        
        self.redView = [[UIView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_newKcL.frame)-7.5, _newKcL.frame.origin.y, 10, 10)];
        self.redView.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        [self.redView setAllCorner:5];
        [self.view addSubview:self.redView];
        
        _newKcL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookKcTap)];
        [_newKcL addGestureRecognizer:tap];
    }
    return _newKcL;
}

- (void)lookKcTap{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"videoSeries/readNotice" Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
      
    } fail:^(NSError * _Nullable error) {
    }];
    
    self.newKcL.hidden = YES;
    self.redView.hidden = YES;
    if (self.kcModel.type.intValue > 0) {
        if (self.kcModel.type.intValue == 2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEFORLOOKKC" object:nil];
        }else if (self.kcModel.type.intValue == 1){
            [self showHUD];
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",self.kcModel.seriesId] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
                [self hideHUD];
                if (success) {
                    if ([dict[@"data"] isEqual:[NSNull null]]) {
                        return;
                    }
                    SXPayForVideoModel *searismodel = [SXPayForVideoModel mj_objectWithKeyValues:dict[@"data"]];
                    if (!searismodel) {
                        return;
                    }
          
                    SXStudyBaseController *ctl = [[SXStudyBaseController alloc] init];
                    ctl.paySearModel = searismodel;
                    [self.navigationController pushViewController:ctl animated:YES];
                 
                }
                
            } fail:^(NSError *error) {
                [self hideHUD];
            }];
        }
    }
    self.kcModel.type = @"0";
    [UIView animateWithDuration:0.3 animations:^{
        self.searchButton.frame = CGRectMake(15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-36-STATUS_BAR_HEIGHT)/2, DR_SCREEN_WIDTH-30, 36);
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshIfHasNew];

}

- (void)refreshCataName{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"videoCategory/get" Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dic in dict[@"data"]) {
                SXGoodsInfoModel *cataM = [SXGoodsInfoModel mj_objectWithKeyValues:dic];
                [arr addObject:cataM.category_name];
            }
            
            if (self.cataArr.count) {
                if (![self.cataArr isEqualToArray:arr]) {//数组元素一样，不执行任何操作，不一样，则更新数据
                    [self.titleArr removeAllObjects];
                    [self.cataArr removeAllObjects];
                    [self.controllArr removeAllObjects];
                    self.cataArr = arr;
                    [self refreshController];
                    DRLog(@"元素更新");
                }else{
                    DRLog(@"元素一样");
                }
            }else{
                self.cataArr = arr;
                [self refreshController];
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)refreshController{
    NoticeVideosController *ctl1 = [[NoticeVideosController alloc] init];
    [self.controllArr addObject:ctl1];
    [self.titleArr addObject:@"全部"];
    
    for (NSString *category_name in self.cataArr) {
        NoticeVideosController *ctl = [[NoticeVideosController alloc] init];
        ctl.categoryName = category_name;
        [self.controllArr addObject:ctl];
        [self.titleArr addObject:category_name];
    }
    
    self.titles = [NSArray arrayWithArray:self.titleArr];
    [self.menuView reload];
    [self reloadData];
}

- (void)refreshIfHasNew{

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"videoSeries/getNotice" Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.kcModel = [SXHasUpdateKcModel mj_objectWithKeyValues:dict[@"data"]];
            if (self.kcModel.type.intValue > 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.searchButton.frame = CGRectMake(15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-36-STATUS_BAR_HEIGHT)/2, DR_SCREEN_WIDTH-96-45, 36);
                } completion:^(BOOL finished) {
                    self.newKcL.hidden = NO;
                    self.redView.hidden = NO;
                }];
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
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
