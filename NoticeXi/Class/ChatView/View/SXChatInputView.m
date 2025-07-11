//
//  SXChatInputView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXChatInputView.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation SXChatInputView

{
    CGFloat kebordHeight;
    
    UIView *_bottomV;
    UIVisualEffectView *effectView;
}


- (NoticeAudioJoinToAudioModel *)audioToAudio{
    if (!_audioToAudio) {
        _audioToAudio = [[NoticeAudioJoinToAudioModel alloc] init];
       
    }
    return _audioToAudio;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
                
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
                
        CGFloat space = (DR_SCREEN_WIDTH-30-24*4)/5;
        UIButton *recrderBtn = [[UIButton alloc] initWithFrame:CGRectMake(15+space, self.frame.size.height-15-24, 24, 24)];
        [recrderBtn setImage:UIImageNamed(@"teamRecoderImg") forState:UIControlStateNormal];
        [self addSubview:recrderBtn];
        [recrderBtn addTarget:self action:@selector(recodClick) forControlEvents:UIControlEventTouchUpInside];
        self.recoderBtn = recrderBtn;
        
        self.emtionBtn = [[UIButton alloc] initWithFrame:CGRectMake(space*2+24+15, self.frame.size.height-15-24, 24, 24)];
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        [self.emtionBtn addTarget:self action:@selector(emtionClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.emtionBtn];
        
        self.imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(space*3+24*2+15, self.frame.size.height-15-24, 24, 24)];
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        [self.imgBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.imgBtn];
        
        UIButton *pzBtn = [[UIButton alloc] initWithFrame:CGRectMake(space*4+24*3+15, self.frame.size.height-15-24, 24, 24)];
        [pzBtn setImage:UIImageNamed(@"teampzBtnImg") forState:UIControlStateNormal];
        [self addSubview:pzBtn];
        [pzBtn addTarget:self action:@selector(pzBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.pzBtn = pzBtn;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
        
        self.contentView = [[NoticeTeamTextView alloc] initWithFrame:CGRectMake(15,8, DR_SCREEN_WIDTH-30, 34)];
        self.contentView.tintColor = GetColorWithName(VMainThumeColor);
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.delegate = self;
        self.contentView.font = FIFTHTEENTEXTFONTSIZE;
        self.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 8;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.contentView];
        self.contentView.returnKeyType = UIReturnKeySend;
        
        self.plaStr = @"输入文字";
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(27,7, 200, 34)];
        _plaL.text = self.plaStr;
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self addSubview:_plaL];
    }
    return self;
}

- (void)refreshButtonFrame{
    self.recoderBtn.frame = CGRectMake(self.recoderBtn.frame.origin.x, self.frame.size.height-15-24, 24, 24);
    self.emtionBtn.frame = CGRectMake(self.emtionBtn.frame.origin.x, self.frame.size.height-15-24, 24, 24);
    self.imgBtn.frame = CGRectMake(self.imgBtn.frame.origin.x, self.frame.size.height-15-24, 24, 24);
    self.pzBtn.frame = CGRectMake(self.pzBtn.frame.origin.x, self.frame.size.height-15-24, 24, 24);
}

- (void)regFirst{
    
    [self.contentView resignFirstResponder];

    if (self.imgOpen) {
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
        self.imgOpen = NO;
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
    }
    
    if (self.emotionOpen) {
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
        self.emotionOpen = NO;
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
    }
}

- (NoticeScroEmtionView *)emotionView{
    if (!_emotionView) {
        _emotionView  = [[NoticeScroEmtionView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+15)];
        _emotionView.backgroundColor = self.backgroundColor;
        __weak typeof(self) weakSelf = self;
        _emotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            
            if (weakSelf.emtionBlock) {
                weakSelf.emtionBlock(url, buckId, pictureId, isHot);
            }
            [weakSelf emtionClick];
        };

        [[NoticeTools getTopViewController].view addSubview:_emotionView];
    }
    return _emotionView;
}


- (NoticeChocieImgListView *)imgListView{
    if (!_imgListView) {
        __weak typeof(self) weakSelf = self;
        _imgListView = [[NoticeChocieImgListView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+15)];
        _imgListView.limitNum = 3;
        _imgListView.didSelectPhotosMBlock = ^(NSMutableArray * _Nonnull photoArr) {
           
            weakSelf.photoArr = photoArr;
            [weakSelf sendImagePhoto:photoArr];
            [weakSelf imgClick];
        };
        [[NoticeTools getTopViewController].view addSubview:_imgListView];
    }
    return _imgListView;
}

- (UIImagePickerController *)imagePickerController{
    if (_imagePickerController==nil) {
        _imagePickerController=[[UIImagePickerController alloc]init];
        _imagePickerController.delegate = (id)self;
        _imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        _imagePickerController.mediaTypes= mediaTypes;
    }
    return _imagePickerController;
}


