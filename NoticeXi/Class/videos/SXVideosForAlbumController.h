//
//  SXVideosForAlbumController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBaseCollectionController.h"
#import "SXVideoZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVideosForAlbumController : SXBaseCollectionController
@property (nonatomic, strong) SXVideoZjModel *zjModel;
@property (nonatomic,copy) void(^nameChangeBlock)(BOOL change);
@property (nonatomic,copy) void(^deletezjBlock)(SXVideoZjModel *model);
@property (nonatomic, strong) SXVideosModel * __nullable videoModel;
@end

NS_ASSUME_NONNULL_END
