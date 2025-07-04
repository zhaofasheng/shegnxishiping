//
//  SXPayForVideoModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXSearisVideoListModel.h"
#import "SXKcComDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXPayForVideoModel : NSObject
@property (nonatomic, strong) NSString *seriesId;//课程id
@property (nonatomic, strong) NSString *series_name;//课程系列名称
@property (nonatomic, strong) NSString *bookseries_name;
@property (nonatomic, strong) NSString *cover_url;//封面
@property (nonatomic, strong) NSString *product_id;
@property (nonatomic, strong) NSMutableArray *searisVideoList;
@property (nonatomic, strong) NSString *episodes;//总课时
@property (nonatomic, strong) NSString *published_episodes;//已发布课时
@property (nonatomic, strong) NSString *created_at;//发布时间
@property (nonatomic, strong) NSArray *videos;//相关视频列表
@property (nonatomic, strong) NSMutableArray *videosArr;
@property (nonatomic, strong) NSString *original_price;//原价
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) NSString *simple_cover_url;//小封面
@property (nonatomic, strong) NSString *pay_tip;//支付提示
@property (nonatomic, strong) NSString *is_bought;
@property (nonatomic, assign) BOOL hasBuy;//是否已经购买
@property (nonatomic, assign) BOOL canBuySingle;//是否可以单集购买
@property (nonatomic, assign) NSInteger hasbuyVideoNum;//已购视频数量
@property (nonatomic, strong) NSString *buy_users_num;//购买用户数
@property (nonatomic, strong) NSString *introduce_img_url;//课程详情
@property (nonatomic, strong) NSArray *carousel_images;//轮播图
@property (nonatomic, strong) NSDictionary *update_video;
@property (nonatomic, strong) SXSearisVideoListModel *updateM;
@property (nonatomic, strong) NSString *commentCt;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *share_img_url;
@property (nonatomic, strong) NSString *qqShareUrl;//qq分享链接
@property (nonatomic, strong) NSString *wechatShareUrl;//微信分享链接
@property (nonatomic, strong) NSString *friendShareUrl;//朋友圈分享链接
@property (nonatomic, strong) NSString *appletId;//小程序Id
@property (nonatomic, strong) NSString *appletPage;//小程序跳转页面
@property (nonatomic, strong) NSString *buy_card_times;//购买礼品卡次数
@property (nonatomic, strong) NSDictionary *from_user_info;//赠送者信息，存在就是别人赠送的课程
@property (nonatomic, strong) NoticeAbout *fromUser;
@property (nonatomic, strong) NSString *singlePrice;//单集价格
@property (nonatomic, strong) NSString *upfront_at;//早鸟价活动截止时间 0代表无限制
@property (nonatomic, strong) NSString *open_episode_way;//是否开启单集购买 0否 1是
@property (nonatomic, strong) NSString *descriptionName;//购买礼品卡说明
@property (nonatomic, strong) NSString *open_upfront_activity;//是否开启早鸟价活动 0否 1是
@property (nonatomic, strong) NSString *episode_price;//单集购买价格
@property (nonatomic, strong) NSDictionary *remarkInfo;//课程评价
@property (nonatomic, strong) SXKcComDetailModel * __nullable kcComDetailModel;

@property (nonatomic, strong) SXKcComDetailModel *remarkModel;//平均分

@end

NS_ASSUME_NONNULL_END
