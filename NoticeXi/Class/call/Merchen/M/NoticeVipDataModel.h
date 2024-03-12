//
//  NoticeVipDataModel.h
//  NoticeXi
//
//  Created by li lei on 2023/9/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVipDataModel : NSObject
@property (nonatomic, strong) NSString *cardId;//贡献卡ID
@property (nonatomic, strong) NSString *score;//贡献卡所需贡献值
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *type;//0=待领取1=已领取2=已赠送3=未完成
@property (nonatomic, strong) NSString *days;

@property (nonatomic, strong) NSString *contribute_score;//用户当前贡献值
@property (nonatomic, strong) NSString *card_score;//下一个任务的贡献值
@property (nonatomic, strong) NSString *distance_score;//距离下一个任务还差多少贡献值
@property (nonatomic, strong) NSString *day_score;//今日获得的贡献值

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *title;
@end

NS_ASSUME_NONNULL_END
