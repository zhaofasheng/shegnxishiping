//
//  NoticeChangePhoneViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangePhoneViewController : NoticeBaseCellController
@property (nonatomic, assign) BOOL hasThird;
@property (nonatomic, assign) BOOL isThird;
@property (nonatomic, assign) BOOL hasPhone;
@property (nonatomic, assign) BOOL backTokc;
@property (nonatomic, strong) NSString *navtitle;
@property (nonatomic, assign) NSInteger type;//1注册 2登录
@property (nonatomic, strong) NoticeUserInfoModel *regModel;
@property (nonatomic, strong) NSString *phone;
@end

NS_ASSUME_NONNULL_END
