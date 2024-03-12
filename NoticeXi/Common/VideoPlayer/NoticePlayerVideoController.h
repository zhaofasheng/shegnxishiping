//
//  NoticePlayerVideoController.h
//  NoticeXi
//
//  Created by li lei on 2021/11/24.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticePlayerVideoController : NoticeBaseCellController
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) SXVideosModel *videoModel;
@property (nonatomic, assign) BOOL islocal;
@property (nonatomic, assign) NSInteger lastPlayTime;
@property (nonatomic,copy) void(^currentPlayTimeBlock)(NSInteger currentTime);
@end

NS_ASSUME_NONNULL_END
