//
//  SXPlayFullListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayFullListController.h"
#import "SXFullPlayCell.h"
#import "DDVideoPlayerManager.h"
#import "SDImageCache.h"
#import "TTCCom.h"
#import "NoticeMoreClickView.h"
#import "NoticeXi-Swift.h"
#import "SXTosatView.h"
#import "NoticeVoiceDownLoadController.h"

@interface SXPlayFullListController ()<ZFManagerPlayerDelegate>

@property (nonatomic, strong) UIView *fatherView;
//这个是播放视频的管理器
@property (nonatomic, strong) DDVideoPlayerManager *videoPlayerManager;
//这个是预加载视频的管理器
@property (nonatomic, strong) DDVideoPlayerManager *preloadVideoPlayerManager;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, assign) BOOL nodata;
@property (nonatomic, assign) BOOL isFirstAlloc;
@property (nonatomic, strong) UIButton *downloadBtn;
@end

@implementation SXPlayFullListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstAlloc = YES;
    self.pageNo = self.page;
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    self.tableView.pagingEnabled = YES;
    self.tableView.estimatedRowHeight = SCREEN_HEIGHT;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.rowHeight = DR_SCREEN_HEIGHT;
    [self.tableView registerClass:[SXFullPlayCell class] forCellReuseIdentifier:@"cell"];

    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    [self playIndex:self.currentPlayIndex];
    if(self.modelArray.count > (self.currentPlayIndex + 1)) {
        [self preLoadIndex:self.currentPlayIndex + 1];
    }
    
    [self.view bringSubviewToFront:self.navBarView];
    [self.navBarView.backButton setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
    [self.navBarView addSubview:self.downloadBtn];
}

- (UIButton *)downloadBtn{
    if (!_downloadBtn) {
        _downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-45, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-45)/2, 45, 45)];
        [_downloadBtn setImage:UIImageNamed(@"sxdownload_img") forState:UIControlStateNormal];
        [_downloadBtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadBtn;
}

- (void)downClick{
    NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    moreView.isVideo = YES;
    __weak typeof(self) weakSelf = self;
    moreView.clickIndexBlock = ^(NSInteger buttonIndex) {
        if (weakSelf.currentPlayIndex < weakSelf.modelArray.count) {
            SXVideosModel *currentPlaySmallVideoModel = weakSelf.modelArray[weakSelf.currentPlayIndex];
            
            if (buttonIndex == 1) {
                [SXTools getDownloadModelAndDownWithVideoModel:currentPlaySmallVideoModel successBlcok:^(BOOL success) {
                    if (success) {
                        SXTosatView *tosatView = [[SXTosatView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-217)/2,(DR_SCREEN_HEIGHT-54)/2-100, 217, 54)];
                        tosatView.lookSaveListBlock = ^(BOOL look) {
                            NoticeVoiceDownLoadController *ctl = [[NoticeVoiceDownLoadController alloc] init];
                            [self.navigationController pushViewController:ctl animated:YES];
                        };
                        [tosatView showSXToast];
                    }
                }];
            }else if(buttonIndex == 0){
                NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
                juBaoView.reouceId = currentPlaySmallVideoModel.vid;
                juBaoView.reouceType = @"148";
                [juBaoView showView];
            }
        }
        
    };
    [moreView showTost];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SXFullPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.videoModel = self.modelArray[indexPath.row];
    cell.commentId = self.commentId;
    cell.replyId = self.replyId;
    __weak typeof(self) weakSelf = self;
    
    cell.showComBlock = ^(BOOL show) {
        if (show) {
            weakSelf.needPopCom = NO;
            weakSelf.videoPlayerManager.playerView.controlView.slider.hidden = YES;
            weakSelf.navBarView.hidden = YES;
        }else{
            weakSelf.navBarView.hidden = NO;
            weakSelf.videoPlayerManager.playerView.controlView.slider.hidden = NO;
        }
    };
    
    
    cell.openMoreBlock = ^(BOOL open) {
        weakSelf.tableView.scrollEnabled = !open;
    };
    
    cell.fullBlock = ^(BOOL show) {
        if (show) {
            [weakSelf.videoPlayerManager.playerView fullPlay];
        }
    };
    
    cell.fatherBlock = ^(CGRect bounds) {
        weakSelf.videoPlayerManager.playerView.frame = bounds;
        weakSelf.videoPlayerManager.playerView.playerLayer.frame = bounds;
    };
    
    return cell;
}

