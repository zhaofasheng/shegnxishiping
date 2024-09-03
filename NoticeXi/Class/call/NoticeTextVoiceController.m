//
//  NoticeTextVoiceController.m
//  NoticeXi
//
//  Created by li lei on 2020/7/10.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextVoiceController.h"
#import "NoticeKeyBordTopView.h"
#import "UIImage+Color.h"
#import <SDWebImage/UIImage+GIF.h>
#import <Photos/Photos.h>
#import <Speech/Speech.h>
#import "NoticeSendVoiceImageView.h"
#import "NoticeSaveVoiceTools.h"
#define Locapaths  @"locapath"
#define ImageDatas  @"ImageDatas"
#import "NoticeXi-Swift.h"
@interface NoticeTextVoiceController ()<UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) UILabel *sendBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *dataView;
@property (nonatomic, strong) NSString *coverId;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) NoticeSendVoiceTools *toolsView;
@property (nonatomic, strong) NSMutableArray *moveArr;
@property (nonatomic, strong) NSMutableArray *phassetArr;
@property (nonatomic, strong) NSString *imageJsonString;
@property (nonatomic, assign) CGFloat keyBordHeight;
@property (nonatomic, assign) BOOL keyBordisUp;
@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, strong) NSString *bucketId;
@property (nonatomic, strong) UIView *imageViewBack;
@property (nonatomic, assign) BOOL needContSet;//是否需要设置偏移量
@property (nonatomic, assign) CGFloat hasTitleHeight;
@property (nonatomic, strong) UILabel *plaL;
@property (nonatomic, strong) NSString *bucket_id;
@property (nonatomic, strong) NoticeSendVoiceImageView *imageViewS;
@property (nonatomic, assign) BOOL canSend;
@property (nonatomic, strong) NSString *cannotSendMsg;
@end

@implementation NoticeTextVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];


    UILabel *btn = [[UILabel alloc] init];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-66-20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2,66,28);
    btn.text = @"发布";
    btn.font = TWOTEXTFONTSIZE;
    btn.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    btn.userInteractionEnabled = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    btn.textAlignment = NSTextAlignmentCenter;
    btn.layer.cornerRadius = 14;
    btn.layer.masksToBounds = YES;
    UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendClick)];
    [btn addGestureRecognizer:sendTap];
    _sendBtn = btn;
    [self.navBarView addSubview:btn];
    
    [self.navBarView.backButton setImage:UIImageNamed(@"sxshopsayclose_img") forState:UIControlStateNormal];
    

    self.tableView.frame = CGRectMake(10,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-20,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-BOTTOM_HEIGHT-10);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    
    self.tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomFirstTap)];
    [self.tableView addGestureRecognizer:tap];
    self.imageViewS.hidden = NO;
    
    self.plaStr = @"请输入文字";
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-19-5, 14)];
    _plaL.text = self.plaStr;
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10,5, DR_SCREEN_WIDTH-40,35)];
    _textView.font = SIXTEENTEXTFONTSIZE;
    _textView.clearsOnInsertion = YES;
    _textView.scrollEnabled = NO;
    _textView.bounces = NO;
    _textView.backgroundColor = self.tableView.backgroundColor;
    _textView.delegate = self;
    _textView.textColor = [UIColor colorWithHexString:@"#25262E"];
    _textView.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    [self.tableView addSubview:_textView];
    [self.tableView addSubview:_plaL];
    self.phassetArr = [NSMutableArray new];
    self.moveArr = [NSMutableArray new];
    
    self.toolsView = [[NoticeSendVoiceTools alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
    self.toolsView.backgroundColor = self.view.backgroundColor;
    [self.toolsView.imgButton addTarget:self action:@selector(openPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toolsView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    [self keyboardHide];

    [self comeFromSave];
    self.canSend = YES;
}


//获取店铺信息和状态
- (void)getShopRequest{
 
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/ByUser" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.shopModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            [self refresButton];
        }
    } fail:^(NSError * _Nullable error) {

  
    }];
}


