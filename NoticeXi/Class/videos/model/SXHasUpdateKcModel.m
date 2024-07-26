//
//  SXHasNewKcModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasUpdateKcModel.h"
#import "SXPayForVideoModel.h"
@implementation SXHasUpdateKcModel



- (void)setCan_bind_list:(NSArray *)can_bind_list{
    _can_bind_list = can_bind_list;
    self.canArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in can_bind_list) {
        SXPayForVideoModel *model = [SXPayForVideoModel mj_objectWithKeyValues:dic];
        [self.canArr addObject:model.bookseries_name];
    }
}

- (void)setCannot_bind_list:(NSArray *)cannot_bind_list{
    _cannot_bind_list = cannot_bind_list;
    self.noCanArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in cannot_bind_list) {
        SXPayForVideoModel *model = [SXPayForVideoModel mj_objectWithKeyValues:dic];
        [self.noCanArr addObject:model.bookseries_name];
    }
}
@end
