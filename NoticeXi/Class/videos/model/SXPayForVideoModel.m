//
//  SXPayForVideoModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPayForVideoModel.h"
#import "SXVideosModel.h"
@implementation SXPayForVideoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"seriesId":@"id",@"descriptionName":@"description"};
}

- (void)setRemarkInfo:(NSDictionary *)remarkInfo{
    _remarkInfo = remarkInfo;
    self.kcComDetailModel = [SXKcComDetailModel mj_objectWithKeyValues:remarkInfo];
}

- (void)setOpen_episode_way:(NSString *)open_episode_way{
    _open_episode_way = open_episode_way;
    self.canBuySingle = open_episode_way.boolValue;
}

- (void)setEpisode_price:(NSString *)episode_price{
    _episode_price = episode_price;
    self.singlePrice = episode_price;
}

- (void)setSeries_name:(NSString *)series_name{
    _series_name = series_name;
    self.bookseries_name = [NSString stringWithFormat:@"《%@》",series_name];
}

- (void)setVideos:(NSArray *)videos{
    _videos = videos;
    if (videos.count) {
        self.videosArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in videos) {
            [self.videosArr addObject:[SXVideosModel mj_objectWithKeyValues:dic]];
        }
    }
}

- (void)setIs_bought:(NSString *)is_bought{
    _is_bought = is_bought;
    self.hasBuy = is_bought.boolValue;
}


- (void)setUpdate_video:(NSDictionary *)update_video{
    _update_video = update_video;
    self.updateM = [SXSearisVideoListModel mj_objectWithKeyValues:update_video];
}

- (void)setFrom_user_info:(NSDictionary *)from_user_info{
    _from_user_info = from_user_info;
    self.fromUser = [NoticeAbout mj_objectWithKeyValues:from_user_info];
}
@end