- (void)refresButton{
    NSString *str = @"";
    __weak typeof(self) weakSelf = self;
    if(self.shopModel.myShopM.is_stop.integerValue > 0){
        if(self.shopModel.myShopM.is_stop.integerValue == 1){//店铺被永久关停
            str = @"店铺已被永久关闭，不能使用此功能";
        }else{
            str = @"店铺被处罚中，请结束后再使用";
        }
        self.canSend = NO;
    }
    if (!self.canSend) {
        self.cannotSendMsg = str;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil cancleBtn:@"知道了"];
        alerView.resultIndex = ^(NSInteger index) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [alerView showXLAlertView];
    }
}


- (void)becomFirstTap{
    [self.textView becomeFirstResponder];
}

- (NoticeSendVoiceImageView *)imageViewS{
    if (!_imageViewS) {
        CGFloat width = (DR_SCREEN_WIDTH-40-10)/3;
        _imageViewS = [[NoticeSendVoiceImageView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.textView.frame)+10, DR_SCREEN_WIDTH-40, width)];
        _imageViewS.isVoice = NO;
        _imageViewS.isLocaImage = YES;
        [self.tableView addSubview:_imageViewS];

        __weak typeof(self) weakSelf = self;
        _imageViewS.imgBlock = ^(NSInteger tag) {
            if (tag <= weakSelf.moveArr.count-1) {
                [weakSelf.moveArr removeObjectAtIndex:tag];
                weakSelf.imageViewS.imgArr = [NSArray arrayWithArray:weakSelf.moveArr];
                [weakSelf.toolsView.imgButton setImage:UIImageNamed(weakSelf.moveArr.count==3? @"senimgv_imgn":@"senimgv_img") forState:UIControlStateNormal];
                if (!weakSelf.moveArr.count) {
                    [weakSelf refreshHeight];
                }
            }
            
        };
        _imageViewS.choiceBlock = ^(BOOL choice) {
            [weakSelf openPhotoClick];
        };
    }
    return _imageViewS;
}

//打开相册
- (void)openPhotoClick{

    [self.textView resignFirstResponder];
    if (self.moveArr.count >= 3) {
        [self showToastWithText:@"最多只能选择三张图片哦~"];
        return;
    }
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3-self.moveArr.count delegate:self];
    imagePicker.sortAscendingByModificationDate = NO;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    self.keyBordisUp = YES;

    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.toolsView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.toolsView.frame.size.height, DR_SCREEN_HEIGHT, 50);
    self.keyBordHeight = keyboardF.size.height;
    _plaL.frame = CGRectMake(19, 15, DR_SCREEN_WIDTH-19-5, 14);

    self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
    [self setTextViewHeight:self.textView text:@""];
    
    if (self.moveArr.count) {
        self.imageViewS.hidden = NO;
        self.imageViewS.frame = CGRectMake(10, DR_SCREEN_HEIGHT-50-self.keyBordHeight-NAVIGATION_BAR_HEIGHT-self.imageViewS.frame.size.height, self.imageViewS.frame.size.width, self.imageViewS.frame.size.height);
    }else{
        self.imageViewS.hidden = YES;
    }
    
}


- (void)keyboardHide{
    self.keyBordisUp = NO;
    _plaL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-19-5, 14);
    self.textView.frame = CGRectMake(10,5, DR_SCREEN_WIDTH-40,(self.textHeight>35?self.textHeight:35));
    
    if (self.moveArr.count) {
        self.imageViewS.hidden = NO;
        if (self.textView.text.length) {
            self.imageViewS.frame = CGRectMake(10, CGRectGetMaxY(self.textView.frame)+4, self.imageViewS.frame.size.width, self.imageViewS.frame.size.height);
        }else{
            self.imageViewS.frame = CGRectMake(10, self.tableView.frame.size.height-self.imageViewS.frame.size.height-10, self.imageViewS.frame.size.width, self.imageViewS.frame.size.height);
        }
        
    }else{
        self.imageViewS.hidden = YES;
    }
    
    self.toolsView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50);
    self.tableView.contentSize = CGSizeMake(0, [SXTools getHeightWithLineHight:0 font:16 width:DR_SCREEN_WIDTH-40 string:self.textView.text isJiacu:NO]+100+(self.imageViewS.hidden?0:self.imageViewS.frame.size.height));

    [self.toolsView.imgButton setImage:UIImageNamed(self.moveArr.count==3? @"senimgv_imgn":@"senimgv_img") forState:UIControlStateNormal];
    

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if (range.location < textView.text.length) {
        self.needContSet = NO;
    }else{
        self.needContSet = YES;
    }
    return YES;
}

