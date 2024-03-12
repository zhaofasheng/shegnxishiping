//
//  NoticeRiLiManager.h
//  NoticeXi
//
//  Created by li lei on 2023/8/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeRiLiForWeekModel.h"
#import "NSDate+CXCategory.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeRiLiManager : NSObject

@property (nonatomic, strong) NSMutableArray *daysArr;
@property (nonatomic, strong) NSMutableArray *smallMinsArr;//当前时间分钟数组
@property (nonatomic, strong) NSMutableArray *minsArr;//5分钟一个元素的分钟数组
@property (nonatomic, strong) NSMutableArray *smallHoursArr;//当前时间后一个小时的小时数组
@property (nonatomic, strong) NSMutableArray *hoursArr;//一天24小时
@property (nonatomic, strong) NSMutableArray *todayHoursArr;//今天剩余小时数
@property (nonatomic, strong) NSMutableArray *todayMinsArr;//今天第一个小时剩余分钟数
@property (nonatomic, strong) NSMutableArray *nextDayHoursArr;//次日可选小时数(12小时减去今天剩余小时)
@property (nonatomic, strong) NSMutableArray *otherMinsArr;//60分钟分钟数
- (void)refreshDays;
- (void)refreshPlayDays;//播放日历

@end

NS_ASSUME_NONNULL_END
