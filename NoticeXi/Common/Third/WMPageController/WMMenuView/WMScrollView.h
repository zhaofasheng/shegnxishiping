//
//  WMScrollView.h
//  WMPageController
//
//  Created by lh on 15/11/21.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMScrollView : UIScrollView <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL needCellScrool;
@property (nonatomic, assign) BOOL isMoveRight;
@end
