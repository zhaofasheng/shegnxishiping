//
//  SXKcComDetailModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/13.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcComDetailModel.h"
#import "NoticeComLabelModel.h"
@implementation SXKcComDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"comId":@"id"};
}

- (void)setScore:(NSString *)score{
    _score = score;
    if (score.intValue == 1) {
        self.scoreName = @"挺难评";
    }else if (score.intValue == 2){
        self.scoreName = @"不太行";
    }else if (score.intValue == 3){
        self.scoreName = @"一般吧";
    }else if (score.intValue == 4){
        self.scoreName = @"挺不错";
    }else if (score.intValue == 5){
        self.scoreName = @"超满意";
    }else{
        self.scoreName = @"";
    }
}

- (void)setAverageScore:(NSString *)averageScore{
    _averageScore = averageScore;
    if (averageScore.floatValue >=0 && averageScore.floatValue <=1) {
        self.averageScoreName = @"挺难评";
    }else if (averageScore.floatValue > 1 && averageScore.floatValue <=2) {
        self.averageScoreName = @"不太行";
    }else if (averageScore.floatValue > 2 && averageScore.floatValue <=3) {
        self.averageScoreName = @"一般吧";
    }else if (averageScore.floatValue > 3 && averageScore.floatValue <=4) {
        self.averageScoreName = @"挺不错";
    }else if (averageScore.floatValue > 4 && averageScore.floatValue <=5) {
        self.averageScoreName = @"超满意";
    }
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-60 string:content isJiacu:NO];
}

- (void)setLabel_info:(NSArray *)label_info{
    _label_info = label_info;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in label_info) {
        NoticeComLabelModel *labelM = [NoticeComLabelModel mj_objectWithKeyValues:dic];
        [arr addObject:labelM.content];
    }
    if (arr.count) {
        self.labelName = [arr componentsJoinedByString:@"·"];
        self.labelHeight = [SXTools getHeightWithLineHight:3 font:11 width:DR_SCREEN_WIDTH-60 string:self.labelName isJiacu:NO];
    }
}

- (void)setUser_info:(NSDictionary *)user_info{
    _user_info = user_info;
    self.userModel = [NoticeAbout mj_objectWithKeyValues:user_info];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [NoticeTools timeDataAppointFormatterWithTime:created_at.intValue appointStr:@"yyyy-MM-dd hh:mm:ss"];
}
@end
