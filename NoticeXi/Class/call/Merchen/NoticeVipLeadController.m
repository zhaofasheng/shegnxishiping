//
//  NoticeVipLeadController.m
//  NoticeXi
//
//  Created by li lei on 2023/8/30.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipLeadController.h"
#import "NoticeVipUpRouteView.h"
@interface NoticeVipLeadController ()
@property (nonatomic, strong) NoticeVipUpRouteView *routeView;
@end

@implementation NoticeVipLeadController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-50);
    self.tableView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
    
    CGFloat height1 = 12+25+(DR_SCREEN_WIDTH-20)*137/335;
    CGFloat height2 = 204;
    CGFloat height3 = 115+(DR_SCREEN_WIDTH-20)*327/335;
    
    self.routeView = [[NoticeVipUpRouteView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,height1+height2+height3)];
    self.tableView.tableHeaderView = self.routeView;
}




@end
