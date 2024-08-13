//
//  NoticeVideosController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBaseCollectionController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVideosController : SXBaseCollectionController
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, assign) NSInteger type;//1最新,2全部
@end

NS_ASSUME_NONNULL_END