- (void)setTextViewHeight:(UITextView *)textView text:(NSString *)text{
    float height;
    height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    self.textHeight = height;
    [self refreshHeight];
}


- (void)refreshHeight{
    
    NSString *currentSelectStr = [self.textView.text substringToIndex:self.textView.selectedRange.location];
    CGFloat curSelectHeight = [self heightForTextView:_textView WithText:currentSelectStr];//当前光标位置高度
    
   // CGFloat allHeight = self.textHeight;//总高度
    CGFloat canLookHeight = DR_SCREEN_HEIGHT-50-self.keyBordHeight-NAVIGATION_BAR_HEIGHT-(self.imageViewS.hidden?0:self.imageViewS.frame.size.height);//文本输入可视区域
    
    if (curSelectHeight >= canLookHeight) {//如果光标位置的高度超过了可视高度
        self.textView.frame = CGRectMake(10,-(curSelectHeight-canLookHeight), DR_SCREEN_WIDTH-40,self.textHeight);
        self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
    }else{
        self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
        self.textView.frame = CGRectMake(10,5, DR_SCREEN_WIDTH-40,(self.textHeight>35?self.textHeight:35));
    }
    [self.tableView bringSubviewToFront:self.imageViewS];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length) {
        _plaL.text = @"";
        _sendBtn.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    }else{
        _plaL.text = self.plaStr;
        _sendBtn.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    _plaL.text = textView.text.length?@"":self.plaStr;
    [self setTextViewHeight:textView text:@""];
}

- (float)heightForTextView:(UITextView *)textView WithText:(NSString *) strText{

    return [SXTools getHeightWithLineHight:0 font:16 width:DR_SCREEN_WIDTH-40 string:strText isJiacu:NO]+50;

}

