//
//  NoticePopMenuCell.h
//  NoticeXi
//
//  Created by li lei on 2023/10/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticePopMenuCell : BaseCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NoticeAbout *numberModel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *numberL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *titleImageView;
@end

NS_ASSUME_NONNULL_END
