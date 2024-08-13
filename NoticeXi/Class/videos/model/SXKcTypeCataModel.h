//
//  SXKcTypeCataModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXKcTypeCataModel : NSObject
@property (nonatomic, strong) NSMutableArray *scoreArr;
@property (nonatomic, strong) NSArray *scoreList;
@property (nonatomic, strong) NSArray *labelList;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, strong) NSString *ctNum;
@end

NS_ASSUME_NONNULL_END
