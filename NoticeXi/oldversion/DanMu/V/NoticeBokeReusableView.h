//
//  NoticeBokeReusableView.h
//  NoticeXi
//
//  Created by li lei on 2023/11/3.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCycleCollectionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBokeReusableView : UICollectionReusableView
@property (nonatomic, strong) XLCycleCollectionView *cyleView;
@end

NS_ASSUME_NONNULL_END
