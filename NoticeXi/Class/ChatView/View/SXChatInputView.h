//
//  SXChatInputView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeScroEmtionView.h"
#import "NoticeChocieImgListView.h"
#import "NoticeTeamTextView.h"
#import "NoticeAudioJoinToAudioModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXChatInputView : UIView<UITextViewDelegate,NoticeRecordDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NoticeTeamTextView *contentView;
@property (nonatomic, strong) NoticeAudioJoinToAudioModel *audioToAudio;
@property (nonatomic, strong) NSString *saveKey;
@property (nonatomic, strong) UILabel *plaL;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, copy) void (^imgBlock)(NSMutableArray *  _Nonnull imagArr);
@property (nonatomic, copy) void (^sendTextBlock)(NSString *sendText);
@property (nonatomic, copy) void (^emtionBlock)(NSString *url, NSString *buckId,NSString *pictureId,BOOL isHot);
@property (nonatomic, strong) NoticeChocieImgListView *imgListView;
@property (nonatomic, assign) BOOL emotionOpen;//表情框架打开
@property (nonatomic, assign) BOOL imgOpen;//图片框架打开
@property (nonatomic, strong) UIButton *emtionBtn;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *recoderBtn;
@property (nonatomic, strong) UIButton *pzBtn;
@property (nonatomic, strong) NSMutableArray *photoArr;
@property (nonatomic, strong) NoticeScroEmtionView *emotionView;
@property (nonatomic, copy) void (^uploadVoiceBlock)(NSString *localPath,NSString *timeLength,NSString *upSuccessPath,BOOL upSuccess,NSString *bucketId);
@property (nonatomic, copy) void (^uploadimgBlock)(NSData *imgData,NSString *upSuccessPath,BOOL upSuccess,NSString *bucketId);
@property (nonatomic, copy) void (^startRecoderOrPzStopPlayBlock)(BOOL stopPlay);//开始录音或者拍照，停止播放音频回调
@property (nonatomic, assign) BOOL isresiger;
@property (nonatomic, copy) void (^orignYBlock)(CGFloat y);

- (void)upLoadHeader:(NSData *)image path:(NSString * __nullable)path;
- (void)regFirst;
- (void)sendTime:(NSString *)time path:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
