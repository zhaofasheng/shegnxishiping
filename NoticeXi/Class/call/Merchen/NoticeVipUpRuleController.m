//
//  NoticeVipUpRuleController.m
//  NoticeXi
//
//  Created by li lei on 2023/9/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipUpRuleController.h"

@interface NoticeVipUpRuleController ()

@end

@implementation NoticeVipUpRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.navBarView.titleL.text = @"规则说明";
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,DR_SCREEN_WIDTH/375*811)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [backView setAllCorner:20];
    self.tableView.tableHeaderView = backView;
    backView.userInteractionEnabled = YES;
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:backView.bounds];
    imageView2.image = UIImageNamed(@"vipRouteimg4");
    [backView addSubview:imageView2];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
