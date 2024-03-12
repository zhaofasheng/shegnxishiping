//
//  NoticeDownLoadBokeModel.m
//  NoticeXi
//
//  Created by li lei on 2023/12/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeDownLoadBokeModel.h"
#import "DownloadAudioService.h"
@implementation NoticeDownLoadBokeModel

- (void)downBoKeToPhone:(BOOL)toIphone boke:(NoticeDanMuModel *)bokeModel{

    
    [DownloadAudioService downloadProgressAudioWithUrl:bokeModel.audio_url                   saveDirectoryPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject]
                 fileName:[NSString stringWithFormat:@"%@.%@",bokeModel.podcast_title,[bokeModel.audio_url pathExtension]]
                                              
    progress:^(CGFloat progress) {
        if(toIphone){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NoticeTools getTopViewController] showHUDWithText:[NSString stringWithFormat:@"下载中%.2f%%",progress]];
            });
        }
   
    } finish:^(NSString * _Nonnull filePath) {
        if(toIphone){
            [[NoticeTools getTopViewController] hideHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveFileToPhone:filePath];
            });
        }
    } failed:^{
        [[NoticeTools getTopViewController] showToastWithText:@"播客下载，请稍后重试"];
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

-(void)presentDocumentCloud {
   NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
   
   UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
   documentPickerViewController.delegate = self;
   [[NoticeTools getTopViewController] presentViewController:documentPickerViewController animated:YES completion:nil];
}

//保存文件到手机文件指定目录
- (void)saveFileToPhone:(NSString *)filePath{
    self.isDownLoad = YES;
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithURL:[NSURL fileURLWithPath:filePath] inMode:UIDocumentPickerModeExportToService];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [[NoticeTools getTopViewController] presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - UIDocumentInteractionControllerDelegate
-(UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller{
    return [NoticeTools getTopViewController];
}

-(UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return [NoticeTools getTopViewController].view;
}

-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return [NoticeTools getTopViewController].view.frame;
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls {
    if(!self.isDownLoad){
        return;
    }
    self.isDownLoad = NO;
    [[NoticeTools getTopViewController] showToastWithText:@"保存成功"];
 //   [self presentDocumentCloud];
     //保存成功
}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
    if(!self.isDownLoad){
        return;
    }
    self.isDownLoad = NO;
    [[NoticeTools getTopViewController] showToastWithText:@"保存失败"];
     //取消保存
}


@end
