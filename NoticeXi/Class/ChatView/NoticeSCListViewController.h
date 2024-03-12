//
//  NoticeSCListViewController.h
//  NoticeXi
//
//  Created by li lei on 2019/1/2.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSCListViewController : NoticeBaseCellController<JXPagerViewListViewDelegate>
@property (nonatomic, assign) NSInteger numMessage;
- (void)refreshNoUnread;
@end

NS_ASSUME_NONNULL_END
