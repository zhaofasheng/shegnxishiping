//
//  NoticeVipIdentifyCell.h
//  NoticeXi
//
//  Created by li lei on 2023/8/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVipIdentifyCell : BaseCell

@property (nonatomic, strong) UILabel *lelveL;
@property (nonatomic, strong) UIImageView *leveBackMarkImageV;
@property (nonatomic, strong) UIImageView *levleMarkView;
@property (nonatomic, strong) UILabel *pointsL;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
