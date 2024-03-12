//
//  SXEdcutionTypeCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXEdcutionTypeCell : BaseCell
@property (nonatomic, strong) NSString *currentEdu;
@property (nonatomic, strong) UILabel *edcL;
@property (nonatomic, strong) UIImageView *changePriceBtn;
@property (nonatomic, strong) NSString *edu;
@end

NS_ASSUME_NONNULL_END
