//
//  SXSendWordView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSendWordView.h"

@implementation SXSendWordView



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

        self.userInteractionEnabled = YES;

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,330)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.backView];
        self.backView.userInteractionEnabled = YES;
        [self.backView setCornerOnTop:15];

        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-72-10,10,72,32)];
        [sendBtn setAllCorner:16];
        sendBtn.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [sendBtn setTitle:@"保存" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:sendBtn];
        self.sendButton = sendBtn;
    
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 52, 52)];
        [cancelBtn setImage:UIImageNamed(@"Image_closechange") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:cancelBtn];

        self.contentBackView = [[UIView alloc] initWithFrame:CGRectMake(20,60, DR_SCREEN_WIDTH-40,240)];
        self.contentBackView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.contentBackView.layer.cornerRadius = 10;
        self.contentBackView.layer.masksToBounds = YES;
        [self.backView addSubview:self.contentBackView];
        self.contentBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regFirst)];
        [self.contentBackView addGestureRecognizer:tap];
        
        self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(10,5, DR_SCREEN_WIDTH-40-20, 36-16)];
        self.contentView.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        self.contentView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.contentView.backgroundColor = [self.contentBackView.backgroundColor colorWithAlphaComponent:0];
        self.contentView.delegate = self;
        self.contentView.font = FOURTHTEENTEXTFONTSIZE;
        self.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.bounces = NO;
        self.contentView.clearsOnInsertion = YES;
        [self.contentBackView addSubview:self.contentView];
        [self.contentView becomeFirstResponder];
        
        self.plaStr = [NoticeTools getLocalStrWith:@"chat.sendTextPla"];
                
        self.plaStr = @"请输入祝福语";
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(13,5,DR_SCREEN_WIDTH-20-40, 36-16)];
        _plaL.text = self.plaStr;
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self.contentBackView addSubview:_plaL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-100,CGRectGetMaxY(self.contentBackView.frame)+10,100, 17)];
        numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        numL.font = TWOTEXTFONTSIZE;
        NSString *allStr = @"0/100";
        numL.textAlignment = NSTextAlignmentRight;
        numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:@"0" beginSize:0];
        [self.backView addSubview:numL];
        self.numL = numL;
        
        self.num = 500;
    }
    return self;
}

- (void)setPlaStr:(NSString *)plaStr{
    _plaStr = plaStr;
    _plaL.text = plaStr;
}

- (void)setNum:(NSInteger)num{
    _num = num;
    NSString *allStr = [NSString stringWithFormat:@"%lu/%ld",_contentView.text.length,(long)num];
    self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:[NSString stringWithFormat:@"%ld",_contentView.text.length] beginSize:0];

}

- (void)refreshViewHeight{
    [self textViewDidChangeSelection:self.contentView];
}



- (void)textViewDidChangeSelection:(UITextView *)textView{
 
    if (textView.text.length) {
        _plaL.text = @"";
       
        self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else{
        _plaL.text = self.plaStr;
        self.sendButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    }
    
    if (textView.text.length > self.num) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/%ld",textView.text.length,self.num] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",textView.text.length] beginSize:0];
        
    }else{
        NSString *allStr = [NSString stringWithFormat:@"%lu/%ld",textView.text.length,self.num];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#25262E"] setLengthString:[NSString stringWithFormat:@"%ld",textView.text.length] beginSize:0];
    }
    
    CGRect frame = textView.frame;
    float height;
    height = [self heightForTextView:textView WithText:textView.text];
    if (height > 230) {
        height = 230;
    }
    
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        textView.frame = frame;
    } completion:nil];
    
}

- (float)heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 0.0;
    return textHeight;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.backView.frame.size.height, DR_SCREEN_WIDTH, self.backView.frame.size.height);
   
}

- (void)keyboardDidHide{

    [self removeFromSuperview];
}

- (void)sendClick{
    if (!self.contentView.text.length) {
        [[NoticeTools getTopViewController] showToastWithText:@"请输入祝福语"];
        return;
    }
    if (self.contentView.text.length > self.num) {
        [[NoticeTools getTopViewController] showToastWithText:[NSString stringWithFormat:@"字数不能超过%ld字哦~",self.num]];
        return;
    }
    if (self.contentView.text.length) {
        [self.contentView resignFirstResponder];
        if (self.jubaoBlock) {
            self.jubaoBlock(self.contentView.text);
        }
        [self cancelClick];
    }
}

- (void)regFirst{
    [self.contentView becomeFirstResponder];
}

- (void)showView{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self.contentView becomeFirstResponder];
}

- (void)cancelClick{
    [self removeFromSuperview];
    [self.contentView resignFirstResponder];

}
@end
