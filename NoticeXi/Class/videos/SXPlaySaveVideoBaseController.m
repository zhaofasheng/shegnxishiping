//
//  SXPlaySaveVideoBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlaySaveVideoBaseController.h"
#import "SXPlayChcahVideoController.h"
#import "JXCategoryView.h"
#import "JXPagerView.h"
#import "JXPagerListRefreshView.h"

#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
@interface SXPlaySaveVideoBaseController ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) SXPlayChcahVideoController *goodsVC;

@property (nonatomic, strong) SelVideoPlayer *player;

@property (nonatomic, strong) UIView *shopHeaderView;
@property (nonatomic, strong) UIView *sectionView;
@end

@implementation SXPlaySaveVideoBaseController


- (void)refresUI{
    if (self.downloadModel.screen.intValue == 2) {//如果是竖屏
        self.shopHeaderView.frame =  CGRectMake(0, 0, 0, (self.downloadModel.screen.intValue==2? DR_SCREEN_WIDTH*4/3 : DR_SCREEN_WIDTH*9/16)-(DR_SCREEN_WIDTH/16*9));
    }else{
        self.shopHeaderView.frame =  CGRectMake(0, 0, 0, 0);
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
    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,0)];
    
    UIView *balckView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
    [self.view addSubview:balckView];
    balckView.backgroundColor = [UIColor blackColor];

    self.shopHeaderView = [[UIView alloc] init];
    self.shopHeaderView.backgroundColor = self.view.backgroundColor;
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
    configuration.shouldAutoPlay = YES;     //自动播放
    configuration.isPlayLocalVideo = YES;//播放的是本地视频
    configuration.supportedDoubleTap = YES;     //支持双击播放暂停
    configuration.shouldAutorotate = YES;   //自动旋转
    configuration.repeatPlay = NO;     //重复播放
    configuration.screen = self.downloadModel.screen.intValue==2?YES:NO;
    configuration.statusBarHideState = SelStatusBarHideStateNever;     //设置状态栏隐藏
    configuration.sourceUrl = [NSURL fileURLWithPath:self.downloadModel.localPath];
    configuration.videoGravity = SelVideoGravityResizeAspect;   //拉伸方式
    configuration.defalutPlayTime = [SXTools getSaveCurrentPlayTime:self.downloadModel.vid];
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, (self.downloadModel.screen.intValue==2? DR_SCREEN_WIDTH*4/3 : DR_SCREEN_WIDTH*9/16)) configuration:configuration];
    _player.currentPlayTimeBlock = ^(NSInteger currentTime) {
        if (currentTime >= 5) {
            [SXTools setSaveCurrentPlayTime:currentTime vid:weakSelf.downloadModel.vid];
        }else{
            [SXTools setSaveCurrentPlayTime:0 vid:weakSelf.downloadModel.vid];
        }
    };
    
    _player.playDidEndBlock = ^(BOOL playDidEnd) {
        [SXTools setSaveCurrentPlayTime:0 vid:weakSelf.downloadModel.vid];
    };
    
    _player.backPopBlock = ^(BOOL back) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.player];
    
    [self refresUI];
}


- (SXPlayChcahVideoController *)goodsVC{
    if(!_goodsVC){
        _goodsVC = [[SXPlayChcahVideoController alloc] init];
        _goodsVC.currentPlayModel = self.downloadModel;
        __weak typeof(self) weakSelf = self;
        _goodsVC.choiceVideoBlock = ^(HWDownloadModel * _Nonnull videoModel) {
            weakSelf.downloadModel = videoModel;
            [weakSelf destroyOldplay];
            [weakSelf setPlayView];
        };
   
    }
    return _goodsVC;
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
    return self.shopHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.shopHeaderView.frame.size.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 0;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 1;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    return self.goodsVC;
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
    self.player.frame = CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, (self.downloadModel.screen.intValue==2? DR_SCREEN_WIDTH*4/3 : DR_SCREEN_WIDTH*9/16)-scrollView.contentOffset.y);
    [self.player refreshUI];
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
    [self destroyOldplay];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
    }
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noPop = NO;
}


@end
