//
//  NoticeChangeNameViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeNameViewController.h"
#import "DDHAttributedMode.h"
@interface NoticeChangeNameViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation NoticeChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navBarView.titleL.text = @"用户名";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(68,NAVIGATION_BAR_HEIGHT+200+NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH-68*2, 56);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = XGTwentyBoldFontSize;
    btn.layer.cornerRadius = 56/2;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:1];
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.saveButton = btn;
   
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 20+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-40, 56)];
    backV.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    [backV setAllCorner:8];
    [self.view addSubview:backV];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(10,0, DR_SCREEN_WIDTH-50, 56)];
    self.nameField.text = self.name;
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"这个名字最多十个字" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
    
    self.nameField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    self.nameField.delegate = self;
    self.nameField.font =FIFTHTEENTEXTFONTSIZE;
    self.nameField.textColor = [UIColor colorWithHexString:@"#14151A"];

    [backV addSubview:self.nameField];
    
    //光标右移
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(15,0,7,30)];
    leftView.backgroundColor = [UIColor clearColor];
    self.nameField.leftView = leftView;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backV.frame)+10, 100, 13)];
    self.numL.textColor = [UIColor colorWithHexString:@"#14151A"];
    self.numL.font = THRETEENTEXTFONTSIZE;
    NSString *allStr = [NSString stringWithFormat:@"%lu/10",self.name.length];
    self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"10" beginSize:allStr.length-2];
    [self.view addSubview:self.numL];

}

- (void)fifinshClick{
    

    if ([self.nameField.text isEqualToString:self.name]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.nameField.text.length > 10) {
        [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.tosatname"]];
        return;
    }
    [self showHUD];
    
    NSString *url = nil;
    url = [NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.nameField.text.length > 10? [self.nameField.text substringToIndex:10] :self.nameField.text forKey:@"nickName"];
    if (self.isBeizhu && !self.nameField.text.length) {
        [parm setObject:self.trueName forKey:@"nickName"];
    }
    
    [[DRNetWorking shareInstance] requestWithPatchPath:url Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            if (!self.isBeizhu) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUSERINFORNOTICATION" object:nil];
                
                NoticeUserInfoModel *infoM = [NoticeSaveModel getUserInfo];
                infoM.nick_name = self.nameField.text.length > 10? [self.nameField.text substringToIndex:10] :self.nameField.text;
                [NoticeSaveModel saveUserInfo:infoM];
            }
            
            if (self.isBeizhu) {
                if (self.sessionId) {
                    NoticeSaveName *nameM = [[NoticeSaveName alloc] init];
                    nameM.sessionId = self.sessionId;
                    nameM.name = self.nameField.text;
                    [NoticeTools saveSessionWith:nameM];
                }
                if (self.nameBlock) {
                    self.nameBlock(self.nameField.text.length > 10? [self.nameField.text substringToIndex:10] :self.nameField.text);
                }
            }
            
            [UIView animateWithDuration:1 animations:^{
                [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.changesus"]];
            } completion:^(BOOL finished) {
                 [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if (_field.text.length > 10) {
        self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/10",(unsigned long)_field.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",_field.text.length] beginSize:0];
        self.saveButton.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:0.5];
    }else{
        if (_field.text.length) {
            self.saveButton.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:1];
        }else{
            self.saveButton.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:0.5];
        }
        NSString *allStr = [NSString stringWithFormat:@"%lu/10",(unsigned long)_field.text.length];
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"10" beginSize:allStr.length-2];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

@end
