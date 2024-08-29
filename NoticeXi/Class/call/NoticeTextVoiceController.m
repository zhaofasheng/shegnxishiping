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
#import "NoticeChoicePhotoCell.h"
#import "NoticeTextChoicePutView.h"
#import "NoticeSendTextStatusController.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
#import "NoticeChoiceVoiceStatusController.h"
#import "NoticeSendVoiceImageView.h"//
#define Locapaths  @"locapath"
#define ImageDatas  @"ImageDatas"
#import "NoticeXi-Swift.h"
@interface NoticeTextVoiceController ()<UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate>

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

@property (nonatomic, strong) NSString *plaStr;
@property (nonatomic, assign) BOOL isHasTostsave;
@property (nonatomic, assign) BOOL hasChange;
@property (nonatomic, strong) NSString *bucketId;
@property (nonatomic, strong) UIView *imageViewBack;
@property (nonatomic, assign) NSInteger timePercent;
@property (nonatomic, assign) NSInteger timeOutNum;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) BOOL isHasTostProgross;
@property (nonatomic, assign) BOOL needContSet;//是否需要设置偏移量
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, assign) CGFloat hasTitleHeight;
@property (nonatomic, strong) UILabel *plaL;
@property (nonatomic, strong) NSString *bucket_id;
@property (nonatomic, assign) NSInteger statysType;
@property (nonatomic, strong) NoticeSendVoiceImageView *imageViewS;
@property (nonatomic, assign) BOOL hasChangeImg;
@property (nonatomic, assign) NSInteger oldImgNum;
@end

@implementation NoticeTextVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];


    UILabel *btn = [[UILabel alloc] init];
    btn.frame = CGRectMake(DR_SCREEN_WIDTH-66-20, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-28)/2,66,28);
    btn.text = [NoticeTools getLocalStrWith:@"py.send"];
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
    

    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-BOTTOM_HEIGHT-50);
    
    self.tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(becomFirstTap)];
    [self.tableView addGestureRecognizer:tap];
    self.imageViewS.hidden = NO;
    
    self.plaStr = [NoticeTools getLocalStrWith:@"sendTextt.input"];
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, DR_SCREEN_WIDTH-19-5, 14)];
    _plaL.text = self.plaStr;
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15,5, DR_SCREEN_WIDTH-30,35)];
    _textView.font = SIXTEENTEXTFONTSIZE;
    _textView.clearsOnInsertion = YES;
    _textView.scrollEnabled = NO;
    _textView.bounces = NO;
    _textView.backgroundColor = self.view.backgroundColor;
    
    _textView.delegate = self;
    _textView.textColor = [UIColor colorWithHexString:@"#25262E"];
    _textView.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    [self.tableView addSubview:_textView];
    [self.tableView addSubview:_plaL];
    self.phassetArr = [NSMutableArray new];
    self.moveArr = [NSMutableArray new];
    
    self.toolsView = [[NoticeSendVoiceTools alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
    self.toolsView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.toolsView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    [self keyboardHide];

}

- (void)becomFirstTap{
    [self.textView becomeFirstResponder];
}

- (NoticeSendVoiceImageView *)imageViewS{
    if (!_imageViewS) {
        CGFloat width = (DR_SCREEN_WIDTH-40-15)/4;
        _imageViewS = [[NoticeSendVoiceImageView alloc] initWithFrame:CGRectMake(10, 10, DR_SCREEN_WIDTH-20, width+30)];
        _imageViewS.isLocaImage = YES;
        _imageViewS.isVoice = NO;
        _imageViewS.backgroundColor = self.view.backgroundColor;
       // [self.tableView addSubview:_imageViewS];

        __weak typeof(self) weakSelf = self;
        _imageViewS.imgBlock = ^(NSInteger tag) {
            if (tag <= weakSelf.moveArr.count-1) {
                [weakSelf.moveArr removeObjectAtIndex:tag];
                weakSelf.imageViewS.imgArr = [NSArray arrayWithArray:weakSelf.moveArr];
                [weakSelf keyboardHide];
                [weakSelf.toolsView.imgButton setImage:UIImageNamed(weakSelf.moveArr.count==3? @"senimgv_imgn":@"senimgv_img") forState:UIControlStateNormal];
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
    if ([NoticeTools isManager]) {
        imagePicker.allowPickingVideo = YES;
        imagePicker.allowPickingMultipleVideo = NO;
    }
    imagePicker.allowCrop = NO;
    imagePicker.showSelectBtn = YES;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)keyboardDidChangeFrame:(NSNotification *)notification{


    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.toolsView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.toolsView.frame.size.height-10, DR_SCREEN_HEIGHT, 60);
    self.keyBordHeight = keyboardF.size.height;
    _plaL.frame = CGRectMake(19, 15, DR_SCREEN_WIDTH-19-5, 14);
    self.imageViewS.frame = CGRectMake(10, -self.imageViewS.frame.size.height-50-10, self.imageViewS.frame.size.width, self.imageViewS.frame.size.height);
    self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
    [self setTextViewHeight:self.textView text:@""];
}

- (void)keyboardHide{
 
    CGFloat width = (DR_SCREEN_WIDTH-40-15)/4;
    self.imageViewS.frame = CGRectMake(10, 10, DR_SCREEN_WIDTH-20, width+30);
    _plaL.frame = CGRectMake(19, 15, DR_SCREEN_WIDTH-19-5, 14);
    self.textView.frame = CGRectMake(15,5, DR_SCREEN_WIDTH-30,(self.textHeight>35?self.textHeight:35));
    self.toolsView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50);
    self.tableView.contentSize = CGSizeMake(0, self.textView.frame.size.height+(self.imageViewS.hidden?0:DR_SCREEN_WIDTH-30+15));

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
    CGFloat curSelectHeight = [self heightForTextView:_textView WithText:currentSelectStr]+20;//当前光标位置高度
    
   // CGFloat allHeight = self.textHeight;//总高度
    CGFloat canLookHeight = self.tableView.frame.size.height-50-self.keyBordHeight-20+100+BOTTOM_HEIGHT-50;//文本输入可视区域
    
    if (curSelectHeight >= canLookHeight) {//如果光标位置的高度超过了可视高度
        self.textView.frame = CGRectMake(15,self.tableView.frame.size.height-curSelectHeight-canLookHeight, DR_SCREEN_WIDTH-30,self.textHeight);
        self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
    }else{
        self.tableView.contentSize = CGSizeMake(0, self.tableView.frame.size.height);
        self.textView.frame = CGRectMake(15,5, DR_SCREEN_WIDTH-30,(self.textHeight>35?self.textHeight:35));
    }
    
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

    return [self getSpaceLabelHeight:strText withFont:SIXTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30]+50;

}

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 0;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          
    };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.hasChangeImg = YES;
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
                [self keyboardHide];
            }];
        });
    }
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset{
    self.hasChangeImg = YES;
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
        
        self.imageViewS.imgArr = [NSArray arrayWithArray:self.moveArr];
        self.imageViewS.hidden = NO;
        [self keyboardHide];
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSEASSEST" object:nil];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
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
        
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (BOOL)isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (void)sendClick{
    if (self.textView.text.length > 10000) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.fali1"]];
        return;
    }

    if (!self.textView.text.length) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.fali2"]];
        return;
    }
    
    if ([self isEmpty:self.textView.text]) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"sendTextt.fali3"]];
        return;
    }

}

- (void)backSucdess{
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.textView resignFirstResponder];
}


@end
