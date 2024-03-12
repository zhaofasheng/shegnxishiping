//
//  NoticeDownloadVoiceCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDownloadVoiceCell : BaseCell

@property (nonatomic, strong) HWDownloadModel *model;
@property (nonatomic, strong) UILabel *timeLabel;   
@property (nonatomic, strong) UILabel *looktimeLabel;   
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UIButton *downButton;
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic, weak) UILabel *titleLabel;            // 标题
@property (nonatomic, weak) UILabel *speedLabel;            // 进度标签
@property (nonatomic, weak) UILabel *fileSizeLabel;         // 文件大小标签
@property (nonatomic, strong) UIImageView *voiceImageView;
@property (nonatomic, strong) NSString *currentPlayId;//当前播放的资源id
// 更新视图
- (void)updateViewWithModel:(HWDownloadModel *)model;
@end

NS_ASSUME_NONNULL_END