- (void)sendImagePhoto:(NSMutableArray *)photoArr{
    if (!photoArr.count) {
        return;
    }
    TZAssetModel *assestM = self.photoArr[0];
    if(assestM.cropImage){//裁剪过图片
        NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
        NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]];
        [self upLoadHeader:UIImageJPEGRepresentation(assestM.cropImage, 0.6) path:pathMd5];
        return;
    }
    
    PHAsset *asset = assestM.asset;
    if(!asset){
        return;
    }
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([[TZImageManager manager] getAssetType:asset] == TZAssetModelMediaTypePhotoGif) {//如果是gif图片
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!imageData) {
                [[NoticeTools getTopViewController] showToastWithText:@"获取文件失败"];
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%9999999996];
            [self upLoadHeader:imageData path:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]]];
        }];
    }else{
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (!imageData) {
                [[NoticeTools getTopViewController] showToastWithText:@"获取文件失败"];
                return ;
            }
            NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999];
            NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]];
            [self upLoadHeader:UIImageJPEGRepresentation([UIImage imageWithData:imageData], 0.6) path:pathMd5];
            ;
        }];
    }
}

- (void)pzBtnClick{
    [self regFirst];
    if(self.startRecoderOrPzStopPlayBlock){
        self.startRecoderOrPzStopPlayBlock(YES);
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        [[NoticeTools getTopViewController] showToastWithText:@"您没有开启相机权限哦~，您可以在手机系统设置开启"];
    } else{
        //判断是否支持相机
          if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
              [[NoticeTools getTopViewController] presentViewController:self.imagePickerController animated:YES completion:nil];
          }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {

        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            __weak typeof(self) weakSelf = self;
            [[TZImageManager manager] savePhotoWithImage:photo location:nil completion:^(PHAsset *asset, NSError *error){
                if (!error) {
                    [weakSelf.photoArr removeAllObjects];
                    TZAssetModel *assestM = [[TZAssetModel alloc] init];
                    assestM.asset = asset;
                    [weakSelf.photoArr addObject:assestM];
                    [weakSelf sendImagePhoto:weakSelf.photoArr];
                }
            }];
        }
    }
}

- (NSMutableArray *)photoArr{
    if(!_photoArr){
        _photoArr = [[NSMutableArray alloc] init];
    }
    return _photoArr;
}

- (void)recodClick{
    [self regFirst];
    if(self.startRecoderOrPzStopPlayBlock){
        self.startRecoderOrPzStopPlayBlock(YES);
    }
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) { // 有使用麦克风的权限
                [weakSelf recoders];
            }else { // 没有麦克风权限
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.kaiqire"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        UIApplication *application = [UIApplication sharedApplication];
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([application canOpenURL:url]) {
                            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                if (@available(iOS 10.0, *)) {
                                    [application openURL:url options:@{} completionHandler:nil];
                                }
                            } else {
                                [application openURL:url options:@{} completionHandler:nil];
                            }
                        }
                    }
                };
                [alerView showXLAlertView];
            }
        });
    }];
}

- (void)imgClick{
    
    if(![[TZImageManager manager] authorizationStatusAuthorized]){//没有相册权限
        [[NoticeTools getTopViewController] showToastWithText:@"您没有开启相册权限哦~ 到系统设置里面开启相册权限即可使用"];
        return;
    }

    [self.contentView resignFirstResponder];
    
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    }

    if (self.imgOpen) {
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
            if (self.orignYBlock) {
                self.orignYBlock(self.frame.origin.y);
            }
        }];

    }else{
   
        [self.imgListView refreshImage];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.imgListView.frame.size.height-self.frame.size.height, DR_SCREEN_WIDTH,self.frame.size.height);
            self.imgListView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.imgListView.frame.size.height, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            if (self.orignYBlock) {
                self.orignYBlock(self.frame.origin.y);
            }
        }];
        [self.imgBtn setImage:UIImageNamed(@"Image_openimgpri") forState:UIControlStateNormal];
    }
    self.imgOpen = !self.imgOpen;

}

- (void)emtionClick{
    
    [self.contentView resignFirstResponder];
    
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    }
    
    if (self.emotionOpen) {
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
     
        [UIView animateWithDuration:0.5 animations:^{
  
            self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
            if (self.orignYBlock) {
                self.orignYBlock(self.frame.origin.y);
            }
        }];

    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.emotionView.frame.size.height-self.frame.size.height, DR_SCREEN_WIDTH,self.frame.size.height);
            self.emotionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.emotionView.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            if (self.orignYBlock) {
                self.orignYBlock(self.frame.origin.y);
            }
        }];
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_sb") forState:UIControlStateNormal];
    }
    self.emotionOpen = !self.emotionOpen;

}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
    }
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
    }

    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.frame.size.height, DR_SCREEN_WIDTH, self.frame.size.height);
    self.isresiger = NO;
    
    kebordHeight = keyboardF.size.height;

    _bottomV.hidden = YES;
    if (self.orignYBlock) {
        self.orignYBlock(self.frame.origin.y);
    }

}

