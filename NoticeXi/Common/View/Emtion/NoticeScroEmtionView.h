//
//  NoticeScroEmtionView.h
//  NoticeXi
//
//  Created by li lei on 2020/12/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeEmotionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeScroEmtionView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void (^sendBlock)(NSString *url, NSString *buckId,NSString *pictureId,BOOL isHot);
@property (nonatomic, strong) NoticeEmotionView *emotionView;
@property (nonatomic, strong) NoticeEmotionView *hotEmotionView;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, assign) BOOL isSelfEmotion;
@property (nonatomic, strong) NoticeEmotionModel *oldModel;
@property (nonatomic, copy) void (^pushBlock)(BOOL push);
- (void)refreshEmotion;
@end

NS_ASSUME_NONNULL_END
