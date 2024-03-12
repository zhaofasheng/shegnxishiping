//
//  NoticeEmotionButtonCell.h
//  NoticeXi
//
//  Created by li lei on 2023/8/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeEmotionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEmotionButtonCell : BaseCell
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) NoticeEmotionModel *buttonModel;
@end

NS_ASSUME_NONNULL_END
