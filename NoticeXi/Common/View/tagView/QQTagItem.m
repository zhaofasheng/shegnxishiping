//
//  QQTagItem.m
//  QQtagView
//
//  Created by ZhangQun on 2017/4/8.
//  Copyright © 2017年 ZhangQun. All rights reserved.
//

#import "QQTagItem.h"

@implementation QQTagItem
- (instancetype)init
{
    if (self = [super init]) {
        self.textColor = GetColorWithName(VMainTextColor);
        self.font = [UIFont systemFontOfSize:15];
        self.textAlignment = NSTextAlignmentCenter;
        self.delegate = self;
        self.tintColor = [UIColor clearColor];
        self.backgroundColor = GetColorWithName(VBackColor);
    }
    return self;
}
-(void)textFieldDidBeginEditing:(UITextField*)textField

{
    [textField resignFirstResponder];
    NSLog(@"string");
//设置选中与正常颜色
    if (self.Style == QQTagStyleNone) {
        self.Style = QQTagStyleSlect;
    }else if(self.Style == QQTagStyleSlect){
        self.Style = QQTagStyleNone;
    }else {
        
    }
    
    if ([self.mydelagete respondsToSelector:@selector(QQTagItem:)]) {
        [self.mydelagete QQTagItem:self];
    }
    
}
- (void)changeItemType:(QQTagStyle)tagType
{
    if (tagType == QQTagStyleNone) {

        _Style = QQTagStyleSlect;
    }else if(tagType == QQTagStyleSlect){

        _Style = QQTagStyleNone;
    }else {
        
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    
    return YES;
    
}
- (void)setEditShowColor:(UIColor *)EditShowColor
{
    self.backgroundColor = EditShowColor;
}
//设置文字的边距
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + self.padding.left,
                      bounds.origin.y + self.padding.top,
                      bounds.size.width - self.padding.right - self.padding.left,
                      bounds.size.height - self.padding.bottom - self.padding.bottom);
}
- (void)setPadding:(UIEdgeInsets)padding
{
    _padding = padding;
    
}
//叉号的位置也可以这么重写  我使用right View 实现的
//- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
//    
//    CGFloat x = CGRectGetMaxX(bounds) - 19 - 5;
//    CGFloat y =  CGRectGetMidY(bounds) - 19/2;
//    CGFloat w = 19;
//    CGFloat h = 19;
//    return CGRectMake(x, y, w, h);
//    
//}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end
