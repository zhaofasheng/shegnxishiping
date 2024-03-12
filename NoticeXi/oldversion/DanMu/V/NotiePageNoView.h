//
//  NotiePageNoView.h
//  NoticeXi
//
//  Created by li lei on 2023/10/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NotiePageNoView : UIView<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat lastTransitionY;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isDragScrollView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger allCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^choicePageNoBlock)(NSInteger pageNo);
- (void)show;
@end

NS_ASSUME_NONNULL_END
