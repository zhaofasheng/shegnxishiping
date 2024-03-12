//
//  NoticeChenjiuMonthsCell.h
//  NoticeXi
//
//  Created by li lei on 2023/12/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeChengjiuMonths.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChenjiuMonthsCell : UICollectionViewCell
@property (nonatomic, strong) NoticeChengjiuMonths *monthsModel;
@property (nonatomic, strong) UIView *dataView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *voiceL;
@property (nonatomic, strong) UILabel *textL;
@property (nonatomic, strong) UILabel *bokeL;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *commentL;
@property (nonatomic, strong) UILabel *commentFromL;
@property (nonatomic, strong) UIView *fromLine;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UIImageView *commentimgView;
@property (nonatomic, strong) UILabel *markL;
@end

NS_ASSUME_NONNULL_END
