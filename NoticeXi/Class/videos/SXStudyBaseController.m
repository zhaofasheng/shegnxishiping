//
//  SXStudyBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXStudyBaseController.h"
#import "SXPayKCDetailComController.h"
#import "SXPayVideoListController.h"
#import "SXKchengIntroController.h"
#import "XLCycleCollectionView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "SXBuySearisController.h"
#import "NoticeMoreClickView.h"
@interface SXStudyBaseController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>


@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) SXPayKCDetailComController *comVC;
@property (nonatomic, strong) SXPayVideoListController *videoVC;
@property (nonatomic, strong) SXKchengIntroController *kcVC;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *imgListView;
@property (nonatomic, strong) UIImageView *priceBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *zeroView;
@property (nonatomic, assign) BOOL shoCom;
@property (nonatomic, strong) UILabel *infoButton;
@property (nonatomic, strong) UILabel *orderButton;
@property (nonatomic, strong) UILabel *comButton;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) XLCycleCollectionView *cyleView;
@end

@implementation SXStudyBaseController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles = @[@"",@"",@""];
    self.navBarView.titleL.text = self.paySearModel.series_name;
    self.navBarView.titleL.alpha = 0;
    

    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,DR_SCREEN_WIDTH,40)];
    self.categoryView.titles = self.titles;
    self.categoryView.delegate = self;

    
    _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    [self.sectionView addSubview:_categoryView];


    if (self.paySearModel.carousel_images.count) {
        self.imgListView.hidden = NO;
        self.cyleView.data = self.paySearModel.carousel_images;
    }

    UIButton *shanreBtn = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
    [shanreBtn setBackgroundImage:UIImageNamed(@"sx_shanrestudyvideo_img") forState:UIControlStateNormal];
    [self.navBarView addSubview:shanreBtn];
    [shanreBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sectionView addSubview:self.infoButton];
    [self.sectionView addSubview:self.orderButton];
    [self.sectionView addSubview:self.comButton];
    [self refreshTitle:self.paySearModel.commentCt];
    
    self.line = [[UIView  alloc] initWithFrame:CGRectMake(self.infoButton.frame.origin.x, 30, self.infoButton.frame.size.width, 4)];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    self.line.layer.cornerRadius = 2;
    self.line.layer.masksToBounds = YES;
    [self.sectionView addSubview:self.line];
    
    self.comVC.paySearModel = self.paySearModel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccess) name:@"BUYSEARISSUCCESS" object:nil];
}

- (void)buySuccess{
    [self.backView removeFromSuperview];
    self.paySearModel.is_bought = @"1";
    if (self.shoCom) {
        self.categoryView.defaultSelectedIndex = 2;
        [self categoryCurentIndex:2];
        self.shoCom = NO;
    }
    self.comVC.paySearModel = self.paySearModel;
    [self.comVC.tableView reloadData];
    self.videoVC.paySearModel = self.paySearModel;
    [self.videoVC.tableView reloadData];
    [self.categoryView reloadData];
    [self.pagerView reloadData];
    [self refreshStatus];
}

- (void)shareClick{
    NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    moreView.isShare = YES;
    moreView.isShareSerise = YES;
    moreView.qqShareUrl = self.paySearModel.qqShareUrl;
    moreView.wechatShareUrl = self.paySearModel.wechatShareUrl;
    moreView.friendShareUrl = self.paySearModel.friendShareUrl;
    moreView.appletId = self.paySearModel.appletId;
    moreView.appletPage = self.paySearModel.appletPage;
    moreView.share_img_url = self.paySearModel.share_img_url;
    moreView.name = [NSString stringWithFormat:@"共%@课时",self.paySearModel.episodes];
    moreView.imgUrl = self.paySearModel.simple_cover_url;
    moreView.title = self.paySearModel.series_name;
    [moreView showTost];
}

- (UIView *)zeroView{
    if (!_zeroView) {
        _zeroView = [[UIView  alloc] initWithFrame:CGRectZero];
    }
    return _zeroView;
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
    return self.paySearModel.hasBuy?self.zeroView: self.imgListView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.paySearModel.hasBuy?0: self.imgListView.frame.size.height+1;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView.frame.size.height;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
  
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.videoVC;
    }else if (index == 1){
        return self.kcVC;
    }
    else{
        return self.comVC;
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
        _videoVC.deleteClickBlock = ^(SXVideoCommentModel * _Nonnull commentM) {
            [weakSelf.comVC deleteCommentWith:commentM.commentId];
        };
    }
    return _videoVC;
}

