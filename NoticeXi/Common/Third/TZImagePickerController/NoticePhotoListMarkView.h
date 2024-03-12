//
//  NoticePhotoListMarkView.h
//  NoticeXi
//
//  Created by li lei on 2020/10/14.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticePhotoListMarkView : UICollectionReusableView
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic,copy) void(^openSetingBlock)(BOOL open);
@end

NS_ASSUME_NONNULL_END
