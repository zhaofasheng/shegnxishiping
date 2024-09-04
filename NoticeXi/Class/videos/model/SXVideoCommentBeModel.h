//
//  SXVideoCommentBeModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/18.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXShopSayListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVideoCommentBeModel : NSObject

@property (nonatomic, strong) NSString *from_user_id;//回复人ID
@property (nonatomic, strong) NSString *created_at;//创建时间
@property (nonatomic, strong) NSString *sysStatus;//1=正常2=内容删除3作品删除（注意不可跳转了）
@property (nonatomic, strong) NSString *commentContent;//评论内容
@property (nonatomic, assign) CGFloat commentHeight;
@property (nonatomic, assign) CGFloat commentHeight1;
@property (nonatomic, strong) NSMutableAttributedString *commentAtt;
@property (nonatomic, assign) CGFloat replytHeight;
@property (nonatomic, assign) CGFloat replytHeight1;
@property (nonatomic, strong) NSMutableAttributedString *replyAtt;
@property (nonatomic, strong) NSString *tips;//文案
@property (nonatomic, strong) NSString *is_author;//1=作者 0不是
@property (nonatomic, strong) NSString *replyId;//回复ID,删除情况不会传
@property (nonatomic, strong) NSString *replyContent;//回复内容
@property (nonatomic, strong) NSString *commentId;//评论ID 删除情况不会传

@property (nonatomic, strong) NSDictionary *from_user;
@property (nonatomic, strong) SXUserModel *fromUserInfo;
@property (nonatomic, strong) NSString *is_like;
@property (nonatomic, strong) NSDictionary *video;
@property (nonatomic, strong) SXVideosModel *videoModel;

@property (nonatomic, strong) NSDictionary *dynamic;
@property (nonatomic, strong) SXShopSayListModel *dynamicModel;
@end

NS_ASSUME_NONNULL_END
