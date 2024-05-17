//
//  SXShopOpenTypeView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopOpenTypeView.h"

@implementation SXShopOpenTypeView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 438)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setCornerOnTop:20];
        [self addSubview:self.contentView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-50, 0, 50, 50)];
        [cancelBtn setImage:UIImageNamed(@"sx_blackclose_img") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(sureDissClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
                
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200,50)];
        contentL.font = XGEightBoldFontSize;
        contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        contentL.text = @"请选择营业模式";
        [self.contentView addSubview:contentL];

        self.allView = [[UIView  alloc] initWithFrame:CGRectMake(15, 74, DR_SCREEN_WIDTH-30, 86)];
        self.allView.layer.cornerRadius = 10;
        self.allView.layer.masksToBounds = YES;
        self.allView.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
        self.allView.layer.borderWidth = 2;
        [self.contentView addSubview:self.allView];
        
        self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.allView.frame.size.width-15-20, 15, 20, 20)];
        self.choiceImageView.image = UIImageNamed(@"Image_choicesh");
        [self.allView addSubview:self.choiceImageView];
        self.choiceImageView.userInteractionEnabled = YES;
        
        UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 20, 200, 22)];
        titleL.font = XGSIXBoldFontSize;
        titleL.text = @"不定时营业";
        titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.allView addSubview:titleL];
        
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 54,self.allView.frame.size.width-30, 20)];
        markL.font = THRETEENTEXTFONTSIZE;
        markL.text = @"营业时间不固定，需店主手动营业和手动结束营业";
        markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.allView addSubview:markL];
        
        self.allView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allTap)];
        [self.allView addGestureRecognizer:tap];
        
        self.timeView = [[UIView  alloc] initWithFrame:CGRectMake(15, 180, DR_SCREEN_WIDTH-30, 158)];
        self.timeView.layer.cornerRadius = 10;
        self.timeView.layer.masksToBounds = YES;
        self.timeView.layer.borderColor = [UIColor colorWithHexString:@"#F0F1F5"].CGColor;
        self.timeView.layer.borderWidth = 1;
        [self.contentView addSubview:self.timeView];
        
        self.choiceImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.timeView.frame.size.width-15-20, 15, 20, 20)];
        self.choiceImageView1.image = UIImageNamed(@"Image_nochoicesh");
        self.choiceImageView1.userInteractionEnabled = YES;
        [self.timeView addSubview:self.choiceImageView1];
        
        UILabel *titleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 20, 200, 22)];
        titleL1.font = XGSIXBoldFontSize;
        titleL1.text = @"定时营业";
        titleL1.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.timeView addSubview:titleL1];
        
        UILabel *markL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 54,self.allView.frame.size.width-30, 20)];
        markL1.font = THRETEENTEXTFONTSIZE;
        markL1.text = @"每日固定时间段，店铺自动营业，到时自动结束";
        markL1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.timeView addSubview:markL1];
        
        self.timeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeTap)];
        [self.timeView addGestureRecognizer:tap1];
        
        self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 360, DR_SCREEN_WIDTH-30, 44)];
        self.addButton.layer.cornerRadius = 22;
        self.addButton.layer.masksToBounds = YES;
        self.addButton.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [self.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];

        [self.addButton setTitle:@"保存" forState:UIControlStateNormal];
        self.addButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.addButton];
        [self.addButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *timeChoiceV = [[UIView  alloc] initWithFrame:CGRectMake(15, 94, DR_SCREEN_WIDTH-60, 44)];
        timeChoiceV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [timeChoiceV setAllCorner:10];
        timeChoiceV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTap)];
        [timeChoiceV addGestureRecognizer:tap2];
        [self.timeView addSubview:timeChoiceV];
        
        self.timeL = [[UILabel  alloc] initWithFrame:CGRectMake(10, 0, timeChoiceV.frame.size.width-10-35, 44)];
        self.timeL.font = XGFifthBoldFontSize;
        self.timeL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [timeChoiceV addSubview:self.timeL];
        self.timeL.text = @"营业时间   每天00:00-23:55";
        
        UIImageView *tapImagev = [[UIImageView alloc] initWithFrame:CGRectMake(timeChoiceV.frame.size.width-10-20, 11, 20, 20)];
        tapImagev.image = UIImageNamed(@"sx_choticeopentime");
        tapImagev.userInteractionEnabled = YES;
        [timeChoiceV addSubview:tapImagev];
    }
    return self;
}

