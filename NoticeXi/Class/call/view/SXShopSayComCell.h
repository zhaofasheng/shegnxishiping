//
//  SXShopSayComCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXShopSayComModel.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayComCell : BaseCell<LCActionSheetDelegate>
@property (nonatomic, strong) SXShopSayComModel *commentM;
@property (nonatomic, strong) UILabel *authorL;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *replyL;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeL;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic,copy) void(^replyClickBlock)(SXShopSayComModel *commentM);
@property (nonatomic,copy) void(^deleteClickBlock)(SXShopSayComModel *commentM);
@property (nonatomic, strong) UIView *replyToView;
@property (nonatomic, strong) UILabel *replyNameL;
@end

NS_ASSUME_NONNULL_END
