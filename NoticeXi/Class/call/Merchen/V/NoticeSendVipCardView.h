//
//  NoticeSendVipCardView.h
//  NoticeXi
//
//  Created by li lei on 2023/9/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeSureSendUserTostView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendVipCardView : UIView
@property (nonatomic, strong) UIView *backView;
@property (strong, nonatomic) UITextField *phoneView;
@property (nonatomic, strong) NSString *vipCardId;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) NoticeSureSendUserTostView *sureView;
@property (nonatomic, strong) UIButton *nimingButton;
@property (nonatomic, assign) BOOL isNiming;
@property (nonatomic, copy) void(^sureSendBlock)(NSString *frequencyNo,BOOL isNiming);
- (void)show;
@end

NS_ASSUME_NONNULL_END
