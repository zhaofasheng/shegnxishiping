//
//  NoticeLyTableViewCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/27.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeLyTableViewCell.h"

@implementation NoticeLyTableViewCell
{
    UILabel *_liuyL;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _liuyL = [[UILabel alloc] init];
        _liuyL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _liuyL.numberOfLines = 0;
        _liuyL.font = FOURTHTEENTEXTFONTSIZE;
        [self.contentView addSubview:_liuyL];
        
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longDleTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longDeleteVoice:)];
        longDleTap.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longDleTap];
    }
    return self;
}

- (void)longDeleteVoice:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;

    //py.dele  删除  chat.jubao 举报
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
       
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if(buttonIndex == 1){
                    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
                    [pastboard setString:self.liuyan.justcontent];
                    [[NoticeTools getTopViewController] showToastWithText:@"已复制"];
                }
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"group.copy"]]];
       
            [sheet show];
            break;
        }
        default:
            break;
    }
}

- (void)setLiuyan:(NoticeLy *)liuyan{
    _liuyan = liuyan;
    _liuyL.attributedText = liuyan.allTextAttStr;
    _liuyL.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, liuyan.height);
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
