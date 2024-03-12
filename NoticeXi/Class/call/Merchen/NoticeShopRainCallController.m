//
//  NoticeShopRainCallController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopRainCallController.h"
#import "NoticeXi-Swift.h"
#import "NoticeChatingInfoModel.h"
@interface NoticeShopRainCallController ()
@property (nonatomic, strong) UIImageView *bkFmimageView;
@property (nonatomic, strong) UIImageView *earthimageView;
@property (nonatomic, strong) UIImageView *roadimageView;
@property (nonatomic, strong) UIButton *workButton;
@property (nonatomic, strong) FSCustomButton *priceButton;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NoticeChatingInfoModel *priceModel;
@property (nonatomic, strong) NoticeGoodsModel *choiceGoods;
@property (nonatomic, strong) NoticeByOfOrderModel *orderM;
@property (nonatomic, assign) BOOL canClickFind;
@end

@implementation NoticeShopRainCallController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.bkFmimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.bkFmimageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bkFmimageView.clipsToBounds = YES;
    self.bkFmimageView.image = UIImageNamed(@"liuxingcall_back_img");
    self.bkFmimageView.userInteractionEnabled = YES;
    [self.view addSubview:self.bkFmimageView];
    
    self.bkFmimageView.frame = CGRectMake(0, 0, hypotf(DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT), hypotf(DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT));
    self.bkFmimageView.center = self.view.center;
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 400;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.bkFmimageView.layer addAnimation:animation forKey:nil];
    
    self.earthimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+10, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH)];
    self.earthimageView.contentMode = UIViewContentModeScaleAspectFill;
    self.earthimageView.clipsToBounds = YES;
    self.earthimageView.image = UIImageNamed(@"earth");
    self.earthimageView.userInteractionEnabled = YES;
    [self.view addSubview:self.earthimageView];
    [self createAnimaition];
    
    self.roadimageView = [[UIImageView alloc] initWithFrame:self.earthimageView.frame];
    self.roadimageView.contentMode = UIViewContentModeScaleAspectFill;
    self.roadimageView.clipsToBounds = YES;
    self.roadimageView.image = UIImageNamed(@"guangyun");
    self.roadimageView.userInteractionEnabled = YES;
    [self.view addSubview:self.roadimageView];
    
    self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.earthimageView.frame), DR_SCREEN_WIDTH, 25)];
    self.markL.textColor = [UIColor whiteColor];
    self.markL.textAlignment = NSTextAlignmentCenter;
    self.markL.font = EIGHTEENTEXTFONTSIZE;
    [self.view addSubview:self.markL];
    self.markL.hidden = YES;
    
    [self configureStar];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-100, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    titleL.font = EIGHTEENTEXTFONTSIZE;
    titleL.text = @"流星电话";
    titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:titleL];
    titleL.textAlignment = NSTextAlignmentCenter;
    
    self.workButton = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-240)/2,DR_SCREEN_HEIGHT-180, 240, 50)];
    self.workButton.layer.cornerRadius = 25;
    self.workButton.layer.masksToBounds = YES;
    //渐变色
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#E4FFD6"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#9BEFFF"].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.workButton.frame), CGRectGetHeight(self.workButton.frame));
 
    [self.workButton.layer addSublayer:gradientLayer];
    [self.workButton setTitle:@"点击寻找" forState:UIControlStateNormal];
    [self.workButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.workButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.view addSubview:self.workButton];
    [self.workButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    FSCustomButton *btn1 = [[FSCustomButton alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.workButton.frame)+20,DR_SCREEN_WIDTH,20)];
    [btn1 setImage:UIImageNamed(@"Image_editprice") forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(changePriceClick) forControlEvents:UIControlEventTouchUpInside];
    btn1.buttonImagePosition = FSCustomButtonImagePositionRight;
    btn1.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    self.priceButton = btn1;
    NSString *str = @"可接受的最高价格：";
    NSString *str1 = @"   鲸币/分钟";
    NSString *price = @"1";
    if (@available(iOS 13.0, *)) {
        [self.priceButton setAttributedTitle:[DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"%@%@%@",str,price,str1] setColor:[UIColor colorWithHexString:@"#B0DEFF"] setSize:20 setLengthString:price beginSize:str.length] forState:UIControlStateNormal];
    }else{
    
        [self.priceButton setTitle:[NSString stringWithFormat:@"%@%@%@",str,price,str1] forState:UIControlStateNormal];
    }

    self.canClickFind = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasKillApp) name:@"APPWASKILLED" object:nil];
    [self getCurruentPrice];
}


