//
//  NoticePhoneChatView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticePhoneChatView.h"
#import "NoticeMyJieYouShopController.h"
#import "NoticeXi-Swift.h"
#import "NoticeAddSellMerchantController.h"
#import "NoticeMyWallectModel.h"
#import "NoticeShopRainCallController.h"
@implementation NoticePhoneChatView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        //pinkback_img  greenback_img Image_lyup  eyes_img  changlr_img
        
        UIImageView *pinkimage = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-330)/3, 0, 120, 72)];
        pinkimage.image = UIImageNamed(@"pinkback_img");
        [self addSubview:pinkimage];
        pinkimage.userInteractionEnabled = YES;
        
        UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(16, 12, 100, 18)];
        titleL.font = THRETEENTEXTFONTSIZE;
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        titleL.text = @"当前模式：";
        [pinkimage addSubview:titleL];
        
        UIView *changeView = [[UIView  alloc] initWithFrame:CGRectMake(0, 34, 120, 22)];
        changeView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        changeView.userInteractionEnabled = YES;
        [pinkimage addSubview:changeView];
        
        self.isCallPhone = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeStyleTap)];
        [changeView addGestureRecognizer:tap];
        
        self.changeStyleL = [[UILabel  alloc] initWithFrame:CGRectMake(16, 0, 104, 22)];
        self.changeStyleL.font = XGSIXBoldFontSize;
        self.changeStyleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.changeStyleL.text = @"语音聊天";
        [changeView addSubview:self.changeStyleL];
        self.changeStyleL.userInteractionEnabled = YES;
        
        UIImageView *changeimage = [[UIImageView  alloc] initWithFrame:CGRectMake(120-15-20,1, 20, 20)];
        changeimage.image = UIImageNamed(@"changlr_img");
        changeimage.userInteractionEnabled = YES;
        [changeView addSubview:changeimage];
        
        UIImageView *greenimage = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-330)/3+CGRectGetMaxX(pinkimage.frame), 0, 210, 72)];
        greenimage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rainCallTap)];
        [greenimage addGestureRecognizer:tapg];
        greenimage.image = UIImageNamed(@"greenback_img");
        [self addSubview:greenimage];
        
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 37, 210-15, 22)];
        markL.font = XGSIXBoldFontSize;
        markL.textColor = [UIColor colorWithHexString:@"#25262E"];
        
        NSString *str1 = @"流星电话";
        NSString *str2 = @"听从时间的安排";
        NSString *allStr = [NSString stringWithFormat:@"%@%@",str1,str2];
        markL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#25262E"] setSize:12 setLengthString:str2 beginSize:str1.length];
        [greenimage addSubview:markL];
        
        // 画圆弧
        CGFloat kViewHeight = 65;
        UIView *showView = [[UIView alloc] initWithFrame:(CGRectMake(0,24+72, self.frame.size.width, kViewHeight))];
        showView.backgroundColor = UIColor.clearColor;
        [self addSubview:showView];
        
        CGFloat kRadian = 20;
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(0, kRadian)];
        [bezierPath addQuadCurveToPoint:CGPointMake(self.frame.size.width, kRadian) controlPoint:CGPointMake(self.frame.size.width/2, -kRadian)];
        [bezierPath addLineToPoint: CGPointMake(self.frame.size.width, showView.frame.size.height)];
        [bezierPath addLineToPoint: CGPointMake(0, showView.frame.size.height)];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        layer.strokeColor = UIColor.clearColor.CGColor;
        layer.fillColor = UIColor.whiteColor.CGColor;
        layer.cornerRadius = 3.0;
        layer.masksToBounds = NO;
        layer.shadowOffset = CGSizeMake(-5, -5); //(0,0)时是四周都有阴影
        layer.shadowColor = [UIColor grayColor].CGColor;
        layer.shadowOpacity = 0.1;
        [showView.layer addSublayer:layer];
        
        self.scrollView = [[UIScrollView  alloc] initWithFrame:CGRectMake(0, 158, DR_SCREEN_WIDTH, self.frame.size.height-158)];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH, 203+104);
        [self addSubview:self.scrollView];
        
        UILabel *title1L = [[UILabel  alloc] initWithFrame:CGRectMake(0, 38+70,DR_SCREEN_WIDTH, 32)];
        title1L.font = XGFifthBoldFontSize;
        title1L.textColor = [UIColor colorWithHexString:@"#000000"];
        title1L.text = @"我的店铺营业中";
        title1L.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title1L];
        self.shopStatusL = title1L;
        
        CGFloat shopStatusWidth = GET_STRWIDTH(self.shopStatusL.text, 16, 32);
        self.leftImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-shopStatusWidth)/2-49, 38+70, 44, 32)];
        self.leftImageView.image = UIImageNamed(@"eyes_img");
        self.leftImageView.userInteractionEnabled = YES;
        [self addSubview:self.leftImageView];
        
        self.rightImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-shopStatusWidth)/2+shopStatusWidth+5, 70+38+8, 16, 16)];
        self.rightImageView.userInteractionEnabled = YES;
        self.rightImageView.image = UIImageNamed(@"Image_lyup");
        [self addSubview:self.rightImageView];
        
        UIView *tapView = [[UIView  alloc] initWithFrame:CGRectMake(0, 24+72, DR_SCREEN_WIDTH,62)];
        tapView.userInteractionEnabled = YES;
        tapView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self addSubview:tapView];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upTap)];
        [tapView addGestureRecognizer:tap1];
        
        self.isOpen = NO;
        
        // 添加滑动手势
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGesture.delegate = self;
        [self addGestureRecognizer:self.panGesture];
        
        
        self.severView = [[NoticeShopContentView  alloc] initWithFrame:CGRectMake(15, 119, (DR_SCREEN_WIDTH-45)/2, 100)];
        self.severView.type = 1;
        [self.scrollView addSubview:self.severView];
        
        self.hasBuyView = [[NoticeShopContentView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.severView.frame)+15, 119, (DR_SCREEN_WIDTH-45)/2, 100)];
        self.hasBuyView.type = 2;
        [self.scrollView addSubview:self.hasBuyView];
        
        self.wallectView = [[NoticeShopContentView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.severView.frame)+15, (DR_SCREEN_WIDTH-45)/2, 100)];
        self.wallectView.type = 3;
        [self.scrollView addSubview:self.wallectView];
        
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
        if(userM.comeHereDays.integerValue < 100 || userM.mobile.integerValue < 10000){
            [self canNotSupply];
        }else{
            [self getStatusRequest];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestGoods) name:@"REFRESHGOODS" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopRequest) name:@"REFRESHMYWALLECT" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStatusRequest) name:@"HASSUPPLYSHOPNOTICE" object:nil];
        
    }
    return self;
}

