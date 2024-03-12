//
//  NoticeSendVoiceImageView.h
//  NoticeXi
//
//  Created by li lei on 2023/11/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeChoiceDefaultVoiceImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeSendVoiceImageView : UIView
@property (nonatomic, copy) void(^imgBlock)(NSInteger tag);
@property (nonatomic, copy) void(^choiceBlock)(BOOL choice);
@property (nonatomic, copy) void(^imgCourIdBlock)(NSString *coverId,NSString *url);
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) UIButton *closeBtn0;
@property (nonatomic, strong) UIButton *closeBtn1;
@property (nonatomic, strong) UIButton *closeBtn2;
@property (nonatomic, assign) BOOL isLocaImage;
@property (nonatomic, strong) UIButton *choiceButton;
@property (nonatomic, assign) BOOL isReEdit;
@property (nonatomic, assign) BOOL isVoice;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

NS_ASSUME_NONNULL_END
