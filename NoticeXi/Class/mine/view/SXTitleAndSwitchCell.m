//
//  SXTitleAndSwitchCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXTitleAndSwitchCell.h"

@implementation SXTitleAndSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     

        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 52)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        _mainL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0,DR_SCREEN_WIDTH-40-15-44, 52)];
        _mainL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _mainL.font = XGFifthBoldFontSize;
        [self.backView addSubview:_mainL];
        
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-44-15,14,44,24)];
        _switchButton.onTintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        _switchButton.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _switchButton.tintColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_switchButton addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventValueChanged];
        [self.backView addSubview:_switchButton];
        _switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
        

    }
    return self;
}

- (void)onStatusDelegate{
    if(_mySwitch.OnStatus){
        [_mySwitch setBackgroundImage:[UIImage imageNamed:@"Imageonset"]];
    }else{
        [_mySwitch setBackgroundImage:[UIImage imageNamed:@"Imageoffset"]];
    }
}
- (void)changeVale:(UISwitch *)switchbutton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceTag:withIsOn: section:)]) {
        [self.delegate choiceTag:self.choiceTag withIsOn:switchbutton.isOn section:self.choiceSection];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
