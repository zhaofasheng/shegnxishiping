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
#import "SXBuyVideoTools.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "SXPlayBuyView.h"
#import "NoticeMoreClickView.h"
#import "NoticeXi-Swift.h"
#import "SXCanBuyAllView.h"
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

@property (nonatomic, strong) UIView *zeroView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) SXPlayBuyView *buyFgView;
@property (nonatomic, strong) UIButton *buyAllButton;
@property (nonatomic, strong) UIView *tryPlayOpenView;
@property (nonatomic, assign) CGFloat moreHeight;
@property (nonatomic, strong) UILabel *openL;

@end

@implementation SXPayVideoPlayDetailBaseController

{
    CGFloat lastContentOffset;
}


- (void)refresUI{
    
    if (self.paySearModel.hasBuy || self.currentPlayModel.unLock || self.currentPlayModel.tryPlayTime) {
        [SXTools setLastPayPlayVideo:self.currentPlayModel.title searisId:self.paySearModel.seriesId];
    }
    
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

//购买课程失败
- (void)buyFaild{
    [self showToastWithText:@"购买失败"];
}


//购买课程成功
- (void)buySuccess{
    [self showToastWithText:@"已解锁当前课程"];
    self.paySearModel.is_bought = @"1";
 
    self.comVC.paySearModel = self.paySearModel;
    [self.comVC.tableView reloadData];
    self.listVC.paySearModel = self.paySearModel;
    [self.listVC.tableView reloadData];
    [self.pagerView reloadData];
    
    self.comVC.currentPlayModel = self.currentPlayModel;
    self.listVC.currentPlayModel = self.currentPlayModel;
    self.listVC.dataArr = self.searisArr;
    self.paySearModel.searisVideoList = self.searisArr;
    
    [self refresUI];
    [self.player _playVideo];
    self.isPause = NO;
    self.buyFgView.hidden = YES;
    
    [self refreshOpenUI];
    
    [self refreshTitle];
}

//购买单集成功
- (void)buySingleSuccess{
   
    DRLog(@"购买单集成功");
    [self showToastWithText:[NSString stringWithFormat:@"已解锁：%@",self.currentPlayModel.title]];
    self.currentPlayModel.is_bought = @"1";
   
    self.comVC.paySearModel = self.paySearModel;
    [self.comVC.tableView reloadData];
    self.listVC.paySearModel = self.paySearModel;
    [self.listVC.tableView reloadData];
    [self.categoryView reloadData];
    [self.pagerView reloadData];
    
    self.comVC.currentPlayModel = self.currentPlayModel;
    self.listVC.currentPlayModel = self.currentPlayModel;
    self.listVC.dataArr = self.searisArr;
    self.paySearModel.searisVideoList = self.searisArr;
    
    self.buyFgView.hasBuySingle = YES;
    [self.buyFgView.allButton setTitle:@"解锁剩余内容" forState:UIControlStateNormal];
    
    [self.player _playVideo];
    self.isPause = NO;
    self.buyFgView.hidden = YES;
    
    [self refreshOpenUI];
    [self refreshTitle];
    
    //判断是否存在单集购买过的产品
    NSInteger hasBuyVideo = 0;
    for (SXSearisVideoListModel *videoM in self.searisArr) {

        if (videoM.unLock) {
            hasBuyVideo ++;
        }
    }
    
    self.paySearModel.hasbuyVideoNum = hasBuyVideo;
    
    NSString *syPrice = @"";
    NSString *title = @"";
    if (self.paySearModel.hasbuyVideoNum > 0) {
        title = @"解锁剩余内容";
        syPrice = [NSString stringWithFormat:@"¥%ld %@",(long)(_paySearModel.price.intValue - self.paySearModel.singlePrice.intValue*self.paySearModel.hasbuyVideoNum),title];
    }else{
        title = @"解锁课程";
        syPrice = [NSString stringWithFormat:@"¥%@ %@",_paySearModel.price,title];
        
    }
    [_buyAllButton setAttributedTitle:[DDHAttributedMode setString:syPrice setSize:16 setLengthString:title beginSize:syPrice.length-title.length] forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.rate) {
        self.rate = 1;
    }
    
    
    //销毁之前的播放
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appdel.playKcTools destroyOldplay];
    
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
    
    if (self.commentId.intValue > 0) {
        self.categoryView.defaultSelectedIndex = 1;
        [self categoryCurentIndex:1];
        [self.categoryView reloadData];
    }
    
    [self refreshTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySingleSuccess) name:@"BUYSINGLESEARISSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccess) name:@"BUYSEARISSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyFaild) name:@"BUYSEARISFAILD" object:nil];
    //退到后台记录播放进度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlayTime) name:@"SXAPPHASINTOBACKGROUNDNOTICE" object:nil];
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
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __weak typeof(self) weakSelf = self;
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    
    configuration.rate = self.rate;
    configuration.screen = self.currentPlayModel.screen.intValue == 2 ? YES : NO;
    
    if (!self.paySearModel.hasBuy && !self.currentPlayModel.unLock && !self.currentPlayModel.tryPlayTime) {//没购买没试看则不自动播放
        configuration.shouldAutoPlay = NO;
        configuration.isTryPlay = self.currentPlayModel.tryPlayTime;
        configuration.noLock = !self.currentPlayModel.unLock;
        
        if (self.isFullPlay) {//如果是全屏，退出全屏
            self.isFullPlay = NO;
            [_player _videoZoomOut];
        }
    }else{
        configuration.shouldAutoPlay =  YES;     //自动播放
    }
    

    configuration.isAutoFull = self.isFullPlay;
    
    configuration.supportedDoubleTap = YES; //支持双击播放暂停
    configuration.shouldAutorotate = YES;   //自动旋转
    configuration.isPay = YES;
    configuration.repeatPlay = NO;  //重复播放
    configuration.statusBarHideState = SelStatusBarHideStateAlways;  //设置状态栏隐藏
    configuration.sourceUrl = [NSURL URLWithString:self.currentPlayModel.video_url];  //设置播放数据源
    configuration.videoGravity = SelVideoGravityResizeAspect;   //拉伸方式
    
    if (!self.paySearModel.hasBuy && !self.currentPlayModel.unLock && self.currentPlayModel.tryPlayTime) {//未解锁试看内容全部从零开始播放
        configuration.defalutPlayTime = 0;
    }else{
        configuration.defalutPlayTime = self.currentPlayModel.schedule.intValue;
    }
    
    
    self.currentPlayModel.screen = @"1";
    
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, (self.currentPlayModel.screen.intValue==2? DR_SCREEN_WIDTH*4/3 : DR_SCREEN_WIDTH*9/16)) configuration:configuration];
    appdel.playKcTools.player = _player;
    appdel.playKcTools.searisArr = self.searisArr;
    appdel.playKcTools.paySearModel = self.paySearModel;
    appdel.playKcTools.rate = self.rate;
    
    _player.playbackControls.rate = self.rate;
    _player.playbackControls.choiceView.currentModel = self.currentPlayModel;
    _player.playbackControls.choiceView.searisArr = self.searisArr;
    _player.currentPlayTimeBlock = ^(NSInteger currentTime) {
  
        if (currentTime >= 5) {
            weakSelf.currentPlayModel.schedule = [NSString stringWithFormat:@"%ld",currentTime];
            if (appdel.playKcTools.isOpenPip && appdel.playKcTools.isLeave) {
                appdel.playKcTools.player.playbackControls.choiceView.currentModel.schedule = [NSString stringWithFormat:@"%ld",currentTime];
            }
      
        }else{
            weakSelf.currentPlayModel.schedule = @"0";
            if (appdel.playKcTools.isOpenPip && appdel.playKcTools.isLeave) {
                appdel.playKcTools.player.playbackControls.choiceView.currentModel.schedule = @"0";
            }
        }
        
        //没有购买过该课程以及没解锁该视频
        if (!weakSelf.paySearModel.hasBuy && !weakSelf.currentPlayModel.unLock && (weakSelf.currentPlayModel.tryPlayTime < weakSelf.currentPlayModel.video_len.intValue)) {
            if (currentTime > weakSelf.currentPlayModel.tryPlayTime) {
                
                if (weakSelf.isFullPlay) {//如果是全屏，退出全屏
                    [weakSelf.player _videoZoomOut];
                }
                
                [weakSelf.player _pauseVideo];
                weakSelf.buyFgView.hidden = NO;
                [weakSelf.view bringSubviewToFront:weakSelf.buyFgView];
            }else{
                weakSelf.buyFgView.hidden = YES;
            }
        }
    };
    
    _player.playbackControls.choiceView.choiceVideoBlock = ^(SXSearisVideoListModel * _Nonnull choiceModel) {
    
        if (!weakSelf.paySearModel.hasBuy && !choiceModel.unLock && !choiceModel.tryPlayTime) {
            [weakSelf.player _videoZoomOut];
        }
        [weakSelf.listVC refreshCurrentModel:choiceModel needScro:YES];
    };
    
    _player.playbackControls.rateClickBlock = ^(NSInteger rate) {
        weakSelf.rate = rate;
        appdel.playKcTools.rate = rate;
    };

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
            if (appdel.playKcTools.isOpenPip && appdel.playKcTools.isLeave) {
                appdel.playKcTools.player.playbackControls.choiceView.currentModel.schedule = @"0";
                appdel.playKcTools.player.playbackControls.choiceView.currentModel.is_finished = @"1";
            }
            weakSelf.currentPlayModel.schedule = @"0";
            weakSelf.currentPlayModel.is_finished = @"1";
            DRLog(@"播放完成");
            if (!appdel.playKcTools.isLeave && !appdel.playKcTools.isOpenPip) {
                [weakSelf.listVC playNext];
            }else if (appdel.playKcTools.isOpenPip){
                [appdel.playKcTools playNext];
            }
        }
    };
    
    _player.backPopBlock = ^(BOOL back) {
        [weakSelf backAction];
    };

    _player.downVideoBlock = ^(BOOL download) {
        
        NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        moreView.isPayVideo = YES;
        moreView.isVideo = YES;
        moreView.clickIndexBlock = ^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                if (!weakSelf.paySearModel.hasBuy) {
                    [weakSelf showToastWithText:@"解锁整个课程才允许窗口播放哦~"];
                    return;
                }
             
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
    
    if (!self.paySearModel.hasBuy && !self.currentPlayModel.unLock) {//没购买没试看则不自动播放
        if (self.currentPlayModel.tryPlayTime) {
            self.buyFgView.hidden = YES;
        }else{
            self.buyFgView.hidden = NO;
        }
        
        self.buyFgView.currentPlayModel = self.currentPlayModel;
    }else{
        _buyFgView.hidden = YES;
    }
        
    if (self.currentIndex == 0) {
        if (self.paySearModel.hasBuy) {
            self.listVC.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-(DR_SCREEN_WIDTH/16*9)-50);
            _buyAllButton.hidden = YES;
        }else{
            self.buyAllButton.hidden = NO;
            [self.view bringSubviewToFront:self.buyAllButton];
            self.listVC.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-(DR_SCREEN_WIDTH/16*9)-50-TAB_BAR_HEIGHT);
        }
    }
    
    [self refreshOpenUI];
}

