//
//  NoticeChengJiuCell.h
//  NoticeXi
//
//  Created by li lei on 2023/12/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeAllZongjieModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChengJiuCell : BaseCell
@property (nonatomic, strong) NoticeAllZongjieModel *dataModel;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *view0;
@property (nonatomic, strong) UILabel *peopleL;
@property (nonatomic, strong) UILabel *useL;
@property (nonatomic, strong) UILabel *storyL;

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UILabel *hereL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *withL;

@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UILabel *jiedaiL;
@property (nonatomic, strong) UILabel *zhiyuL;
@property (nonatomic, strong) UILabel *andL;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *andView;

@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UILabel *topicL;
@property (nonatomic, strong) UILabel *topicMarkL;

@property (nonatomic, strong) UIView *view4;
@property (nonatomic, assign) NSInteger index;


@end

NS_ASSUME_NONNULL_END
