//
//  NoticeAudioChatTools.h
//  NoticeXi
//
//  Created by li lei on 2023/3/28.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NoticeShopGetOrderTostView.h"
#import "NoticeCallView.h"

NS_ASSUME_NONNULL_BEGIN


@interface NoticeAudioChatTools : UIView
- (void)regTencent;
@property (nonatomic, strong) UIWindow * __nullable callingWindow;
@property (nonatomic, strong) NoticeShopGetOrderTostView *callView;
@property (nonatomic, strong) NSString * __nullable fromUserId;
@property (nonatomic, strong) NSString * __nullable toUserId;
@property (nonatomic, strong) NoticeByOfOrderModel *orderModel;
@property (nonatomic, strong) NSString *selfUserId;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, copy) void(^cancelBlcok)(BOOL cancel);
@property (nonatomic, copy) void(^autoNextBlcok)(BOOL next);
@property (nonatomic, copy) void(^repjectautoNextBlcok)(BOOL next);
@property (nonatomic, copy) void(^repjectBlcok)(BOOL cancel);
@property (nonatomic,assign) BOOL autoCallNexttext;//自动拨打下一通通话
@property (nonatomic,assign) BOOL autoCallNext;//自动拨打下一通通话
@property (nonatomic,assign) BOOL autoCallNexting;//自动拨打下一通通话中

@property (nonatomic,assign) BOOL noReClick;//防止重复点击

- (void)callToUserId:(NSString *)userId roomId:(NSInteger)roomIdNum getOrderTime:(NSString *)getOrderTime nickName:(NSString *)nickName autoNext:(BOOL)autonext;
@property (nonatomic, strong) NoticeCallView * __nullable callingView;
@end

NS_ASSUME_NONNULL_END
