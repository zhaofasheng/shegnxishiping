//
//  NoticeVoiceDefaultChoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2023/11/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceDefaultChoiceCell.h"

@implementation NoticeVoiceDefaultChoiceCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.defalutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:self.defalutImageView];
        self.defalutImageView.image = UIImageNamed(@"voice_cdimg");
        self.defalutImageView.hidden = YES;
        self.defalutImageView.userInteractionEnabled = YES;
        
        self.backImageView = [[UIImageView alloc] init];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        self.backImageView.layer.masksToBounds = YES;
        self.backImageView.layer.cornerRadius = 5;
        self.backImageView.layer.borderColor = [UIColor blackColor].CGColor;
        self.backImageView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:self.backImageView];
        
        self.choiceButton = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.choiceButton.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.choiceButton setTitle:[NoticeTools chinese:@"自定义" english:@"DIY" japan:@"カスタ"] forState:UIControlStateNormal];
        [self.choiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.choiceButton setImage:UIImageNamed(@"img_zdyvoice") forState:UIControlStateNormal];
        self.choiceButton.buttonImagePosition = FSCustomButtonImagePositionTop;
        [self.contentView addSubview:self.choiceButton];
        self.choiceButton.userInteractionEnabled = NO;
        self.choiceButton.hidden = YES;
        self.choiceButton.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [self.choiceButton setAllCorner:5];
        
        self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-24-4, 4,24, 24)];
        [self.contentView addSubview:self.choiceImageView];
        self.choiceImageView.image = UIImageNamed(@"Image_choiceadd_b");
        self.choiceImageView.hidden = YES;
        self.choiceImageView.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height-28, self.frame.size.width, 28)];
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = TWOTEXTFONTSIZE;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [label setCornerOnBottom:8];
        [self.contentView addSubview:label];
        self.titleL = label;
        
        //
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    if(index == 0){
        self.choiceButton.hidden = NO;
        self.backImageView.hidden = YES;
        if(self.isVoice){
            self.choiceButton.backgroundColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0];
        }else{
            self.choiceButton.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        }
    }else{
        self.choiceButton.hidden = YES;
        self.backImageView.hidden = NO;
    }
    self.titleL.hidden = self.backImageView.hidden;
    self.choiceImageView.hidden = self.backImageView.hidden;
}

- (void)setIsVoice:(BOOL)isVoice{
    _isVoice = isVoice;
    self.defalutImageView.hidden = isVoice?NO:YES;
    if(isVoice){
        self.backImageView.frame = CGRectMake(20, 20, self.frame.size.width-40, self.frame.size.height-40);
        self.backImageView.layer.borderWidth = 2;
        self.backImageView.layer.cornerRadius = self.backImageView.frame.size.width/2;
        
    }else{
        self.backImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.backImageView.layer.borderWidth = 0;
        self.backImageView.layer.cornerRadius = 5;
    }
}

- (void)setImgModel:(NoticeVoiceDefaultImgModel *)imgModel{
    _imgModel = imgModel;
    if(self.index > 0){
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:imgModel.cover_urls]];
        if ([imgModel.title isEqualToString:@"自定义"]) {
            self.titleL.text = [NoticeTools chinese:@"自定义" english:@"DIY" japan:@"カスタ"];
        }else{
            self.titleL.text = imgModel.title;
        }
        
        self.choiceImageView.hidden = imgModel.currentChoice?NO:YES;
    }else{
        self.choiceImageView.hidden = YES;
    }
}

@end
