//
//  SXVideoTagsView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMTagListView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXVideoTagsView : UIView<KMTagListViewDelegate>
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,copy) void(^choiceTagBlock)(int tag);
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KMTagListView *labeView;
- (void)showTagsView;

@end

NS_ASSUME_NONNULL_END
