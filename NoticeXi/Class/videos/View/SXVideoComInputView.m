//
//  SXVideoComInputView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoComInputView.h"

@implementation SXVideoComInputView

{
    CGFloat kebordHeight;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [rootWindow addSubview:self.backView];
        self.backView.hidden = YES;
        self.backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regFirst)];
        [self.backView addGestureRecognizer:tap];
        

        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        
        self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(15,8, DR_SCREEN_WIDTH-15-60, 34)];
        self.contentView.tintColor = GetColorWithName(VMainThumeColor);
        self.contentView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.contentView.delegate = self;
        self.contentView.font = FIFTHTEENTEXTFONTSIZE;
        self.contentView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentView.layer.cornerRadius = 34/2;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.contentView];
        
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(19,7, 200, 34)];
        _plaL.text = self.plaStr;
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self addSubview:_plaL];
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), 0.5, DR_SCREEN_WIDTH-CGRectGetMaxX(self.contentView.frame), 49.5)];
        sendBtn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
        self.sendButton = sendBtn;
                
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)showJustComment:(NSString *)commentId{
    self.hasClick = NO;
    self.commentId = commentId;
    [self.contentView becomeFirstResponder];
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
//    if (commentId) {
//    
//        self.replyToView = [[NoticeReplyToView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30)];
//        if (self.isHelp) {
//            self.replyToView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
//            self.replyToView.replyLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
//        }
//    }
    
    [self.backView removeFromSuperview];
    [rootWindow addSubview:self.backView];
    
    [rootWindow addSubview:self];
    
    [rootWindow bringSubviewToFront:self.backView];
    [rootWindow bringSubviewToFront:self];

    [rootWindow bringSubviewToFront:self];
}


- (void)regFirst{
    [self.contentView resignFirstResponder];

    self.backView.hidden = YES;
}


- (void)sendClick{
    
    if (!self.contentView.text.length) {
        [self.contentView resignFirstResponder];
        return;
    }
    
    
    if (self.hasClick) {
        return;
    }
    
    self.hasClick = YES;
    
    if(self.saveKey){
        [NoticeComTools removeWithKey:self.saveKey];
    }
    
    NSInteger num = self.limitNum?self.limitNum:500;
    if (self.contentView.text.length > num) {
        self.contentView.text = [self.contentView.text substringToIndex:num];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendWithComment: commentId:)]) {
        [self.delegate sendWithComment:self.contentView.text commentId:self.commentId];
    }

    self.contentView.text = @"";
    [self.contentView resignFirstResponder];
    
}


-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    self.backView.hidden = NO;

    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.frame.size.height, DR_SCREEN_WIDTH, self.frame.size.height);
    self.isresiger = NO;
    
    kebordHeight = keyboardF.size.height;
    self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame),self.frame.size.height-49.5,DR_SCREEN_WIDTH-CGRectGetMaxX(self.contentView.frame),49.5);

    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
//    if (self.commentId) {
//        [self.replyToView removeFromSuperview];
//        [rootWindow addSubview:self.replyToView];
//        self.replyToView.frame = CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30);
//        self.replyToView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
//        self.replyToView.replyLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
//     
//    }
    //self.backView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.frame.origin.y);
    
    //[rootWindow bringSubviewToFront:self.replyToView];
    [rootWindow bringSubviewToFront:self];
}

- (void)keyboardDiddisss{
    self.isresiger = YES;

    [self clearView];
    self.backView.hidden = YES;
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = 0;
    self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame),self.frame.size.height-49.5,DR_SCREEN_WIDTH-CGRectGetMaxX(self.contentView.frame),49.5);
    if (self.commentId) {
        //self.replyToView.frame = CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30);
    }

}

- (void)clearView{
 
    [self.backView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)setSaveKey:(NSString *)saveKey{
    _saveKey = saveKey;
    if(saveKey){
     
        NSString *saveContent = [NoticeComTools getInputWithKey:saveKey];
        if(saveContent && saveContent.length){
            self.contentView.text = saveContent;
      
          //  [self textViewDidChangeSelection:self.contentView];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    //获取高亮部分
    UITextPosition * position = [textView positionFromPosition:textView.markedTextRange.start offset:0];
    if(!position){
        if(self.saveKey){
            [NoticeComTools saveInput:textView.text saveKey:self.saveKey];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.text.length) {
        _plaL.text = @"";
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    }else{
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
       
        _plaL.text = self.plaStr;
    }
    CGRect frame = textView.frame;
    
    NSInteger num = self.limitNum?self.limitNum:500;

    if (textView.text.length > num) {
        textView.text = [textView.text substringToIndex:num];
    }
    float height;
    height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@",textView.text]];
    if (height > 70) {
        height = 70;
    }
    if (height <= 35) {
        height = 36;
    }
    frame.size.height = height;

    if (self.isresiger) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-(14+height)-self->kebordHeight-(self->kebordHeight>0?0:50), DR_SCREEN_WIDTH,14+height);

        if (self.commentId) {
            //self.replyToView.frame = CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30);
        }
        textView.frame = frame;
        self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame),self.frame.size.height-49.5,DR_SCREEN_WIDTH-CGRectGetMaxX(self.contentView.frame),49.5);
    } completion:nil];
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height+(size.size.height>36?10:0)+5;
    return textHeight;
}


- (void)setPlaStr:(NSString *)plaStr{
    _plaStr = plaStr;
    _plaL.text = self.contentView.text.length?@"": _plaStr;
}
@end