- (SXPayKCDetailComController *)comVC{
    if (!_comVC) {
        _comVC = [[SXPayKCDetailComController alloc] init];
        _comVC.paySearModel = self.paySearModel;
        __weak typeof(self) weakSelf = self;
        _comVC.refreshCommentCountBlock = ^(NSString * _Nonnull commentCount) {
            [weakSelf refreshTitle:commentCount];
        };
        _comVC.clickVideoIdBlock = ^(NSString * _Nonnull videoId, NSString * _Nonnull commentId) {
            [weakSelf.videoVC gotoPlayViewWith:videoId commentId:commentId];
        };
        _comVC.buyBlock = ^(BOOL buy) {
            weakSelf.shoCom = YES;
            [weakSelf buyClick];
        };
    
    }
    return _comVC;
}

- (void)refreshTitle:(NSString *)commentCoount{
    self.paySearModel.commentCt = commentCoount;
    self.comButton.text = [NSString stringWithFormat:@"评论%@",commentCoount.intValue?commentCoount:@""];
    self.comButton.frame =  CGRectMake(CGRectGetMaxX(self.orderButton.frame)+40, 0, GET_STRWIDTH(self.comButton.text, 16, 40),40);
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
    
    CGFloat markWidth = GET_STRWIDTH(@"", 15, 40);
    CGFloat realPriceWidth = GET_STRWIDTH(price, 21, 40);
    CGFloat oriPriceWidth = GET_STRWIDTH(oriprice, 14, 40);
    CGFloat orSpace = (self.priceBtn.frame.size.width - markWidth-realPriceWidth-oriPriceWidth-2)/2;
    
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(orSpace, 0, markWidth, 40)];
    markL.font = FIFTHTEENTEXTFONTSIZE;
    markL.textColor = [UIColor whiteColor];
    markL.text = @"";
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
            weakSelf.comVC.paySearModel = weakSelf.paySearModel;
            [weakSelf.videoVC refreshStatus];
            [weakSelf.comVC refreshStatus];
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


- (UILabel *)infoButton{
    if (!_infoButton) {
        _infoButton = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, GET_STRWIDTH(@"课程", 16, 50), 40)];
        _infoButton.font = SIXTEENTEXTFONTSIZE;
        _infoButton.textColor = [UIColor colorWithHexString:@"#14151A"];
        _infoButton.userInteractionEnabled = YES;
        _infoButton.tag = 0;
        _infoButton.text = @"课程";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexTap:)];
        [_infoButton addGestureRecognizer:tap];
    }
    return _infoButton;
}

- (UILabel *)orderButton{
    if (!_orderButton) {
        _orderButton = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.infoButton.frame)+40, 0, GET_STRWIDTH(@"简介", 16, 40), 40)];
        _orderButton.font = SIXTEENTEXTFONTSIZE;
        _orderButton.textColor = [UIColor colorWithHexString:@"#14151A"];
        _orderButton.userInteractionEnabled = YES;
        _orderButton.tag = 1;
        _orderButton.text = @"简介";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexTap:)];
        [_orderButton addGestureRecognizer:tap];
    }
    return _orderButton;
}

- (UILabel *)comButton{
    if (!_comButton) {
        _comButton = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.orderButton.frame)+40, 0, GET_STRWIDTH(@"评价", 16, 40),40)];
        _comButton.font = SIXTEENTEXTFONTSIZE;
        _comButton.textColor = [UIColor colorWithHexString:@"#14151A"];
        _comButton.userInteractionEnabled = YES;
        _comButton.tag = 2;
        _comButton.text = @"评论";
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexTap:)];
        [_comButton addGestureRecognizer:tap];
    }
    return _comButton;
}

- (void)indexTap:(UITapGestureRecognizer *)tap{
    UILabel *tapV = (UILabel *)tap.view;
    
    self.categoryView.defaultSelectedIndex = tapV.tag;
    [self categoryCurentIndex:tapV.tag];
    [self.categoryView reloadData];
}

- (void)categoryCurentIndex:(NSInteger)index{

    self.comButton.font = SIXTEENTEXTFONTSIZE;
    self.infoButton.font = SIXTEENTEXTFONTSIZE;
    self.orderButton.font = SIXTEENTEXTFONTSIZE;
    if (index == 0) {
        self.infoButton.font = XGSIXBoldFontSize;
        self.line.frame = CGRectMake(self.infoButton.frame.origin.x, 30, self.infoButton.frame.size.width, 4);
    }else if (index == 1){
        self.orderButton.font = XGSIXBoldFontSize;
        self.line.frame = CGRectMake(self.orderButton.frame.origin.x, 30, self.orderButton.frame.size.width, 4);
    }else if (index == 2){
        self.comButton.font = XGSIXBoldFontSize;
        self.line.frame = CGRectMake(self.comButton.frame.origin.x, 30, self.comButton.frame.size.width, 4);
    }

}

@end
