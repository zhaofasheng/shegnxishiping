//
//  NoticeVipGetStoryCell.h
//  NoticeXi
//
//  Created by li lei on 2023/9/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeVipDataModel.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVipGetStoryCell : BaseCell
@property (nonatomic, strong) NoticeVipDataModel *vipModel;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *numberL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) CBAutoScrollLabel *titleL;
@end

NS_ASSUME_NONNULL_END