- (void)choiceTap{
    if (self.type == 0) {
        [self timeTap];
        return;
    }
    self.openTimeView.startTime = self.startTime;
    self.openTimeView.endTime = self.endTime;
    [self.openTimeView showATView];
}

- (void)saveClick{
    if (self.type == 0) {
        if (self.originType == 0) {//没更改直接回退
            [self cancelClick];
            return;
        }
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"切换为「不定时」，结束时需要手动结束，确定切换吗？" message:nil sureBtn:@"再想想" cancleBtn:@"切换" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf noTime];
            }
        };
        [alerView showXLAlertView];
    }else{
        [[NoticeTools getTopViewController] showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:self.startTime forKey:@"start_time"];
        [parm setObject:self.endTime forKey:@"end_time"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/%@",self.shopModel.myShopM.shopId,self.shopModel.myShopM.operate_status.intValue==3?@"2":self.shopModel.myShopM.operate_status] Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if(success){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"设置成功" message:[NSString stringWithFormat:@"营业时间为「每日%@-%@」\n打开手机通知，以便即时接收营业提示",self.startTime,self.endTime] cancleBtn:@"知道了"];
                [alerView showXLAlertView];
                [self cancelClick];
            }
        } fail:^(NSError * _Nullable error) {
            
        }];
    }
}



- (void)noTime{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/%@",self.shopModel.myShopM.shopId,self.shopModel.myShopM.operate_status.intValue==3?@"2":self.shopModel.myShopM.operate_status] Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
            [[NoticeTools getTopViewController] showToastWithText:@"设置成功"];
            [self cancelClick];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (SXChoiceShopOpenTimeView *)openTimeView{
    if (!_openTimeView) {
        _openTimeView = [[SXChoiceShopOpenTimeView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _openTimeView.choiceTimeBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
            weakSelf.startTime = startTime;
            weakSelf.endTime = endTime;
            weakSelf.timeL.text = [NSString stringWithFormat:@"营业时间  每天%@-%@",weakSelf.startTime,weakSelf.endTime];
        };
    }
    return _openTimeView;
}

- (void)allTap{
    self.type = 0;
    self.allView.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
    self.allView.layer.borderWidth = 2;
    
    self.timeView.layer.borderColor = [UIColor colorWithHexString:@"#F0F1F5"].CGColor;
    self.timeView.layer.borderWidth = 1;
    
    self.choiceImageView.image = UIImageNamed(@"Image_choicesh");
    self.choiceImageView1.image = UIImageNamed(@"Image_nochoicesh");
}

- (void)timeTap{
    self.type = 1;
    self.timeView.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
    self.timeView.layer.borderWidth = 2;
    
    self.allView.layer.borderColor = [UIColor colorWithHexString:@"#F0F1F5"].CGColor;
    self.allView.layer.borderWidth = 1;
    
    self.choiceImageView1.image = UIImageNamed(@"Image_choicesh");
    self.choiceImageView.image = UIImageNamed(@"Image_nochoicesh");
}

- (void)showATView{

    if (self.shopModel.myShopM.is_timing.boolValue) {//当前是定时营业模式
        [self timeTap];

    }else{
        [self allTap];
    }
    if (!self.shopModel.myShopM.start_time) {
        self.startTime = @"00:00";
        self.endTime = @"23:55";
    }else{
        self.startTime = self.shopModel.myShopM.start_time;
        self.endTime = self.shopModel.myShopM.end_time;
    }
    self.timeL.text = [NSString stringWithFormat:@"营业时间  每天%@-%@",self.startTime,self.endTime];
    self.originType = self.shopModel.myShopM.is_timing.boolValue?1:0;
    
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.contentView.frame.size.height, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    }];
}

- (void)cancelClick{

    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureDissClick{
    if (self.originType == self.type) {
        [self cancelClick];
    }else{
        __weak typeof(self) weakSelf = self;
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NSString stringWithFormat:@"模式已切换为「%@」，是否保存设置？",self.type==1?@"定时营业":@"不定时营业"] message:nil sureBtn:@"不保存" cancleBtn:@"保存" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf saveClick];
            }else{
                [weakSelf cancelClick];
            }
        };
        [alerView showXLAlertView];
    }
}

@end
