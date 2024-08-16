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
#import "SXConfigModel.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "SXBuySearisController.h"
#import "NoticeMoreClickView.h"
#import "SXHasBuyKcHeaderView.h"
#import "SXKCBuyTypeView.h"
#import "NoticeLoginViewController.h"
#import "CMUUIDManager.h"
#import "SXBuyKcCardController.h"
#import "NoticeWebViewController.h"
#import "SXKcNoBuyScoreHeaderView.h"
@interface SXStudyBaseController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>


@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) SXPayKCDetailComController *comVC;
@property (nonatomic, strong) SXPayVideoListController *videoVC;
@property (nonatomic, strong) SXKchengIntroController *kcVC;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSString *webBuyUrl;
@property (nonatomic, strong) SXKcNoBuyScoreHeaderView *imgListView;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *webButton;
@property (nonatomic, strong) SXHasBuyKcHeaderView *zeroView;
@property (nonatomic, assign) BOOL shoCom;
@property (nonatomic, strong) UILabel *infoButton;
@property (nonatomic, strong) UILabel *orderButton;
@property (nonatomic, strong) UILabel *comButton;
@property (nonatomic, strong) UIView *sectionView;


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
        self.imgListView.paySearModel = self.paySearModel;

        [self.categoryView reloadData];
        [self.pagerView reloadData];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyCardSuccess) name:@"BUYCARDSEARISSUCCESS" object:nil];
}

//购买课程成功
- (void)buySuccess{
    [self.webButton removeFromSuperview];
    [self.backView removeFromSuperview];
    self.paySearModel.is_bought = @"1";
    self.paySearModel.buy_card_times = [NSString stringWithFormat:@"%d",self.paySearModel.buy_card_times.intValue+1];
    if (self.shoCom) {
        self.categoryView.defaultSelectedIndex = 2;
        [self categoryCurentIndex:2];
        self.shoCom = NO;
    }
    self.zeroView.paySearModel = self.paySearModel;
    self.comVC.paySearModel = self.paySearModel;
    [self.comVC.tableView reloadData];
    self.videoVC.paySearModel = self.paySearModel;
    [self.videoVC.tableView reloadData];
    [self.categoryView reloadData];
    [self.pagerView reloadData];
    [self refreshStatus];
}

//卡片购买成功
- (void)buyCardSuccess{
    if (self.shoCom) {
        self.categoryView.defaultSelectedIndex = 2;
        [self categoryCurentIndex:2];
        self.shoCom = NO;
    }
    self.paySearModel.buy_card_times = [NSString stringWithFormat:@"%d",self.paySearModel.buy_card_times.intValue+1];
    self.zeroView.paySearModel = self.paySearModel;
    self.comVC.paySearModel = self.paySearModel;
    [self.comVC.tableView reloadData];
    self.videoVC.paySearModel = self.paySearModel;
    [self.videoVC.tableView reloadData];
    [self.categoryView reloadData];
    [self.pagerView reloadData];
    [self refreshStatus];
    
    if (self.buySuccessBlock) {
        self.buySuccessBlock(self.paySearModel.seriesId,self.paySearModel.buy_card_times,self.paySearModel.is_bought);
    }
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

- (SXHasBuyKcHeaderView *)zeroView{
    if (!_zeroView) {
        _zeroView = [[SXHasBuyKcHeaderView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 178+80)];
        _zeroView.paySearModel = self.paySearModel;
        __weak typeof(self) weakSelf = self;
        _zeroView.buyTypeBolck = ^(BOOL isSend) {
            if (isSend) {
                [weakSelf sendVideoClick];
            }else{
                [weakSelf buyClick];
            }
        };
        _zeroView.refreshComUIBolck = ^(BOOL refresh) {
            [weakSelf.categoryView reloadData];
            [weakSelf.pagerView reloadData];
        };
    }
    return _zeroView;
}

- (SXKcNoBuyScoreHeaderView *)imgListView{
    if (!_imgListView) {
        _imgListView = [[SXKcNoBuyScoreHeaderView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/16*9+157)];

    }
    return _imgListView;
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return (self.paySearModel.hasBuy || self.paySearModel.buy_card_times.intValue) ? self.zeroView : self.imgListView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return (self.paySearModel.hasBuy || self.paySearModel.buy_card_times.intValue) ? self.zeroView.frame.size.height: (self.imgListView.frame.size.height+1);
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
    self.pagerView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-((self.paySearModel.is_bought.boolValue || self.paySearModel.buy_card_times.intValue) ?0:TAB_BAR_HEIGHT));
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
    if (self.paySearModel.hasBuy || self.paySearModel.buy_card_times.intValue) {
        [self.backView removeFromSuperview];
        [self.webButton removeFromSuperview];
        if (self.zeroView.paySearModel.remarkModel) {
            [self.zeroView refreshComUI:self.zeroView.paySearModel.remarkModel];
        }
    }else{
        [self noBuyView];
        
    }
    self.pagerView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-((self.paySearModel.is_bought.boolValue || self.paySearModel.buy_card_times.intValue) ?0:TAB_BAR_HEIGHT));
}

