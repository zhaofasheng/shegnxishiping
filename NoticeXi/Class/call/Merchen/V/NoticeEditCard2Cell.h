//
//  NoticeEditCard2Cell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeEditCard2Cell : BaseCell<NoticeRecordDelegate>
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, copy) void(^refreshShopModel)(BOOL refresh);

@property (nonatomic, strong) FSCustomButton *noVoiceL;
@property (nonatomic, strong,nullable) LGAudioPlayer *audioPlayer;
@property (nonatomic, strong) UILabel *voiceLenL;
@property (nonatomic, strong) UIView *voicePlayView;
@property (nonatomic, strong) UIImageView *playImageV;
@property (nonatomic, strong) UIButton *rebutton;
@property (nonatomic, assign) BOOL isReplay;
@property (nonatomic, assign) BOOL isPasue;
@property (nonatomic, assign) BOOL stopPlay;

@property (nonatomic, copy) void(^editShopBlock)(BOOL edit);
@property (nonatomic, assign) BOOL justShow;
@end

NS_ASSUME_NONNULL_END
