//
//  NoticeShopRuleController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopRuleController.h"
#import "NoticeOpenTbModel.h"

@interface NoticeShopRuleController ()

@property (nonatomic, strong) UIView *tabHeadView;

@end

@implementation NoticeShopRuleController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.navBarView.titleL.text = @"店铺说明";
    
    UIView *view = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.tableView.tableHeaderView = view;
    self.tabHeadView = view;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.tabHeadView addSubview:imageView];

    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"getShopRule" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
       
        if (success) {
            NoticeOpenTbModel *urlM = [NoticeOpenTbModel mj_objectWithKeyValues:dict[@"data"]];
            SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlM.shopRuleUrl] placeholderImage:nil options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if(image && image.size.width * image.size.height > 0){
                    CGFloat height = DR_SCREEN_WIDTH /image.size.width*image.size.height;
                    
                    self.tabHeadView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, height);
                    imageView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, height);
                    [self.tableView reloadData];
                    
                }
            }];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}



@end
