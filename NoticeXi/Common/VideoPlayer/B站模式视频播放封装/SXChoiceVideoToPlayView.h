//
//  SXChoiceVideoToPlayView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/1.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXSearisVideoListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXChoiceVideoToPlayView : UIView
@property (nonatomic, strong) NSMutableArray *buttonArr;
- (void)show;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *searisArr;
@property (nonatomic, strong) SXSearisVideoListModel *currentModel;
@property (nonatomic,copy) void(^choiceVideoBlock)(SXSearisVideoListModel *choiceModel);

@end

NS_ASSUME_NONNULL_END
