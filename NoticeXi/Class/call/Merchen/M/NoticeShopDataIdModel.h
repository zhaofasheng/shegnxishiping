//
//  NoticeShopDataIdModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopDataIdModel : NSObject
@property (nonatomic, strong) NSString *photo_url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *dataId;
@property (nonatomic, assign) BOOL isChoice;
@end

NS_ASSUME_NONNULL_END
