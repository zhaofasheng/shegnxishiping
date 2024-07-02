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
#import "SXPayVideoComController.h"
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
/** 加载指示器 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) SXPlayPayVideoDetailHeaderView *videoHeaderView;
@property (nonatomic, strong) SXplayPayVideoDetailSection *sectionView1;
@property (nonatomic, strong) UIView *balckView;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isFullPlay;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) SXPayVideoComController *comVC;
@property (nonatomic, strong) UILabel *infoButton;
@property (nonatomic, strong) UILabel *comButton;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, assign) NSInteger rate;
@property (nonatomic, strong) UIView *zeroView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIView *markView;
@end

@implementation SXPayVideoPlayDetailBaseController

{
    CGFloat lastContentOffset;
}


- (void)refresUI{
    
    [SXTools setLastPayPlayVideo:self.currentPlayModel.title searisId:self.paySearModel.seriesId];
    
    self.videoHeaderView.model = self.paySearModel;
    self.videoHeaderView.videoModel = self.currentPlayModel;
 
    self.listVC.tableView.tableHeaderView = self.videoHeaderView;
    
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
    
    self.rate = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.zeroView = [[UIView  alloc] initWithFrame:CGRectZero];
    
    self.navBarView.hidden = YES;
    
    UIView *balckView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
    [self.view addSubview:balckView];
    balckView.backgroundColor = [UIColor blackColor];
    
    self.sectionView1 = [[SXplayPayVideoDetailSection alloc] initWithFrame:CGRectMake(0, 120, DR_SCREEN_WIDTH, 40)];
    self.sectionView1.model = self.paySearModel;
    
    self.videoHeaderView = [[SXPlayPayVideoDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 160)];
    [self.videoHeaderView addSubview:self.sectionView1];
    
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,0,GET_STRWIDTH(@"商品的", 18, 50)*2+40,0)];
    self.categoryView.titles = @[@"",@"",@""];;
    self.categoryView.delegate = self;
    

    self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    [self.sectionView addSubview:_categoryView];
    [self.sectionView addSubview:self.infoButton];
    [self.sectionView addSubview:self.comButton];
    
    self.line = [[UIView  alloc] initWithFrame:CGRectMake(self.infoButton.frame.origin.x, 30, self.infoButton.frame.size.width, 4)];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    self.line.layer.cornerRadius = 2;
    self.line.layer.masksToBounds = YES;
    [self.sectionView addSubview:self.line];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    if (self.searisArr.count) {
        [self refresUI];
        [self setPlayView];
    }else{
        [self getVideoList];
    }
    
    
    self.markView = [[UIView  alloc] initWithFrame:CGRectMake(15,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT+5,DR_SCREEN_WIDTH-30, 40)];
    self.markView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.markView.layer.cornerRadius = 20;
    self.markView.layer.masksToBounds = YES;
    self.markView.hidden = YES;
    [self.view addSubview:self.markView];
    self.markView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendComClick)];
    [self.markView addGestureRecognizer:tap2];
    
    self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(10, 0, 180, 40)];
    self.markL.font = FIFTHTEENTEXTFONTSIZE;
    self.markL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.markL.text = @"成为第一条评论…";
    [self.markView addSubview:self.markL];
}

//发送评论
- (void)sendComClick{
    [self.comVC sendComClick];
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
                if (model.screen.intValue == 2) {
                    model.screen = @"1";
                }
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
                self.comVC.currentPlayModel = self.currentPlayModel;
                self.listVC.currentPlayModel = self.currentPlayModel;
                self.listVC.dataArr = self.searisArr;
                self.paySearModel.searisVideoList = self.searisArr;
                
                [self refresUI];
                [self setPlayView];
                
                [self refreshTitle];
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
    configuration.isAutoFull = self.isFullPlay;
    configuration.rate = self.rate;
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
    _player.playbackControls.rate = self.rate;
    _player.playbackControls.choiceView.currentModel = self.currentPlayModel;
    _player.playbackControls.choiceView.searisArr = self.searisArr;
    _player.currentPlayTimeBlock = ^(NSInteger currentTime) {
        if (currentTime >= 5) {
            weakSelf.currentPlayModel.schedule = [NSString stringWithFormat:@"%ld",currentTime];
        }else{
            weakSelf.currentPlayModel.schedule = @"0";
        }
    };
    
    _player.playbackControls.choiceView.choiceVideoBlock = ^(SXSearisVideoListModel * _Nonnull choiceModel) {
        [weakSelf.listVC refreshCurrentModel:choiceModel needScro:YES];
    };
    
//    _player.playbackControls.rateClickBlock = ^(NSInteger rate) {
//        weakSelf.rate = rate;
//    };

    _player.fullBlock = ^(BOOL isFull) {
        weakSelf.isFullPlay = isFull;
        if (isFull) {
            [weakSelf.activityIndicatorView startAnimating];
            [[SXTools getKeyWindow] addSubview:weakSelf.balckView];
            [[SXTools getKeyWindow] bringSubviewToFront:weakSelf.player.fullView];
        }else{
            [weakSelf.balckView removeFromSuperview];
            [weakSelf.activityIndicatorView stopAnimating];
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

- (UIView *)balckView{
    if (!_balckView) {
        _balckView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _balckView.backgroundColor = [UIColor blackColor];
        [_balckView addSubview:self.activityIndicatorView];
        self.activityIndicatorView.center = _balckView.center;
    }
    return _balckView;
}

/** 加载指示器 */
- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activityIndicatorView;
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
    return self.zeroView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.zeroView.frame.size.height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView.frame.size.height;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.sectionView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 2;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 1) {
        return self.comVC;
    }
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
    [self.balckView removeFromSuperview];
    [self destroyOldplay];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isPause) {
        DRLog(@"进入视频调用播放");
        [self.player _playVideo];
        self.isPause = NO;
    }
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
    }
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
            weakSelf.comVC.currentPlayModel = weakSelf.currentPlayModel;
            [weakSelf destroyOldplay];
            [weakSelf setPlayView];
            
            weakSelf.categoryView.defaultSelectedIndex = weakSelf.currentIndex;
            [weakSelf categoryCurentIndex:weakSelf.currentIndex];
            [weakSelf.categoryView reloadData];
            
            [weakSelf refreshTitle];
        };

    }
    return _listVC;
}

