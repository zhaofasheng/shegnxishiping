//
//  SXVideoCommentModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/16.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCommentModel.h"

@implementation SXVideoCommentModel

- (NSMutableArray *)replyArr{
    if (!_replyArr) {
        _replyArr = [[NSMutableArray alloc] init];
    }
    return _replyArr;
}

- (NSMutableArray *)moreReplyArr{
    if (!_moreReplyArr) {
        _moreReplyArr = [[NSMutableArray alloc] init];
    }
    return _moreReplyArr;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commentId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [SXTools updateTimeForRowWithNoHourAndMin:created_at];
}


- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUserInfo = [SXUserModel mj_objectWithKeyValues:from_user];
}


- (void)setAuth_user:(NSDictionary *)auth_user{
    _auth_user = auth_user;
    self.authUserInfo = [SXUserModel mj_objectWithKeyValues:auth_user];
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.firstAttr = [SXTools getStringWithLineHight:3 string:content];
    self.firstContentHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-56-15 string:content isJiacu:NO];
    
    self.secondAttr = [SXTools getStringWithLineHight:3 string:content];
    self.secondContentHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-88-15 string:content isJiacu:NO];
}

- (void)setTo_user:(NSDictionary *)to_user{
    _to_user = to_user;
    self.toUserInfo = [SXUserModel mj_objectWithKeyValues:to_user];
}

- (void)setReply:(NSDictionary *)reply{
    _reply = reply;
    self.firstReplyModel = [SXVideoCommentModel mj_objectWithKeyValues:reply];
    if (self.firstReplyModel.comment_type.intValue > 1) {
        self.firstReplyModel.content = @"请更新到最新版本";
    }
}

- (void)setComment:(NSDictionary *)comment{
    _comment = comment;
    self.firstCommentModel = [SXVideoCommentModel mj_objectWithKeyValues:comment];
    if (self.firstCommentModel.comment_type.intValue > 1) {
        self.firstCommentModel.content = @"请更新到最新版本";
    }
}

- (void)setTo_series:(NSString *)to_series{
    _to_series = to_series;
    NSArray *arr = [NoticeTools arraryWithJsonString:to_series];
    self.seariesArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in arr) {
        SXPayForVideoModel *model = [SXPayForVideoModel mj_objectWithKeyValues:dic];
        model.series_name = model.name;
        [self.seariesArr addObject:model];
    }
}

//- (void)setTo_series:(NSArray *)to_series{
//    _to_series = to_series;
//    self.seariesArr = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic in to_series) {
//        SXPayForVideoModel *model = [SXPayForVideoModel mj_objectWithKeyValues:dic];
//        model.series_name = model.name;
//        [self.seariesArr addObject:model];
//    }
//}
@end
