//
//  SXHasBuyKcHeaderView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasBuyKcHeaderView.h"
#import "SXKcBuyChoiceView.h"
#import "SXHasBuyOrderListController.h"
#import "SXKcScoreBaseController.h"
#import "SXComKcController.h"
@implementation SXHasBuyKcHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 10, 120, 160)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self addSubview:self.coverImageView];
        
        _titleL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(145,10,DR_SCREEN_WIDTH-150, 24)];
        _titleL.font = XGEightBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:_titleL];
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(145,38,self.frame.size.width-150, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:_markL];
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectZero];
        _moneyL.font = SXNUMBERFONT(20);
        _moneyL.textColor = [UIColor colorWithHexString:@"#FF569F"];
        [self addSubview:_moneyL];
        
        _orginMoneyL = [[UILabel alloc] initWithFrame:CGRectZero];
        _orginMoneyL.font = SXNUMBERFONT(14);
        _orginMoneyL.textColor = [UIColor colorWithHexString:@"#FF569F"];
        [self addSubview:_orginMoneyL];
        
        self.line = [[UIView  alloc] initWithFrame:CGRectMake(0, 23/2, _orginMoneyL.frame.size.width, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#FF569F"];
        [_orginMoneyL addSubview:self.line];
        
        _buyNumL = [[UILabel alloc] initWithFrame:CGRectZero];
        _buyNumL.font = TWOTEXTFONTSIZE;
        _buyNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:_buyNumL];
        
        _hasBuyTimeL = [[UILabel alloc] initWithFrame:CGRectZero];
        _hasBuyTimeL.font = FOURTHTEENTEXTFONTSIZE;
        _hasBuyTimeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self addSubview:_hasBuyTimeL];

        self.buyImg = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_hasBuyTimeL.frame), 147, 16, 16)];
        self.buyImg.userInteractionEnabled = YES;
        self.buyImg.image = UIImageNamed(@"sx_hasbuykctime_img");
        [self addSubview:self.buyImg];
        
        _hasBuyTimeL.userInteractionEnabled = YES;
        self.buyImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hasBuyTap)];
        [self.hasBuyTimeL addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hasBuyTap)];
        [self.buyImg addGestureRecognizer:tap];
        
        if ([NoticeTools getuserId]) {
            self.contouinBtn = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-33-105, 138, 105, 32)];
            self.contouinBtn.backgroundColor = [UIColor colorWithHexString:@"#FF569F"];
            [self.contouinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.contouinBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
            [self.contouinBtn setTitle:@"继续购课" forState:UIControlStateNormal];
            [self addSubview:self.contouinBtn];
            [self.contouinBtn setAllCorner:16];
            [self.contouinBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_coverImageView.frame)+20, DR_SCREEN_WIDTH-30, 60)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
        
        UIView *colorView = [[UIView  alloc] initWithFrame:CGRectMake(13, 23,46, 14)];
        colorView.backgroundColor = [UIColor colorWithHexString:@"#FFD140"];
        [colorView setAllCorner:7];
        [self.backView addSubview:colorView];
        
        self.scoreL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 4, 94, 38)];
        self.scoreL.font = XGTWOBoldFontSize;
        self.scoreL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.scoreL];
        self.scoreL.text = @"5.0";
        
        UIView *numView = [[UIView  alloc] initWithFrame:CGRectMake(15+94, 20, self.backView.frame.size.width-15-94, 20)];
        [self.backView addSubview:numView];
        numView.userInteractionEnabled = YES;
    
        self.intoImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(numView.frame.size.width-15-16, 2, 16, 16)];
        self.intoImageView.userInteractionEnabled = YES;
        self.intoImageView.image = UIImageNamed(@"kcscore_img");
        [numView addSubview:self.intoImageView];
        
        self.comL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width-15-94-4-16-15, 20)];
        self.comL.font = FOURTHTEENTEXTFONTSIZE;
        self.comL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.comL.textAlignment = NSTextAlignmentRight;
        [numView addSubview:self.comL];
        
        UITapGestureRecognizer *tapcom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comTap)];
        [numView addGestureRecognizer:tapcom];
        
    }
    return self;
}

