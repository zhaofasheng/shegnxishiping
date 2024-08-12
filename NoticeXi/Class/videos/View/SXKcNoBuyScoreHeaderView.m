//
//  SXKcNoBuyScoreHeaderView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcNoBuyScoreHeaderView.h"
#import "SXKcScoreBaseController.h"
@implementation SXKcNoBuyScoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        XLCycleCollectionView *cyleView = [[XLCycleCollectionView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/16*9)];
        cyleView.justImag = YES;
        cyleView.autoPage = YES;
        [self addSubview:cyleView];
        self.cyleView = cyleView;
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(cyleView.frame), DR_SCREEN_WIDTH-30, 132)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15,DR_SCREEN_WIDTH-30-15, 28)];
        self.titleL.font = XGTwentyBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.titleL];
        self.titleL.numberOfLines = 0;
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.titleL.frame)+4 ,DR_SCREEN_WIDTH-20, 17)];
        self.numL.font = TWOTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:self.numL];
        
        self.scoreView = [[UIView  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numL.frame)+12, self.backView.frame.size.width, 38)];
        [self.backView addSubview:self.scoreView];
        
        UIView *colorView = [[UIView  alloc] initWithFrame:CGRectMake(13, 23,46, 14)];
        colorView.backgroundColor = [UIColor colorWithHexString:@"#FFD140"];
        [colorView setAllCorner:7];
        [self.scoreView addSubview:colorView];
        
        self.scoreL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, 94, 38)];
        self.scoreL.font = XGTWOBoldFontSize;
        self.scoreL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.scoreView addSubview:self.scoreL];
        
        UIView *numView = [[UIView  alloc] initWithFrame:CGRectMake(15+94, 15, self.scoreView.frame.size.width-15-94, 20)];
        [self.scoreView addSubview:numView];
        numView.userInteractionEnabled = YES;
    
        self.intoImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(numView.frame.size.width-15-16, 2, 16, 16)];
        self.intoImageView.userInteractionEnabled = YES;
        self.intoImageView.image = UIImageNamed(@"kcscore_img");
        [numView addSubview:self.intoImageView];
        
        self.comL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, self.scoreView.frame.size.width-15-94-4-16-15, 20)];
        self.comL.font = FOURTHTEENTEXTFONTSIZE;
        self.comL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.comL.textAlignment = NSTextAlignmentRight;
        [numView addSubview:self.comL];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comTap)];
        [numView addGestureRecognizer:tap];
    }
    return self;
}

- (void)comTap{
    SXKcScoreBaseController *ctl = [[SXKcScoreBaseController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    _paySearModel = paySearModel;
    self.cyleView.data = paySearModel.carousel_images;
    self.titleL.attributedText = [SXTools getStringWithLineHight:3 string:paySearModel.series_name];
    self.titleL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30-15, [SXTools getHeightWithLineHight:3 font:20 width:DR_SCREEN_WIDTH-30-15 string:paySearModel.series_name isJiacu:YES]);
    
    self.numL.frame = CGRectMake(15,CGRectGetMaxY(self.titleL.frame)+4 ,DR_SCREEN_WIDTH-45, 17);
    self.numL.text = [NSString stringWithFormat:@"共%@课时  |  已更新%@课时",paySearModel.episodes,paySearModel.published_episodes];
    self.backView.frame = CGRectMake(15, CGRectGetMaxY(self.cyleView.frame)+10, DR_SCREEN_WIDTH-30, CGRectGetMaxY(self.numL.frame)+68);
    [self.backView setAllCorner:10];
    
    NSString *scoreDes = @"超满意";
    NSString *score = @"5.0";
    NSString *allStr = [NSString stringWithFormat:@"%@  %@",score,scoreDes];
    self.scoreL.attributedText = [DDHAttributedMode setString:allStr setFont:THIRTTYBoldFontSize setLengthString:score beginSize:0];
    
    self.comL.text = @"学员评价(133条)";

    self.scoreView.frame = CGRectMake(0, CGRectGetMaxY(self.numL.frame)+12, self.backView.frame.size.width, 38);
    self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH/16*9+self.backView.frame.size.height+25);
}

@end
