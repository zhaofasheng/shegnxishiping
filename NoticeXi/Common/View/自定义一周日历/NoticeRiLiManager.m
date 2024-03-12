//
//  NoticeRiLiManager.m
//  NoticeXi
//
//  Created by li lei on 2023/8/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeRiLiManager.h"

@implementation NoticeRiLiManager

- (void)refreshPlayDays{
    self.daysArr = [[NSMutableArray alloc] init];
    NSDate * date= [NSDate date];
    
    NSInteger dayNum = 1;
    if(date.cx_hour > 12){//如果当前时间大于12点，时间就延续到第二天
        dayNum = 2;
    }else{//当天时间就行
        dayNum = 1;
    }
    
    for (int i = 0; i < dayNum; i++) {
        NSDate *arrDate = [date dateByAddingTimeInterval:i*D_DAY];
        NoticeRiLiForWeekModel *model = [[NoticeRiLiForWeekModel alloc] init];
        model.year = [NSString stringWithFormat:@"%ld",arrDate.cx_year];
        model.month = [NSString stringWithFormat:@"%ld",arrDate.cx_month];
        model.day = [NSString stringWithFormat:@"%ld",arrDate.cx_day];
        if(i == 0){
            model.daysName = [NSString stringWithFormat:@"%ld月%ld日 今天",arrDate.cx_month,arrDate.cx_day];
        }else{
            model.daysName = [NSString stringWithFormat:@"%ld月%ld日 %@",arrDate.cx_month,arrDate.cx_day,[self weekStringFromDate:arrDate]];
        }
        [self.daysArr addObject:model];
    }

    self.todayHoursArr = [[NSMutableArray alloc] init];
    NSInteger todaysH = 12;
    if((24 - date.cx_hour) < 12){
        todaysH = 24 - date.cx_hour;
    }
    for (NSInteger i = 0; i < todaysH; i++) {
        NoticeRiLiForWeekModel *hourM = [[NoticeRiLiForWeekModel alloc] init];
        hourM.hour = [NSString stringWithFormat:@"%02ld",i+date.cx_hour];
        hourM.hourName = [NSString stringWithFormat:@"%02ld点",i+date.cx_hour];
        [self.todayHoursArr addObject:hourM];
    }
    
    if(self.todayHoursArr.count < 12){
        self.nextDayHoursArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 12-self.todayHoursArr.count; i++) {
            NoticeRiLiForWeekModel *hourM = [[NoticeRiLiForWeekModel alloc] init];
            hourM.hour = [NSString stringWithFormat:@"%02ld",i];
            hourM.hourName = [NSString stringWithFormat:@"%02ld点",i];
            [self.nextDayHoursArr addObject:hourM];
        }
    }

    
    self.todayMinsArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 60-date.cx_minute; i++) {
        NoticeRiLiForWeekModel *hourM = [[NoticeRiLiForWeekModel alloc] init];
        hourM.min = [NSString stringWithFormat:@"%02ld",i+date.cx_minute];
        hourM.minName = [NSString stringWithFormat:@"%02ld分",i+date.cx_minute];
        [self.todayMinsArr addObject:hourM];
    }

    self.otherMinsArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 60; i++) {
        NoticeRiLiForWeekModel *hourM = [[NoticeRiLiForWeekModel alloc] init];
        hourM.min = [NSString stringWithFormat:@"%02ld",i];
        hourM.minName = [NSString stringWithFormat:@"%02ld分",i];
        [self.otherMinsArr addObject:hourM];
    }
}

- (void)refreshDays{
    self.daysArr = [[NSMutableArray alloc] init];
    NSDate * date= [NSDate date];
    for (int i = 0; i < 7; i++) {
        NSDate *arrDate = [date dateByAddingTimeInterval:i*D_DAY];
        NoticeRiLiForWeekModel *model = [[NoticeRiLiForWeekModel alloc] init];
        model.year = [NSString stringWithFormat:@"%ld",arrDate.cx_year];
        model.month = [NSString stringWithFormat:@"%ld",arrDate.cx_month];
        model.day = [NSString stringWithFormat:@"%ld",arrDate.cx_day];
        if(i == 0){
            model.daysName = [NSString stringWithFormat:@"%ld月%ld日 今天",arrDate.cx_month,arrDate.cx_day];
        }else{
            model.daysName = [NSString stringWithFormat:@"%ld月%ld日 %@",arrDate.cx_month,arrDate.cx_day,[self weekStringFromDate:arrDate]];
        }
        [self.daysArr addObject:model];
    }
    
    self.smallHoursArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 24-date.cx_hour; i++) {
        NoticeRiLiForWeekModel *hourM = [[NoticeRiLiForWeekModel alloc] init];
        hourM.hour = [NSString stringWithFormat:@"%02ld",i+date.cx_hour+1];
        hourM.hourName = [NSString stringWithFormat:@"%02ld点",i+date.cx_hour+1];
        [self.smallHoursArr addObject:hourM];
    }
    
    self.hoursArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 24; i++) {
        NoticeRiLiForWeekModel *hourM = [[NoticeRiLiForWeekModel alloc] init];
        hourM.hour = [NSString stringWithFormat:@"%02ld",i];
        hourM.hourName = [NSString stringWithFormat:@"%02ld点",i];
        [self.hoursArr addObject:hourM];
    }
    
    self.minsArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i++) {
        NoticeRiLiForWeekModel *minM = [[NoticeRiLiForWeekModel alloc] init];
        minM.minName = [NSString stringWithFormat:@"%d分",i*5];
        minM.min = [NSString stringWithFormat:@"%d",i*5];
        [self.minsArr addObject:minM];
    }
    
    self.smallMinsArr = [[NSMutableArray alloc] init];
    int minsIndex = (int)(date.cx_minute/5);
    if(minsIndex == 12){
        minsIndex = 11;
    }
    for (int i = 0; i < 12-minsIndex; i++) {
        NoticeRiLiForWeekModel *minM = [[NoticeRiLiForWeekModel alloc] init];
        minM.minName = [NSString stringWithFormat:@"%d分",(i+minsIndex)*5];
        minM.min = [NSString stringWithFormat:@"%d",(i+minsIndex)*5];
        [self.smallMinsArr addObject:minM];
    }
}

- (NSString *)weekStringFromDate:(NSDate *)date{
    NSArray *arr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    return arr[date.cx_weekday-1];
}

@end
