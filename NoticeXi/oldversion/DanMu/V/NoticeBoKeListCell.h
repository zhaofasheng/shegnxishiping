//
//  NoticeBoKeListCell.h
//  NoticeXi
//
//  Created by li lei on 2022/9/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeDanMuModel.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBoKeListCell : BaseCell
@property (nonatomic, strong) NoticeDanMuModel *model;
@property (nonatomic, strong) CBAutoScrollLabel *titleL;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) NSInteger allCount;
@property (nonatomic, assign) NSInteger allBokeNumber;
@property (nonatomic, strong) UIImageView *zanImageView;
@property (nonatomic, strong) UILabel *zanL;
@property (nonatomic, strong) UIImageView *comImageView;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIView *likeView;
@property (nonatomic, strong) UILabel *numberL;
@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, assign) NSInteger currentPageNo;
@property (nonatomic, assign) NSInteger currentIndex;
@end

NS_ASSUME_NONNULL_END
