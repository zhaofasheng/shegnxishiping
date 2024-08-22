//
//  SXVideoCompilationListView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXVideoCompilationListView : UIView
@property (nonatomic, strong) SXVideosModel *videoModel;
- (void)show;
@end

NS_ASSUME_NONNULL_END
