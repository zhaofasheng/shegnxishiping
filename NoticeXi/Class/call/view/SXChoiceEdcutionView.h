//
//  SXChoiceEdcutionView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXChoiceEdcutionView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) CGFloat lastTransitionY;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isDragScrollView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) NSString *currenEdc;
@property (nonatomic,copy) void(^edcBlock)(NSString *edc);

- (void)closeClick;
- (void)show;
@end

NS_ASSUME_NONNULL_END
