//
//  SXUpIdentyController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXUpIdentyController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface SXUpIdentyController ()<LCActionSheetDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView *zImageView;
@property (nonatomic, strong) FSCustomButton *zBtn;

@property (nonatomic, strong) UIImageView *fImageView;
@property (nonatomic, strong) FSCustomButton *fBtn;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSString *zmImageString;
@property (nonatomic, strong) NSString *fmImageString;
@property (nonatomic, strong) NSString *bucketId;
@property (nonatomic, assign) BOOL isZM;
@end

@implementation SXUpIdentyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.titleL.text = @"身份验证";
    
    CGFloat imgheight = (DR_SCREEN_WIDTH-30)*210/345;
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-50);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, imgheight*2+24+97)];
    self.tableView.tableHeaderView = headerView;
    
    //头部提示
    UILabel *headlabeL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-15, 25)];
    headlabeL.font = XGEightBoldFontSize;
    headlabeL.textColor = [UIColor colorWithHexString:@"#14151A"];
    headlabeL.text = @"请拍摄/上传本人身份证";
    [headerView addSubview:headlabeL];
    
    UILabel *headlabeL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 53, DR_SCREEN_WIDTH-15, 20)];
    headlabeL1.font = FOURTHTEENTEXTFONTSIZE;
    headlabeL1.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    headlabeL1.text = @"请确保证件信息的完整、清晰，无遮挡";
    [headerView addSubview:headlabeL1];
    
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 97+(imgheight+24)*i, DR_SCREEN_WIDTH-30, imgheight)];
        imageView.userInteractionEnabled = YES;
        [headerView addSubview:imageView];
        
        FSCustomButton *btn = [[FSCustomButton  alloc] initWithFrame:imageView.bounds];
        [btn setImage:UIImageNamed(@"sxpaisfimg_img") forState:UIControlStateNormal];
        btn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [btn setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
        [imageView addSubview:btn];
        btn.space = 10;
        btn.buttonImagePosition = FSCustomButtonImagePositionTop;
        btn.tag = i;
        [btn addTarget:self action:@selector(getimageClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            self.zImageView = imageView;
            self.zBtn = btn;
            if (self.zmImage) {
                self.zImageView.image = self.zmImage;
                [self.zBtn setTitle:@"点击更换图片" forState:UIControlStateNormal];
            }else{
                [self.zImageView sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.front_photo_url] placeholderImage:UIImageNamed(@"sxidentyzm_img")];
                [self.zBtn setTitle:self.verifyModel.front_photo_url.length > 10 ? @"点击更换图片" : @"点击上传人像面" forState:UIControlStateNormal];
            }
        }else{
            self.fImageView = imageView;
            self.fBtn = btn;
            if (self.fmImage) {
                self.fImageView.image = self.fmImage;
                [self.fBtn setTitle:@"点击更换图片" forState:UIControlStateNormal];
            }else{
                [self.fImageView sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.back_photo_url] placeholderImage:UIImageNamed(@"sxidentyfm_img")];
                [self.fBtn setTitle:self.verifyModel.back_photo_url.length > 10?@"点击更换图片" : @"点击上传国徽面" forState:UIControlStateNormal];
            }
        }
    }
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableView.frame)+5, DR_SCREEN_WIDTH-40, 40)];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    [addBtn setAllCorner:20];
    [addBtn setTitle:@"提交" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [addBtn addTarget:self action:@selector(upClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}

- (void)getimageClick:(FSCustomButton *)button{
    self.isZM = button.tag == 0? YES:NO;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[@"拍照",@"相册上传"]];
    sheet.delegate = self;
    [sheet show];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    UIImage *choiceImage = photos[0];
    if (self.isZM) {
        self.zmImage = choiceImage;
        self.zImageView.image = self.zmImage;
        [self.zBtn setTitle:@"点击更换图片" forState:UIControlStateNormal];
    }else{
        self.fmImage = choiceImage;
        self.fImageView.image = self.fmImage;
        [self.fBtn setTitle:@"点击更换图片" forState:UIControlStateNormal];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {

        UIImage *choiceImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (choiceImage) {
            if (self.isZM) {
                self.zmImage = choiceImage;
                self.zImageView.image = self.zmImage;
                [self.zBtn setTitle:@"点击更换图片" forState:UIControlStateNormal];
            }else{
                self.fmImage = choiceImage;
                self.fImageView.image = self.fmImage;
                [self.fBtn setTitle:@"点击更换图片" forState:UIControlStateNormal];
            }
        }
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
        imagePicker.allowCrop = true;
        imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*210/345+30);
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)upClick{
    if (!self.zmImage) {
        [self showToastWithText:@"请上传身份证正面照"];
        return;
    }
    if (!self.fmImage) {
        [self showToastWithText:@"请上传身份证反面照"];
        return;
    }
    
    [self upLoadzm:self.zmImage path:[NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999]];
   
    
  
}


- (void)upLoadzm:(UIImage *)zimage path:(NSString *)path{
    
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    
    [self showHUD];
    //获取七牛token
    NSString *pathMd5 =[NSString stringWithFormat:@"%ld_%@.jpg",arc4random()%999999999678999,[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"90" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:zimage parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
        if (sussess) {
    
            self.zmImageString = errorMessage;
            [self upLoadfm:self.fmImage path:[NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999]];
           
        }else{
            [self showToastWithText:errorMessage];
            [self hideHUD];
        }
    }];
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
            self.fmImageString = errorMessage;
            [self upAllData];
        }else{
            [self showToastWithText:errorMessage];
            [self hideHUD];
        }
    }];
}

- (void)upAllData{
    if (!self.fmImageString || !self.zmImageString) {
        [self hideHUD];
        return;
    }
    
 
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.fmImageString forKey:@"back_photo_url"];
    [parm setObject:self.zmImageString forKey:@"front_photo_url"];
    [parm setObject:@"1" forKey:@"action"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/authentication/%@",self.shopId] Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (self.imgBlock) {
            self.imgBlock(self.zmImage, self.fmImage);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYSHOP" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

@end