- (void)refreshCom{
    if (self.hasRequested) {
        return;
    }
    self.hasRequested = YES;
    NSString *useriD = [NoticeTools getuserId];
    if (!useriD) {
        useriD = @"0";
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoSeriesRemark/getScore/%@/%@",self.paySearModel.seriesId,useriD] Accept:@"application/vnd.shengxi.v5.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
            SXKcComDetailModel *comM = [SXKcComDetailModel mj_objectWithKeyValues:dict[@"data"]];
            self.paySearModel.remarkModel = comM;
            [self refreshComUI:comM];
        }
    
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)refreshComUI:(SXKcComDetailModel *)comM{
    self.giveScoreView.hidden = YES;
    NSString *scoreDes = @"超满意";
    NSString *score = @"5.0";
    if (comM.ctNum.intValue) {//有评价数量
        self.comL.text = [NSString stringWithFormat:@"学员评价(%@条)",comM.ctNum];
        self.intoImageView.hidden = NO;
        self.comL.frame = CGRectMake(0, 0, self.backView.frame.size.width-15-94-4-16-15, 20);
        scoreDes = comM.averageScoreName;
        score = comM.averageScore;
    }else{
        self.comL.text = @"还没有学员评价，暂无评分";
        self.intoImageView.hidden = YES;
        self.comL.frame = CGRectMake(0, 0, self.backView.frame.size.width-15-94-4-15, 20);
      
    }
    NSString *allStr = [NSString stringWithFormat:@"%@ %@",score,scoreDes];
    self.scoreL.attributedText = [DDHAttributedMode setString:allStr setFont:THIRTTYBoldFontSize setLengthString:score beginSize:0];
    
    if (comM.is_remark.intValue == 1 || comM.is_remark.intValue == 2) {//评价过
        self.giveScoreView.hidden = YES;
    }else{
        if ([SXTools getPayPlayLastsearisId:self.paySearModel.seriesId] && [SXTools isCanShow:[NSString stringWithFormat:@"comshow%@%@",[NoticeTools getuserId],self.paySearModel.seriesId]]){
            self.giveScoreView.hidden = NO;
        }
    }
    
    if (self.giveScoreView.hidden) {
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 178+80);
        self.backView.frame = CGRectMake(15,CGRectGetMaxY(_coverImageView.frame)+20, DR_SCREEN_WIDTH-30, 60);
    }else{
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 178+80+137);
        self.backView.frame = CGRectMake(15,CGRectGetMaxY(_coverImageView.frame)+20, DR_SCREEN_WIDTH-30, 60+127);
    }
    
    [self.backView setAllCorner:10];
    
    if (self.refreshComUIBolck) {
        self.refreshComUIBolck(YES);
    }
}

//查看评分
- (void)comTap{
    if (![NoticeTools getuserId]) {
        [[NoticeTools getTopViewController] showToastWithText:@"登录声昔账号才能查看评价内容哦~"];
        return;
    }
    
    if (!self.paySearModel.remarkModel.ctNum.intValue) {
        return;
    }
    
    SXKcScoreBaseController *ctl = [[SXKcScoreBaseController alloc] init];
    ctl.hasCom = self.paySearModel.remarkModel.is_remark.intValue == 1?YES:NO;
    ctl.paySearModel = self.paySearModel;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

//继续购课
- (void)buyClick{
    SXKcBuyChoiceView *choiceView = [[SXKcBuyChoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    choiceView.hasBuy = self.paySearModel.hasBuy;
    __weak typeof(self) weakSelf = self;
    choiceView.buyTypeBolck = ^(BOOL isSend) {
        if (weakSelf.buyTypeBolck) {
            weakSelf.buyTypeBolck(isSend);
        }
    };
    [choiceView show];
}

- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    _paySearModel = paySearModel;
    self.titleL.text = paySearModel.series_name;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:paySearModel.simple_cover_url]];
    self.markL.text = [NSString stringWithFormat:@"共%@课时  |  已更新%@课时",paySearModel.episodes,paySearModel.published_episodes];
    
    NSString *price = [NSString stringWithFormat:@"¥%@",_paySearModel.price];
    NSString *oriprice = [NSString stringWithFormat:@"¥%@",_paySearModel.original_price];
    _moneyL.text = price;
    _orginMoneyL.text = oriprice;
    
    _buyNumL.text = [NSString stringWithFormat:@"%d人已报名",_paySearModel.buy_users_num.intValue];
    
    _moneyL.frame = CGRectMake(145, 67, GET_STRWIDTH(_moneyL.text, 20, 24), 24);
    _orginMoneyL.frame = CGRectMake(CGRectGetMaxX(_moneyL.frame), 67, GET_STRWIDTH(_orginMoneyL.text, 14, 24), 24);
    self.line.frame = CGRectMake(0, 23/2, _orginMoneyL.frame.size.width, 1);
    _buyNumL.frame = CGRectMake(CGRectGetMaxX(_orginMoneyL.frame)+8, 67, GET_STRWIDTH(_buyNumL.text, 12, 24), 24);
    
    self.hasBuyTimeL.text = [NSString stringWithFormat:@"已购%d次",paySearModel.buy_card_times.intValue];
    self.hasBuyTimeL.frame = CGRectMake(145, 145, GET_STRWIDTH(self.hasBuyTimeL.text, 14, 20), 20);
    self.buyImg.frame = CGRectMake(CGRectGetMaxX(_hasBuyTimeL.frame)+3, 147, 16, 16);
    
    [self refreshCom];
    
    if (paySearModel.remarkModel) {
        [self refreshComUI:paySearModel.remarkModel];
    }
}

