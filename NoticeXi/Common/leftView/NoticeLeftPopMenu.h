//
//  NoticeLeftPopMenu.h
//  NoticeXi
//
//  Created by li lei on 2023/10/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeLeftPopMenu : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) void(^choiceIndexBlock)(NSInteger index);
- (void)showPopMenu;
- (void)fastPopMenu;
@end

NS_ASSUME_NONNULL_END
