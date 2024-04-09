//
//  SXWorkCheckController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXWorkCheckController.h"
#import "SXUpIdentyController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SXWorkCheckController ()<UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,LCActionSheetDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImage *zmImage;
@property (nonatomic, strong) UIImage *fmImage;
@property (nonatomic, strong) UIButton *upSFbtn;//上传身份证按钮
@property (nonatomic, strong) UIButton *zhengshuBtn;
@property (nonatomic, strong) UITextField *schoolTextField;
@property (nonatomic, strong) UITextField *zyTextField;
@property (nonatomic, strong) UIButton *inputBtn;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *numTextField;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITextView *cnField;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIImageView *zhengshuImageView1;

@property (nonatomic, strong) UIImageView *zhengshuImageView2;

@property (nonatomic, strong) UIImageView *zhengshuImageView3;

@property (nonatomic, strong) UIImageView *zhengshuImageView4;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) NSString *imageJsonString;
@end

@implementation SXWorkCheckController

{
    UILabel *_plaL;
}

- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.titleL.text = @"职业认证";
    [self setUI];
}


- (void)setUI{
    NSString *markStr = @"* 劳动合同、在职证明、从业证书(任一)\n* 请确保相关信息(姓名、身份证号、职务、公司公章、证书编号等)清晰可见，无遮挡。在职证明须为6个月内开具。";
    CGFloat height = [SXTools getHeightWithLineHight:3 font:12 width:DR_SCREEN_WIDTH-60 string:markStr isJiacu:NO];
    CGFloat imgageWidth = (DR_SCREEN_WIDTH-60-35)/4;
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 268+30+162+248+(44+height+30+imgageWidth)+30)];
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-50);
    
    //头部提示
    UILabel *headlabeL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
    headlabeL.font = FOURTHTEENTEXTFONTSIZE;
    headlabeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    headlabeL.text = @"材料仅在审核中使用";
    [self.headerView addSubview:headlabeL];
    
    //实名信息
    UIView *identidyView = [[UIView  alloc] initWithFrame:CGRectMake(15, 40, DR_SCREEN_WIDTH-30, 228)];
    identidyView.backgroundColor = [UIColor whiteColor];
    [identidyView setAllCorner:10];
    [self.headerView addSubview:identidyView];
    
    UILabel *identTitleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 25)];
    identTitleL.font = XGEightBoldFontSize;
    identTitleL.textColor = [UIColor colorWithHexString:@"#14151A"];
    identTitleL.text = @"实名信息";
    [identidyView addSubview:identTitleL];
    
    UIView *sfView = [[UIView  alloc] initWithFrame:CGRectMake(15, 60, DR_SCREEN_WIDTH-60, 56)];
    sfView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [sfView setAllCorner:8];
    [identidyView addSubview:sfView];
    
    UIImageView *sfImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 18, 24, 24)];
    sfImageV.image = UIImageNamed(@"sxedcsfimg_img");
    [sfView addSubview:sfImageV];
    
    UILabel *sfL = [[UILabel  alloc] initWithFrame:CGRectMake(47, 17, 200, 21)];
    sfL.font = FIFTHTEENTEXTFONTSIZE;
    sfL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    sfL.text = @"身份证照片";
    [sfView addSubview:sfL];
    
    self.upSFbtn = [[UIButton  alloc] initWithFrame:CGRectMake(sfView.frame.size.width-15-72, 12, 72, 32)];
    self.upSFbtn.layer.cornerRadius = 16;
    self.upSFbtn.layer.masksToBounds = YES;
    self.upSFbtn.layer.borderWidth = 1;
    self.upSFbtn.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
    [self.upSFbtn setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    [self.upSFbtn setTitle:@"去上传" forState:UIControlStateNormal];
    self.upSFbtn.titleLabel.font = TWOTEXTFONTSIZE;
    [sfView addSubview:self.upSFbtn];
    [self.upSFbtn addTarget:self action:@selector(upIdentImgClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *plaArr = @[@"请输入真实姓名",@"请填写身份证号"];
    CGFloat labelWidth = GET_STRWIDTH(@"身份信息", 15, 51);
    for (int i = 0; i < 2; i++) {
        UILabel *idMarkL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 121+51*i, labelWidth, 51)];
        idMarkL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        idMarkL.font = FIFTHTEENTEXTFONTSIZE;
        [identidyView addSubview:idMarkL];
        if (i == 0) {
            idMarkL.text = @"姓名";
        }else{
            idMarkL.text = @"身份证号";
        }
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(idMarkL.frame)+10, 121+51*i, DR_SCREEN_WIDTH-45-CGRectGetMaxX(idMarkL.frame)-10, 51)];
        [textField setupToolbarToDismissRightButton];
        textField.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        textField.font = FIFTHTEENTEXTFONTSIZE;
        textField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        textField.textColor = [UIColor colorWithHexString:@"#14151A"];
        textField.textAlignment = NSTextAlignmentRight;
        [identidyView addSubview:textField];
        textField.delegate = self;
        if (i == 1) {
            textField.keyboardType = UIKeyboardTypeNamePhonePad;
        }
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:plaArr[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1]}];
        
        if (i == 0) {
            self.nameTextField = textField;
        }else{
            self.numTextField = textField;
        }
    }
    
    //认证信息
    UIView *checkView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(identidyView.frame)+10, DR_SCREEN_WIDTH-30, 162)];
    checkView.backgroundColor = [UIColor whiteColor];
    [checkView setAllCorner:10];
    [self.headerView addSubview:checkView];
    
    UILabel *identTitleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 25)];
    identTitleL1.font = XGEightBoldFontSize;
    identTitleL1.textColor = [UIColor colorWithHexString:@"#14151A"];
    identTitleL1.text = @"职业信息";
    [checkView addSubview:identTitleL1];
    
    NSArray *plaArr1 = @[@"如：软件开发",@"如：产品经理、测试工程师"];
    for (int i = 0; i < 2; i++) {
        UILabel *idMarkL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 55+51*i, labelWidth, 51)];
        idMarkL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        idMarkL.font = FIFTHTEENTEXTFONTSIZE;
        [checkView addSubview:idMarkL];
        if (i == 0) {
            idMarkL.text = @"行业";
        }else if (i == 1){
            idMarkL.text = @"职位";
        }
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(idMarkL.frame)+10, 55+51*i, DR_SCREEN_WIDTH-45-CGRectGetMaxX(idMarkL.frame)-10, 51)];
        [textField setupToolbarToDismissRightButton];
        textField.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        textField.font = FIFTHTEENTEXTFONTSIZE;
        textField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        textField.textColor = [UIColor colorWithHexString:@"#14151A"];
        textField.textAlignment = NSTextAlignmentRight;
        [checkView addSubview:textField];
        textField.delegate = self;
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:plaArr1[i] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1]}];
        
        if (i == 0) {
            self.schoolTextField = textField;
        }else{
            self.zyTextField = textField;
        }
       
    }
    
    //照片验证信息
    UIView *imgCheckView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(checkView.frame)+10, DR_SCREEN_WIDTH-30, 44+height+30+imgageWidth+20)];
    imgCheckView.backgroundColor = [UIColor whiteColor];
    [imgCheckView setAllCorner:10];
    [self.headerView addSubview:imgCheckView];
    
    UILabel *identTitleL3 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 25)];
    identTitleL3.font = XGEightBoldFontSize;
    identTitleL3.textColor = [UIColor colorWithHexString:@"#14151A"];
    identTitleL3.text = @"职业验证信息";
    [imgCheckView addSubview:identTitleL3];
    
    UILabel *markL3 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 44, DR_SCREEN_WIDTH-60, height)];
    markL3.font = TWOTEXTFONTSIZE;
    markL3.numberOfLines = 0;
    markL3.textColor = [UIColor colorWithHexString:@"#168BB3"];
    markL3.attributedText = [SXTools getStringWithLineHight:3 string:markStr];
    [imgCheckView addSubview:markL3];
    
    UIView *imView1 = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(markL3.frame)+15, DR_SCREEN_WIDTH-60, imgageWidth+20)];
    imView1.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [imView1 setAllCorner:8];
    [imgCheckView addSubview:imView1];
    
    for (int i = 0; i < 4; i++) {
        UIImageView *zsImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10+(imgageWidth+5)*i, 10, imgageWidth,imgageWidth)];
        zsImageView.userInteractionEnabled = YES;
        [imView1 addSubview:zsImageView];
        [zsImageView setAllCorner:4];
        zsImageView.hidden = YES;
        zsImageView.contentMode = UIViewContentModeScaleAspectFill;
        zsImageView.clipsToBounds = YES;
        
        UIButton *reChoiceBtn = [[UIButton  alloc] initWithFrame:CGRectMake(zsImageView.frame.size.width-20-4, 4, 20, 20)];
        reChoiceBtn.tag = i;
        [reChoiceBtn setImage:UIImageNamed(@"sxrechoicezj_img") forState:UIControlStateNormal];
        [zsImageView addSubview:reChoiceBtn];
        [reChoiceBtn addTarget:self action:@selector(deleteImgClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            self.zhengshuImageView1 = zsImageView;
        }else if (i == 1){
            self.zhengshuImageView2 = zsImageView;
        }else if (i == 2){
            self.zhengshuImageView3 = zsImageView;
        }else if (i == 3){
            self.zhengshuImageView4 = zsImageView;
        }
    }
    
    self.addBtn = [[UIButton  alloc] initWithFrame:self.zhengshuImageView1.frame];
    [self.addBtn setBackgroundImage:UIImageNamed(@"sxaddimgbutton") forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    [imView1 addSubview:self.addBtn];
    self.addBtn.hidden = YES;

    self.zhengshuBtn = [[UIButton  alloc] initWithFrame:CGRectMake((sfView.frame.size.width-118)/2, (imView1.frame.size.height-32)/2, 118, 32)];
    self.zhengshuBtn.layer.cornerRadius = 16;
    self.zhengshuBtn.layer.masksToBounds = YES;
    self.zhengshuBtn.layer.borderWidth = 1;
    self.zhengshuBtn.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
    [self.zhengshuBtn setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    [self.zhengshuBtn setTitle:@"去上传原件图片" forState:UIControlStateNormal];
    self.zhengshuBtn.titleLabel.font = TWOTEXTFONTSIZE;
    [imView1 addSubview:self.zhengshuBtn];
    [self.zhengshuBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    
    //验证信息
    UIView *realView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(imgCheckView.frame)+10, DR_SCREEN_WIDTH-30, 248)];
    realView.backgroundColor = [UIColor whiteColor];
    [realView setAllCorner:10];
    [self.headerView addSubview:realView];
    
    UILabel *identTitleL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 25)];
    identTitleL2.font = XGEightBoldFontSize;
    identTitleL2.textColor = [UIColor colorWithHexString:@"#14151A"];
    identTitleL2.text = @"从业经历认证";
    [realView addSubview:identTitleL2];
    
    CGFloat height1 = [SXTools getHeightWithLineHight:3 font:12 width:DR_SCREEN_WIDTH-60 string:@"本人承诺所提供的信息(包括身份信息、职业信息)真实准确，如有不实，愿意承担相关责任。" isJiacu:NO];
    UILabel *markL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 70, DR_SCREEN_WIDTH-60, height1)];
    markL2.font = TWOTEXTFONTSIZE;
    markL2.numberOfLines = 0;
    markL2.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
    markL2.attributedText = [SXTools getStringWithLineHight:3 string:@"本人承诺所提供的信息(包括身份信息、职业信息)真实准确，如有不实，愿意承担相关责任。"];
    [realView addSubview:markL2];
    
    UILabel *markL5 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 48, DR_SCREEN_WIDTH-60, 18)];
    markL5.font = TWOTEXTFONTSIZE;
    markL5.textColor = [UIColor colorWithHexString:@"#14151A"];
    markL5.text = @"为保证信息真实性，请输入以下个人承诺声明：";
    [realView addSubview:markL5];
    
    UIView *imView = [[UIView  alloc] initWithFrame:CGRectMake(15, 119, DR_SCREEN_WIDTH-60, 114)];
    imView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [imView setAllCorner:8];
    [realView addSubview:imView];
    
    self.cnField = [[UITextView alloc] initWithFrame:CGRectMake(8, 10, DR_SCREEN_WIDTH-60-20, 30)];
    self.cnField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    self.cnField.delegate = self;
    self.cnField.font = FOURTHTEENTEXTFONTSIZE;
    self.cnField.scrollEnabled = NO;
    self.cnField.textColor = [UIColor colorWithHexString:@"#14151A"];
    self.cnField.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [imView addSubview:self.cnField];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 14)];
    _plaL.text = @"请完整输入以上承诺声明内容";
    _plaL.font = FOURTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [imView addSubview:_plaL];

    self.inputBtn = [[UIButton  alloc] initWithFrame:CGRectMake(10, 80,68, 24)];
    self.inputBtn.layer.cornerRadius = 12;
    self.inputBtn.layer.masksToBounds = YES;
    self.inputBtn.layer.borderWidth = 1;
    self.inputBtn.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
    [self.inputBtn setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    [self.inputBtn setTitle:@"一键输入" forState:UIControlStateNormal];
    self.inputBtn.titleLabel.font = TWOTEXTFONTSIZE;
    [imView addSubview:self.inputBtn];
    [self.inputBtn addTarget:self action:@selector(upyuanjianImgClick) forControlEvents:UIControlEventTouchUpInside];
    
  
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableView.frame)+5, DR_SCREEN_WIDTH-40, 40)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    [addBtn setAllCorner:20];
    [addBtn setTitle:@"提交认证" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [addBtn addTarget:self action:@selector(upClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    //监听键盘将要升起的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘回收的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self hasImageView];
    [self refreshData];
}

- (void)imgClick{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[@"拍照",@"相册上传"]];
    sheet.delegate = self;
    [sheet show];
}


- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
            
            [self showToastWithText:@"您没有开启相机权限哦~，您可以在手机系统设置开启"];
        } else{
            //判断是否支持相机
              if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                  [self presentViewController:self.imagePickerController animated:YES completion:nil];
              }
        }
    }else if (buttonIndex == 2){
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePicker.sortAscendingByModificationDate = false;
        imagePicker.allowPickingOriginalPhoto = false;
        imagePicker.alwaysEnableDoneBtn = true;
        imagePicker.allowPickingVideo = false;
        imagePicker.allowPickingGif = false;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
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

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    [self addZSImage:choiceImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {

        UIImage *choiceImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (choiceImage) {
            [self addZSImage:choiceImage];
        }
    }
}

- (void)addZSImage:(UIImage *)addImage{
    
    [self.imageArr addObject:addImage];
    
    [self refreImages];
}

- (void)refreImages{
    if (self.imageArr.count) {
        self.zhengshuBtn.hidden = YES;
    }else{
        self.zhengshuBtn.hidden = NO;
    }
    
    if (self.imageArr.count && self.imageArr.count != 4) {
        self.addBtn.hidden = NO;
    }else{
        self.addBtn.hidden = YES;
    }
    
    self.zhengshuImageView1.hidden = YES;
    self.zhengshuImageView2.hidden = YES;
    self.zhengshuImageView3.hidden = YES;
    self.zhengshuImageView4.hidden = YES;
    
    if (self.imageArr.count == 1) {
        self.addBtn.frame = self.zhengshuImageView2.frame;
        self.zhengshuImageView1.image = self.imageArr[0];
        self.zhengshuImageView1.hidden = NO;
    }else if (self.imageArr.count == 2){
        self.addBtn.frame = self.zhengshuImageView3.frame;
        self.zhengshuImageView1.image = self.imageArr[0];
        self.zhengshuImageView1.hidden = NO;
        self.zhengshuImageView2.image = self.imageArr[1];
        self.zhengshuImageView2.hidden = NO;
    }else if (self.imageArr.count == 3){
        self.addBtn.frame = self.zhengshuImageView4.frame;
        self.zhengshuImageView1.image = self.imageArr[0];
        self.zhengshuImageView1.hidden = NO;
        self.zhengshuImageView2.image = self.imageArr[1];
        self.zhengshuImageView2.hidden = NO;
        self.zhengshuImageView3.image = self.imageArr[2];
        self.zhengshuImageView3.hidden = NO;
    }else if (self.imageArr.count == 4){
        self.zhengshuImageView1.image = self.imageArr[0];
        self.zhengshuImageView1.hidden = NO;
        self.zhengshuImageView2.image = self.imageArr[1];
        self.zhengshuImageView2.hidden = NO;
        self.zhengshuImageView3.image = self.imageArr[2];
        self.zhengshuImageView3.hidden = NO;
        self.zhengshuImageView4.image = self.imageArr[3];
        self.zhengshuImageView4.hidden = NO;
    }
}

- (void)deleteImgClick:(UIButton *)button{
    if (button.tag < self.imageArr.count) {
        [self.imageArr removeObjectAtIndex:button.tag];
        [self refreImages];
    }
}

- (void)refreshData{
    if (self.isCheckFail || self.isUpdate) {
        self.nameTextField.text = self.verifyModel.real_name;
        self.numTextField.text = self.verifyModel.cert_no;
        self.schoolTextField.text = self.verifyModel.industry_name;
        self.zyTextField.text = self.verifyModel.position_name;
        if (self.verifyModel.career_images_url.count == 1) {
            [self.zhengshuImageView1 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    [self addZSImage:image];
                }
            }];
        }else if (self.verifyModel.career_images_url.count == 2){
            [self.zhengshuImageView1 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    [self addZSImage:image];
                    
                    [self.zhengshuImageView2 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[1]] completed:^(UIImage * _Nullable image1, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        if (image1) {
                            [self addZSImage:image1];
                        }
                    }];
                }
            }];
        }else if (self.verifyModel.career_images_url.count == 3){
            [self.zhengshuImageView1 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    [self addZSImage:image];
                    
                    [self.zhengshuImageView2 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[1]] completed:^(UIImage * _Nullable image1, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        if (image1) {
                            [self addZSImage:image1];
                            
                            [self.zhengshuImageView3 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[2]] completed:^(UIImage * _Nullable image2, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                if (image2) {
                                    [self addZSImage:image2];
                                }
                            }];
                        }
                    }];
                }
            }];
        }else if (self.verifyModel.career_images_url.count == 4){
            [self.zhengshuImageView1 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    [self addZSImage:image];
                    
                    [self.zhengshuImageView2 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[1]] completed:^(UIImage * _Nullable image1, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        if (image1) {
                            [self addZSImage:image1];
                            
                            [self.zhengshuImageView3 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[2]] completed:^(UIImage * _Nullable image2, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                if (image2) {
                                    [self addZSImage:image2];
                                    [self.zhengshuImageView4 sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.career_images_url[3]] completed:^(UIImage * _Nullable image3, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                        if (image3) {
                                            [self addZSImage:image3];
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }
}

- (void)hasImageView{
    if (self.verifyModel.front_photo_url.length > 10 && self.verifyModel.back_photo_url.length > 10) {
        self.upSFbtn.layer.borderWidth = 0;
        [self.upSFbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.upSFbtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.upSFbtn setTitle:@"查看图片" forState:UIControlStateNormal];
    }
}

-(void)keyboardWillShow:(NSNotification*)note{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,keyBoardRect.size.height,0);
}

-(void)keyboardWillHide:(NSNotification*)note{
    self.tableView.contentInset = UIEdgeInsetsZero;
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    [self.schoolTextField resignFirstResponder];
    [self.zyTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.numTextField resignFirstResponder];
    [self.cnField resignFirstResponder];
}


//一键输入
- (void)upyuanjianImgClick{
    self.cnField.text = @"本人承诺所提供的信息(包括身份信息、职业信息)真实准确，如有不实，愿意承担相关责任。";
    [self textViewDidChangeSelection:self.cnField];
}


//提交
- (void)upClick{
    
    if (![self.cnField.text isEqualToString:@"本人承诺所提供的信息(包括身份信息、职业信息)真实准确，如有不实，愿意承担相关责任。"]) {
        [self showToastWithText:@"请正确输入承诺文案"];
        return;
    }
    if (!self.imageArr.count) {
        [self showToastWithText:@"请上传职业验证信息图片"];
        return;
    }
    if (!self.zmImage && !(self.verifyModel.front_photo_url.length > 10)) {
        [self showToastWithText:@"请上传身份证正反面照片"];
        return;
    }
    
    if (!self.nameTextField.text.length) {
        [self showToastWithText:@"请输入真实姓名"];
        return;
    }
    if (!self.numTextField.text.length) {
        [self showToastWithText:@"请输入身份证号"];
        return;
    }
    if (![HWToolBox isIdentityCardNumber:self.numTextField.text]) {
        [self showToastWithText:@"请输入正确的身份证号码"];
        return;
    }
    
    if (!self.schoolTextField.text.length) {
        [self showToastWithText:@"请输入行业名称"];
        return;
    }
    if (!self.zyTextField.text.length) {
        [self showToastWithText:@"请输入职位名称"];
        return;
    }

    [self updateImage];

}


- (void)updateImage{
    [self showHUD];
    NSMutableArray *imageDataArr = [[NSMutableArray alloc] init];
    NSMutableArray *pathArr = [[NSMutableArray alloc] init];
    for (UIImage *image in self.imageArr) {
        [imageDataArr addObject:UIImageJPEGRepresentation(image, 0.6)];
        [pathArr addObject:[NSString stringWithFormat:@"%ld_%@.jpg",arc4random()%99999678999,[NoticeTools getFileMD5WithPath:[NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%9999678999]]]];
    }
    NSString *pathMd5 = [NoticeTools arrayToJSONString:pathArr];//多个文件用数组,单个用字符串
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"90" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];
 

    [[XGUploadDateManager sharedManager] uploadMoreWithImageArr:imageDataArr noNeedToast:YES parm:parm progressHandler:^(CGFloat progress) {
      
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (!sussess) {
            [self hideHUD];
           
            [self showToastWithText:@"图片上传失败，请稍后再试"];
        
            return ;
        }else{
       
            self.imageJsonString = Message;
            [self upAlldata];
        }
    }];
}

- (void)upAlldata{
    //下面就可以执行上传
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"2" forKey:@"authentication_type"];
    [parm setObject:self.nameTextField.text forKey:@"real_name"];
    [parm setObject:self.numTextField.text forKey:@"cert_no"];
    [parm setObject:self.schoolTextField.text forKey:@"industry_name"];
    [parm setObject:self.zyTextField.text forKey:@"position_name"];
    [parm setObject:self.imageJsonString forKey:@"career_images"];
    [parm setObject:@"2" forKey:@"action"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/authentication/%@",self.shopId] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (self.upsuccessBlock) {
            self.upsuccessBlock(5);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYSHOP" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)backClick{
    BOOL hasContent = NO;
    if (self.nameTextField.text.length) {
        hasContent = YES;
    }
    if (self.numTextField.text.length) {
        hasContent = YES;
    }
    if ([HWToolBox isIdentityCardNumber:self.numTextField.text]) {
        hasContent = YES;
    }

    if (self.schoolTextField.text.length) {
        hasContent = YES;
    }
    if (self.zyTextField.text.length) {
        hasContent = YES;
    }
    if (hasContent) {
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:nil message:@"确定退出吗？退出后内容不会被保存" sureBtn:@"确定" cancleBtn:@"取消" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        [alerView showXLAlertView];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)upIdentImgClick{
    __weak typeof(self) weakSelf = self;
    SXUpIdentyController *ctl = [[SXUpIdentyController alloc] init];
    ctl.verifyModel = self.verifyModel;
    ctl.shopId = self.shopId;
    ctl.imgBlock = ^(UIImage * _Nonnull zImage, UIImage * _Nonnull fImage) {
        weakSelf.zmImage = zImage;
        weakSelf.fmImage = fImage;
        
        weakSelf.upSFbtn.layer.borderWidth = 0;
        [weakSelf.upSFbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        weakSelf.upSFbtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [weakSelf.upSFbtn setTitle:@"查看图片" forState:UIControlStateNormal];
    };
    ctl.zmImage = self.zmImage;
    ctl.fmImage = self.fmImage;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
   
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
   
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = @"请完整输入以上承诺声明内容";
    }
    
    CGRect frame = textView.frame;
    float height;
    height = [self heightForTextView:textView WithText:textView.text];
    if (height > 60) {
        height = 60;
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        textView.frame = frame;
    } completion:nil];
}



- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}


@end
