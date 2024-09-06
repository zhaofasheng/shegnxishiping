//
//  NoticeKnowSendTextView.h
//  NoticeXi
//
//  Created by li lei on 2020/7/16.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXHuodonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeKnowSendTextView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) SXHuodonModel *huodongModel;
- (void)showGetView;
@end

NS_ASSUME_NONNULL_END
