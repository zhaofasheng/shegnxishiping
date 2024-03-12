//
//  NoticeChangeBokeController.m
//  NoticeXi
//
//  Created by li lei on 2023/12/19.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeBokeController.h"
#import "DDHAttributedMode.h"
@interface NoticeChangeBokeController ()<UITextViewDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UITextView *nameField;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) NSMutableAttributedString *attStr1;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) NSString *changeUri;
@property (nonatomic, strong) NSString *bucketId;
@property (nonatomic, strong) UIImage *cutsumeImg;
@property (nonatomic, strong) NSString *filepath;
@end

@implementation NoticeChangeBokeController
{
    UILabel *_plaL;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.titleL.text = @"修改播客";
    
    UIView *bokeimgView = [[UIView alloc] initWithFrame:CGRectMake(15, 12+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-30, 132)];
    bokeimgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bokeimgView setAllCorner:5];
    [self.view addSubview:bokeimgView];
    
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 42, 120, 80)];
    self.coverImageView.layer.cornerRadius = 4;
    self.coverImageView.layer.edgeAntialiasingMask = YES;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bokeimgView addSubview:self.coverImageView];
    self.coverImageView.userInteractionEnabled = YES;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.coverUrl]];
    
    self.changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(56,47, 60, 29)];
    [self.changeBtn addTarget:self action:@selector(choiceTap) forControlEvents:UIControlEventTouchUpInside];
    [self.changeBtn setBackgroundImage:UIImageNamed(@"changeicon_Image") forState:UIControlStateNormal];
    [self.coverImageView addSubview:self.changeBtn];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 22)];
    label1.font = SIXTEENTEXTFONTSIZE;
    label1.text = [NoticeTools getLocalStrWith:@"zj.fm"];
    label1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    [bokeimgView addSubview:label1];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(bokeimgView.frame)+15, DR_SCREEN_WIDTH-30, 140)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [backView setAllCorner:5];
    [self.view addSubview:backView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 22)];
    label2.font = SIXTEENTEXTFONTSIZE;
    label2.text = [NoticeTools getLocalStrWith:@"bk.jjjie"];
    label2.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    [backView addSubview:label2];

    
    self.nameField = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, DR_SCREEN_WIDTH-30, 30)];
    self.nameField.text = self.induce;
    self.nameField.backgroundColor = backView.backgroundColor;
    self.nameField.tintColor = [UIColor colorWithHexString:@"#00ABE4"];
    self.nameField.text = self.induce;

    
    self.nameField.delegate = self;
    self.nameField.font =FIFTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#25262E"];
    [backView addSubview:self.nameField];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20+40, 200, 14)];

    if(self.induce){
        _plaL.text = @"";
    }
    
    _plaL.font = FIFTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [backView addSubview:_plaL];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-60,12,50, 17)];
    self.numL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.numL.font = TWOTEXTFONTSIZE;

    NSString *allStr = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.induce.length,@"80"];
    self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"80" beginSize:allStr.length-2];
    [backView addSubview:self.numL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-20-40,DR_SCREEN_WIDTH-40, 40);
    [btn setTitle:[NoticeTools getLocalStrWith:@"groupManager.save"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = XGTwentyBoldFontSize;
    btn.layer.cornerRadius = 20;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"#00ABE4"];
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.finishBtn = btn;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.nameField resignFirstResponder];
}


- (void)fifinshClick{
    if ([self.induce isEqualToString:self.nameField.text] && !self.cutsumeImg) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if(!self.nameField.text.length){
        [self showToastWithText:@"播客简介不允许为空哦~"];
        return;
    }
    
    if(self.nameField.text.length > 80){
        [self showToastWithText:@"简介字数超限"];
        return;
    }
    
    if(self.cutsumeImg){
        [self upLoadHeader:self.cutsumeImg path:nil];
    }else{
        [self changeInfo];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    self.cutsumeImg = choiceImage;
    self.coverImageView.image = self.cutsumeImg;
 
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
        }
        self.filepath = [NSString stringWithFormat:@"%@_%@.jpeg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:filePath]];
    }];
  
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path{
    if (!path) {

        path = [NSString stringWithFormat:@"%@_%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
    }
    
    [self showHUD];
    self.finishBtn.enabled = NO;
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"80" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        [self hideHUD];
        if (sussess) {
            self.changeUri = Message;
            if (bucketId) {
                self.bucketId = bucketId;
            }else{
                self.bucketId = @"0";
            }
    
            [self changeInfo];
            
        }else{
 
            self.finishBtn.enabled = YES;

        }
    }];
}

- (void)changeInfo{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if(self.cutsumeImg && self.changeUri){
        [parm setObject:self.changeUri forKey:@"coverUri"];
        [parm setObject:self.bucketId forKey:@"bucketId"];
    }
    [parm setObject:self.nameField.text forKey:@"podcastIntro"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@",self.bokeId] Accept:@"application/vnd.shengxi.v5.5.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        self.finishBtn.enabled = YES;
        if (success) {
            NoticeDanMuModel *dataM = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
            if(self.changeBokeIntroBlock){
                self.changeBokeIntroBlock(self.nameField.text, self.bokeId,(dataM.coverUrl.length > 8 ?dataM.coverUrl:@""));
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NoticeOneToOne *msgModel = [NoticeOneToOne mj_objectWithKeyValues:dict];
    
            if (msgModel.chatM.keyword.count) {
                for (NSString *str in msgModel.chatM.keyword) {
                    [self setRedColor:str sourceString:self.nameField.text textView:self.nameField att:self.attStr1];

                }
                [self showToastWithText:@"包含违规词汇"];
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        self.finishBtn.enabled = YES;
        [self hideHUD];
    }];
}


- (void)choiceTap{
    [self.nameField resignFirstResponder];
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = false;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = false;
    imagePicker.allowCrop = true;
    imagePicker.cropRect = CGRectMake(0,(DR_SCREEN_HEIGHT-(DR_SCREEN_WIDTH*203/305))/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*203/305);
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //YES：允许右滑返回  NO：禁止右滑返回
    return NO;
}


- (void)setRedColor:(NSString *)redString sourceString:(NSString *)sourchString textView:(UITextView*)textView att:(NSMutableAttributedString *)att{
    if (!att) {
        att =  [[NSMutableAttributedString alloc]initWithString:sourchString];
        self.attStr1 = att;
    }
    NSMutableAttributedString *nameString =  att;
    for (int i = 0; i < sourchString.length; i++) {
        if ((sourchString.length - i) < redString.length) {  //防止遍历剩下的字符少于搜索条件的字符而崩溃
            
        }else {
            NSString *str = [sourchString substringWithRange:NSMakeRange(i, redString.length)];
            if ([redString isEqualToString:str]) {
                [nameString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, redString.length)];
                
                i = i + (int)(redString.length) - 1;
            }
        }
    }
    [nameString addAttribute:NSFontAttributeName value:FIFTHTEENTEXTFONTSIZE range:NSMakeRange(0, textView.text.length)];
    textView.attributedText = nameString;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    if (height > 90) {
        height = 90;
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        textView.frame = frame;
    } completion:nil];
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    self.attStr1 = nil;
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = @"请输入播客简介";
    }
    
    if (textView.text.length > 80) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/%@",textView.text.length,@"80"] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
        
    }else{
        NSString *allStr = [NSString stringWithFormat:@"%lu/%@",textView.text.length,@"80"];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"80" beginSize:allStr.length-2];
    }
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}


@end