//刷新是否解锁uI
- (void)refreshOpenUI{
    [self.view bringSubviewToFront:_buyFgView];
    _tryPlayOpenView.hidden = YES;
    self.moreHeight = 10;
    if (!self.paySearModel.hasBuy) {
        if (self.currentPlayModel.tryPlayTime && !self.currentPlayModel.unLock) {
            self.tryPlayOpenView.hidden = NO;
            if (self.currentPlayModel.tryPlayTime >= self.currentPlayModel.video_len.intValue) {
                self.openL.text = @"本节课可试看，购买解锁本课程完整内容";
            }else{
                self.openL.text = [NSString stringWithFormat:@"本节课试看%@，购买解锁本课程完整内容",[self getMMSSFromSS:self.currentPlayModel.tryPlayTime]];
            }
            self.moreHeight = 42;
            self.sectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 50+32);
        }else{
            self.sectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 50);
        }
    }else{
        self.listVC.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-(DR_SCREEN_WIDTH/16*9)-50);
        self.sectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 50);
    }
    
    self.line.frame = CGRectMake(self.line.frame.origin.x, 30+self.moreHeight, self.infoButton.frame.size.width, 4);    self.infoButton.frame = CGRectMake(15, self.sectionView.frame.size.height-40, GET_STRWIDTH(@"课程", 16, 50), 40);
    self.comButton.frame = CGRectMake(CGRectGetMaxX(self.infoButton.frame)+40, self.sectionView.frame.size.height-40, GET_STRWIDTH(@"课程", 16, 50), 40);
    [self.categoryView reloadData];
}

