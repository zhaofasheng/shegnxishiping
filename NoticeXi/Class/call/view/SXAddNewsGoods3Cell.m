//
//  SXAddNewsGoods3Cell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAddNewsGoods3Cell.h"

@implementation SXAddNewsGoods3Cell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 50)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView setAllCorner:10];
        [self.contentView addSubview:self.backView];
        
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 50, 20)];
        markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        markL.font = XGFourthBoldFontSize;
        markL.attributedText = [DDHAttributedMode setColorString:@"*价格" setColor:[UIColor colorWithHexString:@"#EE4B4E"] setLengthString:@"*" beginSize:0];
        [self.backView addSubview:markL];

        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-41-100,0, 100, 50)];

        self.nameField.keyboardType = UIKeyboardTypeNumberPad;
        self.nameField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        self.nameField.delegate = self;
        self.nameField.font = SXNUMBERFONT(22);
        self.nameField.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        self.nameField.textAlignment = NSTextAlignmentRight;
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入商品价格" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF68A3"]}];
        [self.nameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.nameField setupToolbarToDismissRightButton];
    
        
        [self.backView addSubview:self.nameField];
        
        self.backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputTap)];
        [self.backView addGestureRecognizer:tap];
        
        UILabel *markL1 = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameField.frame)+2, 0,GET_STRWIDTH(@"鲸币", 12, 50), 50)];
        markL1.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        markL1.font = TWOTEXTFONTSIZE;
        markL1.text = @"鲸币";
        [self.backView addSubview:markL1];
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

    if (self.priceBlock) {
        self.priceBlock(self.nameField.text);
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