- (void)rainCallTap{
    NoticeShopRainCallController *ctl = [[NoticeShopRainCallController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)refresTitle:(NSString *)title imageName:(NSString *)imageName{
    
    self.shopStatusL.text = title;
    
    CGFloat shopStatusWidth = GET_STRWIDTH(self.shopStatusL.text, 16, 32);
    self.leftImageView.image = UIImageNamed(imageName);
    self.leftImageView.frame = CGRectMake((DR_SCREEN_WIDTH-shopStatusWidth)/2-49, 38+70, 44, 32);
    self.rightImageView.frame = CGRectMake((DR_SCREEN_WIDTH-shopStatusWidth)/2+shopStatusWidth+5, 70+38+8, 16, 16);
}

//不满足条件不能申请店铺
- (void)canNotSupply{
    self.noShopView.hidden = NO;
    _shopStatusView.hidden = YES;
    self.noShopView.suppleyButton.hidden = YES;
    self.noShopView.titleL.hidden = NO;
    self.noShopView.titleL.text = @"申请店铺需满足“来声昔100天、绑定手机号”";
    [self refresTitle:@"我的店铺" imageName:@"eyes_imgno"];
}

- (void)refreshShopStatus{
    if (!self.applyModel || self.applyModel.status != 6) {
        [self getStatusRequest];
    }
}

//获取是否申请了店铺
- (void)getStatusRequest{
    NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
    if (userInfo.comeHereDays.intValue < 100 || userInfo.mobile.intValue < 1000) {
        [self getwallect];
        self.noShopView.hidden = NO;
        _shopStatusView.hidden = YES;
        self.noShopView.titleL.hidden = NO;
        self.noShopView.suppleyButton.hidden = YES;
        [self refresTitle:@"我的店铺" imageName:@"eyes_imgno"];
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/getApplyStage" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {

        if(success){
            self.applyModel = [NoticeCureentShopStatusModel mj_objectWithKeyValues:dict[@"data"]];
            
            if(self.applyModel.status < 4 || self.applyModel.status == 5){//1未实名 2未绑定提现方式 3未设置店名 4待审核 5审核失败 6审核通过
                //没有申请店铺，或者店铺审核失败，申请店铺
                [self getwallect];
                self.noShopView.hidden = NO;
                _shopStatusView.hidden = YES;
                self.noShopView.titleL.hidden = YES;
                self.noShopView.suppleyButton.hidden = NO;
                [self.noShopView.suppleyButton setTitle:@"申请开通店铺" forState:UIControlStateNormal];
                [self.noShopView.suppleyButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
                self.noShopView.suppleyButton.backgroundColor = [UIColor colorWithHexString:@"#00ABE4"];
                [self refresTitle:@"我的店铺" imageName:@"eyes_imgno"];
            }else if (self.applyModel.status == 4) {
                [self getwallect];
                self.noShopView.hidden = NO;
                _shopStatusView.hidden = YES;
                self.noShopView.titleL.hidden = YES;
                self.noShopView.suppleyButton.hidden = NO;
                [self.noShopView.suppleyButton setTitle:@"等待审核" forState:UIControlStateNormal];
                [self.noShopView.suppleyButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
                self.noShopView.suppleyButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
                [self refresTitle:@"我的店铺" imageName:@"eyes_imgno"];
            }else if (self.applyModel.status == 6) {
                _noShopView.hidden = YES;
                self.shopStatusView.hidden = NO;
                [self getShopRequest];
            }
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] showToastWithText:error.debugDescription];
    }];
}

//获取店铺信息
- (void)getShopRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/ByUser" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.shopModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            
            [self requestGoods];
            [self refresButton];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
        [[NoticeTools getTopViewController] showToastWithText:error.debugDescription];
    }];
    
    [self getwallect];
}

