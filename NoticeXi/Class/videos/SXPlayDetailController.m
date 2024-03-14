//
//  SXPlayDetailController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayDetailController.h"
#import "SXPlayDetailListController.h"
#import "SXVideoHeaderDetailView.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"
#import "SXTosatView.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "NoticeVoiceDownLoadController.h"
#import "NoticeMoreClickView.h"
#import "NoticeXi-Swift.h"
@interface SXPlayDetailController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) SXPlayDetailListController *listVC;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;

@property (nonatomic, strong) SelVideoPlayer *player;

@property (nonatomic, strong) SXVideoHeaderDetailView *videoHeaderView;

@property (nonatomic, assign) BOOL isNotPop;
@property (nonatomic, assign) BOOL isPause;
@end

@implementation SXPlayDetailController
{
    CGFloat lastContentOffset;
}

- (void)refresUI{
    
    self.videoHeaderView.videoModel = self.currentPlayModel;
    
    CGFloat videoHeaderHeight = self.currentPlayModel.titleHeight+5+self.currentPlayModel.introHeight+20+56;
    
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

    self.videoHeaderView = [[SXVideoHeaderDetailView alloc] init];
    [self refresUI];
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,GET_STRWIDTH(@"商品的", 18, 50)*2+40,0)];
    self.categoryView.titles = @[@"",@"",@""];;
    self.categoryView.delegate = self;
    

    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    [self setPlayView];
}

- (void)setPlayView{
    __weak typeof(self) weakSelf = self;
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.screen = self.currentPlayModel.screen.intValue==2?YES:NO;
    configuration.shouldAutoPlay = YES;     //自动播放
    configuration.supportedDoubleTap = YES;     //支持双击播放暂停
    configuration.shouldAutorotate = YES;   //自动旋转
    configuration.repeatPlay = NO;     //重复播放
    configuration.statusBarHideState = SelStatusBarHideStateAlways;     //设置状态栏隐藏
    configuration.sourceUrl = [NSURL URLWithString:self.currentPlayModel.video_url];     //设置播放数据源
    configuration.videoGravity = SelVideoGravityResizeAspect;   //拉伸方式
    configuration.defalutPlayTime = [SXTools getCurrentPlayTime:self.currentPlayModel.vid];
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, (self.currentPlayModel.screen.intValue==2? DR_SCREEN_WIDTH*4/3 : DR_SCREEN_WIDTH*9/16)) configuration:configuration];
    _player.currentPlayTimeBlock = ^(NSInteger currentTime) {
        if (currentTime >= 5) {
            [SXTools setCurrentPlayTime:currentTime vid:weakSelf.currentPlayModel.vid];
        }else{
            [SXTools setCurrentPlayTime:0 vid:weakSelf.currentPlayModel.vid];
        }
    };
    
    _player.backPopBlock = ^(BOOL back) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    _player.playDidEndBlock = ^(BOOL playDidEnd) {
        [SXTools setCurrentPlayTime:0 vid:weakSelf.currentPlayModel.vid];
    };
    
    _player.downVideoBlock = ^(BOOL download) {
        NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        moreView.isVideo = YES;
        moreView.clickIndexBlock = ^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [SXTools getDownloadModelAndDownWithVideoModel:weakSelf.currentPlayModel successBlcok:^(BOOL success) {
                    if (success) {
                        SXTosatView *tosatView = [[SXTosatView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-217)/2,(DR_SCREEN_HEIGHT-54)/2-100, 217, 54)];
                        tosatView.lookSaveListBlock = ^(BOOL look) {
                            weakSelf.isNotPop = YES;
                            NoticeVoiceDownLoadController *ctl = [[NoticeVoiceDownLoadController alloc] init];
                            [weakSelf.navigationController pushViewController:ctl animated:YES];
                        };
                        [tosatView showSXToast];
                    }
                }];
            }else{
                NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
                juBaoView.reouceId = weakSelf.currentPlayModel.vid;
                juBaoView.reouceType = @"148";
                [juBaoView showView];
            }
        };
        [moreView showTost];
    };
        
    [self.view addSubview:self.player];
    
    [self refresUI];
}

- (SXPlayDetailListController *)listVC{
    if(!_listVC){
        _listVC = [[SXPlayDetailListController alloc] init];
        _listVC.currentPlayModel = self.currentPlayModel;
        __weak typeof(self) weakSelf = self;
        _listVC.choiceVideoBlock = ^(SXVideosModel * _Nonnull videoModel) {
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
    return self.videoHeaderView.sectionView.frame.size.height;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.videoHeaderView.sectionView;
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
