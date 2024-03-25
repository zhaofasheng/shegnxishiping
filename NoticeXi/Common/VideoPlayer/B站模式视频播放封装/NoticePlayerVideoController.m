//
//  NoticePlayerVideoController.m
//  NoticeXi
//
//  Created by li lei on 2021/11/24.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticePlayerVideoController.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
@interface NoticePlayerVideoController ()
@property (nonatomic, strong) SelVideoPlayer *player;
@end

@implementation NoticePlayerVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
    self.navBarView.hidden = YES;
    
    UIView *balckView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
    [self.view addSubview:balckView];
    balckView.backgroundColor = [UIColor blackColor];

    
    self.tableView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT+STATUS_BAR_HEIGHT);

    __weak typeof(self) weakSelf = self;
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;     //自动播放
    configuration.supportedDoubleTap = YES;     //支持双击播放暂停
    configuration.shouldAutorotate = YES;   //自动旋转
    configuration.repeatPlay = NO;     //重复播放
    configuration.statusBarHideState = SelStatusBarHideStateAlways;     //设置状态栏隐藏
    configuration.sourceUrl = [NSURL URLWithString:self.videoModel.video_url];     //设置播放数据源

    configuration.videoGravity = SelVideoGravityResizeAspect;   //拉伸方式
    configuration.defalutPlayTime = [SXTools getCurrentPlayTime:self.videoModel.vid];
    _player = [[SelVideoPlayer alloc]initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*9/16) configuration:configuration];
    _player.currentPlayTimeBlock = ^(NSInteger currentTime) {
        if (currentTime >= 5) {
            [SXTools setCurrentPlayTime:currentTime vid:weakSelf.videoModel.vid];
        }else{
            [SXTools setCurrentPlayTime:0 vid:weakSelf.videoModel.vid];
        }
    };
    
    _player.backPopBlock = ^(BOOL back) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    _player.playDidEndBlock = ^(BOOL playDidEnd) {
        [SXTools setCurrentPlayTime:0 vid:weakSelf.videoModel.vid];
    };
    
    _player.downVideoBlock = ^(BOOL download) {
        DRLog(@"点击下载");
    };
    
  
    self.tableView.tableHeaderView = _player;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_player _pauseVideo];
    [_player _deallocPlayer];
    [_player removeFromSuperview];
    
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
}
@end
