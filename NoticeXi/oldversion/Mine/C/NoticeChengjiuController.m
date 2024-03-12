//
//  NoticeChengjiuController.m
//  NoticeXi
//
//  Created by li lei on 2023/11/30.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChengjiuController.h"
#import "XLCardSwitch.h"
#import "NoticeZongJieController.h"
#import "LXCalendarMonthModel.h"
@interface NoticeChengjiuController ()

@property (nonatomic, strong) XLCardSwitch *cardSwitch;
@property (nonatomic, strong) XLCardSwitch *yearCardSwitch;
@property (nonatomic, assign) NSInteger currentYearIndex;
@property (nonatomic, strong) NSMutableArray *yearsArr;
@property (nonatomic, strong) NSString *currentYear;
@property (nonatomic, strong) NSString *currentMonth;
@property (nonatomic, assign) BOOL isNoFirst;
@end

@implementation NoticeChengjiuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    
    self.navBarView.hidden = NO;
    self.navBarView.titleL.text = @"成就";
    __weak typeof(self)weakSelf = self;
    //初始化
    self.cardSwitch = [[XLCardSwitch alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-40-92-30)];
    self.cardSwitch.isMonths = YES;
    self.cardSwitch.pagingEnabled = true;
    [self.cardSwitch addCollectionWithItemWidth:DR_SCREEN_WIDTH-60];
    self.cardSwitch.clickIndexBlock = ^(NSInteger currentIndex) {
  
        if(weakSelf.cardSwitch.months.count > currentIndex){
      
            NoticeChengjiuMonths *choiceMonth = weakSelf.cardSwitch.months[currentIndex];
            if(choiceMonth.given_month.intValue == 99 && choiceMonth.is_click.intValue){
                NoticeZongJieController *ctl = [[NoticeZongJieController alloc] init];
                [weakSelf.navigationController pushViewController:ctl animated:YES];
            }
        }
    
    };
    
    self.cardSwitch.scrotoIndexBlock = ^(NSInteger currentIndex) {
        
    };

    [self.view addSubview:self.cardSwitch];
    self.currentYearIndex = 0;
    //初始化
    self.yearCardSwitch = [[XLCardSwitch alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.cardSwitch.frame)+40, DR_SCREEN_WIDTH,92)];
    self.yearCardSwitch.isYear = YES;
    [self.yearCardSwitch addCollectionWithItemWidth:92];
    self.yearCardSwitch.clickIndexBlock = ^(NSInteger currentIndex) {
        if(weakSelf.currentYearIndex != currentIndex){
            if(weakSelf.yearsArr.count > currentIndex){
                NoticeChengjiuMonths *yearM = weakSelf.yearsArr[currentIndex];
                [weakSelf requestMonths:yearM];
            }
        }
        weakSelf.currentYearIndex = currentIndex;
        
    };

    [self.view addSubview:self.yearCardSwitch];
    
    [self requestYears];
}

//获取当前时间戳
-(NSInteger ) getTimeNow{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这一点对时间的处理很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *dateNow = [NSDate date];
    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    return timeStamp.integerValue;
}


- (void)requestYears{
    self.yearsArr = [[NSMutableArray alloc] init];
    LXCalendarMonthModel *monthModel = [[LXCalendarMonthModel alloc] initWithDate:[NSDate date]];
    self.currentYear = [NSString stringWithFormat:@"%ld",monthModel.year];
    self.currentMonth = [NSString stringWithFormat:@"%02ld",monthModel.month];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"summarizeCover/yearData" Accept:@"application/vnd.shengxi.v5.5.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            return ;
        }
        for (NSDictionary *dic in dict[@"data"]) {
            NoticeChengjiuMonths *yearModel = [NoticeChengjiuMonths mj_objectWithKeyValues:dic];
            yearModel.currentYear = self.currentYear;
            yearModel.currentMonth = self.currentMonth;
            [self.yearsArr addObject:yearModel];
        }
        
        if(self.yearsArr.count){
            NoticeChengjiuMonths *currentYearModel = self.yearsArr[0];
            
            //如果是当前年份的一月份，则默认展示上一年
            if((currentYearModel.currentYear.intValue == currentYearModel.year.intValue) && (currentYearModel.currentMonth.intValue == 1)){
                for (int i = 0; i < self.yearsArr.count; i++) {
                    NoticeChengjiuMonths *oldYear = self.yearsArr[i];
                    if(oldYear.year.intValue == (currentYearModel.currentYear.intValue-1)){
                        oldYear.isChoice = YES;
                        self.yearCardSwitch.years = self.yearsArr;
                        self.currentYearIndex = i;
                        [self requestMonths:oldYear];
                        break;
                    }
                }
            }else{
                currentYearModel.isChoice = YES;
                self.yearCardSwitch.years = self.yearsArr;
                [self requestMonths:currentYearModel];
            }

        }
    } fail:^(NSError * _Nullable error) {
        
    }];

}

- (void)requestMonths:(NoticeChengjiuMonths *)yearModel{
    if(yearModel.monthsArr){
        self.cardSwitch.months = yearModel.monthsArr;
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"summarizeCover/summarizeData?year=%@",yearModel.year] Accept:@"application/vnd.shengxi.v5.5.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            return ;
        }
        for (NSDictionary *dic in dict[@"data"]) {
            NoticeChengjiuMonths *monthModel = [NoticeChengjiuMonths mj_objectWithKeyValues:dic];
            monthModel.currentYear = self.currentYear;
            monthModel.currentMonth = self.currentMonth;
            [arr addObject:monthModel];
        }
        yearModel.monthsArr = arr;
        self.cardSwitch.months = arr;
    } fail:^(NSError * _Nullable error) {
        
    }];
}

@end
