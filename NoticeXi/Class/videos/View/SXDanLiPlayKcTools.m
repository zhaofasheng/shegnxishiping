//
//  SXDanLiPlayKcTools.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXDanLiPlayKcTools.h"

@implementation SXDanLiPlayKcTools

- (void)destroyOldplay{
    self.isOpenPip = NO;
    if (_player) {
        [_player _pauseVideo];
        [_player _deallocPlayer];
        [_player deallocAll];
        [_player removeFromSuperview];
        _player = nil;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.pipVC) {
            appdel.pipVC = nil;
        }
    }
}

- (void)playNext{

    for (int i = 0; i < self.searisArr.count; i++) {
        SXSearisVideoListModel *model = self.searisArr[i];
        if ([model.videoId isEqualToString:self.player.playbackControls.choiceView.currentModel.videoId]) {
            if (self.searisArr.count > (i+1)) {
                SXSearisVideoListModel *nextModel = self.searisArr[i+1];
                [self setPlayView:nextModel];
            }
            break;
        }
    }
}

- (void)setPlayView:(SXSearisVideoListModel *)playCurrentModel{

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;

    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    configuration.shouldAutoPlay = YES;     //自动播放
    configuration.supportedDoubleTap = YES; //支持双击播放暂停
    configuration.shouldAutorotate = YES;   //自动旋转
    configuration.isPay = YES;
    configuration.repeatPlay = NO;  //重复播放
    configuration.statusBarHideState = SelStatusBarHideStateAlways;  //设置状态栏隐藏
    configuration.sourceUrl = [NSURL URLWithString:playCurrentModel.video_url];  //设置播放数据源
    configuration.videoGravity = SelVideoGravityResizeAspect;   //拉伸方式
    configuration.defalutPlayTime = playCurrentModel.schedule.intValue;
    playCurrentModel.screen = @"1";
    _player.playerConfiguration = configuration;

    _player.playbackControls.choiceView.currentModel = playCurrentModel;
    [_player autoNextForPip];
    _player.currentPlayTimeBlock = ^(NSInteger currentTime) {
    
        if (currentTime >= 5) {
            if (appdel.playKcTools.isOpenPip && appdel.playKcTools.isLeave) {
                appdel.playKcTools.player.playbackControls.choiceView.currentModel.schedule = [NSString stringWithFormat:@"%ld",currentTime];
            }
        }else{
            if (appdel.playKcTools.isOpenPip && appdel.playKcTools.isLeave) {
                appdel.playKcTools.player.playbackControls.choiceView.currentModel.schedule = @"0";
            }
        }
    };

    _player.playDidEndBlock = ^(BOOL playDidEnd) {
        if (playDidEnd) {
            if (appdel.playKcTools.isOpenPip && appdel.playKcTools.isLeave) {
                appdel.playKcTools.player.playbackControls.choiceView.currentModel.schedule = @"0";
                appdel.playKcTools.player.playbackControls.choiceView.currentModel.is_finished = @"1";
            }
            [appdel.playKcTools playNext];
        }
    };

}

@end
