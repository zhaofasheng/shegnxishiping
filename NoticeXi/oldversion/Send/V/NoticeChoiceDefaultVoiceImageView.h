//
//  NoticeChoiceDefaultVoiceImageView.h
//  NoticeXi
//
//  Created by li lei on 2023/11/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceDefaultChoiceCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoiceDefaultVoiceImageView : UIView<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) BOOL isVoice;
@property (nonatomic, assign) BOOL hasLocaChoice;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) CGFloat lastTransitionY;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isDragScrollView;
@property (nonatomic, assign) BOOL noRequest;
@property (nonatomic, assign) BOOL isVoiceDetail;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^imgCourIdBlock)(NSString *coverId,NSString *url);
@property (nonatomic, copy) void(^imgRefreshBlock)(BOOL refresh);
@property (nonatomic, copy) void(^imgupBlock)(BOOL up);
@property (nonatomic, strong) NSString * __nullable currentCoverId;
@property (nonatomic, strong) NSString * __nullable currentUrl;
- (void)closeClick;
- (void)show;
@end

NS_ASSUME_NONNULL_END
