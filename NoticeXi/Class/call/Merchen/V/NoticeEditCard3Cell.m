//
//  NoticeEditCard3Cell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeEditCard3Cell.h"
#import "NoticeJuBaoBoKeTosatView.h"
@implementation NoticeEditCard3Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 108)];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:backView];
        self.backView = backView;
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,DR_SCREEN_WIDTH-60,21)];
        self.nameL.font = FIFTHTEENTEXTFONTSIZE;
        self.nameL.numberOfLines = 0;
        self.nameL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.nameL.text = @"写下你的故事，让Ta更了解你…";
        [backView addSubview:self.nameL];
        self.nameL.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        backView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIntro)];
        [backView addGestureRecognizer:tap1];
    }
    return self;
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    if (shopModel.myShopM.tale && shopModel.myShopM.tale.length) {
        self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, ((shopModel.myShopM.taleHeight>88)?(shopModel.myShopM.taleHeight+20):108));
        self.nameL.frame = CGRectMake(10, 10, DR_SCREEN_WIDTH-60, shopModel.myShopM.taleHeight);
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.nameL.attributedText = shopModel.myShopM.taleAtstr;
    }else{
        self.nameL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
}

- (void)changeIntro{
    if (self.justShow) {
        if (self.editShopBlock) {
            self.editShopBlock(YES);
        }
        return;
    }
    NoticeJuBaoBoKeTosatView *jubaoV = [[NoticeJuBaoBoKeTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    jubaoV.plaStr = @"写下你的故事，让Ta更了解你…";
    jubaoV.num = 80;
    jubaoV.noDissmiss = YES;
    [jubaoV.sendButton setTitle:@"保存" forState:UIControlStateNormal];
    if (_shopModel.myShopM.tale && _shopModel.myShopM.tale.length) {
        jubaoV.contentView.text = _shopModel.myShopM.tale;
        [jubaoV refreshViewHeight];
    }
    jubaoV.titleL.text = @"我的故事";
    __block NoticeJuBaoBoKeTosatView *strongBlock = jubaoV;
    [jubaoV showView];
    __weak typeof(self) weakSelf = self;
    jubaoV.jubaoBlock = ^(NSString * _Nonnull content) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:content forKey:@"tale"];
        [[NoticeTools getTopViewController] showHUD];
        
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@",weakSelf.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success1) {
            [[NoticeTools getTopViewController] hideHUD];

            if (success1) {
                [strongBlock removeFromSuperview];
                [strongBlock cancelClick];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
            }else{
                NoticeOneToOne *msgModel = [NoticeOneToOne mj_objectWithKeyValues:dict];
                if (msgModel.chatM.keyword.count) {
                    for (NSString *str in msgModel.chatM.keyword) {
                        [weakSelf setStroyRedColor:str sourceString:strongBlock.contentView.text textView:strongBlock.contentView att:weakSelf.attStroy];
                    }
                }else{
                    [strongBlock removeFromSuperview];
                    [strongBlock cancelClick];
                }
            }
        } fail:^(NSError * _Nullable error) {
            [strongBlock removeFromSuperview];
            [strongBlock cancelClick];
            [[NoticeTools getTopViewController] hideHUD];
        }];
    };
}

- (void)setStroyRedColor:(NSString *)redString sourceString:(NSString *)sourchString textView:(UITextView*)textView att:(NSMutableAttributedString *)att{
    if (!att) {
        att =  [[NSMutableAttributedString alloc]initWithString:sourchString];
        self.attStroy = att;
    }
    NSMutableAttributedString *nameString =  att;
    for (int i = 0; i < sourchString.length; i++) {
        if ((sourchString.length - i) < redString.length) {  //防止遍历剩下的字符少于搜索条件的字符而崩溃
            
        }else {
            NSString *str = [sourchString substringWithRange:NSMakeRange(i, redString.length)];
            if ([redString isEqualToString:str]) {
                [nameString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, redString.length)];
                
                i = i + (int)(redString.length) - 1;
            }
        }
    }
    [nameString addAttribute:NSFontAttributeName value:FOURTHTEENTEXTFONTSIZE range:NSMakeRange(0, textView.text.length)];
    textView.attributedText = nameString;
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
