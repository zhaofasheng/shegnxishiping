//
//  SXAddNewsGoods2Cell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAddNewsGoods2Cell.h"

@implementation SXAddNewsGoods2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 100)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView setAllCorner:10];
        [self.contentView addSubview:self.backView];
        
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 120, 20)];
        markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        markL.font = XGFourthBoldFontSize;
        markL.attributedText = [DDHAttributedMode setColorString:@"*商品名称" setColor:[UIColor colorWithHexString:@"#EE4B4E"] setLengthString:@"*" beginSize:0];
        [self.backView addSubview:markL];

        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(15,43, DR_SCREEN_WIDTH-30, 21)];
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入商品名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
        
        self.nameField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        self.nameField.delegate = self;
        self.nameField.font = FIFTHTEENTEXTFONTSIZE;
        self.nameField.textColor = [UIColor colorWithHexString:@"#14151A"];

        //光标右移
        UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(15,0,7,30)];
        leftView.backgroundColor = [UIColor clearColor];
        self.nameField.leftView = leftView;
        self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.nameField.leftViewMode = UITextFieldViewModeAlways;
        [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.nameField setupToolbarToDismissRightButton];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-15-100, 17, 100, 17)];
        self.numL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.numL.font = THRETEENTEXTFONTSIZE;
        NSString *allStr = [NSString stringWithFormat:@"%d/20",0];
        self.numL.textAlignment = NSTextAlignmentRight;
        self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"10" beginSize:allStr.length-2];
        
        [self.backView addSubview:self.nameField];
        [self.backView addSubview:self.numL];
        
        self.backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputTap)];
        [self.backView addGestureRecognizer:tap];
    }
    return self;
}

- (void)inputTap{
    [self.nameField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if (_field == self.nameField) {
        if (_field.text.length > 20) {
            self.numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%lu/20",(unsigned long)_field.text.length] setColor:[UIColor redColor] setLengthString:[NSString stringWithFormat:@"%lu",_field.text.length] beginSize:0];
        }else{
         
            NSString *allStr = [NSString stringWithFormat:@"%lu/20",(unsigned long)_field.text.length];
            self.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"20" beginSize:allStr.length-2];
        }
    }
    if (self.nameBlock) {
        self.nameBlock(self.nameField.text);
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
