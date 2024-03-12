//
//  NoticeDownLoadBokeModel.h
//  NoticeXi
//
//  Created by li lei on 2023/12/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDownLoadBokeModel : NSObject<UIDocumentInteractionControllerDelegate,UIDocumentPickerDelegate>
- (void)downBoKeToPhone:(BOOL)toIphone boke:(NoticeDanMuModel *)bokeModel;
-(void)presentDocumentCloud;
@property (nonatomic, assign) BOOL isDownLoad;
@end

NS_ASSUME_NONNULL_END
