//
//  NoticeVoiceDefaultImgModel.h
//  NoticeXi
//
//  Created by li lei on 2023/11/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeVoiceDefaultImgModel : NSObject
@property (nonatomic, strong) NSString *cover_url;
@property (nonatomic, strong) NSString *coverId;
@property (nonatomic, strong) NSString *cover_type;
@property (nonatomic, strong) NSString *cover_urls;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL currentChoice;
@end

NS_ASSUME_NONNULL_END
