//
//  NoticeEditCard1Cell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEditCard1Cell : BaseCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);

@property (nonatomic, copy) void(^refreshImgHeightBlock)(NSInteger imgNum);
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) void(^editShopBlock)(BOOL edit);
@property (nonatomic, assign) BOOL justShow;
@end

NS_ASSUME_NONNULL_END
