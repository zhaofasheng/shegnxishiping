//
//  SXBaseCollectionController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseController.h"
#import "CYWWaterFallLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXBaseCollectionController : NoticeBaseController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) CYWWaterFallLayout *layout;
@end

NS_ASSUME_NONNULL_END
