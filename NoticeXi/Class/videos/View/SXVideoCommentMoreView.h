//
//  SXVideoCommentMoreView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXVideoCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVideoCommentMoreView : UITableViewHeaderFooterView
@property (nonatomic, strong) SXVideoCommentModel *commentM;
@property (nonatomic, strong) FSCustomButton *moreButton;
@property (nonatomic, strong) UILabel *closeL;
@property (nonatomic,copy) void(^moreCommentBlock)(SXVideoCommentModel *commentM);
@property (nonatomic,copy) void(^closeCommentBlock)(SXVideoCommentModel *commentM);
@end

NS_ASSUME_NONNULL_END
