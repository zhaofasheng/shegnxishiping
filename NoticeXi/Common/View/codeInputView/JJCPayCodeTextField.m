//
//  JJCPayCodeTextField.m
//  JJCPayCodeTextField
//
//  Created by 苜蓿鬼仙 on 2017/8/2.
//  Copyright © 2017年 苜蓿鬼仙. All rights reserved.
//

#import "JJCPayCodeTextField.h"
#import "JJCPayCodeTextFieldCell.h"
#import <YYKit/YYKit.h>


@interface JJCPayCodeTextField ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (nonatomic, assign) JJCPayCodeTextFieldType textFieldType;    // 样式

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *originArrayM;         // 最初始的空数组
@property (nonatomic, strong) NSMutableArray *dataArrayM;           // 要显示的数组（中间变量）
@property (nonatomic, strong) NSMutableArray *ciphertextArrayM;     // 密文 数组
@property (nonatomic, strong) NSMutableArray *plaintextArrayM;      // 明文 数组

@property (nonatomic, copy)   NSString *currentInputString; // 当前输入的字符

@end

@implementation JJCPayCodeTextField


static NSString *const reuseId = @"JJCPayCodeTextFieldCell";


- (instancetype)initWithFrame:(CGRect)frame TextFieldType:(JJCPayCodeTextFieldType)textFieldType {
    
    if (self = [super initWithFrame:frame]) {
        
        self.textFieldType = textFieldType;
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        //self.textField.keyboardAppearance = UIKeyboardAppearanceDark;
        
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self collectionView];
    [self.textField becomeFirstResponder];
}


#pragma mark -----
#pragma mark ---------------  Lazy Loading  ---------------

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.userInteractionEnabled = NO;
        [self addSubview:_collectionView];
        
        
        [_collectionView registerClass:[JJCPayCodeTextFieldCell class] forCellWithReuseIdentifier:reuseId];
    }
    return _collectionView;
}


- (NSMutableArray *)dataArrayM {
    if (!_dataArrayM) {
        
        if (self.textFieldNum == 0) {
            self.textFieldNum = 8;
        }
        
        _dataArrayM       = [NSMutableArray array];
        _ciphertextArrayM = [NSMutableArray array];
        _plaintextArrayM  = [NSMutableArray array];
        
        self.currentInputString = @"";
        
        NSString *string = @"";
        
        for (int i=0; i < self.textFieldNum; i++) {
            [_dataArrayM addObject:string];
            [_ciphertextArrayM addObject:string];
            [_plaintextArrayM addObject:string];
        }
        
        _originArrayM = [NSMutableArray arrayWithArray:[_dataArrayM copy]];
    }
    return _dataArrayM;
}


- (UITextField *)textField {
    if (!_textField) {
        
        _textField = [[JJCTextField alloc] initWithFrame:self.bounds];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.textColor = [UIColor clearColor];
        _textField.tintColor = [UIColor clearColor];
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        [self addSubview:_textField];
    }
    return _textField;
}


- (void)setIsChangeTextFieldNum:(BOOL)isChangeTextFieldNum {
    
    _isChangeTextFieldNum = isChangeTextFieldNum;
}


- (void)setTextFieldNum:(NSInteger)textFieldNum {
    
    _textFieldNum = textFieldNum;
    
    
    if (self.isChangeTextFieldNum) {
        if (textFieldNum > self.dataArrayM.count) {     // 增加长度
            for (int i=0; i < (textFieldNum-self.dataArrayM.count); i++) {
                [self.plaintextArrayM addObject:@""];
                [self.ciphertextArrayM addObject:@""];
                [self.originArrayM addObject:@""];
            }
        } else {    // 减小长度
            textFieldNum = textFieldNum < 0 ? 0:textFieldNum;   // 此判断用来防止无输入长度小于0的情况
            [self.plaintextArrayM replaceObjectsInRange:NSMakeRange(textFieldNum, self.dataArrayM.count-textFieldNum) withObjectsFromArray:@[]];
            [self.ciphertextArrayM replaceObjectsInRange:NSMakeRange(textFieldNum, self.dataArrayM.count-textFieldNum) withObjectsFromArray:@[]];
            [self.originArrayM replaceObjectsInRange:NSMakeRange(textFieldNum, self.dataArrayM.count-textFieldNum) withObjectsFromArray:@[]];
        }
    }
    
    
    [self updateData];
}


- (void)setIsShowTrueCode:(BOOL)isShowTrueCode {
    
    _isShowTrueCode = isShowTrueCode;
    
    [self updateData];
}


- (void)setBorderSpace:(CGFloat)borderSpace {
    
    _borderSpace = borderSpace < 0 ? 0:borderSpace;     // 防止输入间距小于0 的情况
    
    [self updateData];
}


