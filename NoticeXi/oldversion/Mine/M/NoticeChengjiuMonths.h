//
//  NoticeChengjiuMonths.h
//  NoticeXi
//
//  Created by li lei on 2023/12/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChengjiuMonths : NSObject

@property (nonatomic, strong) NSString *currentYear;
@property (nonatomic, strong) NSString *currentMonth;

//年份数量
@property (nonatomic, strong) NSString *back_url;//图片链接
@property (nonatomic, strong) NSString *year;//年
@property (nonatomic, strong) NSMutableArray *monthsArr;
@property (nonatomic, assign) BOOL isChoice;

//年份里面的月份
@property (nonatomic, strong) NSString *given_year;//年份
@property (nonatomic, strong) NSString *given_month;//月份 月份0表示年终总结 99表示特殊活动
@property (nonatomic, strong) NSString *cover_url;//图片链接

//月份里面的具体数据
@property (nonatomic, strong) NoticeChengjiuMonths *dataModel;
@property (nonatomic, strong) NSDictionary *datas;
@property (nonatomic, strong) NSString *contentType;//1=文字类型2=图片类型3表情包
@property (nonatomic, strong) NSString *type;//1=心情留言2=播客留言3求助帖留言4配音留言
@property (nonatomic, strong) NSString *content;//内容，根据contentType来判断
@property (nonatomic, strong) NSString *voiceLen;//语音秒
@property (nonatomic, strong) NSString *podcastLen;//播客秒
@property (nonatomic, strong) NSString *textLen;//文字心情长度
@property (nonatomic, strong) NSString *is_click;//1=可以点击0=不能点击

@end

NS_ASSUME_NONNULL_END
