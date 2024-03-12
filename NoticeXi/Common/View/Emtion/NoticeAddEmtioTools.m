//
//  NoticeAddEmtioTools.m
//  NoticeXi
//
//  Created by li lei on 2023/8/22.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAddEmtioTools.h"

@implementation NoticeAddEmtioTools

+ (void)addEmtionWithUri:(NSString *)uri bucktId:(NSString *)bucketId url:(NSString *)url{
    if(uri && uri.length > 6){
        NSMutableDictionary *postParm = [NSMutableDictionary new];
        if (bucketId) {
            [postParm setObject:bucketId?bucketId:@"0" forKey:@"bucketId"];
        }
        [postParm setObject:uri forKey:@"pictureUri"];
        [[NoticeTools getTopViewController] showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/picture",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.7.7+json" isPost:YES parmaer:postParm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                
                [[NoticeTools getTopViewController] showToastWithText:@"已添加"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HASADDNEWEMTION" object:nil];
            }
            [[NoticeTools getTopViewController] hideHUD];
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
    }

}

@end