- (void)setBorderColor:(UIColor *)borderColor {
    
    _borderColor = borderColor;
    
    [self updateData];
}



#pragma mark -----
#pragma mark ---------------  UICollectionViewDataSource、UICollectionViewDelegateFlowLayout  ---------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArrayM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JJCPayCodeTextFieldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    cell.indePath = indexPath;
    cell.cellNum  = self.dataArrayM.count;
    cell.cellType = (NSInteger)self.textFieldType;
    cell.titleString = self.dataArrayM[indexPath.row];
    cell.cellBorderColor = self.borderColor;
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.textFieldType == JJCPayCodeTextFieldTypeSpaceBorder) {
        return CGSizeMake(self.frame.size.width/self.textFieldNum-self.borderSpace-0.005, self.frame.size.height);
    } else {
        return CGSizeMake(self.frame.size.width/self.textFieldNum-0.005, self.frame.size.height);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    if (self.textFieldType == JJCPayCodeTextFieldTypeSpaceBorder) {
        return self.borderSpace;
    } else {
        return 0;
    }
}


#pragma mark -----
#pragma mark ---------------  Method  ---------------

/** 清除已输入的支付密码 **/
- (void)clearKeyCode {
    
    self.dataArrayM       = [NSMutableArray arrayWithArray:[self.originArrayM copy]];
    self.plaintextArrayM  = [NSMutableArray arrayWithArray:[self.originArrayM copy]];
    self.ciphertextArrayM = [NSMutableArray arrayWithArray:[self.originArrayM copy]];
    
    
    self.currentInputString = @"";
    self.textField.text = @"";
    self.payCodeString = @"";
    [self.collectionView reloadData];
}


#pragma mark -----
#pragma mark ---------------  UITextFieldDelegate  ---------------

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (self.payCodeString.length != 0) {
        self.textField.text = self.payCodeString;
    }
    
    if (textField.text.length == self.textFieldNum-1) {
        self.textField.text = @"";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    NSLog(@"text -- %@, string -- %@, location -- %zd, length -- %zd", textField.text, string, range.location, range.length);
    
    
    if (range.length != 0) {
        
        // 此处处理联想输入的时候，引起的可以一次性输入多个字符问题
        if (string.length > 0) {    // 联想输入处理
            return NO;
        } else {    // 删除
            
            self.currentInputString = @"";
            
            [_plaintextArrayM replaceObjectAtIndex:range.location withObject:string];
            string = @"";
            [_ciphertextArrayM replaceObjectAtIndex:range.location withObject:string];
            
            [self updateData];
            return YES;
        }
    } else {    // 添加
        
        if (![self isInputRuleAndNumber:string]) {
            return NO;
        }
        
        if (string.length > 1) {
            return NO;
        }
        
        if (textField.text.length >= self.textFieldNum) {
            
            self.currentInputString = @"";
            
            [self updateData];
            return NO;
            
        } else {
            
            self.currentInputString = string;
            
            [_plaintextArrayM replaceObjectAtIndex:range.location withObject:string];
            if (self.ciphertext && self.ciphertext.length == 1) {
                string = self.ciphertext;
            } else {
                string = @"●";
            }
            [_ciphertextArrayM replaceObjectAtIndex:range.location withObject:string];
            
            [self updateData];
            return YES;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}


- (void)updateData {
    
    [self dataArrayM];      // 防止未创建时就调用
    
    self.payCodeString = [self.plaintextArrayM componentsJoinedByString:@""];
    
    
    if (self.isShowTrueCode) {
        self.dataArrayM = [NSMutableArray arrayWithArray:[self.plaintextArrayM copy]];
    } else {
        self.dataArrayM = [NSMutableArray arrayWithArray:[self.ciphertextArrayM copy]];
    }
    
    [_collectionView reloadData];
    
    
    if (self.currentBlock) {
        self.currentBlock(self.payCodeString, self.currentInputString);
    }
    
    
    if (self.payCodeString.length == self.textFieldNum) {
        
        [self textFieldDidEndEditing:self.textField];
        
        if (self.finishedBlock) {
            self.finishedBlock(self.payCodeString);
        }
    }
}


/********************  限制字符样式  *******************/
/**
 pattern中,输入需要验证的通过的字符
 小写a-z
 大写A-Z
 汉字\u4E00-\u9FA5
 数字\u0030-\u0039
 @param string 要过滤的字符
 @return YES 只允许输入字母和数字
 */
- (BOOL)isInputRuleAndNumber:(NSString *)string {
    
    NSString *pattern = @"[a-zA-Z0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}




@end







