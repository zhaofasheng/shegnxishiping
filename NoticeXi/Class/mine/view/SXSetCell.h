//
//  SXSetCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXSetCell : BaseCell
@property (nonatomic, strong) UILabel *subL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *subImageV;
@property (nonatomic, strong) UIView *backView;
@end

NS_ASSUME_NONNULL_END