- (void)refreshSnedUI{
    if (self.textView.text.length || self.moveArr.count) {
  
        _sendBtn.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    }else{
        _sendBtn.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    dispatch_queue_t queue = dispatch_queue_create("com.itheima.queue", DISPATCH_QUEUE_SERIAL);
    for (PHAsset *asset in assets) {
        dispatch_sync(queue, ^{
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                if (!imageData) {
                    [self showToastWithText:@"图片选择失败"];
                    return ;
                }
                NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
                NSMutableDictionary *imagerDic = [NSMutableDictionary new];
                if ([[TZImageManager manager] getAssetType:asset] == TZAssetModelMediaTypePhotoGif) {//如果是gif图片
                    [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                    [imagerDic setObject:imageData forKey:ImageDatas];
            
                }else{
                    [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
                    UIImage *ciImage = [UIImage imageWithData:imageData];
                    [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.5) forKey:ImageDatas];
          
                }
     
                [self.moveArr addObject:imagerDic];
                self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
                self.imageViewS.hidden = NO;
                [self.toolsView.imgButton setImage:UIImageNamed(self.moveArr.count==3? @"senimgv_imgn":@"senimgv_img") forState:UIControlStateNormal];
                if (self.moveArr.count) {
                    self.imageViewS.hidden = NO;
                    if (self.textView.text.length) {
                        self.imageViewS.frame = CGRectMake(10, CGRectGetMaxY(self.textView.frame)+4, self.imageViewS.frame.size.width, self.imageViewS.frame.size.height);
                    }else{
                        self.imageViewS.frame = CGRectMake(10, self.tableView.frame.size.height-self.imageViewS.frame.size.height-10, self.imageViewS.frame.size.width, self.imageViewS.frame.size.height);
                    }
                    
                }else{
                    self.imageViewS.hidden = YES;
                }
                [self refreshSnedUI];
            }];
        });
    }
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset{

    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (!imageData) {
            [self showToastWithText:@"图片选择失败"];
            return ;
        }
        
        NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
        NSMutableDictionary *imagerDic = [NSMutableDictionary new];
        [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.GIF",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
        [imagerDic setObject:imageData forKey:ImageDatas];
        [imagerDic setObject:@"1" forKey:@"type"];

        [self.moveArr addObject:imagerDic];
        [self.toolsView.imgButton setImage:UIImageNamed(self.moveArr.count==3? @"senimgv_imgn":@"senimgv_img") forState:UIControlStateNormal];
        self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
        self.imageViewS.hidden = NO;
        if (self.moveArr.count) {
            self.imageViewS.hidden = NO;
            if (self.textView.text.length) {
                self.imageViewS.frame = CGRectMake(10, CGRectGetMaxY(self.textView.frame)+4, self.imageViewS.frame.size.width, self.imageViewS.frame.size.height);
            }else{
                self.imageViewS.frame = CGRectMake(10, self.tableView.frame.size.height-self.imageViewS.frame.size.height-10, self.imageViewS.frame.size.width, self.imageViewS.frame.size.height);
            }
            
        }else{
            self.imageViewS.hidden = YES;
        }
        [self refreshSnedUI];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSEASSEST" object:nil];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSEASSEST" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_textView resignFirstResponder];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)backClick{
    [_textView resignFirstResponder];

    if (_textView.text.length || self.moveArr.count) {
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"保留此次编辑吗？" message:nil sureBtn:@"不保留" cancleBtn:@"保留" right:YES];
       alerView.resultIndex = ^(NSInteger index) {
           if (index == 2) {
               [weakSelf saveTocaogao];
           }else{
               [weakSelf clearCache];
           }
           [weakSelf.navigationController popViewControllerAnimated:YES];
       };
       [alerView showXLAlertView];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)sendClick{
    if (!self.canSend) {
        [self showToastWithText:self.cannotSendMsg];
        return;
    }
    if (self.textView.text.length > 3000) {
        [self showToastWithText:@"文案内容不能超过三千字哦~"];
        return;
    }

    if (!self.textView.text.length && !self.moveArr.count) {
        [self showToastWithText:@"请输入文案或者选择图片"];
        return;
    }
    
    if (self.moveArr.count) {
        [self updateImage];
    }else{
        [self upDontai];
    }

    [self clearCache];
}


- (void)updateImage{
    [self showHUD];

    _sendBtn.userInteractionEnabled = NO;
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *arr1 = [NSMutableArray new];
    for (NSMutableDictionary *dic in self.moveArr) {
        [arr addObject:[dic objectForKey:Locapaths]];
        [arr1 addObject:[dic objectForKey:ImageDatas]];
    }
    
    NSString *pathMd5 = [NoticeTools arrayToJSONString:arr];//多个文件用数组,单个用字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"92" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
 
    [[XGUploadDateManager sharedManager] uploadMoreWithImageArr:arr1 noNeedToast:YES parm:parm progressHandler:^(CGFloat progress) {
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (!sussess) {
            [self hideHUD];
           
            [self showToastWithText:Message];
            return ;
        }else{
            [self hideHUD];
            self.bucket_id = bucketId;
            self.imageJsonString = Message;
            [self upDontai];
        }
    }];
}

- (void)upDontai{
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if (self.textView.text.length && self.textView.text) {
        [parm setObject:self.textView.text forKey:@"content"];
    }
    if (self.moveArr.count && self.imageJsonString) {
        [parm setObject:self.imageJsonString forKey:@"dynamicImg"];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopDynamic" Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self sendSuccess:YES];
        }else{
            [self sendSuccess:NO];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [self sendSuccess:NO];
    }];
}

- (void)sendSuccess:(BOOL)success{
    [self showToastWithText:success?@"发布成功":@"发布失败，已保存至发布页"];
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICESHOPSAYSEND" object:nil];
        }
    });
}

