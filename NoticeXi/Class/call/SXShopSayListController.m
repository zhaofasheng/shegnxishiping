//
//  SXShopSayListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayListController.h"
#import "NoticeTextVoiceController.h"
@interface SXShopSayListController ()
@property (nonatomic, strong) UIView *noListView;
@end

@implementation SXShopSayListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.useSystemeNav = YES;
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    self.tableView.tableHeaderView = self.noListView;
}


- (UIView *)noListView{
    if (!_noListView) {
        _noListView = [[UIView  alloc] initWithFrame:self.tableView.bounds];
        
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(0, (_noListView.frame.size.height-80)/2, DR_SCREEN_WIDTH, 20)];
        label.text = @"还没有动态，发条动态抢占第一";
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [_noListView addSubview:label];
        
        FSCustomButton *button = [[FSCustomButton  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-80)/2, CGRectGetMaxY(label.frame)+24, 80, 36)];
        [button setAllCorner:18];
        button.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        button.titleLabel.font = THRETEENTEXTFONTSIZE;
        [button setTitle:@"发动态" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.buttonImagePosition = FSCustomButtonImagePositionLeft;
        [button setImage:UIImageNamed(@"sxshopsend_img") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [_noListView addSubview:button];
    }
    return _noListView;
}

- (void)sendClick{
    NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