- (SXPayVideoComController *)comVC{
    if (!_comVC) {
        _comVC = [[SXPayVideoComController alloc] init];
        _comVC.paySearModel = self.paySearModel;
        _comVC.isVideoCom = YES;
        _comVC.currentPlayModel = self.currentPlayModel;
        __weak typeof(self) weakSelf = self;
        _comVC.refreshCommentCountBlock = ^(NSString * _Nonnull commentCount) {
            weakSelf.currentPlayModel.commentCt = commentCount;
            [weakSelf refreshTitle];
            [weakSelf.listVC.tableView reloadData];
        };
    }
    return _comVC;
}

- (void)refreshTitle{
    self.markL.text = self.currentPlayModel.commentCt.intValue?@"说说我的想法...":@"成为第一条评论…";
    self.comButton.text = [NSString stringWithFormat:@"评论%@",self.currentPlayModel.commentCt.intValue?self.currentPlayModel.commentCt:@""];
    self.comButton.frame =  CGRectMake(CGRectGetMaxX(self.infoButton.frame)+40, 0, GET_STRWIDTH(self.comButton.text, 16, 40),40);
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


- (UILabel *)comButton{
    if (!_comButton) {
        _comButton = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.infoButton.frame)+40, 0, GET_STRWIDTH(@"评价", 16, 40),40)];
        _comButton.font = SIXTEENTEXTFONTSIZE;
        _comButton.textColor = [UIColor colorWithHexString:@"#14151A"];
        _comButton.userInteractionEnabled = YES;
        _comButton.tag = 1;
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
    self.currentIndex = index;
    self.comButton.font = SIXTEENTEXTFONTSIZE;
    self.infoButton.font = SIXTEENTEXTFONTSIZE;
    if (index == 0) {
        self.markView.hidden = YES;
        self.infoButton.font = XGSIXBoldFontSize;
        self.line.frame = CGRectMake(self.infoButton.frame.origin.x, 30, self.infoButton.frame.size.width, 4);
    }else if (index == 1){
        self.markView.hidden = NO;
        self.comButton.font = XGSIXBoldFontSize;
        self.line.frame = CGRectMake(self.comButton.frame.origin.x, 30, self.comButton.frame.size.width, 4);
    }

    [self.view bringSubviewToFront:self.markView];
}


@end