- (void)request{
  
    if (self.isRequesting || self.nodata || self.isSearch || self.noRequest) {
        return;
    }
    
    self.pageNo += 1;
    self.isRequesting = YES;
    NSString *url = @"";
    url = [NSString stringWithFormat:@"video/list?pageNo=%ld",self.pageNo];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            BOOL hasData = NO;
            for (NSDictionary *dic in dict[@"data"]) {
                SXVideosModel *videoM = [SXVideosModel mj_objectWithKeyValues:dic];
                videoM.textContent = [NSString stringWithFormat:@"%@\n%@",videoM.title,videoM.introduce];
                [self.modelArray addObject:videoM];
                hasData = YES;
            }
            if (!hasData) {
                self.nodata = YES;
                return;
            }
            
            if (self.modelArray.count) {
                [self.tableView reloadData];
                
                SXFullPlayCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0]];
                self.fatherView = currentCell.playerFatherView;
                [self.fatherView addSubview:self.videoPlayerManager.playerView];
                
                if (self.dataBlock) {
                    self.dataBlock(self.pageNo, self.modelArray);
                }
            }
       
        }
        self.isRequesting = NO;
    } fail:^(NSError * _Nullable error) {
        self.isRequesting = NO;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = round(self.tableView.contentOffset.y / SCREEN_HEIGHT);
    if(self.currentPlayIndex != currentIndex) {
        if(self.currentPlayIndex > currentIndex) {
            [self preLoadIndex:currentIndex-1];
        } else if(self.currentPlayIndex < currentIndex) {
            [self preLoadIndex:currentIndex+1];
        }
        self.currentPlayIndex = currentIndex;
        [self playIndex:self.currentPlayIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat currentIndex = self.tableView.contentOffset.y / SCREEN_HEIGHT;
    if(fabs(currentIndex - self.currentPlayIndex)>1) {
        [self.videoPlayerManager resetPlayer];
        [self.preloadVideoPlayerManager resetPlayer];
    }
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 15;
    
    if(y > h + reload_distance) {
        [self request];
    }
    
    if (offset.y < -80) {
        [self showToastWithText:@"到顶啦~"];
    }
}

- (void)playIndex:(NSInteger)currentIndex {

    SXFullPlayCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    
    NSString *artist = nil;
    NSString *title = nil;
    NSString *cover_url = nil;
    NSURL *videoURL = nil;
    NSURL *originVideoURL = nil;
    BOOL useDownAndPlay = NO;
    AVLayerVideoGravity videoGravity = AVLayerVideoGravityResizeAspect;
    

    SXVideosModel *currentPlaySmallVideoModel = self.modelArray[currentIndex];

    title = currentPlaySmallVideoModel.title;
    cover_url = currentPlaySmallVideoModel.first_frame_url;
    videoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    originVideoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    useDownAndPlay = YES;
    if(currentPlaySmallVideoModel.screen.intValue == 2) {
        videoGravity = AVLayerVideoGravityResizeAspectFill;
    } else {
        videoGravity = AVLayerVideoGravityResizeAspect;
    }
    self.videoPlayerManager = nil;
    
    self.fatherView = currentCell.playerFatherView;
    self.videoPlayerManager.playerModel.isFirstAlloc = self.isFirstAlloc;
 
    self.isFirstAlloc = NO;
    self.videoPlayerManager.playerModel.screen = currentPlaySmallVideoModel.screen.intValue==1?NO:YES;
    self.videoPlayerManager.playerModel.seekTime = currentPlaySmallVideoModel.seekTime;
    self.videoPlayerManager.playerModel.videoGravity = videoGravity;
    self.videoPlayerManager.playerModel.fatherView       = self.fatherView;
    self.videoPlayerManager.playerModel.title            = title;
    self.videoPlayerManager.playerModel.artist = artist;
    self.videoPlayerManager.playerModel.placeholderImageURLString = cover_url;
    self.videoPlayerManager.playerModel.videoURL         = videoURL;
    self.videoPlayerManager.originVideoURL = originVideoURL;
    self.videoPlayerManager.playerModel.useDownAndPlay = YES;
    //如果设备存储空间不足200M,那么不要边下边播
    if([self deviceFreeMemorySize] < 200) {
        self.videoPlayerManager.playerModel.useDownAndPlay = NO;
    }
    [self.videoPlayerManager resetToPlayNewVideo];
    
    if (self.needPopCom && self.noRequest) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0];
        SXFullPlayCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.needPopCom = self.needPopCom;
        self.needPopCom = NO;
    }
}

