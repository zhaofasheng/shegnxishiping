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
    if (_player) {
        [_player _pauseVideo];
        [_player _deallocPlayer];
        [_player deallocAll];
        [_player removeFromSuperview];
        _player = nil;
    }

}
@end
