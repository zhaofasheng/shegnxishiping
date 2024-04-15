//
//  SXChatEachOtherMeassageView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXChatEachOtherMeassageView : UIView

- (void)clearNum;

- (void)requestNoread;
@property (nonatomic, strong) UILabel *sysL;
@property (nonatomic, strong) UILabel *comL;
@property (nonatomic, strong) UILabel *likeL;
@end

NS_ASSUME_NONNULL_END
