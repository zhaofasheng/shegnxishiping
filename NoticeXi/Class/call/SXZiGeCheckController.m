//
//  SXZiGeCheckController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXZiGeCheckController.h"
#import "SXUpIdentyController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SXZiGeCheckController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,LCActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImage *zmImage;
@property (nonatomic, strong) UIImage *fmImage;
@property (nonatomic, strong) UIButton *upSFbtn;//上传身份证按钮
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIButton *zhengshuBtn;
@property (nonatomic, strong) UIImageView *zhengshuImageView;
@property (nonatomic, strong) UIImage *zhengshuImage;

@property (nonatomic, strong) UITextField *zyTextField;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *numTextField;

@end

@implementation SXZiGeCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = @"资格证认证";
    
    [self setUI];
}


- (void)setUI{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 228+40+20+111+199)];
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
    
    //资格证信息
    UIView *checkView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(identidyView.frame)+10, DR_SCREEN_WIDTH-30, 111)];
    checkView.backgroundColor = [UIColor whiteColor];
    [checkView setAllCorner:10];
    [self.headerView addSubview:checkView];
    
    UILabel *identTitleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 25)];
    identTitleL1.font = XGEightBoldFontSize;
    identTitleL1.textColor = [UIColor colorWithHexString:@"#14151A"];
    identTitleL1.text = @"资格证信息";
    [checkView addSubview:identTitleL1];
    
    UILabel *idMarkL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 55, GET_STRWIDTH(@"资格证全称", 15, 51), 51)];
    idMarkL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    idMarkL.font = FIFTHTEENTEXTFONTSIZE;
    [checkView addSubview:idMarkL];
    idMarkL.text = @"资格证全称";
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(idMarkL.frame)+10, 55, DR_SCREEN_WIDTH-45-CGRectGetMaxX(idMarkL.frame)-10, 51)];
    [textField setupToolbarToDismissRightButton];
    textField.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    textField.font = FIFTHTEENTEXTFONTSIZE;
    textField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    textField.textColor = [UIColor colorWithHexString:@"#14151A"];
    textField.textAlignment = NSTextAlignmentRight;
    [checkView addSubview:textField];
    textField.delegate = self;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"如：法律职业资格证" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1]}];
    self.zyTextField = textField;
    [checkView addSubview:self.zyTextField];
    
    
    //验证信息
    UIView *realView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(checkView.frame)+10, DR_SCREEN_WIDTH-30, 179)];
    realView.backgroundColor = [UIColor whiteColor];
    [realView setAllCorner:10];
    [self.headerView addSubview:realView];
    
    UILabel *identTitleL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 25)];
    identTitleL2.font = XGEightBoldFontSize;
    identTitleL2.textColor = [UIColor colorWithHexString:@"#14151A"];
    identTitleL2.text = @"资格证验证信息";
    [realView addSubview:identTitleL2];
    
    UILabel *markL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 44, DR_SCREEN_WIDTH-60, 17)];
    markL2.font = TWOTEXTFONTSIZE;
    markL2.numberOfLines = 0;
    markL2.textColor = [UIColor colorWithHexString:@"#168BB3"];
    markL2.text = @"* 请确保证书相关信息、印章清晰可见，无遮挡";
    [realView addSubview:markL2];
    
    UIView *imView = [[UIView  alloc] initWithFrame:CGRectMake(15, 76, DR_SCREEN_WIDTH-60, 88)];
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
    
    //监听键盘将要升起的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘回收的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self hasImageView];
    
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

    [self.nameTextField resignFirstResponder];
    [self.numTextField resignFirstResponder];
    [self.zyTextField resignFirstResponder];
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
  
    if (!self.zyTextField.text.length) {
        [self showToastWithText:@"请输入资格证全称"];
        return;
    }
    if (!self.zhengshuImage) {
        [self showToastWithText:@"请上传资格证相关图片"];
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
    [parm setObject:@"3" forKey:@"authentication_type"];
    [parm setObject:self.nameTextField.text forKey:@"real_name"];
    [parm setObject:self.numTextField.text forKey:@"cert_no"];
    [parm setObject:self.zyTextField.text forKey:@"credentials_name"];
    [parm setObject:imageUrl forKey:@"credentials_img_url"];
    [parm setObject:@"2" forKey:@"action"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/authentication/%@",self.shopId] Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (self.upsuccessBlock) {
            self.upsuccessBlock(3);
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}


@end