//未解锁覆盖视图
- (SXPlayBuyView *)buyFgView{
    if (!_buyFgView) {
        _buyFgView = [[SXPlayBuyView  alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, (self.currentPlayModel.screen.intValue==2? DR_SCREEN_WIDTH*4/3 : DR_SCREEN_WIDTH*9/16))];
        _buyFgView.paySearModel = self.paySearModel;
        _buyFgView.videoArr = self.searisArr;
        _buyFgView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
        [self.view addSubview:_buyFgView];
        _buyFgView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _buyFgView.backClickBlock = ^(BOOL pop) {
            [weakSelf backAction];
        };
        _buyFgView.buyClickBlock = ^(NSInteger type) {
            if (type == 1) {
                [weakSelf buySingle];
            }else{
                [weakSelf buyAll:0];
            }
        };
    }
    return _buyFgView;
}

//试看
- (UIView *)tryPlayOpenView{
    if (!_tryPlayOpenView) {
        _tryPlayOpenView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 32)];
        _tryPlayOpenView.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.sectionView addSubview:_tryPlayOpenView];
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-50, 0, 50, 32)];
        label.textColor = [UIColor colorWithHexString:@"#FFE7CA"];
        label.font = TWOTEXTFONTSIZE;
        label.text = @"去解锁 >";
        [_tryPlayOpenView addSubview:label];
        _tryPlayOpenView.hidden = YES;
        
        self.openL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-65-15, 32)];
        self.openL.font = TWOTEXTFONTSIZE;
        self.openL.textColor = label.textColor;
        [_tryPlayOpenView addSubview:self.openL];
        _tryPlayOpenView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyAlls)];
        [_tryPlayOpenView addGestureRecognizer:tap];
    }
    return _tryPlayOpenView;
}