- (void)hasKillApp{
    DRLog(@"程序杀死");
    [self cancelOrder];
}

//取消订单
- (void)cancelOrder{
    if (self.choiceGoods.type.intValue == 2){
        if(self.orderM.room_id){
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:@"2" forKey:@"orderType"];
            [parm setObject:self.orderM.room_id forKey:@"roomId"];
            [[DRNetWorking shareInstance] requestWithPatchPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    [self refreshCanfind:YES];
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        }
    }
}

//是否完成了订单后结束
- (void)refreshCanfind:(BOOL)orderHasFinish{
    if (orderHasFinish) {
        self.markL.hidden = YES;
    }else{
        self.markL.hidden = NO;
        self.markL.text = @"没有找到那个人，请稍后再试";
    }
    [self.workButton setTitle:@"点击寻找" forState:UIControlStateNormal];
}

- (void)changePriceClick{
    __weak typeof(self) weakSelf = self;

    NoticeChangePriceView *nameVieww = [[NoticeChangePriceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    nameVieww.titleL.text = @"可接受的最高价格";
    nameVieww.nameBlock = ^(NSString * _Nullable price) {
        if (price.intValue <= 0) {
            [weakSelf showToastWithText:@"价格必须大于零哦~"];
            return;
        }
        [weakSelf setPriceCall:price];

    };
    [nameVieww showView];
}

- (void)setPriceCall:(NSString *)price{
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:price forKey:@"price"];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"user/setPrice" Accept:@"application/vnd.shengxi.v5.6.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NSString *str = @"可接受的最高价格：";
            NSString *str1 = @"   鲸币/分钟";
          //
            if (@available(iOS 13.0, *)) {
                [self.priceButton setAttributedTitle:[DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"%@%@%@",str,price,str1] setColor:[UIColor colorWithHexString:@"#B0DEFF"] setSize:20 setLengthString:price beginSize:str.length] forState:UIControlStateNormal];
            }else{
            
                [self.priceButton setTitle:[NSString stringWithFormat:@"%@%@%@",str,price,str1] forState:UIControlStateNormal];
            }
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
    
}

- (void)getCurruentPrice{

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"user/getSetPrice" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
     
        if (success) {
            self.priceModel = [NoticeChatingInfoModel mj_objectWithKeyValues:dict[@"data"]];
            NSString *str = @"可接受的最高价格：";
            NSString *str1 = @"   鲸币/分钟";
            if (@available(iOS 13.0, *)) {
                [self.priceButton setAttributedTitle:[DDHAttributedMode setSizeAndColorString:[NSString stringWithFormat:@"%@%@%@",str,self.priceModel.price,str1] setColor:[UIColor colorWithHexString:@"#B0DEFF"] setSize:20 setLengthString:self.priceModel.price beginSize:str.length] forState:UIControlStateNormal];
            }else{
            
                [self.priceButton setTitle:[NSString stringWithFormat:@"%@%@%@",str,self.priceModel.price,str1] forState:UIControlStateNormal];
            }
         //
        }
        
    } fail:^(NSError * _Nullable error) {
  
    }];
}

