//
//  NoticeChoiceIfAutoStopPlayView.h
//  NoticeXi
//
//  Created by li lei on 2023/12/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoiceIfAutoStopPlayView : UIView

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) void(^choiceTimeBlock)(NSString *formtTime);
@property (nonatomic, strong) UIImageView *closeImgeView;
@property (nonatomic, strong) UIImageView *openImgeView;
@property (nonatomic, strong) UILabel *timeL;
- (void)showTost;
@end

NS_ASSUME_NONNULL_END
