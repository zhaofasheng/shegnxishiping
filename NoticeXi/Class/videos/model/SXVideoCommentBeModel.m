//
//  SXVideoCommentBeModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/18.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCommentBeModel.h"

@implementation SXVideoCommentBeModel

- (void)setDynamic:(NSDictionary *)dynamic{
    _dynamic = dynamic;
    self.dynamicModel = [SXShopSayListModel mj_objectWithKeyValues:dynamic];
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [SXTools updateTimeForRowWithNoHourAndMin:created_at];
}


- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUserInfo = [SXUserModel mj_objectWithKeyValues:from_user];
}

- (void)setVideo:(NSDictionary *)video{
    _video = video;
    self.videoModel = [SXVideosModel mj_objectWithKeyValues:video];
    self.videoModel.textContent = [NSString stringWithFormat:@"%@\n%@",self.videoModel.title,self.videoModel.introduce];
}

- (void)setCommentContent:(NSString *)commentContent{
    _commentContent = commentContent;
    self.commentAtt = [SXTools getStringWithLineHight:3 string:commentContent];
    self.commentHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-56-78 string:commentContent isJiacu:NO];
    self.commentHeight1 = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-56-15 string:commentContent isJiacu:NO];
}

- (void)setReplyContent:(NSString *)replyContent{
    _replyContent = replyContent;
    self.replyAtt = [SXTools getStringWithLineHight:3 string:replyContent];
    self.replytHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-56-78 string:replyContent isJiacu:NO];
    self.replytHeight1 = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-56-15 string:replyContent isJiacu:NO];
}
@end
