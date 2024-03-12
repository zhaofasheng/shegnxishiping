//
//  NoticeVoiceReadMoreCell.h
//  NoticeXi
//
//  Created by li lei on 2022/3/31.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVoiceReadModel.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceReadMoreCell : BaseCell
@property (nonatomic, strong) NoticeVoiceReadModel *readModel;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) CBAutoScrollLabel *nameL;
@property (nonatomic, strong) CBAutoScrollLabel *contentL;
@property (nonatomic, copy) void(^readingBlock)(NoticeVoiceReadModel *moreM);
@end

NS_ASSUME_NONNULL_END
