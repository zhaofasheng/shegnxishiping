//
//  SXPayVideoPlayDetailBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPayVideoPlayDetailBaseController.h"
#import "SXPayVideoPlayDetailListController.h"

#import "SXplayPayVideoDetailSection.h"
#import "SXPlayPayVideoDetailHeaderView.h"

#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"

#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"

#import "NoticeMoreClickView.h"
#import "NoticeXi-Swift.h"
@interface SXPayVideoPlayDetailBaseController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) SXPayVideoPlayDetailListController *listVC;

@property (nonatomic, strong) SelVideoPlayer *player;

@property (nonatomic, strong) SXPlayPayVideoDetailHeaderView *videoHeaderView;
@property (nonatomic, strong) SXplayPayVideoDetailSection *sectionView;

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, assign) BOOL isPause;

@end

@implementation SXPayVideoPlayDetailBaseController

{
    CGFloat lastContentOffset;
}


- (void)refresUI{
    
    [SXTools setLastPayPlayVideo:self.currentPlayModel.title searisId:self.paySearModel.seriesId];
    
    self.videoHeaderView.model = self.paySearModel;
    self.videoHeaderView.videoModel = self.currentPlayModel;
    CGFloat videoHeaderHeight = 90+self.currentPlayModel.titleHeight;
 
    if (self.currentPlayModel.screen.intValue == 2) {//如果是竖屏
        self.videoHeaderView.frame =  CGRectMake(0, 0, 0, (DR_SCREEN_WIDTH*4/3)-(DR_SCREEN_WIDTH/16*9)+videoHeaderHeight);
    }else{
        self.videoHeaderView.frame =  CGRectMake(0, 0, 0, videoHeaderHeight);
    }

    [self.pagerView removeFromSuperview];
    self.pagerView = nil;
    
    _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
        _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    

    [self.view addSubview:self.pagerView];
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    [self.categoryView reloadData];
    [self.view bringSubviewToFront:self.player];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navBarView.hidden = YES;
    
    UIView *balckView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
    [self.view addSubview:balckView];
    balckView.backgroundColor = [UIColor blackColor];
    
    self.sectionView = [[SXplayPayVideoDetailSection alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
    self.sectionView.model = self.paySearModel;
    
    self.videoHeaderView = [[SXPlayPayVideoDetailHeaderView alloc] init];
    
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,GET_STRWIDTH(@"商品的", 18, 50)*2+40,0)];
    self.categoryView.titles = @[@"",@"",@""];;
    self.categoryView.delegate = self;
    

    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    if (self.searisArr.count) {
        [self refresUI];
        [self setPlayView];
    }else{
        [self getVideoList];
    }
}

- (NSMutableArray *)searisArr{
    if (!_searisArr) {
        _searisArr = [[NSMutableArray alloc] init];
    }
    return _searisArr;
}

