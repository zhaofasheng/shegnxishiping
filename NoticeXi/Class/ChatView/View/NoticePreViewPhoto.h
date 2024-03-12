//
//  NoticePreViewPhoto.h
//  NoticeXi
//
//  Created by li lei on 2022/5/23.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NoticePreViewPhoto : UIView
@property (nonatomic, strong) NSMutableArray *models;                  ///< All photo models / 所有图片模型数组
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *choiceSelectView;
@property (nonatomic, strong) UIButton *cirButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, assign) BOOL hideToolsView;
@property (nonatomic, assign) BOOL isOnlyOne;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, copy) void(^getPhotosBlock)(NSMutableArray *photos);
@end

NS_ASSUME_NONNULL_END