- (void)getwallect{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"wallet" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            NoticeMyWallectModel *wallectM = [NoticeMyWallectModel mj_objectWithKeyValues:dict[@"data"]];
            self.hasBuyView.dataL.text = wallectM.buy_order_num.intValue?wallectM.buy_order_num:@"0";
            NSString *allMoney = wallectM.total_balance.floatValue>0?wallectM.total_balance:@"0";
            NSString *titstr = @"鲸币";
            self.wallectView.dataL.attributedText = [DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"%@%@",allMoney,titstr] setColor:[UIColor colorWithHexString:@"#25262E"] setSize:12 setLengthString:titstr beginSize:allMoney.length];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)upTap{
    self.isOpen = !self.isOpen;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.isOpen) {
            self.rightImageView.transform =  CGAffineTransformMakeRotation(-M_PI);
            self.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+30, DR_SCREEN_WIDTH, self.frame.size.height);
        }else{
            self.rightImageView.transform =  CGAffineTransformMakeRotation(0);
            self.frame = CGRectMake(0,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-158, DR_SCREEN_WIDTH, self.frame.size.height);
        }
   
    } completion:^(BOOL finished) {
    }];
}

- (void)changeStyleTap{
    self.isCallPhone = !self.isCallPhone;
    self.changeStyleL.text = self.isCallPhone?@"语音聊天":@"文字聊天";
    if (self.changeStyleBlock) {
        self.changeStyleBlock(self.isCallPhone);
    }
}

//店铺被暂停营业时候的点击
- (void)stopGetStatusTap{
    
}

- (void)refresButton{
    if(self.shopModel.myShopM.is_stop.integerValue > 0){
        if(self.shopModel.myShopM.is_stop.integerValue == 1){//店铺被永久关停
            self.shopStatusView.startGetOrderBtn.hidden = YES;
            self.shopStatusView.stopGetView.hidden = NO;
            self.shopStatusView.stop1L.text = @"店铺已被\n永久关闭";
            [self refresTitle:@"我的店铺" imageName:@"eyes_imgno"];
        }else{
            self.shopStatusView.startGetOrderBtn.hidden = YES;
            self.shopStatusView.stopGetView.hidden = NO;
            self.shopStatusView.stop1L.text = [NSString stringWithFormat:@"暂停营业中\n%@",[NoticeTools getDaoishi:self.shopModel.myShopM.is_stop]];
            [self refresTitle:@"我的店铺" imageName:@"eyes_imgno"];
        }
    }
    else{
        if (!self.shopModel.myShopM.role.intValue) {//如果没有角色，自动设置一个角色
            [self autoSetRole];
        }
        if(self.shopModel.myShopM.operate_status.integerValue == 2){
            [self.shopStatusView.startGetOrderBtn setTitle:@"结束营业" forState:UIControlStateNormal];
            self.shopStatusView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FE827E"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#D84022"].CGColor];
            [self refresTitle:@"我的店铺营业中" imageName:@"eyes_img"];
        }else if (!self.sellGoodsArr.count){
            [self refresTitle:@"我的店铺休息中" imageName:@"eyes_imgno"];
            [self.shopStatusView.startGetOrderBtn setTitle:@"添加商品" forState:UIControlStateNormal];
            self.shopStatusView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#25262E"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#25262E"].CGColor];
        }else if (self.shopModel.myShopM.operate_status.integerValue == 1){
            [self refresTitle:@"我的店铺休息中" imageName:@"eyes_imgno"];
            [self.shopStatusView.startGetOrderBtn setTitle:@"开始营业" forState:UIControlStateNormal];
            self.shopStatusView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#1FE4FB"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#00ABE4"].CGColor];
        }
    }
    
    self.shopStatusView.shopNameL.text = self.shopModel.myShopM.shop_name;
    self.shopStatusView.shopNameL.frame = CGRectMake(86, 0, GET_STRWIDTH(self.shopStatusView.shopNameL.text, 18, 104), 104);
    self.shopStatusView.shopDetailImageView.frame = CGRectMake(CGRectGetMaxX(self.shopStatusView.shopNameL.frame), 42, 20, 20);
    [self.shopStatusView.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:self.shopModel.myShopM.shop_avatar_url]];

    self.severView.dataL.text =  self.shopModel.myShopM.order_num.intValue?self.shopModel.myShopM.order_num:@"0";
}