- (void)clearCache{
    NSMutableArray *alreadyArr = [[NSMutableArray alloc] init];
    [NoticeSaveVoiceTools saveVoiceArr:alreadyArr];
}

- (void)saveTocaogao{
    NSMutableArray *alreadyArr = [[NSMutableArray alloc] init];
    NoticeVoiceSaveModel *saveM = [[NoticeVoiceSaveModel alloc] init];
    saveM.sendTime = [NoticeSaveVoiceTools getTimeString];
    saveM.textContent = self.textView.text;

    if (self.moveArr.count) {
        for (int i = 0; i < self.moveArr.count; i++) {
            UIImage * imgsave = [UIImage imageWithData:[self.moveArr[i] objectForKey:ImageDatas]];
            NSString *pathName = [NSString stringWithFormat:@"/%@",[self.moveArr[i] objectForKey:Locapaths]];
            NSString * Pathimg = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:pathName];
            [UIImagePNGRepresentation(imgsave) writeToFile:Pathimg atomically:YES];
            if (i == 0) {
                saveM.img1Path = [self.moveArr[i] objectForKey:Locapaths];
            }else if (i == 1){
                saveM.img2Path = [self.moveArr[i] objectForKey:Locapaths];
            }else if (i == 2){
                saveM.img3Path = [self.moveArr[i] objectForKey:Locapaths];
            }
        }
    }
    [alreadyArr insertObject:saveM atIndex:0];
    [NoticeSaveVoiceTools saveVoiceArr:alreadyArr];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textView resignFirstResponder];
}

- (void)comeFromSave{
    //缓存进来的
    if (self.saveModel) {

        self.textView.text = self.saveModel.textContent;

        self.moveArr = [[NSMutableArray alloc] init];
        if (self.saveModel.img1Path || self.saveModel.img2Path || self.saveModel.img3Path) {
       
            if (self.saveModel.img1Path) {
                [self getsaveimg1];
            }
        }else{
            [self setTextViewHeight:self.textView text:@""];
            [self.textView becomeFirstResponder];
        }
    }
}

- (void)getsaveimg1{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",self.saveModel.img1Path]]];
    if (image) {
        NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
        NSMutableDictionary *imagerDic = [NSMutableDictionary new];
        [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
        UIImage *ciImage = image;
        [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
        [self.moveArr addObject:imagerDic];
        if (self.saveModel.img2Path) {
            [self getsaveimg2];
        }else{
            self.imageViewS.imgArr = self.moveArr;
            self.imageViewS.hidden = NO;
            [self setTextViewHeight:self.textView text:@""];
            [self keyboardHide];
            [self.textView becomeFirstResponder];
            [self hideHUD];
        }
    }
    
}

- (void)getsaveimg2{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",self.saveModel.img2Path]]];
    if (image) {
        NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
        NSMutableDictionary *imagerDic = [NSMutableDictionary new];
        [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
        UIImage *ciImage = image;
        [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
        [self.moveArr addObject:imagerDic];
        if (self.saveModel.img3Path) {
            [self getsaveimg3];
        }else{
            self.imageViewS.imgArr = self.moveArr;
            self.imageViewS.hidden = NO;
            [self setTextViewHeight:self.textView text:@""];
            [self keyboardHide];
            [self.textView becomeFirstResponder];
            [self hideHUD];
        }
    }
}

- (void)getsaveimg3{
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",self.saveModel.img3Path]]];
    if (image) {
        NSString *filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],(long)arc4random()%999999999678999];
        NSMutableDictionary *imagerDic = [NSMutableDictionary new];
        [imagerDic setObject:[NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]] forKey:Locapaths];
        UIImage *ciImage = image;
        [imagerDic setObject:UIImageJPEGRepresentation(ciImage, 0.8) forKey:ImageDatas];
        [self.moveArr addObject:imagerDic];
        self.imageViewS.imgArr = self.moveArr;
        self.imageViewS.hidden = NO;
        [self setTextViewHeight:self.textView text:@""];
        [self keyboardHide];
        [self.textView becomeFirstResponder];
        [self hideHUD];
    }
}


@end
