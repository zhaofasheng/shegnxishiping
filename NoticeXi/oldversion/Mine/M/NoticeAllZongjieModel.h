//
//  NoticeAllZongjieModel.h
//  NoticeXi
//
//  Created by li lei on 2023/12/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeAbout.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeAllZongjieModel : NSObject

@property (nonatomic, strong) NSString *user_num;
@property (nonatomic, strong) NSString *use_user_num;
@property (nonatomic, strong) NSString *story_num;
@property (nonatomic, strong) NSString *online_days;
@property (nonatomic, strong) NSString *latest_time;
@property (nonatomic, strong) NSString *night_online_days;
@property (nonatomic, strong) NSString *had_shop;
@property (nonatomic, strong) NSString *order_num;
@property (nonatomic, strong) NSString *cure_num;
@property (nonatomic, strong) NSString *time_period;
@property (nonatomic, strong) NSString *time_periodName;
@property (nonatomic, strong) NSString *time_Range;
@property (nonatomic, strong) NSString *most_user_id;
@property (nonatomic, strong) NSDictionary *most_user;
@property (nonatomic, strong) NoticeAbout *userM;
@property (nonatomic, strong) NSString *most_shop_id;
@property (nonatomic, strong) NSString *most_shop_name;
@property (nonatomic, strong) NSString *most_topic_id;
@property (nonatomic, strong) NSString *most_topic_name;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) NSString *music_url;

@property (nonatomic, strong) NSString *activity_status;//活动状态 1未开始 2已开始 3已结束
@property (nonatomic, strong) NSString *letter_status;//信件状态 1未寄信 2已寄信 3已收信
@property (nonatomic, strong) NSString *last_letter_time;

@property (nonatomic, strong) NSString *letter_content;

@property (nonatomic, strong) NSDictionary *letter_user;
@property (nonatomic, strong) NoticeAbout *letterUser;
@end

NS_ASSUME_NONNULL_END
