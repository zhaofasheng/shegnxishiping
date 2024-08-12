//
//  SXSearisHeaderView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPayForVideoModel.h"
#import "CBAutoScrollLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXSearisHeaderView : UIView
@property (nonatomic, strong) SXPayForVideoModel *paySearModel;

@property (nonatomic, strong) UIView *hasReviewView;


@property (nonatomic, strong) CBAutoScrollLabel *hasLookVideoNameL;

@property (nonatomic,copy) void(^choiceBeforeLookBlock)(NSString *videoName);


- (void)refresUI;
@end

NS_ASSUME_NONNULL_END