- (void)chongzhiView{
    NoticeChongZhiTosatView *payV = [[NoticeChongZhiTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    [payV showView];
}

- (void)ifXidDan:(NoticeMyWallectModel *)walect{
    __weak typeof(self) weakSelf = self;

    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"matchShop" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
    
        if (success) {
            NoticeGoodsModel *goodsM = [NoticeGoodsModel mj_objectWithKeyValues:dict[@"data"]];
            if (goodsM.goods_id.intValue > 0 && goodsM.shop_id.intValue > 0) {
                goodsM.goodId = goodsM.goods_id;
                goodsM.type = @"2";
                self.markL.hidden = YES;
                weakSelf.canClickFind = YES;
                [self.workButton setTitle:@"点击寻找" forState:UIControlStateNormal];
                NoticeShopXiaDanTostaView *sureView = [[NoticeShopXiaDanTostaView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
                sureView.autoButton.hidden = YES;
                sureView.titleL.text = [NSString stringWithFormat:@"你的鲸币余额可通话%d分钟\n超时自动结束，确定下单？",(int)(walect.total_balance.floatValue/goodsM.price.intValue)];
                sureView.titleL.frame = CGRectMake(0, 15, 280, GET_STRHEIGHT(sureView.titleL.text, 16, sureView.titleL.frame.size.width)+10);
                sureView.contentL.text = [NSString stringWithFormat:@"·聊天时长最多%d分钟\n·聊天双方都是匿名的\n·聊天记录不会保留\n·此类型仅可语音通话",(int)(walect.total_balance.floatValue/goodsM.price.intValue)];
                sureView.contentL.frame = CGRectMake(48,CGRectGetMaxY(sureView.titleL.frame)+5, 280-48, 108);
                sureView.sureXdBlock = ^(NSInteger index) {
                    [weakSelf buyVoice:goodsM autoNext:NO needAudo:NO];
                };
                [sureView showView];
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appdel.audioChatTools.autoCallNexttext = NO;
                appdel.audioChatTools.autoCallNext = NO;
            }else{
                self.markL.hidden = NO;
  
                weakSelf.canClickFind = YES;
                [weakSelf refreshCanfind:NO];
            }
           
        }else{
            self.markL.hidden = NO;

            weakSelf.canClickFind = YES;
            [weakSelf refreshCanfind:NO];
        }
    } fail:^(NSError * _Nullable error) {
        self.markL.hidden = NO;
        self.markL.text = @"没有找到那个人，请稍后再试";
        [self.workButton setTitle:@"点击寻找" forState:UIControlStateNormal];
        weakSelf.canClickFind = YES;
        [weakSelf refreshCanfind:NO];
    }];
}

- (void)startClick{
    __weak typeof(self) weakSelf = self;
    if (!self.canClickFind) {
        return;
    }
    self.markL.hidden = NO;
    self.markL.text = @"寻找有缘人中…";
    [self.workButton setTitle:@"寻找中" forState:UIControlStateNormal];
    self.canClickFind = NO;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"wallet" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            NoticeMyWallectModel *wallectM = [NoticeMyWallectModel mj_objectWithKeyValues:dict[@"data"]];
            //wallectM.total_balance 总鲸币
            if (wallectM.total_balance.intValue <= 0) {
                [NoticeQiaojjieTools showWithTitle:@"你的鲸币余额不足，无法使用此功能~" msg:@"" button1:@"再想想" button2:@"充值" clickBlcok:^(NSInteger tag) {
                    [weakSelf chongzhiView];
                }];
                self.canClickFind = YES;
                self.markL.hidden = YES;
                [self.workButton setTitle:@"点击寻找" forState:UIControlStateNormal];
                return;
            }
            [weakSelf ifXidDan: wallectM];
        }
    } fail:^(NSError * _Nullable error) {
        self.canClickFind = YES;
        self.markL.hidden = YES;
        [self.workButton setTitle:@"点击寻找" forState:UIControlStateNormal];
    }];
}


