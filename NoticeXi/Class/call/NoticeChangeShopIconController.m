//
//  NoticeChangeShopIconController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeShopIconController.h"
#import "YYImageCoder.h"

@interface NoticeChangeShopIconController ()<TZImagePickerControllerDelegate>

@property (strong, nonatomic)  UIImageView *headeimageView;

@end

@implementation NoticeChangeShopIconController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.hidden = NO;
    self.navBarView.titleL.text = @"店铺头像";
    self.tableView.hidden = YES;
    
    self.headeimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,(DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-DR_SCREEN_WIDTH)/2-30, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
    [self.view addSubview:self.headeimageView];
    [self.headeimageView sd_setImageWithURL:[NSURL URLWithString:self.url]];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(64,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-40-NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH-128, 50);
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [btn setTitle:@"更换店铺头像" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"#1D1E24"];
    [btn setAllCorner:25];
    [btn addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)changeIcon{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.sortAscendingByModificationDate = false;
    imagePicker.allowPickingOriginalPhoto = false;
    imagePicker.alwaysEnableDoneBtn = true;
    imagePicker.allowPickingVideo = false;
    imagePicker.allowPickingGif = false;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePicker.allowCrop = true;
    imagePicker.cropRect = CGRectMake(0, DR_SCREEN_HEIGHT/2-DR_SCREEN_WIDTH/2, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH);
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    UIImage *choiceImage = photos[0];
    PHAsset *asset = assets[0];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        NSString *filePath = contentEditingInput.fullSizeImageURL.absoluteString;
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@-%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%999999999678999];
            [self upLoadHeader:choiceImage path:filePath withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }else{
            [self upLoadHeader:choiceImage path:[filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""] withDate:[outputFormatter stringFromDate:asset.creationDate]];
        }
    }];
}

- (void)upLoadHeader:(UIImage *)image path:(NSString *)path withDate:(NSString *)date{
    if (!path) {
        [YZC_AlertView showViewWithTitleMessage:@"文件不存在"];
        return;
    }
    
    //获取七牛token
    NSString *pathMd5 =[NSString stringWithFormat:@"%ld_%@.jpg",arc4random()%999999999678999,[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"86" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *errorMessage,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:errorMessage forKey:@"avatar_url"];
            
            if (bucketId) {
               [parm setObject:bucketId forKey:@"bucketId"];
            }

    
            [[NoticeTools getTopViewController] showHUD];
            
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",self.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
                [[NoticeTools getTopViewController] hideHUD];
                if (success1) {
                    self.headeimageView.image = image;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
                 
                }
            } fail:^(NSError * _Nullable error) {
                [[NoticeTools getTopViewController] hideHUD];
            }];
           
        }else{
            [self showToastWithText:errorMessage];
            [self hideHUD];
        }
    }];
}

@end
