//
//  SXScrollLabel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,DirtionType){
 
    DirtionTypeLeft, //left
    DirtionTypeRight //right
    
};

NS_ASSUME_NONNULL_BEGIN

@interface SXScrollLabel : UIScrollView



//set Text
@property (nonatomic, copy) NSString *text;
// label and label gap
@property (nonatomic, assign) NSInteger labelBetweenGap;
//deafult 2 秒
@property (nonatomic, assign) NSInteger pauseTime;
//deafult DirtionTypeLeft
@property (nonatomic, assign) DirtionType dirtionType;
//set speed ,default 30
@property (nonatomic, assign) NSInteger speed;
//set Color
@property (nonatomic, strong) UIColor  *textColor;
@property (nonatomic,copy) void(^scrollFinishBlcok)(BOOL finish);

- (void)rejustlabels;
@end

NS_ASSUME_NONNULL_END