- (void)buyVoice:(NoticeGoodsModel *)goodM autoNext:(BOOL)autoNext needAudo:(BOOL)needAudo{
    __weak typeof(self) weakSelf = self;
    self.choiceGoods = goodM;
    
    [self showHUD];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:weakSelf.choiceGoods.goodId forKey:@"goodsId"];
    [parm setObject:weakSelf.choiceGoods.shop_id forKey:@"shopId"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoodsOrder" Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [weakSelf hideHUD];
        weakSelf.canClickFind = YES;
        if(success){
            weakSelf.orderM = [NoticeByOfOrderModel mj_objectWithKeyValues:dict[@"data"]];
      
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [weakSelf refreshCanfind:YES];
            [appdel.audioChatTools callToUserId:weakSelf.choiceGoods.shop_user_id roomId:weakSelf.orderM.room_id.intValue getOrderTime:autoNext?weakSelf.choiceGoods.match_time : weakSelf.orderM.get_order_time nickName:weakSelf.orderM.user_nick_name autoNext:autoNext];
            
            appdel.audioChatTools.cancelBlcok = ^(BOOL cancel) {
                [weakSelf cancelOrder];
            };
        }else{
            NoticeOneToOne *allM = [NoticeOneToOne mj_objectWithKeyValues:dict];
            if(allM.code.intValue == 288){//用户余额不足
                [NoticeQiaojjieTools showWithTitle:@"你的鲸币余额不足，需要充值才能继续下单噢" msg:@"" button1:@"再想想" button2:@"充值" clickBlcok:^(NSInteger tag) {
                    [weakSelf chongzhiView];
                }];
            }else{
                [NoticeQiaojjieTools showWithTitle:allM.msg];
            }
        }
    } fail:^(NSError * _Nullable error) {
        weakSelf.canClickFind = YES;
        [weakSelf hideHUD];
        [weakSelf showToastWithText:error.description];
    }];
}

- (void)configureStar{
    CGRect locationOne      = CGRectMake(30.f, 140.f, 35.f, 35.f);
    CGRect locationTwo      = CGRectMake(DR_SCREEN_WIDTH-90.f, 80.f, 15.f, 15.f);
    CGRect locationThree    = CGRectMake(30.f+20.f, DR_SCREEN_HEIGHT/2.f+20.f, 25.f, 25.f);
    CGRect locationaFour    = CGRectMake(DR_SCREEN_WIDTH-60.f, DR_SCREEN_HEIGHT/2.f, 15.f, 15.f);
    CGRect locationFive     = CGRectMake(30.f+10.f, DR_SCREEN_WIDTH-BOTTOM_HEIGHT-120.f, 25.f, 25.f);
    CGRect locationSix      = CGRectMake(DR_SCREEN_WIDTH/2.f+50.f, DR_SCREEN_HEIGHT/2.f+100.f, 15.f, 15.f);
    CGRect locationSeven    = CGRectMake(DR_SCREEN_WIDTH-100.f, DR_SCREEN_HEIGHT-44.f-50.f-BOTTOM_HEIGHT, 25.f, 25.f);
    CGRect locationEight    = CGRectMake(DR_SCREEN_WIDTH/2, DR_SCREEN_HEIGHT/2-100, 25.f, 25.f);
    NSArray *locationS = @[[NSValue valueWithCGRect:locationOne],
                           [NSValue valueWithCGRect:locationTwo],
                           [NSValue valueWithCGRect:locationThree],
                           [NSValue valueWithCGRect:locationaFour],
                           [NSValue valueWithCGRect:locationSix],
                           [NSValue valueWithCGRect:locationFive],
                           [NSValue valueWithCGRect:locationSeven],
                           [NSValue valueWithCGRect:locationEight]];
    for (NSInteger i = 0; i < locationS.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]init];
        NSValue *value= locationS[i];
        imageview.frame =  [value CGRectValue];
        imageview.image = [UIImage imageNamed:@"circlesofociety"];
        [imageview.layer addAnimation:[self opacityForever_Animation:i%3+1] forKey:nil];
        [self.view addSubview:imageview];
    }
    
}


-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}


- (void)backClick{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.noNeedStop = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
 
}

- (void)createAnimaition{


    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat duration = 5.f;
    CGFloat height = 17.f;
    CGFloat currentY = self.earthimageView.transform.ty;
    animation.duration = duration;
    animation.values = @[@(currentY),@(currentY - height/4),@(currentY - height/4*2),@(currentY - height/4*3),@(currentY - height),@(currentY - height/ 4*3),@(currentY - height/4*2),@(currentY - height/4),@(currentY)];
    animation.keyTimes = @[ @(0), @(0.025), @(0.085), @(0.2), @(0.5), @(0.8), @(0.915), @(0.975), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    [self.earthimageView.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}

@end
