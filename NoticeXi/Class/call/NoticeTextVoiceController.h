//
//  NoticeTextVoiceController.h
//  NoticeXi
//
//  Created by li lei on 2020/7/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "NoticeVoiceSaveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeTextVoiceController : NoticeBaseCellController
@property (nonatomic, strong) NoticeVoiceSaveModel *saveModel;
@end

NS_ASSUME_NONNULL_END
