//
//  SXKcCardDetailController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcCardDetailController.h"
#import "SXSendWordView.h"
@interface SXKcCardDetailController ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentL;
@end

@implementation SXKcCardDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    self.headerView = [[UIView  alloc] initWithFrame:self.tableView.bounds];
    self.tableView.tableHeaderView = self.headerView;
    
    self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-168)/2, 20, 168, 223)];
    [self.coverImageView setAllCorner:2];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    [self.headerView addSubview:self.coverImageView];
    self.coverImageView.backgroundColor = [UIColor blueColor];
    
    UIImageView *markImageV = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-218)/2, 224, 218, 56)];
    markImageV.image = UIImageNamed(@"sx_buycardmark_img");
    [self.headerView addSubview:markImageV];
    
    self.contentView = [[UIView  alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.coverImageView.frame)+54, DR_SCREEN_WIDTH-40,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-CGRectGetMaxY(self.coverImageView.frame)-54-30)];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    [self.headerView addSubview:self.contentView];
    self.contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputTap)];
    [self.contentView addGestureRecognizer:tap];
    
    self.contentL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15,DR_SCREEN_WIDTH-40-30, 0)];
    self.contentL.font = FIFTHTEENTEXTFONTSIZE;
    self.contentL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.contentL.numberOfLines = 0;
    self.contentL.text = @"添加祝福语";
    [self.contentView addSubview:self.contentL];
    
    self.contentL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-70, [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-70 string:self.contentL.text isJiacu:NO]);
    
    UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    CGFloat width = (DR_SCREEN_WIDTH-40-15)/2;
    for (int i = 0; i < 2; i++) {
        FSCustomButton *button = [[FSCustomButton  alloc] initWithFrame:CGRectMake(20+(width+15)*i, 5, width, 40)];
        [button setAllCorner:20];
        button.backgroundColor = [UIColor colorWithHexString:i==0?@"#09BB07":@"#4897FF"];
        button.titleLabel.font = XGSIXBoldFontSize;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:i==0?@"赠送微信好友":@"赠送QQ好友" forState:UIControlStateNormal];
        [button setImage:UIImageNamed(i==0?@"sx_sendwx_img":@"sx_sendqq_img") forState:UIControlStateNormal];
        button.buttonImagePosition = FSCustomButtonImagePositionLeft;
        button.tag = i;
        [button addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }
}

- (void)sendClick:(FSCustomButton *)btn{
    if (btn.tag == 0) {
        
    }else{
        
    }
}

- (void)inputTap{
    SXSendWordView *wordV = [[SXSendWordView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    wordV.plaStr = @"请输入祝福语";
    wordV.num = 500;
    wordV.titleL.text = @"我的故事";
    [wordV showView];
    __weak typeof(self) weakSelf = self;
    wordV.jubaoBlock = ^(NSString * _Nonnull content) {
        weakSelf.contentL.attributedText = [SXTools getStringWithLineHight:3 string:content];
        weakSelf.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        CGFloat height = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-70 string:content isJiacu:NO];
        CGFloat contentHeight = DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-CGRectGetMaxY(self.coverImageView.frame)-54-30;
        weakSelf.contentL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-70, height);
        if (height > (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-CGRectGetMaxY(self.coverImageView.frame)-54-30 - 15)) {
            contentHeight = height + 30;
        }
        weakSelf.contentView.frame = CGRectMake(20, CGRectGetMaxY(self.coverImageView.frame)+54, DR_SCREEN_WIDTH-40,contentHeight);
        weakSelf.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, weakSelf.contentView.frame.origin.y+weakSelf.contentView.frame.size.height+15);
        [weakSelf.tableView reloadData];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:content forKey:@"tale"];
       // [[NoticeTools getTopViewController] showHUD];
        
//        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",weakSelf.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
//            [[NoticeTools getTopViewController] hideHUD];
//
//        } fail:^(NSError * _Nullable error) {
//            [strongBlock removeFromSuperview];
//            [strongBlock cancelClick];
//            [[NoticeTools getTopViewController] hideHUD];
//        }];
    };
}


@end
