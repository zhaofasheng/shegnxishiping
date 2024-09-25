//
//  SXBuySeriesTools.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/18.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuySeriesTools.h"
#import "SXBuySeriesTypeTools.h"
#import "SXBuyKcMarkView.h"
#import "SXCanBuyAllView.h"
@interface SXBuySeriesTools()

@property (nonatomic, strong) SXBuySeriesTypeTools *singleTools;
@property (nonatomic, strong) SXBuySeriesTypeTools *allTools;
@property (nonatomic, strong) SXBuySeriesTypeTools *threeTools;
@property (nonatomic, strong) SXBuySeriesTypeTools *syTools;
@property (nonatomic, assign) NSInteger buyType;//1购买单集，2购买课程，3购买课程卡，4解锁3节,5解锁剩余内容
@property (nonatomic, assign) NSInteger hasBuyVideoNum;//已经购买了多少视频
@property (nonatomic, assign) CGFloat hasPayPrice;//当前课程已经花了多少钱
@property (nonatomic, strong) UIScrollView *scorllView;
@property (nonatomic, strong) SXBuyKcMarkView *markView;

@property (nonatomic, strong) UIView *birdPriceView;
@end

@implementation SXBuySeriesTools


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0.3];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 460)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [_contentView setCornerOnTop:20];
        [self addSubview:_contentView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-50-15, 50)];
        label.font = XGFifthBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#14151A"];
        [_contentView addSubview:label];
        self.titleL = label;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-50, 0,50, 50)];
        [button setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
                
        UIButton *upButton = [[UIButton  alloc] initWithFrame:CGRectMake(20, self.contentView.frame.size.height-79-5, DR_SCREEN_WIDTH-40, 40)];
        [upButton setAllCorner:20];
        upButton.backgroundColor = [UIColor colorWithHexString:@"#FF4B98"];
        [upButton setTitle:@"提交订单" forState:UIControlStateNormal];
        upButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [upButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:upButton];
        [upButton addTarget:self action:@selector(upClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//购买单集选择
- (void)buySingle{
    self.singleTools.isSelect = YES;
    self.allTools.isSelect = NO;
    self.threeTools.isSelect = NO;
    self.syTools.isSelect = NO;
    self.buyType = 1;
    self.markView.showMoney = NO;
    self.markView.numL.text = @"1节";
    self.markView.buyType = 0;
    self.titleL.text = self.currentVideo;
}

//购买三节
- (void)buyThree{
    self.singleTools.isSelect = NO;
    self.allTools.isSelect = NO;
    self.threeTools.isSelect = YES;
    self.syTools.isSelect = NO;
    self.buyType = 4;
    self.markView.showMoney = NO;
    self.markView.numL.text = @"3节";
    self.markView.buyType = 0;
    self.titleL.text = @"";
}

//购买课程
- (void)buyAll{
    self.singleTools.isSelect = NO;
    self.allTools.isSelect = YES;
    self.threeTools.isSelect = NO;
    self.syTools.isSelect = NO;
    self.markView.showMoney = YES;
    self.markView.numL.text = [NSString stringWithFormat:@"%@节",self.paySearModel.episodes];
    self.markView.moneyL.text = [NSString stringWithFormat:@"¥%d",self.paySearModel.original_price.intValue - self.paySearModel.price.intValue];
    self.titleL.text = @"";
    if (self.justBuyCard) {
        self.markView.buyType = 3;
        [self.markView buySend];
    }else if (self.justBuyAll){
        self.markView.buyType = 1;
        [self.markView buyself];
    }else if (self.jisugouke && (self.hasBuyVideoNum > 0 && !self.paySearModel.is_bought.boolValue)){
        self.markView.buyType = 3;
        [self.markView buySend];
    }
    else{
        self.markView.buyType = 1;
        [self.markView buyself];
    }
}

//购买剩余课程
- (void)buySy{
    self.titleL.text = @"";
    self.singleTools.isSelect = NO;
    self.allTools.isSelect = NO;
    self.threeTools.isSelect = NO;
    self.syTools.isSelect = YES;
    self.markView.showMoney = NO;
    self.markView.numL.text = [NSString stringWithFormat:@"%ld节",self.paySearModel.episodes.integerValue-self.hasBuyVideoNum];
    self.buyType = 5;
    self.markView.buyType = 0;
}

- (void)upClick{

    if (self.buyType == 1) {
        if ((self.paySearModel.singlePrice.intValue + (self.paySearModel.singlePrice.intValue * self.hasBuyVideoNum)) >= self.paySearModel.price.intValue) {//如果解锁单集的时候可以解锁全部
            __weak typeof(self) weakSelf = self;
            SXCanBuyAllView *allView = [[SXCanBuyAllView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
            [allView showView];
            allView.buyBlock = ^(BOOL buy) {
                if (weakSelf.buytypeBlock) {
                    weakSelf.buytypeBlock(5,weakSelf.currentId);
                }
                [weakSelf dissMissTap];
            };
            return;
        }
    }
    if (self.buytypeBlock) {
        self.buytypeBlock(self.buyType,self.currentId);
    }
    [self dissMissTap];
}

- (void)refreshUI{
    if (self.paySearModel.hasBuy) {//购买过，则只购买课程卡
        self.justBuyCard = YES;
    }else if(!self.paySearModel.canBuySingle){//不能单集购买，则只允许购买课程或者课程卡
        self.justBuyAll = YES;
    }
 
    CGFloat width = (DR_SCREEN_WIDTH-60)/3;
    
    NSInteger threee = 0;
    //判断是否存在单集购买过的产品
    NSInteger hasBuyVideo = 0;
    for (SXSearisVideoListModel *videoM in self.dataArr) {
        
        if (!self.currentId) {
            if (!videoM.unLock  && (videoM.tryPlayTime < videoM.video_len.intValue)) {//试看时长小于视频时长
                self.currentId = videoM.videoId;
                self.currentVideo = [NSString stringWithFormat:@"即将解锁：%@",videoM.title];
                threee++;
            }
        }
  
        if (videoM.unLock) {
            hasBuyVideo ++;
        }
    }
    
    self.hasBuyVideoNum = hasBuyVideo;

    self.hasPayPrice = hasBuyVideo * self.paySearModel.singlePrice.intValue;
    
    self.singleTools = [[SXBuySeriesTypeTools  alloc] initWithFrame:CGRectMake(15, 70,width,123)];
    self.singleTools.titleL.text = @"解锁本节";
    NSString *singlePrice = [NSString stringWithFormat:@"¥%@",self.paySearModel.singlePrice];
    self.singleTools.priceL.attributedText = [DDHAttributedMode setString:singlePrice setSize:12 setLengthString:@"¥" beginSize:0];
    self.singleTools.oricePriceL.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.singleTools.typeClickBlock = ^(NSInteger type) {//解锁单集
        [weakSelf buySingle];
    };
    
    [self.contentView addSubview:self.singleTools];
    self.singleTools.isSelect = NO;
    self.singleTools.hidden = YES;
    
    self.allTools = [[SXBuySeriesTypeTools  alloc] initWithFrame:CGRectMake(15+width+15, 70,width,123)];
    self.allTools.titleL.text = @"解锁课程";
    NSString *allPrice = [NSString stringWithFormat:@"¥%@",_paySearModel.price];
    self.allTools.priceL.attributedText = [DDHAttributedMode setString:allPrice setSize:12 setLengthString:@"¥" beginSize:0];
    self.allTools.oricePriceL.hidden = NO;
    self.allTools.oricePriceL.text = [NSString stringWithFormat:@"原价¥%@",self.paySearModel.original_price];
    self.allTools.typeClickBlock = ^(NSInteger type) {//解锁课程
        [weakSelf buyAll];
    
    };
    [self.contentView addSubview:self.allTools];
    self.allTools.isSelect = YES;
    self.buyType = 2;
    self.allTools.hidden = YES;
    
    _birdPriceView.hidden = YES;
  
    
//    self.threeTools = [[SXBuySeriesTypeTools  alloc] initWithFrame:CGRectMake(15+(width+15)*2, 70,width,123)];
//    self.threeTools.titleL.text = @"解锁3节";
//    NSString *threePrice = [NSString stringWithFormat:@"¥%d",self.paySearModel.singlePrice.intValue*3];
//    self.threeTools.priceL.attributedText = [DDHAttributedMode setString:threePrice setSize:12 setLengthString:@"¥" beginSize:0];
//    self.threeTools.oricePriceL.hidden = YES;
//    self.threeTools.typeClickBlock = ^(NSInteger type) {//解锁3节
//
//        [weakSelf buyThree];
//    };
//    [self.contentView addSubview:self.threeTools];
//    self.threeTools.isSelect = NO;
//    self.threeTools.hidden = YES;
    
    self.syTools = [[SXBuySeriesTypeTools  alloc] initWithFrame:CGRectMake(15+(width+15)*2, 70,width,123)];
    self.syTools.titleL.text = @"剩余内容";
    NSString *syPrice = [NSString stringWithFormat:@"¥%ld",(long)(self.paySearModel.price.intValue - self.paySearModel.singlePrice.intValue*self.hasBuyVideoNum)];
    self.syTools.priceL.attributedText = [DDHAttributedMode setString:syPrice setSize:12 setLengthString:@"¥" beginSize:0];
    self.syTools.oricePriceL.hidden = YES;
    
    self.syTools.typeClickBlock = ^(NSInteger type) {//解锁剩余内容
        [weakSelf buySy];
    };
    
    [self.contentView addSubview:self.syTools];
    self.syTools.isSelect = NO;
    self.syTools.hidden = YES;
    
    self.markView = [[SXBuyKcMarkView  alloc] initWithFrame:CGRectMake(0, 203, DR_SCREEN_WIDTH, 88+90)];
    [self.contentView addSubview:self.markView];
    self.markView.buyTypeBlock = ^(BOOL isbuySend) {
        weakSelf.buyType = isbuySend?3:2;
    };

    //只购买课程或者课程卡
    if (self.justBuyAll || self.justBuyCard) {
        self.allTools.hidden = NO;
      
        self.allTools.isSelect = YES;
        [self buyAll];
        self.allTools.frame = CGRectMake(15, 70,width,123);
        if (self.paySearModel.open_upfront_activity.boolValue) {
            self.birdPriceView.hidden = NO;
            self.birdPriceView.frame = CGRectMake(self.allTools.frame.origin.x, 58, self.allTools.frame.size.width, 24);
        }
        
    }//没有购买过
    else if (self.hasBuyVideoNum <= 0 && !self.paySearModel.is_bought.boolValue){
        self.singleTools.hidden = NO;
        self.allTools.hidden = NO;
        if (self.paySearModel.open_upfront_activity.boolValue) {
            self.birdPriceView.hidden = NO;
            self.birdPriceView.frame = CGRectMake(self.allTools.frame.origin.x, 58, self.allTools.frame.size.width, 24);
        }
        self.allTools.isSelect = YES;
        [self buyAll];
    }//购买过单集视频
    else if (self.hasBuyVideoNum > 0 && !self.paySearModel.is_bought.boolValue){
        
        self.allTools.hidden = YES;
        _birdPriceView.hidden = YES;
        if (self.jisugouke) {
            self.allTools.hidden = NO;
            if (self.paySearModel.open_upfront_activity.boolValue) {
                self.birdPriceView.hidden = NO;
                self.birdPriceView.frame = CGRectMake(self.allTools.frame.origin.x, 58, self.allTools.frame.size.width, 24);
            }
            self.syTools.frame = CGRectMake(15+(width+15)*2, 70,width,123);
         
        }else{
            self.syTools.frame = CGRectMake(15+(width+15)*1, 70,width,123);
        }
        
        self.singleTools.hidden = NO;
        self.syTools.hidden = NO;
        self.syTools.isSelect = YES;
        [self buySy];
    }
}

- (UIView *)birdPriceView{
    if (!_birdPriceView) {
        _birdPriceView = [[UIView  alloc] initWithFrame:CGRectMake(self.allTools.frame.origin.x, 58, self.allTools.frame.size.width, 24)];
        _birdPriceView.layer.cornerRadius = 8;
        _birdPriceView.layer.masksToBounds = YES;
        [self.contentView addSubview:_birdPriceView];
        
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF6C2D"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FF421F"].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_birdPriceView.frame), CGRectGetHeight(_birdPriceView.frame));
       
        [_birdPriceView.layer addSublayer:gradientLayer];
        
        UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake((_birdPriceView.frame.size.width-72)/2, 5, 72, 14)];
        imageV.image = UIImageNamed(@"sxbirdprice_img");
        [_birdPriceView addSubview:imageV];
    }
    return _birdPriceView;
}

- (void)show{
    [self refreshUI];
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self->_contentView.frame.size.height+20, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
}

- (void)dissMissTap{
 
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
      
    }];
}

@end
