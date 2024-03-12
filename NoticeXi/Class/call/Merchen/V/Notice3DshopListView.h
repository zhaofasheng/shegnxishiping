//
//  Notice3DshopListView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoungSphere.h"

#import "ChildGestureRecognizer.h"
#import "ChildLongPress.h"
NS_ASSUME_NONNULL_BEGIN

@interface Notice3DshopListView : UIView
@property (nonatomic, strong) YoungSphere *sphereView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *titleName; // 标题
@property (nonatomic, strong) NSMutableArray *cellArr;
@property(nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSMutableArray *shopArr;
@property (nonatomic, strong) NSUserDefaults * userDefault; // 本地保存信息

- (void)startRadi;
- (void)stopRadi;
// 图片位置
@property(nonatomic, assign) NSInteger newflag;
@end

NS_ASSUME_NONNULL_END
