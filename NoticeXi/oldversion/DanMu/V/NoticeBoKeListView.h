//
//  NoticeBoKeListView.h
//  NoticeXi
//
//  Created by li lei on 2022/9/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeBoKeListCell.h"
#import "NotiePageNoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeBoKeListView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NoticeDanMuModel *choiceModel;
@property (nonatomic, strong) NoticeDanMuModel *allModel;
@property (nonatomic, strong) FSCustomButton *choiceButton;
@property (nonatomic, strong) UIButton *sortButton;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat lastTransitionY;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isDragScrollView;
@property (nonatomic, strong) NotiePageNoView *pageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isDown;//YES  下拉
@property (nonatomic, assign) BOOL isSClist;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL hasLoadFirstNum;//是否已经加载过第一页
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger upPageNo;
@property (nonatomic,copy) void (^choiceBoKeBlock)(NoticeDanMuModel *choiceModel);
- (void)show;
@end

NS_ASSUME_NONNULL_END
