//
//  SXKcComDetailModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXKcComDetailModel : NSObject

@property (nonatomic, strong) NSString *comId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *is_zan;
@property (nonatomic, strong) NSString *zan_num;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *scoreName;
@property (nonatomic, strong) NSString *series_id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDictionary *user_info;
@property (nonatomic, strong) NoticeAbout *userModel;
@property (nonatomic, strong) NSArray *label_info;
@property (nonatomic, strong) NSString *labelName;
@property (nonatomic, assign) CGFloat labelHeight;

@property (nonatomic, strong) NSString *is_remark;//1=已评价 2删除了自己的评价
@property (nonatomic, strong) NSString *averageScore;//平均分
@property (nonatomic, strong) NSString *averageScoreName;
@property (nonatomic, strong) NSString *ctNum;//评价数量
@end

NS_ASSUME_NONNULL_END
