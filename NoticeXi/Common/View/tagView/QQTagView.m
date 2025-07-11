//
//  QQTagView.m
//  QQtagView
//
//  Created by ZhangQun on 2017/4/8.
//  Copyright © 2017年 ZhangQun. All rights reserved.
//

#import "QQTagView.h"
#import "CustomBtn.h"
@implementation QQTagView

- (instancetype)init
{
    if (self = [super init]) {
        self.tagFontSize = 12;
        self.tagSpace = 10;
        self.padding = UIEdgeInsetsMake(10, 10, 10, 10);//控件的距离
//        self.tagTextPadding = UIEdgeInsetsMake(5, 10, 5, 10);
        self.Style = QQTagStyleNone;
    }
    return self;
}
- (instancetype)initWith:(QQTagStyle)TagViewStyle
{
    self = [super init];
    self.tagFontSize = 12;
    self.tagSpace = 5;
    self.Style = TagViewStyle;
    self.padding = UIEdgeInsetsMake(5,5,5,5);//控件的距离
    self.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
    return self;
}

- (void)QQTagItem:(QQTagItem *)QQTagItem
{
    if([self.delegate respondsToSelector:@selector(QQTagView:QQTagItem:)]) {
        [self.delegate QQTagView:self QQTagItem:QQTagItem];
    }
    
    if (QQTagItem.Style == QQTagStyleEditNone) {
        [QQTagItem removeFromSuperview];
    }
}

- (void)changeTagStatus:(QQTagStyle)TagStyle string:(NSString *)string
{
    for (QQTagItem *item in self.subviews) {
        if([self stringIsEquals:item.text to:string]) {
            [item changeItemType:TagStyle];
        }
    }
}
- (void)remove:(NSString *)text
{
    for (QQTagItem *item in self.subviews) {
        if([self stringIsEquals:item.text to:text]) {
            [item removeFromSuperview];
        }
    }
}
- (void)addTags:(NSArray *)tags
{
    for (int i = 0; i< tags.count; i++) {
        [self addLabel:tags[i] tag:i];
    }
}

- (void)addLabel:(NSString *)text tagId:(NSString *)tagId{
    CGRect frame = CGRectZero;
    if(self.subviews && self.subviews.count > 0) {
        frame = [self.subviews lastObject].frame;
    }
    
    QQTagItem *Item = [[QQTagItem alloc]init];
    Item.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    if (self.Style == QQTagStyleEditSlect) {
        UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        CustomBtn *button = [CustomBtn buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        button.frame = CGRectMake(4, 5, 16, 16);
        [button setBackgroundImage:UIImageNamed(@"Image_tagb") forState:UIControlStateNormal];
        button.info = Item;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightVeiw addSubview:button];
        Item.rightView = rightVeiw;
        Item.rightViewMode = UITextFieldViewModeAlways;
        Item.padding = UIEdgeInsetsMake(5,5,5, 26);//字体与控件的距离
        Item.Style = QQTagStyleEditNone;
        Item.EditShowColor = [UIColor colorWithHexString:@"#292B33"];
    }else{
        Item.padding = UIEdgeInsetsMake(10, 10, 10, 10);//字体与控件的距离
    }
    Item.text =text;
    Item.tagId = tagId;
    Item.mydelagete = self;
    Item.frame = CGRectMake(frame.origin.x, frame.origin.y, Item.frame.size.width, Item.frame.size.height);
    [Item sizeToFit];
    [self addSubview:Item];
}

- (void)addLabel:(NSString *)text tag:(NSInteger)tag {
    
    CGRect frame = CGRectZero;
    if(self.subviews && self.subviews.count > 0) {
        frame = [self.subviews lastObject].frame;
    }
    
    QQTagItem *Item = [[QQTagItem alloc]init];
    Item.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    if (self.Style == QQTagStyleEditSlect) {
        UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        CustomBtn *button = [CustomBtn buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        button.frame = CGRectMake(4, 5, 16, 16);
        [button setBackgroundImage:UIImageNamed(@"Image_tagb") forState:UIControlStateNormal];
        button.info = Item;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightVeiw addSubview:button];
        Item.rightView = rightVeiw;
        Item.rightViewMode = UITextFieldViewModeAlways;
        Item.padding = UIEdgeInsetsMake(5,5,5, 26);//字体与控件的距离
        Item.Style = QQTagStyleEditNone;
        Item.EditShowColor = [UIColor colorWithHexString:@"#292B33"];
    }else{
        Item.padding = UIEdgeInsetsMake(10, 10, 10, 10);//字体与控件的距离
    }
    Item.text =text;
    Item.tag = tag;
    Item.mydelagete = self;
    Item.frame = CGRectMake(frame.origin.x, frame.origin.y, Item.frame.size.width, Item.frame.size.height);
    [Item sizeToFit];
    [self addSubview:Item];

}
- (void)buttonClick:(CustomBtn *)btn
{
    [self QQTagItem:btn.info];
}
- (void)layoutSubviews {
    [UIView beginAnimations:nil context:nil];
    CGFloat paddingRight = self.padding.right;
    CGFloat cellspace = 5;
    CGFloat y = self.padding.top;
    CGFloat x = self.padding.left;
    CGRect frame;
    for(UIView *tag in self.subviews) {
        frame = tag.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        
        if(frame.origin.x + frame.size.width + paddingRight > self.frame.size.width) {
            // 换行
            frame.origin.x = self.padding.left;
            frame.origin.y = frame.origin.y + frame.size.height + cellspace;
            
            y = frame.origin.y;
        }
        
        if(frame.origin.x + frame.size.width > self.frame.size.width - paddingRight) {
            frame.size.width = self.frame.size.width - paddingRight - frame.origin.x;
        }
        
        x = frame.origin.x + frame.size.width + cellspace;
        tag.frame = frame;
    }
    CGFloat containerHeight = frame.origin.y + frame.size.height + self.padding.bottom;
    CGRect containerFrame = self.frame;
    containerFrame.size.height = containerHeight;
    self.frame = containerFrame;
    if([self.delegate respondsToSelector:@selector(QQTagView:sizeChange:)]) {
        [self.delegate QQTagView:self sizeChange:self.frame];
    }
    [UIView commitAnimations];
}
- (BOOL)stringIsEquals:(NSString *)string to:(NSString *)string2 {
    return [string isEqualToString:string2];
}@end