- (void)autoSetRole{
    if (self.shopModel.role_listArr.count >= 1) {
        NoticeMyShopModel *roleM1 = self.shopModel.role_listArr[0];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        self.shopModel.myShopM.role = roleM1.role;
        [parm setObject:roleM1.role forKey:@"role"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            
        } fail:^(NSError * _Nullable error) {
            
        }];
    }

}

//获取在营业的商品
- (void)requestGoods{
 
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoods/byUser" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.sellGoodsArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"][@"goodsList"]) {
                NoticeGoodsModel *model = [NoticeGoodsModel mj_objectWithKeyValues:dic];
                [self.sellGoodsArr addObject:model];
            }
        }
        [self refresButton];
    } fail:^(NSError * _Nullable error) {
        [self refresButton];
    }];
    
}


//开始营业或者结束营业
- (void)openDoorClick{
    if(self.shopModel.myShopM.is_stop.integerValue){
        return;
    }

    if(self.shopModel.myShopM.operate_status.integerValue == 2){
        [[NoticeTools getTopViewController] showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:@"99" forKey:@"goods_id"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/1",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if(success){
                [self getShopRequest];
            }
            [[NoticeTools getTopViewController] hideHUD];
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
        return;
    }
    
    if(!self.shopModel.myShopM.role.intValue){
        [[NoticeTools getTopViewController] showToastWithText:@"请选择您的角色"];
        return;
    }
   
    if(!self.sellGoodsArr.count){
        [self addClick];
        return;
    }
   
    if(self.shopModel.myShopM.operate_status.integerValue == 1 && self.shopModel.myShopM.role.intValue && self.sellGoodsArr.count){
        
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"营业中，店铺有新订单时，声昔会通过手机短信提示你" message:nil sureBtn:@"再想想" cancleBtn:@"开始营业" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [weakSelf start];
            }
        };
        [alerView showXLAlertView];
    }
}

- (void)start{
    
    
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) { // 有使用麦克风的权限
                NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                if(weakSelf.sellGoodsArr.count){
                    [parm setObject:@"99" forKey:@"goods_id"];
                }else{
                    [YZC_AlertView showViewWithTitleMessage:@"没有选择营业的商品"];
                    return;
                }
                
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/operateStatus/%@/2",weakSelf.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if(success){
                        [weakSelf getShopRequest];
                    }
                } fail:^(NSError * _Nullable error) {
                    
                }];
            }else { // 没有麦克风权限
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools getLocalStrWith:@"recoder.kaiqire"] message:@"有麦克风权限才可以语音通话功能哦~" sureBtn:[NoticeTools getLocalStrWith:@"recoder.kaiqi"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"] right:YES];
                alerView.resultIndex = ^(NSInteger index) {
                    if (index == 1) {
                        UIApplication *application = [UIApplication sharedApplication];
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([application canOpenURL:url]) {
                            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                if (@available(iOS 10.0, *)) {
                                    [application openURL:url options:@{} completionHandler:nil];
                                }
                            } else {
                                [application openURL:url options:@{} completionHandler:nil];
                            }
                        }
                    }
                };
                [alerView showXLAlertView];
            }
        });
    }];
    

}

