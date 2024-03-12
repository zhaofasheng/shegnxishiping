//
//  NoticeVipUpRouteCell.h
//  NoticeXi
//
//  Created by li lei on 2023/9/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeSendVipCardView.h"
#import "NoticeVipDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVipUpRouteCell : BaseCell
@property (nonatomic, strong) NoticeVipDataModel *vipModel;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) UILabel *numberL;
@property (nonatomic, strong) UIButton *getButton;
@property (nonatomic, strong) NoticeSendVipCardView *sendCardView;
@end

NS_ASSUME_NONNULL_END
