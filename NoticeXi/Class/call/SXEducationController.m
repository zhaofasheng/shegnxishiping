//
//  SXEducationController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXEducationController.h"
#import "SXUpIdentyController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SXChoiceEdcutionView.h"

@interface SXEducationController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,LCActionSheetDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImage *zmImage;
@property (nonatomic, strong) UIImage *fmImage;
@property (nonatomic, strong) UIButton *upSFbtn;//上传身份证按钮
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIButton *zhengshuBtn;
@property (nonatomic, strong) UIImageView *zhengshuImageView;
@property (nonatomic, strong) UIImage *zhengshuImage;
@property (nonatomic, strong) UILabel *edcL;
@property (nonatomic, strong) NSString *edcString;
@property (nonatomic, strong) SXChoiceEdcutionView *eduChoiceView;
@property (nonatomic, strong) UITextField *schoolTextField;
@property (nonatomic, strong) UITextField *zyTextField;
@property (nonatomic, strong) NSString *edcStringType;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *numTextField;
@end

@implementation SXEducationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.titleL.text = @"学历认证";
    [self setUI];
}


- (void)setUI{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 707)];
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
    UIView *checkView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(identidyView.frame)+10, DR_SCREEN_WIDTH-30, 213)];
    checkView.backgroundColor = [UIColor whiteColor];
    [checkView setAllCorner:10];
    [self.headerView addSubview:checkView];
    
    UILabel *identTitleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 25)];
    identTitleL1.font = XGEightBoldFontSize;
    identTitleL1.textColor = [UIColor colorWithHexString:@"#14151A"];
    identTitleL1.text = @"认证信息";
    [checkView addSubview:identTitleL1];
    
    NSArray *plaArr1 = @[@"请填写学校全称",@"如：哲学、法学、社会学"];
    for (int i = 0; i < 3; i++) {
        UILabel *idMarkL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 55+51*i, labelWidth, 51)];
        idMarkL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        idMarkL.font = FIFTHTEENTEXTFONTSIZE;
        [checkView addSubview:idMarkL];
        if (i == 0) {
            idMarkL.text = @"学历";
        }else if (i == 1)
            idMarkL.text = @"学校全称";
        else{
            idMarkL.text = @"专业名称";
        }
        if (i < 2) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(idMarkL.frame)+10, 106+51*i, DR_SCREEN_WIDTH-45-CGRectGetMaxX(idMarkL.frame)-10, 51)];
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
       
    }
    
    self.edcL = [[UILabel  alloc] initWithFrame:CGRectMake(15+labelWidth, 55, checkView.frame.size.width-30-16-labelWidth, 51)];
    self.edcL.font = FIFTHTEENTEXTFONTSIZE;
    self.edcL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.edcL.text = @"请选择";
    self.edcL.textAlignment = NSTextAlignmentRight;
    [checkView addSubview:self.edcL];
    self.edcL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceEdc)];
    [self.edcL addGestureRecognizer:tap1];
    
    UIImageView *choiceEduImg = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.edcL.frame), 73, 16, 16)];
    choiceEduImg.image = UIImageNamed(@"cellnextbutton");
    [checkView addSubview:choiceEduImg];
    choiceEduImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceEdc)];
    [choiceEduImg addGestureRecognizer:tap2];
    
    //验证信息
    UIView *realView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(checkView.frame)+10, DR_SCREEN_WIDTH-30, 196)];
    realView.backgroundColor = [UIColor whiteColor];
    [realView setAllCorner:10];
    [self.headerView addSubview:realView];
    
    UILabel *identTitleL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 25)];
    identTitleL2.font = XGEightBoldFontSize;
    identTitleL2.textColor = [UIColor colorWithHexString:@"#14151A"];
    identTitleL2.text = @"学历验证信息";
    [realView addSubview:identTitleL2];
    
    CGFloat height = [SXTools getHeightWithLineHight:3 font:12 width:DR_SCREEN_WIDTH-60 string:@"* 校园卡、学生证、录取通知书、毕业证(任选其一)\n* 请确保相关信息、印章清晰可见，无遮挡" isJiacu:NO];
    UILabel *markL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 44, DR_SCREEN_WIDTH-60, height)];
    markL2.font = TWOTEXTFONTSIZE;
    markL2.numberOfLines = 0;
    markL2.textColor = [UIColor colorWithHexString:@"#168BB3"];
    markL2.attributedText = [SXTools getStringWithLineHight:3 string:@"* 校园卡、学生证、录取通知书、毕业证(任选其一)\n* 请确保相关信息、印章清晰可见，无遮挡"];
    [realView addSubview:markL2];
    
    UIView *imView = [[UIView  alloc] initWithFrame:CGRectMake(15, 93, DR_SCREEN_WIDTH-60, 88)];
    imView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [imView setAllCorner:8];
    [realView addSubview:imView];

    self.zhengshuBtn = [[UIButton  alloc] initWithFrame:CGRectMake((sfView.frame.size.width-118)/2, 28, 118, 32)];
    self.zhengshuBtn.layer.cornerRadius = 16;
    self.zhengshuBtn.layer.masksToBounds = YES;
    self.zhengshuBtn.layer.borderWidth = 1;
    self.zhengshuBtn.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
    [self.zhengshuBtn setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    [self.zhengshuBtn setTitle:@"去上传原件图片" forState:UIControlStateNormal];
    self.zhengshuBtn.titleLabel.font = TWOTEXTFONTSIZE;
    [imView addSubview:self.zhengshuBtn];
    [self.zhengshuBtn addTarget:self action:@selector(upyuanjianImgClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.zhengshuImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 91, 68)];
    self.zhengshuImageView.userInteractionEnabled = YES;
    [imView addSubview:self.zhengshuImageView];
    [self.zhengshuImageView setAllCorner:2];
    self.zhengshuImageView.hidden = YES;
    
    UIButton *reChoiceBtn = [[UIButton  alloc] initWithFrame:CGRectMake(67, 4, 20, 20)];
    [reChoiceBtn setImage:UIImageNamed(@"sxrechoicezj_img") forState:UIControlStateNormal];
    [self.zhengshuImageView addSubview:reChoiceBtn];
    [reChoiceBtn addTarget:self action:@selector(deleteImgClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableView.frame)+5, DR_SCREEN_WIDTH-40, 40)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    [addBtn setAllCorner:20];
    [addBtn setTitle:@"提交认证" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [addBtn addTarget:self action:@selector(upClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    [self hasImageView];
    
    //监听键盘将要升起的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘回收的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self refreshData];
}

- (void)refreshData{
    if (self.isCheckFail || self.isUpdate) {
        self.nameTextField.text = self.verifyModel.real_name;
        self.numTextField.text = self.verifyModel.cert_no;
        self.edcL.text = self.verifyModel.education_option.intValue == 1?@"本科在读":self.verifyModel.education_optionName;
        self.edcString = self.edcL.text;
        self.edcStringType = self.verifyModel.education_option;
        self.schoolTextField.text = self.verifyModel.school_name;
        self.zyTextField.text = self.verifyModel.speciality_name;
        self.edcL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.edcL.font = XGFifthBoldFontSize;
        [self.zhengshuImageView sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.education_img_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                self.zhengshuBtn.hidden = YES;
                self.zhengshuImage = image;
                self.zhengshuImageView.image = image;
                self.zhengshuImageView.hidden = NO;
            }
        
        }];
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
}

- (void)deleteImgClick{
    self.zhengshuImage = nil;
    self.zhengshuImageView.hidden = YES;
    self.zhengshuBtn.hidden = NO;
}

//上传原件
- (void)upyuanjianImgClick{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[@"拍照",@"相册上传"]];
    sheet.delegate = self;
    [sheet show];
}

//选择学历
- (void)choiceEdc{
    self.eduChoiceView.currenEdc = self.edcString;
    [self.eduChoiceView show];
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
    if (self.edcString) {
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
    ctl.imgBlock = ^(UIImage * _Nonnull zImage, UIImage * _Nonnull fImage) {
        weakSelf.zmImage = zImage;
        weakSelf.fmImage = fImage;
        
        weakSelf.upSFbtn.layer.borderWidth = 0;
        [weakSelf.upSFbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        weakSelf.upSFbtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [weakSelf.upSFbtn setTitle:@"查看图片" forState:UIControlStateNormal];
    };
    ctl.verifyModel = self.verifyModel;
    ctl.shopId = self.shopId;
    ctl.zmImage = self.zmImage;
    ctl.fmImage = self.fmImage;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)hasImageView{
    if (self.verifyModel.front_photo_url.length > 10 && self.verifyModel.back_photo_url.length > 10) {
        self.upSFbtn.layer.borderWidth = 0;
        [self.upSFbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.upSFbtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.upSFbtn setTitle:@"查看图片" forState:UIControlStateNormal];
    }
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
    self.zhengshuBtn.hidden = YES;
    self.zhengshuImage = choiceImage;
    self.zhengshuImageView.image = choiceImage;
    self.zhengshuImageView.hidden = NO;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {

        UIImage *choiceImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (choiceImage) {
            self.zhengshuBtn.hidden = YES;
            self.zhengshuImage = choiceImage;
            self.zhengshuImageView.image = choiceImage;
            self.zhengshuImageView.hidden = NO;
        }
    }
}


//提交
- (void)upClick{
    
    
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
    if (!self.edcString) {
        [self showToastWithText:@"请选择学历"];
        return;
    }
    if (!self.schoolTextField.text.length) {
        [self showToastWithText:@"请输入学校全名"];
        return;
    }
    if (!self.zyTextField.text.length) {
        [self showToastWithText:@"请输入专业名称"];
        return;
    }
    if (!self.zhengshuImage) {
        [self showToastWithText:@"请上传 校园卡、学生证、录取通知书、毕业证(任选其一)"];
        return;
    }
    
    //下面就可以执行上传
    [self upLoadfm:self.zhengshuImage path:[NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999]];
}


- (void)upLoadfm:(UIImage *)fimage path:(NSString *)path{
    
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    //获取七牛token
    NSString *pathMd5 =[NSString stringWithFormat:@"%ld_%@.jpg",arc4random()%999999999678999,[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"90" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:fimage parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            [self upAllData:errorMessage];
        }else{
            [self showToastWithText:errorMessage];
            [self hideHUD];
        }
    }];
}

- (void)upAllData:(NSString *)imageUrl{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"1" forKey:@"authentication_type"];
    [parm setObject:self.nameTextField.text forKey:@"real_name"];
    [parm setObject:self.numTextField.text forKey:@"cert_no"];
    [parm setObject:self.edcStringType forKey:@"education_option"];
    [parm setObject:self.schoolTextField.text forKey:@"school_name"];
    [parm setObject:self.zyTextField.text forKey:@"speciality_name"];
    [parm setObject:imageUrl forKey:@"education_img_url"];
    [parm setObject:@"2" forKey:@"action"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/authentication/%@",self.shopId] Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (self.upsuccessBlock) {
            self.upsuccessBlock(1);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYSHOP" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (SXChoiceEdcutionView *)eduChoiceView{
    if (!_eduChoiceView) {
        _eduChoiceView = [[SXChoiceEdcutionView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _eduChoiceView.edcBlock = ^(NSString * _Nonnull edc,NSInteger edcType) {
            weakSelf.edcL.text = edc;

            weakSelf.edcString = edc;
            weakSelf.edcStringType = [NSString stringWithFormat:@"%ld",edcType];
            weakSelf.edcL.textColor = [UIColor colorWithHexString:@"#14151A"];
            weakSelf.edcL.font = XGFifthBoldFontSize;
        };
    }
    return _eduChoiceView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

@end
