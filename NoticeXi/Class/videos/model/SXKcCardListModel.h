//
//  SXKcCardListModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/25.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXKcCardListModel : NSObject

@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) NSString * __nullable blessing_text;//祝福语
@property (nonatomic, strong) NSString *give_status;//赠送状态 1未赠送 2已赠送 3已领取
@property (nonatomic, strong) NSString *share_url;//赠送的url
@property (nonatomic, strong) NSString *card_number;//卡片编号

@property (nonatomic, strong) NSDictionary *to_user_info;//领取者信息
@property (nonatomic, strong) NoticeAbout *getUserInfoM;

@property (nonatomic, strong) NSDictionary *from_user_info;
@property (nonatomic, strong) NoticeAbout *userM;

@property (nonatomic, strong) NSDictionary *series_info;
@property (nonatomic, strong) SXPayForVideoModel *searModel;
@end

NS_ASSUME_NONNULL_END