- (void)getVideoList{
    NSString *url = @"";
    
    [self showHUD];
    url = [NSString stringWithFormat:@"series/%@/video",self.paySearModel.seriesId];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.searisArr removeAllObjects];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
     
            NSString *oldPlayVideoName = [SXTools getPayPlayLastsearisId:self.paySearModel.seriesId];
            for (NSDictionary *dic in dict[@"data"]) {
                SXSearisVideoListModel *model = [SXSearisVideoListModel mj_objectWithKeyValues:dic];
                if (oldPlayVideoName) {
                    if ([model.title isEqualToString:oldPlayVideoName]) {
                        self.currentPlayModel = model;
                    }
                }
                [self.searisArr addObject:model];
            }
         
            if (self.searisArr.count) {
                
                if (!self.currentPlayModel) {
                    self.currentPlayModel = self.searisArr[0];
                }
                
                self.listVC.currentPlayModel = self.currentPlayModel;
                self.listVC.dataArr = self.searisArr;
                self.paySearModel.searisVideoList = self.searisArr;
                [self refresUI];
                [self setPlayView];
            }
        }
        [self hideHUD];
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)setPlayView{
    
    __weak typeof(self) weakSelf = self;
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.screen = self.currentPlayModel.screen.intValue==2?YES:NO;
    configuration.shouldAutoPlay = YES;     //自动播放
    configuration.supportedDoubleTap = YES;     //支持双击播放暂停
    configuration.shouldAutorotate = YES;   //自动旋转
    configuration.isPay = YES;
    configuration.repeatPlay = NO;     //重复播放
    configuration.statusBarHideState = SelStatusBarHideStateAlways;     //设置状态栏隐藏
    configuration.sourceUrl = [NSURL URLWithString:self.currentPlayModel.video_url];     //设置播放数据源
    configuration.videoGravity = SelVideoGravityResizeAspect;   //拉伸方式
    configuration.defalutPlayTime = self.currentPlayModel.schedule.intValue;
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, (self.currentPlayModel.screen.intValue==2? DR_SCREEN_WIDTH*4/3 : DR_SCREEN_WIDTH*9/16)) configuration:configuration];
    _player.currentPlayTimeBlock = ^(NSInteger currentTime) {
        if (currentTime >= 5) {
            weakSelf.currentPlayModel.schedule = [NSString stringWithFormat:@"%ld",currentTime];
        }else{
            weakSelf.currentPlayModel.schedule = @"0";
        }
    };
    
    _player.playDidEndBlock = ^(BOOL playDidEnd) {
        if (playDidEnd) {
            weakSelf.currentPlayModel.schedule = @"0";
            weakSelf.currentPlayModel.is_finished = @"1";
            DRLog(@"播放完成");
            [weakSelf.listVC playNext];
        }
    };
    
    _player.backPopBlock = ^(BOOL back) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };

    _player.downVideoBlock = ^(BOOL download) {
        
        NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        moreView.isPayVideo = YES;
        moreView.isVideo = YES;
        moreView.clickIndexBlock = ^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                //判断当前是否为画中画
                if (appdel.pipVC.isPictureInPictureActive) {
                    //关闭画中画
                    [appdel.pipVC stopPictureInPicture];
                } else {
                    //开始画中画
                    [appdel.pipVC startPictureInPicture];
                }
            }else{
                NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
                juBaoView.reouceId = weakSelf.currentPlayModel.videoId;
                juBaoView.reouceType = @"148";
                [juBaoView showView];
            }
           
        };
        [moreView showTost];
    };
    
    [self.view addSubview:self.player];
    
    [self refresUI];
}

- (SXPayVideoPlayDetailListController *)listVC{
    if(!_listVC){
        _listVC = [[SXPayVideoPlayDetailListController alloc] init];
        _listVC.currentPlayModel = self.currentPlayModel;
        _listVC.searisArr = self.searisArr;
        __weak typeof(self) weakSelf = self;
        _listVC.choiceVideoBlock = ^(SXSearisVideoListModel * _Nonnull videoModel) {
            
            if (weakSelf.refreshPlayTimeBlock) {
                weakSelf.refreshPlayTimeBlock(weakSelf.currentPlayModel);
            }
            
            weakSelf.currentPlayModel = videoModel;
            [weakSelf destroyOldplay];
            [weakSelf setPlayView];
        };

    }
    return _listVC;
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.navBarView];
    // 在定义JXPagerView的时候
    if (@available(iOS 15.0, *)) {
      _pagerView.mainTableView.sectionHeaderTopPadding = 0;
    }
    self.pagerView.frame = CGRectMake(0,STATUS_BAR_HEIGHT+DR_SCREEN_WIDTH/16*9, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-(DR_SCREEN_WIDTH/16*9));

    self.pagerView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.videoHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.videoHeaderView.frame.size.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView.frame.size.height;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 1;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    return self.listVC;
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return YES;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.currentPlayModel.screen.intValue == 2) {
        CGFloat height = DR_SCREEN_WIDTH*4/3-scrollView.contentOffset.y;
        if (height > DR_SCREEN_WIDTH/16*9) {
            self.player.frame = CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_WIDTH*4/3-scrollView.contentOffset.y);
        }else{
            self.player.frame = CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_WIDTH/16*9);
        }
        [self.player refreshUI];
    }

}

- (void)mainTableViewWillBeginDraggingScroll:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)destroyOldplay{
    [_player _pauseVideo];
    [_player _deallocPlayer];
    [_player deallocAll];
    [_player removeFromSuperview];
    _player = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.refreshPlayTimeBlock) {
        self.refreshPlayTimeBlock(self.currentPlayModel);
    }
    if (self.refreshBuyPlayTimeBlock) {
        self.refreshBuyPlayTimeBlock(self.currentPlayModel, self.paySearModel);
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_player _pauseVideo];
    self.isPause = YES;
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)dealloc{
    [self destroyOldplay];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isPause) {
        [self.player _playVideo];
        self.isPause = NO;
    }
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
    }

}



@end
