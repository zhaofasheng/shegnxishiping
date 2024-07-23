//
//  SXSearisVideoListModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXSearisVideoListModel : NSObject
@property (nonatomic, strong) NSString *screen;//屏幕信息 0未知 1横屏 2竖屏
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *title;//视频标题
@property (nonatomic, strong) NSMutableAttributedString *titleAtt;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, strong) NSString *video_len;//视频时长
@property (nonatomic, strong) NSString *is_finished;//是否完成观看
@property (nonatomic, strong) NSString *schedule;//观看进度(第几秒)
@property (nonatomic, strong) NSString *video_url;
@property (nonatomic, strong) NSString *is_new;
@property (nonatomic, strong) NSDictionary *user_info;//用户信息
@property (nonatomic, strong) NSString *commentCt;
@property (nonatomic, strong) SXUserModel  *userModel;


@end

NS_ASSUME_NONNULL_END
