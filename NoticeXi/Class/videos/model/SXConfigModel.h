//
//  SXConfigModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/16.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXConfigModel : NSObject

@property (nonatomic, strong) NSDictionary *websiteBuySeriesUrl;

@property (nonatomic, strong) SXConfigModel *webBuyModel;
@property (nonatomic, strong) NSString *values;//values有值代表需要显示活动  否则不显示在后面拼接相应的课程id，拼接方式：?seriesId=2
@property (nonatomic, strong) NSString *directions;

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSString *countNum;
@end

NS_ASSUME_NONNULL_END
