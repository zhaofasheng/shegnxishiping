//
//  SXScVideoAlbumCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "SXVideoZjModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXScVideoAlbumCell : BaseCell
@property (nonatomic, strong) SXVideoZjModel *zjModel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *albumL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIView *fgView;
@end

NS_ASSUME_NONNULL_END
