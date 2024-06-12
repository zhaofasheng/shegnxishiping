//
//  SXShopLyStoryModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopLyStoryModel.h"

@implementation SXShopLyStoryModel
- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools updateTimeForRow:created_at];
}

@end
