//
//  SXKcCardDetailController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcCardDetailController.h"
#import "SXSendWordView.h"
#import "SXStudyBaseController.h"

@interface SXKcCardDetailController ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIView *backview;
@property (nonatomic, strong) NSString *zhufuyu;
@property (nonatomic, strong) UILabel *markL;

@property (nonatomic, strong) UIView *sendIngView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickNameL;
@end

@implementation SXKcCardDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = [[UIView  alloc] initWithFrame:self.tableView.bounds];
    self.tableView.tableHeaderView = self.headerView;
    
    self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-168)/2, 20, 168, 223)];
    [self.coverImageView setAllCorner:2];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    [self.headerView addSubview:self.coverImageView];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.cardModel.searModel.simple_cover_url]];
    
    UIImageView *markImageV = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-218)/2, 224, 218, 56)];
    markImageV.image = UIImageNamed(@"sx_buycardmark_img");
    [self.headerView addSubview:markImageV];
    
    self.contentView = [[UIView  alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.coverImageView.frame)+54, DR_SCREEN_WIDTH-40,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-CGRectGetMaxY(self.coverImageView.frame)-54-30)];
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    [self.headerView addSubview:self.contentView];
    self.contentView.userInteractionEnabled = YES;
    
    self.contentL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15,DR_SCREEN_WIDTH-40-30, 24)];
    self.contentL.font = FIFTHTEENTEXTFONTSIZE;
    
    self.contentL.numberOfLines = 0;
    
    [self.contentView addSubview:self.contentL];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputTap)];
    [self.contentView addGestureRecognizer:tap];
    
 
    if (self.isGet) {
        [self hasGet];
    }else{
        [self isNoGiveing];
        [self isGiviing];
        [self beGet];
    }
}

- (void)isNoGiveing{
    if (self.cardModel.give_status.intValue == 1) {//增送中
        self.sendIngView.hidden = YES;
        self.contentView.hidden = NO;
        self.markL.hidden = YES;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        self.contentL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        NSString *saveWord = [NoticeComTools getInputWithKey:[NSString stringWithFormat:@"cardsendword%@",self.cardModel.cardId]];
        if (saveWord && saveWord.length > 0) {
            [self refshUI:saveWord];
            self.zhufuyu = saveWord;
        }else{
            self.contentL.text = @"添加祝福语";
        }
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
        if (!self.backview) {
            UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
            backView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:backView];
            self.backview = backView;
            
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
                self.backview = backView;
            }
        }
        self.backview.hidden = NO;
  
    }
}

//增送中
- (void)isGiviing{
    if (self.cardModel.give_status.intValue == 2) {
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
        if (!self.sendIngView) {
            UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
            backView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:backView];
            self.sendIngView = backView;
            
            UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(20, 5, DR_SCREEN_WIDTH-40, 40)];
            [button setAllCorner:20];
            button.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
            button.titleLabel.font = SIXTEENTEXTFONTSIZE;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backView addSubview:button];
            [button setTitle:@"取消赠送" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cancelSend) forControlEvents:UIControlEventTouchUpInside];
        }
        self.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.sendIngView.hidden = NO;
        if (!self.markL) {
            self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.coverImageView.frame)+46, DR_SCREEN_WIDTH, 20)];
            self.markL.text = @"此礼品卡赠送中";
            self.markL.font = FOURTHTEENTEXTFONTSIZE;
            self.markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
            self.markL.textAlignment = NSTextAlignmentCenter;
            [self.headerView addSubview:self.markL];
        }
        
        if (!self.cardModel.blessing_text || !self.cardModel.blessing_text.length) {
            self.contentView.hidden = YES;
        }else{
            self.contentView.hidden = NO;
        }
        [self refshUI:self.cardModel.blessing_text];
        self.backview.hidden = YES;
        self.markL.hidden = NO;
    }
 
}

//被领取
- (void)beGet{
    if (self.cardModel.give_status.intValue == 3) {
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        
        self.iconImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-48)/2, CGRectGetMaxY(self.coverImageView.frame)+46, 48, 48)];
        [self.iconImageView setAllCorner:24];
        [self.iconImageView sd_setImageWithURL: [NSURL URLWithString:self.cardModel.getUserInfoM.avatar_url]];
        [self.headerView addSubview:self.iconImageView];
        
        self.nickNameL = [[UILabel  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame)+12, DR_SCREEN_WIDTH, 20)];
        self.nickNameL.text = self.cardModel.getUserInfoM.nick_name;
        self.nickNameL.font = XGFifthBoldFontSize;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.nickNameL.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:self.nickNameL];
        
        self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nickNameL.frame)+12, DR_SCREEN_WIDTH, 20)];
        self.markL.text = @"已领取此礼品卡";
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        self.markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.markL.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:self.markL];
        
        if (!self.cardModel.blessing_text || !self.cardModel.blessing_text.length) {
            self.contentView.hidden = YES;
        }else{
            self.contentView.hidden = NO;
        }
        [self refshUI:self.cardModel.blessing_text];
    }
}

