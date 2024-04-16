//
//  SXVideoCommentModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/16.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCommentModel.h"

@implementation SXVideoCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commentId":@"id"};
}

- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUserInfo = [SXUserModel mj_objectWithKeyValues:from_user];
}

- (void)setTo_user:(NSDictionary *)to_user{
    _to_user = to_user;
    self.toUserInfo = [SXUserModel mj_objectWithKeyValues:to_user];
}

- (void)setReply:(NSDictionary *)reply{
    _reply = reply;
    self.firstReplyModel = [SXVideoCommentModel mj_objectWithKeyValues:reply];
}

- (void)setComment:(NSDictionary *)comment{
    _comment = comment;
    self.firstCommentModel = [SXVideoCommentModel mj_objectWithKeyValues:comment];
}
@end
