//
//  SXStudyListView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXStudyListView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic,copy) void (^addBlock)(SXPayForVideoModel *studyModel);
- (void)showATView;
@end

NS_ASSUME_NONNULL_END
