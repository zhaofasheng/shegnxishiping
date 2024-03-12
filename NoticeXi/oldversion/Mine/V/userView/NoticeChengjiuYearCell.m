//
//  NoticeChengjiuYearCell.m
//  NoticeXi
//
//  Created by li lei on 2023/12/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChengjiuYearCell.h"

@implementation NoticeChengjiuYearCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
  
        self.urlImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.urlImageView];
        self.urlImageView.userInteractionEnabled = YES;

        self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-24-3, 3, 24, 24)];
        [self.contentView addSubview:self.choiceImageView];
        self.choiceImageView.userInteractionEnabled = YES;
        self.choiceImageView.image = UIImageNamed(@"bkRecoFin_Image");
        
    }
    return self;
}

- (void)setYearModel:(NoticeChengjiuMonths *)yearModel{
    _yearModel = yearModel;
    [self.urlImageView sd_setImageWithURL:[NSURL URLWithString:yearModel.back_url]];
    self.choiceImageView.hidden = yearModel.isChoice?NO:YES;
}

@end
