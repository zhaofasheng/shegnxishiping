//
//  SXDanLiPlayKcTools.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelVideoPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXDanLiPlayKcTools : UIView
@property (nonatomic, strong) SelVideoPlayer *player;
@property (nonatomic, assign) BOOL isOpenPip;//是否开启画中画
@property (nonatomic, assign) BOOL isLeave;//是否离开了播放界面
- (void)destroyOldplay;
@end

NS_ASSUME_NONNULL_END