- (CGFloat)deviceFreeMemorySize {
    /// 总大小
    float totalsize = 0.0;
    /// 剩余大小
    float freesize = 0.0;
    /// 是否登录
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue]*1.0/(1024);
        
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue]*1.0/(1024);
    } else
    {
        DRLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return freesize/1024.0;
}


//预加载
- (void)preLoadIndex:(NSInteger)index {
    
    [self.preloadVideoPlayerManager resetPlayer];
    if(self.modelArray.count <= index || [self deviceFreeMemorySize] < 200  || index<0) {
        return;
    }
    
    NSString *artist = nil;
    NSString *title = nil;
    NSString *cover_url = nil;
    NSURL *videoURL = nil;
    NSURL *originVideoURL = nil;
    BOOL useDownAndPlay = NO;
    
    //关注,推荐
    SXVideosModel *currentPlaySmallVideoModel = self.modelArray[index];
    title = currentPlaySmallVideoModel.title;
    cover_url = currentPlaySmallVideoModel.video_cover_url;
    videoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    originVideoURL = [NSURL URLWithString:currentPlaySmallVideoModel.video_url];
    useDownAndPlay = YES;
    
    self.preloadVideoPlayerManager.playerModel.seekTime = currentPlaySmallVideoModel.seekTime;
    self.preloadVideoPlayerManager.playerModel.title            = title;
    self.preloadVideoPlayerManager.playerModel.artist = artist;
   // self.preloadVideoPlayerManager.playerModel.placeholderImageURLString = cover_url;
    self.preloadVideoPlayerManager.playerModel.videoURL         = videoURL;
    self.preloadVideoPlayerManager.originVideoURL = originVideoURL;
    self.preloadVideoPlayerManager.playerModel.useDownAndPlay = YES;
    self.preloadVideoPlayerManager.playerModel.isAutoPlay = NO;
    [self.preloadVideoPlayerManager resetToPlayNewVideo];
    
}

- (void)backClick{
    [self.videoPlayerManager resetPlayer];
    [self.preloadVideoPlayerManager resetPlayer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.videoPlayerManager autoPause];
    
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.videoPlayerManager autoPlay];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        // Fallback on earlier versions
    }
}


- (void)zfManager_playerCurrentSliderValue:(NSInteger)value playerModel:(ZFPlayerModel *)model{
    if (self.currentPlayIndex < self.modelArray.count) {
        SXVideosModel *currentM = self.modelArray[self.currentPlayIndex];
        currentM.seekTime = value;
    }
}

- (void)zfManager_playerFinished:(ZFPlayerModel *)model{
    if (self.currentPlayIndex < self.modelArray.count) {
        SXVideosModel *currentM = self.modelArray[self.currentPlayIndex];
        currentM.seekTime = 0;
    }
}

//开始拖动进度
- (void)beginChangeVlue{

    if (self.currentPlayIndex < self.modelArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0];
        SXFullPlayCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.infoView.hidden = YES;
    }
}

//结束拖动进度
- (void)endChangeVlue{
    if (self.currentPlayIndex < self.modelArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPlayIndex inSection:0];
        SXFullPlayCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.infoView.hidden = NO;

    }
}

#pragma mark - LazyLoad

- (DDVideoPlayerManager *)videoPlayerManager {
    if(!_videoPlayerManager) {
        _videoPlayerManager = [[DDVideoPlayerManager alloc] init];
        _videoPlayerManager.managerDelegate = self;
    }
    return _videoPlayerManager;
}

- (DDVideoPlayerManager *)preloadVideoPlayerManager {
    if(!_preloadVideoPlayerManager) {
        _preloadVideoPlayerManager = [[DDVideoPlayerManager alloc] init];
    }
    return _preloadVideoPlayerManager;
}
@end
