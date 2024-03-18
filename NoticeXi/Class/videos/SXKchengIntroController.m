//
//  SXKchengIntroController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKchengIntroController.h"

@interface SXKchengIntroController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIImageView *introImageView;
@end

@implementation SXKchengIntroController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.hidden = YES;
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-(self.paySearModel.is_bought.boolValue?0:TAB_BAR_HEIGHT));
    
    self.introImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.tableView.tableHeaderView = self.introImageView;
    [self.introImageView sd_setImageWithURL:[NSURL URLWithString:self.paySearModel.introduce_img_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            if (image.size.height) {
                self.introImageView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/image.size.width*image.size.height);
                [self.tableView reloadData];
            }
        }
    }];

    [self.tableView reloadData];
}

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}


@end
