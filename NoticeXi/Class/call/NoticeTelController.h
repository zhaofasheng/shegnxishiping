//
//  NoticeTelController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBaseCollectionController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTelController : SXBaseCollectionController
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, strong) NSString *category_Id;
@end

NS_ASSUME_NONNULL_END