- (UIView *)giveScoreView{
    if (!_giveScoreView) {
        _giveScoreView = [[UIView  alloc] initWithFrame:CGRectMake(0, 60, DR_SCREEN_WIDTH-30, 127)];
        [self.backView addSubview:_giveScoreView];
        
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FFFFFF"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FFFFED"].CGColor];//#FF3C92
        gradientLayer.startPoint = CGPointMake(1, 1);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_giveScoreView.frame), CGRectGetHeight(_giveScoreView.frame));
        [_giveScoreView.layer addSublayer:gradientLayer];
        
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(15, 12, DR_SCREEN_WIDTH-60, 18)];
        label.font = THRETEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#14151A"];
        label.text = @"课程已观看一段时间了，你有什么感受呢";
        [_giveScoreView addSubview:label];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_giveScoreView.frame.size.width-15-20, 11, 20, 20)];
        [closeBtn setBackgroundImage:UIImageNamed(@"sxclosecomkc_img") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeComClick) forControlEvents:UIControlEventTouchUpInside];
        [_giveScoreView addSubview:closeBtn];
        
        _giveScoreView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goComTap)];
        [_giveScoreView addGestureRecognizer:tap];
        _giveScoreView.userInteractionEnabled = YES;
                
        NSArray *titleArr = @[@"挺难评",@"不太行",@"一般吧",@"挺不错",@"超满意"];
        NSArray *imgArr = @[@"sxkcscore0_img",@"sxkcscore1_img",@"sxkcscore2_img",@"sxkcscore3_img",@"sxkcscore4_img"];
        CGFloat space = (DR_SCREEN_WIDTH-30-48*5)/6;
        for (int i = 0; i < 5; i++) {
            UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake(space+(48+space)*i, 40, 48, 48)];
            imageV.image = UIImageNamed(imgArr[i]);
            [_giveScoreView addSubview:imageV];
            
            UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(imageV.frame.origin.x-1, CGRectGetMaxY(imageV.frame)+4, 50, 20)];
            markL.text = titleArr[i];
            markL.font = THRETEENTEXTFONTSIZE;
            markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
            markL.textAlignment = NSTextAlignmentCenter;
            [_giveScoreView addSubview:markL];
        }
    }
    return _giveScoreView;
}

//关闭评分提示
- (void)closeComClick{

    [SXTools setCanNotShow:[NSString stringWithFormat:@"comshow%@%@",[NoticeTools getuserId],self.paySearModel.seriesId]];
    [self refreshComUI:self.paySearModel.remarkModel];
}

//去评分
- (void)goComTap{
    SXComKcController *ctl = [[SXComKcController alloc] init];
    ctl.paySearModel = self.paySearModel;
    __weak typeof(self) weakSelf = self;
    ctl.refreshComBlock = ^(BOOL isAdd, SXKcComDetailModel * _Nonnull comModel) {
        if (isAdd) {
            weakSelf.hasRequested = NO;
            [weakSelf refreshCom];
        }
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    
}

- (void)hasBuyTap{
    SXHasBuyOrderListController *ctl = [[SXHasBuyOrderListController alloc] init];
    ctl.isSuccess = YES;
    ctl.seriesId = self.paySearModel.seriesId;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

@end
