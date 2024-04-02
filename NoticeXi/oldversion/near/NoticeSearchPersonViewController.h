//
//  NoticeSearchPersonViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeSearchPersonViewController : NoticeBaseCellController
- (void)sarchPerson:(NSString *)name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, assign) BOOL olnySearsh;
@property (nonatomic, assign) BOOL sendWhite;//送白噪声卡
@property (nonatomic, assign) BOOL fromSearch;
@end

NS_ASSUME_NONNULL_END
