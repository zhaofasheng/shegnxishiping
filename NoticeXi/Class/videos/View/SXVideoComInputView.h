//
//  SXVideoComInputView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTeamTextView.h"
#import "SXStudyListView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol NoticeVideoComentInputDelegate <NSObject>

@optional
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId linkArr:(NSMutableArray *)linkArr;

@end

@interface SXVideoComInputView : UIView<UITextViewDelegate>
@property (nonatomic, strong) NoticeTeamTextView *contentView;
@property (nonatomic, weak) id <NoticeVideoComentInputDelegate>delegate;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *plaL;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, assign) NSInteger limitNum;
@property (nonatomic, strong) NSString *saveKey;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) BOOL isresiger;
@property (nonatomic, assign) BOOL hasClick;
@property (nonatomic, assign) BOOL noNeedkC;
@property (nonatomic, strong) NSString * __nullable commentId;//存在就是给留言留言，不存在就是留言
@property (nonatomic, assign) BOOL needBack;
@property (nonatomic, strong) NSMutableArray *studyArr;
@property (nonatomic, strong) SXStudyListView *listView;

- (void)showJustComment:(NSString * __nullable)commentId;

- (void)clearView;
@property (nonatomic, strong) NSMutableArray * currentSelectedPersonItems;
@property (nonatomic, strong) UIView *addStudyView;
@end

NS_ASSUME_NONNULL_END
