//
//  SXStudyBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXStudyBaseController.h"

#import "SXPayVideoListController.h"
#import "SXKchengIntroController.h"
#import "XLCycleCollectionView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "SXBuySearisController.h"
@interface SXStudyBaseController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;

@property (nonatomic, strong) SXPayVideoListController *videoVC;
@property (nonatomic, strong) SXKchengIntroController *kcVC;

@property (nonatomic, strong) UIView *imgListView;
@property (nonatomic, strong) UIImageView *priceBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) XLCycleCollectionView *cyleView;
@end

@implementation SXStudyBaseController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.titles = @[@"课程简介",@"课程目录"];
    self.navBarView.titleL.text = self.paySearModel.series_name;
    self.navBarView.titleL.alpha = 0;

    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,DR_SCREEN_WIDTH,40)];
    self.categoryView.titles = self.titles;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#14151A"];
    self.categoryView.titleColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.8];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleFont = SIXTEENTEXTFONTSIZE;
    self.categoryView.titleSelectedFont = XGSIXBoldFontSize;
    self.categoryView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    [self.sectionView addSubview:_categoryView];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
    lineView.lineScrollOffsetX = 2;
    lineView.indicatorHeight = 2;
    lineView.indicatorColor = [UIColor colorWithHexString:@"#1FC7FF"];
    lineView.indicatorWidth = 50;
    self.categoryView.indicators = @[lineView];

    if (self.paySearModel.carousel_images.count) {
        self.imgListView.hidden = NO;
        self.cyleView.data = self.paySearModel.carousel_images;
    }

}

- (UIView *)imgListView{
    if (!_imgListView) {
        _imgListView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/16*9)];

        XLCycleCollectionView *cyleView = [[XLCycleCollectionView alloc] initWithFrame:_imgListView.bounds];
        cyleView.justImag = YES;
        cyleView.autoPage = YES;
        [_imgListView addSubview:cyleView];
        self.cyleView = cyleView;
    }
    return _imgListView;
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.imgListView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.imgListView.frame.size.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 40;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
  
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 1) {
        return self.videoVC;
    }else{
        return self.kcVC;
    }
}

- (SXPayVideoListController *)videoVC{
    if (!_videoVC) {
        _videoVC = [[SXPayVideoListController alloc] init];
        _videoVC.paySearModel = self.paySearModel;
        __weak typeof(self) weakSelf = self;
        _videoVC.buySuccessBlock = ^(NSString * _Nonnull searisID) {
            if (weakSelf.buySuccessBlock) {
                weakSelf.buySuccessBlock(searisID);
            }
        };
    }
    return _videoVC;
}

- (SXKchengIntroController *)kcVC{
    if (!_kcVC) {
        _kcVC = [[SXKchengIntroController alloc] init];
        _kcVC.paySearModel = self.paySearModel;
    }
    return _kcVC;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagerView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-(self.paySearModel.is_bought.boolValue?0:TAB_BAR_HEIGHT));
    self.pagerView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];

    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
}


#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshStatus];
}

- (void)refreshStatus{
    if (!self.paySearModel.hasBuy) {
        [self noBuyView];
    }else{
        self.backView.hidden = YES;
    }
    self.pagerView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-(self.paySearModel.is_bought.boolValue?0:TAB_BAR_HEIGHT));
}

//没有购买时候的底部UI
- (void)noBuyView{
    
    UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    self.backView = backView;
    
    self.priceBtn = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2,5, 234, 40)];
    self.priceBtn.image = UIImageNamed(@"sxpricebak_img");
    [backView addSubview:self.priceBtn];
    
    NSString *price = [NSString stringWithFormat:@"¥%@",self.paySearModel.price];
    NSString *oriprice = [NSString stringWithFormat:@"¥%@",self.paySearModel.original_price];
    
    CGFloat markWidth = GET_STRWIDTH(@"专属价", 15, 40);
    CGFloat realPriceWidth = GET_STRWIDTH(price, 21, 40);
    CGFloat oriPriceWidth = GET_STRWIDTH(oriprice, 14, 40);
    CGFloat orSpace = (self.priceBtn.frame.size.width - markWidth-realPriceWidth-oriPriceWidth-2)/2;
    
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(orSpace, 0, markWidth, 40)];
    markL.font = FIFTHTEENTEXTFONTSIZE;
    markL.textColor = [UIColor whiteColor];
    markL.text = @"专属价";
    markL.textAlignment = NSTextAlignmentCenter;
    [self.priceBtn addSubview:markL];
    
    UILabel *realPriceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markL.frame)+2, 0, realPriceWidth, 40)];
    realPriceL.font = SXNUMBERFONT(20);
    realPriceL.textColor = [UIColor whiteColor];
    realPriceL.text = price;
    realPriceL.textAlignment = NSTextAlignmentCenter;
    [self.priceBtn addSubview:realPriceL];
    
    UILabel *oripriceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(realPriceL.frame), 0, oriPriceWidth, 40)];
    oripriceL.font = SXNUMBERFONT(14);
    oripriceL.textColor = [UIColor whiteColor];
    oripriceL.text = oriprice;
    oripriceL.textAlignment = NSTextAlignmentCenter;
    [self.priceBtn addSubview:oripriceL];
    
    UIView *line = [[UIView  alloc] initWithFrame:CGRectMake(0, 39/2, oriPriceWidth, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [oripriceL addSubview:line];
    
    self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-self.priceBtn.frame.origin.x-116, self.priceBtn.frame.origin.y, 116, 40)];
    [self.buyBtn setBackgroundImage:UIImageNamed(@"sxbuyBtn_img") forState:UIControlStateNormal];
    self.buyBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buyBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [backView addSubview:self.buyBtn];
    [self.buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buyClick{

    SXBuySearisController *ctl = [[SXBuySearisController alloc] init];
    ctl.paySearModel = self.paySearModel;
    __weak typeof(self) weakSelf = self;
    ctl.buySuccessBlock = ^(NSString * _Nonnull searisID) {
        if ([searisID isEqualToString:weakSelf.paySearModel.seriesId]) {
            weakSelf.paySearModel.is_bought = @"1";
            weakSelf.videoVC.paySearModel = weakSelf.paySearModel;
            [weakSelf.videoVC refreshStatus];
            [weakSelf refreshStatus];
            weakSelf.categoryView.defaultSelectedIndex = 0;
            [weakSelf.categoryView reloadData];
            weakSelf.kcVC.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-(weakSelf.paySearModel.is_bought.boolValue?0:TAB_BAR_HEIGHT));
        }
        if (weakSelf.buySuccessBlock) {
            weakSelf.buySuccessBlock(searisID);
        }
        
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView{
    DRLog(@"%.f",scrollView.contentOffset.y);
    CGFloat progress = 1/self.imgListView.frame.size.height;
    CGFloat value = scrollView.contentOffset.y * progress;
    self.navBarView.titleL.alpha = value;
}
@end
