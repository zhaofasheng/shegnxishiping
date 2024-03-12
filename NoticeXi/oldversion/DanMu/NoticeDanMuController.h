//
//  NoticeDanMuController.h
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseListController.h"
#import "NoticeDanMuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDanMuController : NoticeBaseListController
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic, assign) NSInteger currentItem;
@property (nonatomic, assign) BOOL isSClist;
@property (nonatomic,copy) void (^likeBokeBlock)(NoticeDanMuModel  *boKeModel);
@property (nonatomic, copy) void(^changeBokeIntroBlock)(NSString *intro,NSString *bokeId,NSString *coverUrl);
@property (nonatomic,copy) void (^reloadBlock)(BOOL reload);
@end

NS_ASSUME_NONNULL_END
