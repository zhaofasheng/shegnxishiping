//
//  SXBaseCollectionController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseController.h"
#import "CHTCollectionViewWaterfallLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXBaseCollectionController : NoticeBaseController<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

NS_ASSUME_NONNULL_END
