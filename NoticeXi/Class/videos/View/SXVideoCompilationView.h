//
//  SXVideoCompilationView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXVideoCompilationView : UIView
@property (nonatomic, strong) SXVideosModel *videoModel;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic,copy) void(^choiceHeJiVideoBlock)(SXVideosModel *currentModel,NSMutableArray *heVideoArr);
@end

NS_ASSUME_NONNULL_END