- (void)addClick{
    NoticeAddSellMerchantController *ctl = [[NoticeAddSellMerchantController alloc] init];
    ctl.goodsModel = self.shopModel;
    __weak typeof(self) weakSelf = self;
    ctl.refreshGoodsBlock = ^(NSMutableArray * _Nonnull goodsArr) {
        weakSelf.sellGoodsArr = goodsArr;
        [weakSelf refresButton];
    };

    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

//店铺详情
- (void)changeRoleTap{
    [self shopdetailTap];
}

//店铺详情
- (void)shopdetailTap{
    NoticeMyJieYouShopController *ctl = [[NoticeMyJieYouShopController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

//申请店铺
- (void)supplyShopTap{
    if(self.applyModel.status == 5){
        NoticeSupplyProController *ctl = [[NoticeSupplyProController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else if (self.applyModel.status < 4 && self.applyModel.status > 0){
        NoticeSupplyProController *ctl = [[NoticeSupplyProController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

//店铺头像，名称，营业和结束营业视图
- (NoticeShopStatusView *)shopStatusView{
    if (!_shopStatusView) {
        _shopStatusView = [[NoticeShopStatusView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 104)];
        
        [self.scrollView addSubview:_shopStatusView];
        
        __weak typeof(self)weakSelf = self;
        _shopStatusView.stopStatusBlock = ^(BOOL status) {
            [weakSelf stopGetStatusTap];
        };
        _shopStatusView.openDoorBlock = ^(BOOL open) {
            [weakSelf openDoorClick];
        };
        _shopStatusView.roleChangeBlock = ^(BOOL role) {
            [weakSelf changeRoleTap];
        };
        _shopStatusView.detailBlock = ^(BOOL detail) {
            [weakSelf shopdetailTap];
        };
    }
    return _shopStatusView;
}

- (NoticeNoOpenShopView *)noShopView{
    if (!_noShopView) {
        _noShopView = [[NoticeNoOpenShopView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 104)];
        __weak typeof(self)weakSelf = self;
        
        _noShopView.supplyBlock = ^(BOOL supply) {
            [weakSelf supplyShopTap];
        };
        [self.scrollView addSubview:_noShopView];
    }
    return _noShopView;
}

- (NSMutableArray *)sellGoodsArr{
    if(!_sellGoodsArr){
        _sellGoodsArr = [[NSMutableArray alloc] init];
    }
    return _sellGoodsArr;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.panGesture) {
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if ([touchView isKindOfClass:[UIScrollView class]]) {
                self.scrollView = (UIScrollView *)touchView;
                self.isDragScrollView = YES;
                break;
            }else if (touchView == self) {
                self.isDragScrollView = NO;
                break;
            }
            touchView = (UIView *)[touchView nextResponder];
        }
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
     if (gestureRecognizer == self.panGesture) {
        return YES;
    }
    return YES;
}

// 是否与其他手势共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self];
    if (self.isDragScrollView) {
        // 当UIScrollView在最顶部时，处理视图的滑动
        if (self.scrollView.contentOffset.y <= 0) {
            if (translation.y > 0) { // 向下拖拽
                self.scrollView.contentOffset = CGPointZero;
                self.scrollView.panGestureRecognizer.enabled = NO;
                self.isDragScrollView = NO;
                
                CGRect contentFrame = self.frame;
                contentFrame.origin.y += translation.y;
                self.frame = contentFrame;
            }
        }
    }else {
        
        CGFloat contentM = (self.frame.size.height - self.frame.size.height);
        if (translation.y > 0) { // 向下拖拽
            CGRect contentFrame = self.frame;
            contentFrame.origin.y += translation.y;
            self.frame = contentFrame;
        }else if (translation.y < 0 && self.frame.origin.y > contentM) { // 向上拖拽
            CGRect contentFrame = self.frame;
            contentFrame.origin.y = MAX((self.frame.origin.y + translation.y), contentM);
            self.frame = contentFrame;
        }
    }
    
    [panGesture setTranslation:CGPointZero inView:self];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [panGesture velocityInView:self];
        
        self.scrollView.panGestureRecognizer.enabled = YES;
        
        // 结束时的速度>0 滑动距离> 5 且UIScrollView滑动到最顶部
        if (velocity.y > 0 && self.lastTransitionY > 5 && !self.isDragScrollView) {
            self.isOpen = YES;
            [self upTap];
        }else {
            self.isOpen = NO;
            [self upTap];
        }
    }
    
    self.lastTransitionY = translation.y;
}


@end
