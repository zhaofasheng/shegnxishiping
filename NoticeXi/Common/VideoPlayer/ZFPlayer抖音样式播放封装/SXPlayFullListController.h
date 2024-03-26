//
//  SXPlayFullListController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

@class SXVideosModel;

NS_ASSUME_NONNULL_BEGIN

@interface SXPlayFullListController : NoticeBaseCellController<UINavigationControllerDelegate>
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) NSInteger currentPlayIndex;
@property (nonatomic) BOOL hasMore;

@property (nonatomic, assign) NSInteger rid;

@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) UIImage *startImage;
@property (nonatomic, copy) void(^popbackBlock)(void);
@end

NS_ASSUME_NONNULL_END
