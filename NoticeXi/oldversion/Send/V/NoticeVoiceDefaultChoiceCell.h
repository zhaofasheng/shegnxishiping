//
//  NoticeVoiceDefaultChoiceCell.h
//  NoticeXi
//
//  Created by li lei on 2023/11/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeVoiceDefaultImgModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceDefaultChoiceCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isVoice;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *defalutImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *choiceImageView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) FSCustomButton *choiceButton;
@property (nonatomic, strong) NoticeVoiceDefaultImgModel *imgModel;
@end

NS_ASSUME_NONNULL_END
