//
//  SXKcTypeCataModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcTypeCataModel.h"
#import "NoticeComLabelModel.h"
@implementation SXKcTypeCataModel

- (void)setScoreList:(NSArray *)scoreList{
    _scoreList = scoreList;
    self.scoreArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in scoreList) {
        SXKcComDetailModel *scoreM = [SXKcComDetailModel mj_objectWithKeyValues:dic];
        [self.scoreArr addObject:scoreM];
    }
}

- (void)setLabelList:(NSArray *)labelList{
    _labelList = labelList;
    self.labelArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in labelList) {
        NoticeComLabelModel *labelM = [NoticeComLabelModel mj_objectWithKeyValues:dic];
        [self.labelArr addObject:labelM];
    }
}
@end
