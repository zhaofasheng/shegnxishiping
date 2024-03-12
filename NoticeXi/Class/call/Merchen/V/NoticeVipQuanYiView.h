//
//  NoticeVipQuanYiView.h
//  NoticeXi
//
//  Created by li lei on 2023/8/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVipQuanYiView : UIView
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, copy) void(^FunBlock)(NSInteger tag);
@property (nonatomic, copy) void(^skinBlock)(NSInteger tag);
@property (nonatomic, assign) BOOL noSkinBlock;
@end

NS_ASSUME_NONNULL_END