//跳转购买
- (void)webBuyClick{
    
    NSURL *taobaoUrl = [NSURL URLWithString:self.webBuyUrl];

    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:taobaoUrl]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
         
                [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        DRLog(@"跳转成功");
                    }
                }];
            }
        } else {
            [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    DRLog(@"跳转成功");
                }
            }];
        }
    }else{

        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        ctl.url = self.webBuyUrl;
        ctl.isFromShare = YES;
        ctl.isMerechant = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

//没有购买时候的底部UI
- (void)noBuyView{
    
    UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    self.backView = backView;
    
    if ([NoticeTools getuserId]) {
        UIButton *sendBtn = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-144-80,5, 80, 40)];
        [sendBtn setBackgroundImage:UIImageNamed(@"sxpricebak_img") forState:UIControlStateNormal];
        [sendBtn setTitle:@"赠送" forState:UIControlStateNormal];
        sendBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backView addSubview:sendBtn];
        [sendBtn addTarget:self action:@selector(sendVideoClick) forControlEvents:UIControlEventTouchUpInside];
        
        if (![[NoticeTools getuserId] isEqualToString:@"2"] && [NoticeTools getuserId]) {
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"config?key=websiteBuySeriesUrl" Accept:@"application/vnd.shengxi.v5.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    SXConfigModel *configM = [SXConfigModel mj_objectWithKeyValues:dict[@"data"]];
                    if (configM.webBuyModel.values && configM.webBuyModel.values.length) {
                        
                        UIView *webBuyeV = [[UIView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-96, self.backView.frame.origin.y-56-23-18, 96, 56+23)];
                        [self.view addSubview:webBuyeV];
                        webBuyeV.userInteractionEnabled = YES;
                        UITapGestureRecognizer *webTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webBuyClick)];
                        [webBuyeV addGestureRecognizer:webTap];
                        
                        UIImageView *webImagV1 = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 23, 96, 56)];
                        webImagV1.image = UIImageNamed(@"webBuy_img");
                        webImagV1.userInteractionEnabled = YES;
                        [webBuyeV addSubview:webImagV1];
                        
                        UIImageView *webImagV2 = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, 96, 50)];
                        webImagV2.image = UIImageNamed(@"webBuy_img1");
                        webImagV2.userInteractionEnabled = YES;
                        [webBuyeV addSubview:webImagV2];
                  
                        self.webBuyUrl = [NSString stringWithFormat:@"%@?seriesId=%@",configM.webBuyModel.values,self.paySearModel.seriesId];
                        // 先缩小
                        webBuyeV.transform = CGAffineTransformMakeScale(0.5, 0.5);
                        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
                        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                            // 放大
                            webBuyeV.transform = CGAffineTransformMakeScale(1, 1);
                        } completion:nil];
                    }
                    
                  
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
          
        }
      
    }

    NSString *price = [NSString stringWithFormat:@"¥%@",self.paySearModel.price];
    NSString *oriprice = [NSString stringWithFormat:@"¥%@",self.paySearModel.original_price];
    
    CGFloat realPriceWidth = GET_STRWIDTH(price, 20, 40);
    CGFloat oriPriceWidth = GET_STRWIDTH(oriprice, 14, 40);
    
    UILabel *realPriceL = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, realPriceWidth, 35)];
    realPriceL.font = SXNUMBERFONT(20);
    realPriceL.textColor = [UIColor colorWithHexString:@"#FF4B98"];
    realPriceL.text = price;
    [self.backView addSubview:realPriceL];
    
    UILabel *oripriceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(realPriceL.frame), 5, oriPriceWidth, 35)];
    oripriceL.font = SXNUMBERFONT(14);
    oripriceL.textColor = [UIColor colorWithHexString:@"#FF4B98"];
    oripriceL.text = oriprice;
    [self.backView addSubview:oripriceL];
    
    UIView *line = [[UIView  alloc] initWithFrame:CGRectMake(0, 34/2, oriPriceWidth-2, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#FF4B98"];
    [oripriceL addSubview:line];
    
    self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-112, 5, 112, 40)];
    [self.buyBtn setBackgroundImage:UIImageNamed(@"sxbuyBtn_img") forState:UIControlStateNormal];
    self.buyBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buyBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [backView addSubview:self.buyBtn];
    [self.buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
}

//赠送课程
- (void)sendVideoClick{
    SXBuyKcCardController *ctl = [[SXBuyKcCardController alloc] init];
    ctl.paySearModel = self.paySearModel;
    [self.navigationController pushViewController:ctl animated:YES];
}

//购买课程
- (void)buyClick{
    
    if ([NoticeTools getuserId]) {
        [self sureApplePay];
    }else{
        [self showHUD];
        //获得UUID存入keyChain中
        NSUUID *UUID=[UIDevice currentDevice].identifierForVendor;
        NSString *uuid = [CMUUIDManager readUUID];
        
        if (uuid==nil) {
            [CMUUIDManager deleteUUID];
            [CMUUIDManager saveUUID:UUID.UUIDString];
            uuid = UUID.UUIDString;
        }
  
        
        //设备登录
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:uuid forKey:@"uuid"];
        [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"users/loginByUuid" Accept:@"application/vnd.shengxi.v5.8.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:dict[@"data"]];
                if (userM.token && userM.token.length > 10) {
                    [self loginOrNoLoginBuy:userM.token];
                }else{
                    [self login];
                }
                
            }else{
                [self login];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
            [self login];
        }];
    }

}

- (void)sureApplePay{
    
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
            weakSelf.buySuccessBlock(searisID,weakSelf.paySearModel.buy_card_times,weakSelf.paySearModel.is_bought);
        }
        
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)loginOrNoLoginBuy:(NSString *)token{
    __weak typeof(self) weakSelf = self;
    SXKCBuyTypeView *buyTypeView = [[SXKCBuyTypeView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    buyTypeView.buyTypeBlock = ^(NSInteger type) {
        if (type == 0) {
            [weakSelf login];
        }else{
            [SXTools saveLocalToken:token];
            [self sureApplePay];
        }
    };
    [buyTypeView showTost];
}

- (void)login{
    NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
    ctl.backTokc = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)mainTableViewDidScroll:(UIScrollView *)scrollView{
   
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