-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
 
    NSInteger seconds = totalTime;
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@时%@分%@秒",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
    }else{
        if(str_minute.intValue){
            return [NSString stringWithFormat:@"%@分%@秒",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
        }else{
            return [NSString stringWithFormat:@"%@秒",str_second.intValue?str_second:@"0"];
        }
    }
 
}

//购买单集
- (void)buySingle{

    NSInteger hasBuyVideo = 0;
    for (SXSearisVideoListModel *videoM in self.searisArr) {

        if (videoM.unLock) {
            hasBuyVideo ++;
        }
    }
    
    if ((self.paySearModel.singlePrice.intValue + (self.paySearModel.singlePrice.intValue * hasBuyVideo)) >= self.paySearModel.price.intValue) {//如果解锁单集的时候可以解锁全部
        __weak typeof(self) weakSelf = self;
        SXCanBuyAllView *allView = [[SXCanBuyAllView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [allView showView];
        allView.buyBlock = ^(BOOL buy) {
            [weakSelf buyAll:hasBuyVideo];
        };
        return;
    }

    NSInteger index = 0;
    for (int i = 0; i < self.searisArr.count;i++) {
        SXSearisVideoListModel *videoM = self.searisArr[i];
        if ([videoM.videoId isEqualToString:self.currentPlayModel.videoId]) {
            index = i;
            break;
        }
    }
    [SXBuyVideoTools buyKSinglecvideoId:self.currentPlayModel.videoId product_id:[NSString stringWithFormat:@"%@_%ld",self.paySearModel.product_id,index+1] getOrderBlock:^(SXOrderStatusModel * _Nonnull payModel) {
    }];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.pushBuySuccess = NO;
}

- (void)buyAlls{
    [self buyAll:0];
}

//解锁全部
- (void)buyAll:(NSInteger)number{
    
    //判断是否存在单集购买过的产品
    NSInteger hasBuyVideo = 0;
    if (number > 0) {
        hasBuyVideo = number;
    }else{
        for (SXSearisVideoListModel *videoM in self.searisArr) {

            if (videoM.unLock) {
                hasBuyVideo ++;
            }
        }
    }
 
    
    self.paySearModel.hasbuyVideoNum = hasBuyVideo;
    if (hasBuyVideo > 0) {//购买剩余内容
       // __weak typeof(self) weakSelf = self;
        //需要买的数量，总价减去已经购买的价钱，除单价
        NSInteger needBuy = (self.paySearModel.price.intValue-(self.paySearModel.singlePrice.intValue*hasBuyVideo))/self.paySearModel.singlePrice.intValue;
        [SXBuyVideoTools buyKSyvideoseriesId:self.paySearModel.seriesId product_id:[NSString stringWithFormat:@"%@x%ld",self.paySearModel.product_id,needBuy] money:[NSString stringWithFormat:@"%ld",(long)(needBuy*self.paySearModel.singlePrice.intValue)] getOrderBlock:^(SXOrderStatusModel * _Nonnull payModel) {
         
        }];
    }else{//解锁课程
        [SXBuyVideoTools buyKcseriesId:self.paySearModel.seriesId isSeriesCard:@"0" product_id:self.paySearModel.product_id getOrderBlock:^(SXOrderStatusModel * _Nonnull payModel) {
        }];
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.pushBuySuccess = NO;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)refreshPlayTime{
    if (self.refreshPlayTimeBlock) {
        self.refreshPlayTimeBlock(self.currentPlayModel);
    }
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
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appdel.playKcTools.isOpenPip) {//没开启画中画就暂停播放
        [_player _pauseVideo];
        self.isPause = YES;
    }
    appdel.playKcTools.isLeave = YES;
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
    }
}

- (void)dealloc{
    [self.balckView removeFromSuperview];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appdel.playKcTools.isOpenPip) {//没开启画中画就销毁播放视图
        [self destroyOldplay];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.playKcTools.isLeave = NO;
    if (self.isPause && (self.paySearModel.hasBuy || self.currentPlayModel.unLock)) {
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
        _listVC.paySearModel = self.paySearModel;
        _listVC.currentPlayModel = self.currentPlayModel;
        _listVC.searisArr = self.searisArr;
        __weak typeof(self) weakSelf = self;
        _listVC.choiceVideoBlock = ^(SXSearisVideoListModel * _Nonnull videoModel) {
            
            if (!weakSelf.paySearModel.hasBuy && !videoModel.unLock && !videoModel.tryPlayTime) {
                if (weakSelf.isFullPlay) {
                    [weakSelf.player _videoZoomOut];
                }
            }
            
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
        
        if (self.commentId.intValue > 0) {
            _comVC.type = @"2";
            _comVC.commentId = self.commentId;
            _comVC.topVideoId = self.currentPlayModel.videoId;
            _comVC.replyId = self.replyId;
        }
        _comVC.currentPlayModel = self.currentPlayModel;
        __weak typeof(self) weakSelf = self;
        _comVC.refreshCommentCountBlock = ^(NSString * _Nonnull commentCount) {
            weakSelf.currentPlayModel.commentCt = commentCount;
            [weakSelf refreshTitle];
            [weakSelf.listVC.tableView reloadData];
        };
        _comVC.deleteClickBlock = ^(SXVideoCommentModel * _Nonnull commentM) {
            if (weakSelf.deleteClickBlock) {
                weakSelf.deleteClickBlock(commentM);
            }
        };
    }
    return _comVC;
}

- (void)refreshTitle{
    self.markL.text = self.currentPlayModel.commentCt.intValue?@"说说我的想法...":@"成为第一条评论…";
    self.comButton.text = [NSString stringWithFormat:@"评论%@",self.currentPlayModel.commentCt.intValue?self.currentPlayModel.commentCt:@""];
    self.comButton.frame =  CGRectMake(CGRectGetMaxX(self.infoButton.frame)+40, self.sectionView.frame.size.height-40, GET_STRWIDTH(self.comButton.text, 16, 40),40);
}

- (UILabel *)infoButton{
    if (!_infoButton) {
        _infoButton = [[UILabel  alloc] initWithFrame:CGRectMake(15, self.sectionView.frame.size.height-40, GET_STRWIDTH(@"课程", 16, 50), 40)];
        _infoButton.font = SIXTEENTEXTFONTSIZE;
        _infoButton.textColor = [UIColor colorWithHexString:@"#14151A"];
        _infoButton.userInteractionEnabled = YES;
        _infoButton.tag = 0;
        _infoButton.text = @"课程";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action :@selector(indexTap:)];
        [_infoButton addGestureRecognizer:tap];
    }
    return _infoButton;
}

- (UILabel *)comButton{
    if (!_comButton) {
        _comButton = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.infoButton.frame)+40,self.sectionView.frame.size.height-40, GET_STRWIDTH(@"评价", 16, 40),40)];
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
        self.line.frame = CGRectMake(self.infoButton.frame.origin.x, 30+self.moreHeight, self.infoButton.frame.size.width, 4);
        if (self.paySearModel.hasBuy) {
            self.listVC.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-(DR_SCREEN_WIDTH/16*9)-50);
            _buyAllButton.hidden = YES;
        }else{
            self.buyAllButton.hidden = NO;
            self.listVC.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-(DR_SCREEN_WIDTH/16*9)-50-TAB_BAR_HEIGHT);
        }
        
    }else if (index == 1){
        if (self.paySearModel.hasBuy) {
            self.markView.hidden = NO;
            _buyAllButton.hidden = YES;
        }else{
            if (self.currentPlayModel.unLock || (self.currentPlayModel.tryPlayTime >= self.currentPlayModel.video_len.intValue)) {
                self.markView.hidden = NO;
            }else{
                self.markView.hidden = YES;
            }
            self.buyAllButton.hidden = !self.markView.hidden;
        }
        self.comButton.font = XGSIXBoldFontSize;
        self.line.frame = CGRectMake(self.comButton.frame.origin.x, 30+self.moreHeight, self.comButton.frame.size.width, 4);
        [self.comVC refreshData];
    }

    [self.view bringSubviewToFront:self.markView];
}

