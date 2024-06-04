//
//  NoticeEditCardCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEditCardCell : BaseCell
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);
@property (nonatomic, copy) void(^changeNameBlock)(BOOL change);
@property (nonatomic, copy) void(^sexBlock)(BOOL boy);
@property (nonatomic, strong) UILabel *nameL;

@property (nonatomic, strong) UIView *maleButton;
@property (nonatomic, strong) UIImageView *boyImageV;
@property (nonatomic, strong) UILabel *boyL;
@property (nonatomic, strong) UIView *faleButton;
@property (nonatomic, strong) UIImageView *girlImageV;
@property (nonatomic, strong) UILabel *girlL;
@end

NS_ASSUME_NONNULL_END
