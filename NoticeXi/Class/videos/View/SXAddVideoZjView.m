//
//  SXAddVideoZjView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAddVideoZjView.h"

@implementation SXAddVideoZjView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

        self.userInteractionEnabled = YES;

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,173)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.backView];
        [self.backView setCornerOnTop:20];
        self.backView.userInteractionEnabled = YES;
        
                
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        label.text = [NoticeTools getLocalStrWith:@"zj.creatnewzj"];
        label.font = XGTwentyBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        self.titleL = label;
        

        UILabel *cancelL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 50)];
        cancelL.userInteractionEnabled = YES;
        cancelL.font = SIXTEENTEXTFONTSIZE;
        cancelL.textColor = [UIColor colorWithHexString:@"#25262E"];
        cancelL.text = @"取消";
        UITapGestureRecognizer *cantap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [cancelL addGestureRecognizer:cantap];
        [self.backView addSubview:cancelL];
   
        self.sendButton = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-50, 0, 50, 50)];
        self.sendButton.text = @"完成";
        self.sendButton.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.sendButton.font = SIXTEENTEXTFONTSIZE;
        self.sendButton.userInteractionEnabled = YES;
        self.sendButton.textAlignment = NSTextAlignmentRight;
        [self.backView addSubview:self.sendButton];
        UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendClick)];
        [self.sendButton addGestureRecognizer:sendTap];
        
        self.contentBackView = [[UIView alloc] initWithFrame:CGRectMake(15,60, DR_SCREEN_WIDTH-30, 56)];
        self.contentBackView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentBackView.layer.cornerRadius = 8;
        self.contentBackView.layer.masksToBounds = YES;
        [self.backView addSubview:self.contentBackView];
        
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(10,0,self.contentBackView.frame.size.width-20-35, 56)];
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入专辑名称～" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
        self.nameField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        self.nameField.delegate = self;
        self.nameField.font =SIXTEENTEXTFONTSIZE;
        self.nameField.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.nameField.layer.cornerRadius = 5;
        self.nameField.layer.masksToBounds = YES;
        [self.nameField becomeFirstResponder];
        self.nameField.backgroundColor = self.contentBackView.backgroundColor;
        [self.contentBackView addSubview:self.nameField];
        [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(self.contentBackView.frame.size.width-10-35, 0, 35, 56)];
        self.numL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.numL.font = TWOTEXTFONTSIZE;
        self.numL.text = @"0/15";
        self.numL.textAlignment = NSTextAlignmentRight;
        [self.contentBackView addSubview:self.numL];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
      
   
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_contentBackView.frame)+10, DR_SCREEN_WIDTH-30, 16)];
        self.markL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.markL.font = TWOTEXTFONTSIZE;
        [self.backView addSubview:self.markL];
    }
    return self;
}

- (void)setIsChange:(BOOL)isChange{
    _isChange = isChange;
    if (isChange) {
        self.titleL.text = @"修改专辑";
    }
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.backView.frame.size.height, DR_SCREEN_WIDTH, self.backView.frame.size.height);

}

- (void)keyboardDiddisss{
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.backView.frame.size.height);
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    NSString *allStr = [NSString stringWithFormat:@"%ld/15",_field.text.length];
    NSString *lengStr = [NSString stringWithFormat:@"%ld",_field.text.length];
    if (_field.text.length <= 0) {
        self.numL.text = allStr;
    }else if(_field.text.length <= 15){
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#14151A"] setLengthString:lengStr beginSize:0];
    }else if (_field.text.length > 15){
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#EE4B4E"] setLengthString:lengStr beginSize:0];
    }
    
    self.sendButton.textColor = [UIColor colorWithHexString:_field.text.length?@"#1FC7FF":@"#A1A7B3"];
    
}

- (void)sendClick{
    if (self.nameField.text.length > 15) {
        self.markL.text = @"专辑名称不能超过15个字哦~";
        return;
    }
    if (self.nameField.text.length && self.nameField.text.length <= 15) {
        if (self.addBlock) {
            self.addBlock(self.nameField.text, self.isOpen);
        }
        [self.nameField resignFirstResponder];
    }
}
    
- (void)cancelClick{
    [self.nameField resignFirstResponder];
}
    
- (void)keyboardDidHide{
    [self removeFromSuperview];
}

- (void)show{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self.nameField becomeFirstResponder];
}

@end