//自己得到的
- (void)hasGet{
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    
    if (!self.cardModel.blessing_text || !self.cardModel.blessing_text.length) {
        self.contentView.hidden = YES;
    }else{
        self.contentView.hidden = NO;
    }
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self refshUI:self.cardModel.blessing_text];
    
    if (!self.sendIngView) {
        UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
        self.sendIngView = backView;
        
        UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(20, 5, DR_SCREEN_WIDTH-40, 40)];
        [button setAllCorner:20];
        button.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backView addSubview:button];
        [button setTitle:@"查看课程" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lookKc) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)lookKc{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",self.cardModel.searModel.seriesId] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            SXPayForVideoModel *searismodel = [SXPayForVideoModel mj_objectWithKeyValues:dict[@"data"]];
            if (!searismodel) {
                return;
            }
  
            SXStudyBaseController *ctl = [[SXStudyBaseController alloc] init];
            ctl.paySearModel = searismodel;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
         
        }
        
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)sendClick:(FSCustomButton *)btn{
    [self showHUD];
    [NoticeComTools removeWithKey:[NSString stringWithFormat:@"cardsendword%@",self.cardModel.cardId]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"2" forKey:@"giveStatus"];
    if (self.zhufuyu) {
        [parm setObject:self.zhufuyu forKey:@"blessingText"];
    }
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"series/gift/card/%@",self.cardModel.cardId] Accept:@"application/vnd.shengxi.v5.8.5+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            if (btn.tag == 0) {
                [NoticeShareView shareWithurl:self.cardModel.share_url type:SSDKPlatformSubTypeWechatSession title:@"Hey！亲爱的朋友这是我的心意" name:self.cardModel.searModel.series_name imageUrl:self.cardModel.searModel.simple_cover_url];
            }else{
                [NoticeShareView shareWithurl:self.cardModel.share_url type:SSDKPlatformSubTypeQQFriend title:@"Hey！亲爱的朋友这是我的心意" name:self.cardModel.searModel.series_name imageUrl:self.cardModel.searModel.simple_cover_url];
            }
            self.cardModel.give_status = @"2";
            if (self.zhufuyu) {
                self.cardModel.blessing_text = self.zhufuyu;
            }
            [self isGiviing];
            self.zhufuyu = nil;
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];

}

- (void)sureNOsend{
    [self showHUD];
    [NoticeComTools removeWithKey:[NSString stringWithFormat:@"cardsendword%@",self.cardModel.cardId]];
    self.contentView.frame = CGRectMake(20, CGRectGetMaxY(self.coverImageView.frame)+54, DR_SCREEN_WIDTH-40,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-CGRectGetMaxY(self.coverImageView.frame)-54-30);
    self.contentL.text = @"添加祝福语";
    self.contentL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.contentL.frame = CGRectMake(15, 15,DR_SCREEN_WIDTH-40-30, 24);
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"1" forKey:@"giveStatus"];
   
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"series/gift/card/%@",self.cardModel.cardId] Accept:@"application/vnd.shengxi.v5.8.5+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
         
            self.cardModel.give_status = @"1";
            self.cardModel.blessing_text = nil;
            [self isNoGiveing];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)cancelSend{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"取消赠送，祝福语将被清除？" message:nil sureBtn:@"再想想" cancleBtn:@"取消赠送" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf sureNOsend];
        }
    };
    [alerView showXLAlertView];

}

- (void)inputTap{
    if (self.cardModel.give_status.intValue != 1) {
        if (self.cardModel.give_status.intValue == 2) {
            [self showToastWithText:@"赠送中不能编辑"];
        }
        return;
    }
    SXSendWordView *wordV = [[SXSendWordView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    wordV.plaStr = @"请输入祝福语";
    if (![self.contentL.text isEqualToString:@"添加祝福语"]) {
        wordV.contentView.text = self.contentL.text;
        [wordV refreshViewHeight];
    }
    wordV.num = 500;
    [wordV showView];
    __weak typeof(self) weakSelf = self;
    wordV.jubaoBlock = ^(NSString * _Nonnull content) {
        [weakSelf showToastWithText:@"保存成功"];
        [NoticeComTools saveInput:content saveKey:[NSString stringWithFormat:@"cardsendword%@",self.cardModel.cardId]];
        [weakSelf refshUI:content];
        weakSelf.zhufuyu = content;
    };
}

- (void)refshUI:(NSString *)content{
    self.contentL.attributedText = [SXTools getStringWithLineHight:3 string:content];
    self.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
    CGFloat height = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-70 string:content isJiacu:NO];
    CGFloat contentHeight = DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-CGRectGetMaxY(self.coverImageView.frame)-54-30;
    self.contentL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-70, height);
    if (height > (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-CGRectGetMaxY(self.coverImageView.frame)-54-30 - 15)) {
        contentHeight = height + 30;
    }
    CGFloat orginY = CGRectGetMaxY(self.coverImageView.frame)+54;
    if (self.cardModel.give_status.intValue == 2) {
        orginY = CGRectGetMaxY(self.coverImageView.frame)+54+30;
    }else if (self.cardModel.give_status.intValue == 3){
        orginY = CGRectGetMaxY(self.markL.frame)+15;
    }
 
    self.contentView.frame = CGRectMake(20, orginY, DR_SCREEN_WIDTH-40,contentHeight);
    self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, CGRectGetMaxY(self.contentView.frame)+15);
    [self.tableView reloadData];
}

@end
