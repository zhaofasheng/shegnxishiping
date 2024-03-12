//
//  NoticeChangeIntroduceViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeIntroduceViewController.h"
#import "DDHAttributedMode.h"
@interface NoticeChangeIntroduceViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITextView *nameField;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) NSMutableAttributedString *attStr1;
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation NoticeChangeIntroduceViewController
{
    UILabel *_plaL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navBarView.titleL.text = @"文字简介";

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 12+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-30, 100)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    [backView setAllCorner:5];
    [self.view addSubview:backView];
    

    self.nameField = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, DR_SCREEN_WIDTH-30, 30)];
    self.nameField.text = self.induce;
    self.nameField.backgroundColor = backView.backgroundColor;
    self.nameField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    if ([[NoticeSaveModel getUserInfo] self_intro]) {
        self.nameField.text = [[NoticeSaveModel getUserInfo] self_intro];
    }

    self.nameField.delegate = self;
    self.nameField.font =FIFTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#14151A"];
    [backView addSubview:self.nameField];
    
    _plaL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 14)];
    
    if ([[NoticeSaveModel getUserInfo] self_intro].length) {
        _plaL.text = @"";
    }else{
        _plaL.text = @"请输入你的文字简介哦～";
    }
    
    if(self.induce && self.isBoKeIntro){
        _plaL.text = @"";
    }
    
    _plaL.font = FIFTHTEENTEXTFONTSIZE;
    _plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [backView addSubview:_plaL];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(backView.frame)+10,50, 13)];
    self.numL.textColor = [UIColor colorWithHexString:@"#14151A"];
    self.numL.font = TWOTEXTFONTSIZE;

    NSString *allStr = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.induce.length,self.isBoKeIntro?@"80":@"20"];
    self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"20" beginSize:allStr.length-2];
    [self.view addSubview:self.numL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(68,CGRectGetMaxY(self.numL.frame)+64,DR_SCREEN_WIDTH-68*2, 56);
    [btn setTitle:[NoticeTools getLocalStrWith:@"groupManager.save"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = XGTwentyBoldFontSize;
    btn.layer.cornerRadius = 56/2;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:1];
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.saveButton = btn;
}

- (void)setRedColor:(NSString *)redString sourceString:(NSString *)sourchString textView:(UITextView*)textView att:(NSMutableAttributedString *)att{
    if (!att) {
        att =  [[NSMutableAttributedString alloc]initWithString:sourchString];
        self.attStr1 = att;
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
    [nameString addAttribute:NSFontAttributeName value:FIFTHTEENTEXTFONTSIZE range:NSMakeRange(0, textView.text.length)];
    textView.attributedText = nameString;
}

- (void)fifinshClick{
    if (!self.nameField.text.length) {
        return;
    }
    if (self.nameField.text.length > 20) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.tosat"]];
        return;
    }

    [self showHUD];

    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];

    [parm setObject:self.nameField.text.length > 20? [self.nameField.text substringToIndex:20] :self.nameField.text forKey:@"selfIntro"];
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
            NoticeUserInfoModel *infoM = [NoticeSaveModel getUserInfo];
            infoM.self_intro = self.nameField.text.length > 20? [self.nameField.text substringToIndex:20] :self.nameField.text;
            [NoticeSaveModel saveUserInfo:infoM];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    if (height > 90) {
        height = 90;
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        textView.frame = frame;
    } completion:nil];
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    self.attStr1 = nil;
    if (textView.text.length) {
        _plaL.text = @"";
    }else{
        _plaL.text = @"请输入你的文字简介哦～";
    }
    
    if (textView.text.length > 20) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/%@",textView.text.length,self.isBoKeIntro?@"80":@"20"] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
        self.saveButton.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:0.5];
    }else{
        if (textView.text.length) {
            self.saveButton.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:1];
        }else{
            self.saveButton.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:0.5];
        }
        NSString *allStr = [NSString stringWithFormat:@"%lu/%@",textView.text.length,self.isBoKeIntro?@"80":@"20"];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"20" beginSize:allStr.length-2];
    }
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}


@end
