//
//  NoticeShopTitlesSelectView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopTitlesSelectView : UIView
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIImageView *tapView1;
@property (nonatomic, strong) UIImageView *tapView2;
@property (nonatomic, strong) UIImageView *tapView3;
@property (nonatomic, strong) UILabel *tapL1;
@property (nonatomic, strong) UILabel *tapL2;
@property (nonatomic, strong) UILabel *tapL3;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,copy) void (^viewChoiceBlock)(NSInteger index);
- (void)refreshButton:(NSInteger)tag;
@end

NS_ASSUME_NONNULL_END
