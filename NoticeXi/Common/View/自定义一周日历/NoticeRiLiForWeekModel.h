//
//  NoticeRiLiForWeekModel.h
//  NoticeXi
//
//  Created by li lei on 2023/8/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeRiLiForWeekModel : NSObject
@property (nonatomic, strong) NSString *daysName;
@property (nonatomic, strong) NSString *hourName;
@property (nonatomic, strong) NSString *minName;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *min;
@property (nonatomic, assign) BOOL isChoice;
@end

NS_ASSUME_NONNULL_END