- (void)keyboardDiddisss{
    _bottomV.hidden = NO;
    self.isresiger = YES;

    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = 0;
    if (self.orignYBlock) {
        self.orignYBlock(self.frame.origin.y);
    }

}



- (void)sendClick{
    NSString *str = self.contentView.text;
    if(!str || !str.length){
        return;
    }
    if (self.sendTextBlock) {
        self.sendTextBlock(str);
    }
 
    self.contentView.text = @"";
    [self textViewDidChangeSelection:self.contentView];

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([text isEqualToString:@"\n"]) {
        [self sendClick];
        return NO;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = self.plaStr;
    }
    CGRect frame = textView.frame;
    
    NSInteger num = 3000;

    if (textView.text.length > num) {
        textView.text = [textView.text substringToIndex:num];
    }
    float height;
    height = [self heightForTextView:textView WithText:self.contentView.text];
    if (height > 120) {
        height = 120;
    }
    if (height <= 35) {
        height = 36;
    }
    frame.size.height = height;

    if (self.contentView.needBackOldPoint) {
        self.contentView.selectedRange = self.contentView.oldRange;
        self.contentView.needBackOldPoint= NO;
    }
    if (self.isresiger) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-(57+height)-self->kebordHeight-(self->kebordHeight > 0?0 :BOTTOM_HEIGHT), DR_SCREEN_WIDTH,57+height);
    
        self.contentView.frame = CGRectMake(15,8, DR_SCREEN_WIDTH-30, height);
        [self refreshButtonFrame];
        if (self.orignYBlock) {
            self.orignYBlock(self.frame.origin.y);
        }
    } completion:nil];
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height+(size.size.height>36?10:0)+5;
    return textHeight;
}

- (void)recoders{
    NoticeRecoderView *recodeView = [[NoticeRecoderView alloc] shareRecoderViewWith:@""];
    recodeView.isSayToSelf = YES;
    recodeView.hideCancel = NO;
    recodeView.noPushLeade = YES;
    recodeView.isReply = YES;
    recodeView.delegate = self;
    recodeView.startRecdingNeed = YES;
    [recodeView show];
}

- (void)recoderSureWithPath:(NSString *)locaPath time:(NSString *)timeLength{
    [self sendTime:timeLength path:locaPath];
}

- (void)comVoice:(NSString *)path time:(NSString *)time{
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,path]],[path pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"4" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    
    
    [[XGUploadDateManager sharedManager] uploadVoiceWithVoicePath:path parm:parm1 progressHandler:^(CGFloat progress) {
      
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId,BOOL sussess) {
        if (sussess) {
            if(self.uploadVoiceBlock){
                self.uploadVoiceBlock(path, time, Message, YES,bucketId);
            }
            [[NoticeTools getTopViewController] hideHUD];
        } else{
            if(self.uploadVoiceBlock){
                self.uploadVoiceBlock(path, time, @"", NO,@"");
            }
            [[NoticeTools getTopViewController] hideHUD];
            [[NoticeTools getTopViewController] showToastWithText:Message];
        }
    }];
}

//发送音频
- (void)sendTime:(NSString *)time path:(NSString *)path{

    if (!path) {
        [[NoticeTools getTopViewController] showToastWithText:@"文件不存在"];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self.audioToAudio compressVideo:path successCompress:^(NSString * _Nonnull url) {
        [weakSelf comVoice:url time:time];
    }];
    
}

//发送图片
- (void)upLoadHeader:(NSData *)image path:(NSString * __nullable)path{
    if (!path) {
        path = [NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NoticeTools getNowTimeTimestamp]]];
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"4" forKey:@"resourceType"];
    [parm setObject:path forKey:@"resourceContent"];
    [[NoticeTools getTopViewController] showHUD];
    [[XGUploadDateManager sharedManager] uploadImageWithImageData:image parm:parm progressHandler:^(CGFloat progress) {
    
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {

        if (sussess) {
            if(self.uploadimgBlock){
                self.uploadimgBlock(image, errorMessage, YES, bucketId);
            }
            if (self.photoArr.count) {
                [self.photoArr removeObjectAtIndex:0];
                if (self.photoArr.count) {
                    [self sendImagePhoto:self.photoArr];
                }
            }
            [[NoticeTools getTopViewController] hideHUD];
            
        }else{
            if(self.uploadimgBlock){
                self.uploadimgBlock(image, @"", NO, @"");
            }
            [[NoticeTools getTopViewController] showToastWithText:errorMessage];
            [[NoticeTools getTopViewController] hideHUD];
            
        }
    }];
}


@end