- (UIButton *)buyAllButton{
    if (!_buyAllButton) {
        _buyAllButton = [[UIButton  alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT,DR_SCREEN_WIDTH-40, 40)];
        _buyAllButton.backgroundColor = [UIColor colorWithHexString:@"#FF4B98"];
        [_buyAllButton setAllCorner:20];
        _buyAllButton.titleLabel.font = SXNUMBERFONT(20);
        [_buyAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_buyAllButton];
        [_buyAllButton addTarget:self action:@selector(buyAlls) forControlEvents:UIControlEventTouchUpInside];
        
        //判断是否存在单集购买过的产品
        NSInteger hasBuyVideo = 0;
        for (SXSearisVideoListModel *videoM in self.searisArr) {
 
            if (videoM.unLock) {
                hasBuyVideo ++;
            }
        }
        
        self.paySearModel.hasbuyVideoNum = hasBuyVideo;
        
        NSString *syPrice = @"";
        NSString *title = @"";
        if (self.paySearModel.hasbuyVideoNum > 0) {
            title = @"解锁剩余内容";
            syPrice = [NSString stringWithFormat:@"¥%ld %@",(long)(_paySearModel.price.intValue - self.paySearModel.singlePrice.intValue*self.paySearModel.hasbuyVideoNum),title];
        }else{
            title = @"解锁课程";
            syPrice = [NSString stringWithFormat:@"¥%@ %@",_paySearModel.price,title];
            
        }
        [_buyAllButton setAttributedTitle:[DDHAttributedMode setString:syPrice setSize:16 setLengthString:title beginSize:syPrice.length-title.length] forState:UIControlStateNormal];
    }
    return _buyAllButton;
}

@end
