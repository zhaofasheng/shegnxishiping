//
//  NoticeChengjiuYearCell.h
//  NoticeXi
//
//  Created by li lei on 2023/12/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeChengjiuMonths.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChengjiuYearCell : UICollectionViewCell
@property (nonatomic, strong) NoticeChengjiuMonths *yearModel;
@property (nonatomic, strong) UIImageView *urlImageView;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UILabel *titleL;
@end

NS_ASSUME_NONNULL_END
