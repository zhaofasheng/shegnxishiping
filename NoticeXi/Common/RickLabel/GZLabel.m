//
//  GZLabel.m
//  GZKit
//
//  Created by 刘德华 on 17/3/22.
//  Copyright © 2017年 刘德华 All rights reserved.
//

#import "GZLabel.h"

@interface GZLabel()
/* 布局管理者 */
@property(nonatomic, strong)NSLayoutManager *layout;

/* 容器,需要设置容器的大小 */
@property(nonatomic, strong)NSTextContainer *textContainer;


/* NSMutableAttributeString的子类 */
@property(nonatomic, strong)NSTextStorage *GZTextString;


/* 点击类型 */
@property(nonatomic, assign)GZLabelStyle ClickStyle;

/* 用于记录用户选中的range */
@property(nonatomic, assign)NSRange selectedRange;

/* 用户记录点击还是松开 */
@property(nonatomic, assign)BOOL isSelected;

/* 用户文字颜色 */
@property(nonatomic, strong)UIColor *userHightColor;

/* 话题文字颜色 */
@property(nonatomic, strong)UIColor *topicHightColor;

/* 链接文字颜色 */
@property(nonatomic, strong)UIColor *linkHightColor;

/* 协议/政策文字颜色 */
@property(nonatomic, strong)UIColor *agreementHightColor;

/* 电话号码文字颜色 */
@property(nonatomic, strong)UIColor *PhoneNumberHightColor;

/* 链接范围 */
@property(nonatomic, strong)NSArray *linkRangesArr;

/* 用户名范围 */
@property(nonatomic, strong)NSArray *userRangesArr;

/* 话题范围 */
@property(nonatomic, strong)NSArray *topicRangesArr;

/* 协议/政策范围 */
@property(nonatomic, strong)NSArray *agreementRangesArr;

/* 电话号码范围 */
@property(nonatomic, strong)NSArray *PhoneNumberRangesArr;

/* 自定义要查找的范围 */
@property(nonatomic, strong)NSArray *userDefineRangesArr;

@end

@implementation GZLabel


static NSString *GZRange = @"gzrange";
static NSString *GZColor = @"gzcolor";
-(void)setHightLightLabelColor:(UIColor *)hightLightColor forGZLabelStyle:(GZLabelStyle)GZLabelStyle{
    switch (GZLabelStyle) {
        case GZLabelStyleLink:
        {
            self.linkHightColor = hightLightColor;
            [self prepareText];
        }
            break;
        case GZLabelStyleTopic:
        {
            self.topicHightColor = hightLightColor;
            [self prepareText];
        }
            break;
        case GZLabelStyleAgreement:
        {
            self.agreementHightColor = hightLightColor;
            [self prepareText];
        }
            break;
        case GZLabelStyleUser:
        {
            self.userHightColor = hightLightColor;
            [self prepareText];
        }
            break;
        case GZLabelStylePhoneNumber:
        {
            self.PhoneNumberHightColor = hightLightColor;
            [self prepareText];
        }
            break;
        default:
            break;
    }
}

-(void)setGZLabelNormalColor:(UIColor *)GZLabelNormalColor{
    _GZLabelNormalColor = GZLabelNormalColor;
    [self prepareText];
}

-(void)setGZLabelMatchArr:(NSArray<NSDictionary *> *)GZLabelMatchArr{
    _GZLabelMatchArr = GZLabelMatchArr;
    [self prepareText];
}


#pragma mark --------------------------------------------------
#pragma mark 重写系统的属性

-(void)setText:(NSString *)text{
    [super setText:text];
    [self prepareText];
}

-(void)setFont:(UIFont *)font{
    [super setFont:font];
    [self prepareText];
}

-(void)setTextColor:(UIColor *)textColor{
    [super setTextColor:textColor];
    [self prepareText];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    _GZTextString = [NSTextStorage new];
    _layout = [NSLayoutManager new];
    _textContainer = [NSTextContainer new];
    _GZLabelNormalColor = [UIColor colorWithRed:162.0/255 green:162.0/255  blue:162.0/255  alpha:162.0/255];
    _GZLabelHightLightBackgroundColor = [UIColor colorWithWhite:0.7 alpha:0.2];
    _PhoneNumberHightColor = _linkHightColor = _topicHightColor = _agreementHightColor = _userHightColor = [UIColor colorWithRed:64.0/255 green:64.0/255 blue:64.0/255 alpha:1];
    
    [self prepareTextSystem];
}


#pragma mark --------------------------------------------------
#pragma mark 系统回调

// 布局子控件
-(void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置容器的大小为Label的尺寸
    self.textContainer.size = self.frame.size;
}


// 重写drawTextInRect方法
-(void)drawRect:(CGRect)rect{
    
    // 不调用super就不会绘制原有文字
    //    [super drawRect:rect];
    
    // 1.绘制背景
    if (self.selectedRange.length != 0) {
        
        // 2.0.确定颜色
        UIColor *selectedColor = self.isSelected ? self.GZLabelHightLightBackgroundColor : [UIColor clearColor];
        
        // 2.1.设置颜色
        [self.GZTextString addAttribute:NSBackgroundColorAttributeName value:selectedColor range:self.selectedRange];
        
        // 2.2.绘制背景
        [self.layout drawBackgroundForGlyphRange:self.selectedRange atPoint:CGPointMake(0, 0)];
    }
    
    // 2.绘制字形
    // 需要绘制的范围
    NSRange range = NSMakeRange(0, self.GZTextString.length);
    [self.layout drawGlyphsForGlyphRange:range atPoint:CGPointZero];
}



#pragma mark --------------------------------------------------
#pragma mark Private

// 准备文本系统
-(void)prepareTextSystem{
    // 0.准备文本
    [self prepareText];
    
    // 1.将布局添加到storeage中
    [self.GZTextString addLayoutManager:self.layout];
    
    // 2.将容器添加到布局中
    [self.layout addTextContainer:self.textContainer];
    
    // 3.让label可以和用户交互
    self.userInteractionEnabled = YES;
    
    // 4.设置间距为0
    self.textContainer.lineFragmentPadding = 0;
}


// 准备文本
-(void)prepareText{

    // 1.准备字符串
    NSAttributedString *attrString = nil;
    if (self.attributedText != nil) {
        attrString = self.attributedText;
    }
    else if (self.text != nil){
        attrString = [[NSAttributedString alloc]initWithString:self.text];
    }
    else{
        attrString = [[NSAttributedString alloc]initWithString:@""];
    }
    
    if (attrString.length == 0) return;
    
    self.selectedRange = NSMakeRange(0, 0);
    
    // 2.设置换行模型
    NSMutableAttributedString *attrStringM = [self addLineBreak:attrString];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];

    // 3.给文本添加显示字号和颜色
    NSDictionary *attr;
    attr = @{
             NSFontAttributeName : self.font,
             NSForegroundColorAttributeName : self.GZLabelNormalColor,
             NSParagraphStyleAttributeName:paragraphStyle
             };
    
    [attrStringM setAttributes:attr range:NSMakeRange(0, attrStringM.length)];
    
    // 4.设置GZTextString的内容
    [self.GZTextString setAttributedString:attrStringM];
    
//    // 5.匹配URL
//    NSArray *linkRanges = [self getLinkRanges];
//    self.linkRangesArr = linkRanges;
//    for (NSValue *value in linkRanges) {
//        NSRange range;
//        [value getValue:&range];
//        
//        [self.GZTextString addAttribute:NSForegroundColorAttributeName value:self.linkHightColor range:range];
//    }
//    
//    // 6.匹配电话号码
//    NSArray *phoneNumberRanges = [self getPhoneNumberRanges];
//    self.PhoneNumberRangesArr = phoneNumberRanges;
//    for (NSValue *value in phoneNumberRanges) {
//        NSRange range;
//        [value getValue:&range];
//        [self.GZTextString addAttribute:NSForegroundColorAttributeName value:self.PhoneNumberHightColor range:range];
//    }
//
//    
//    // 7.匹配@用户
//    NSArray *userRanges = [self getRanges:@"@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"];
//    self.userRangesArr = userRanges;
//    for (NSValue *value in userRanges) {
//        NSRange range;
//        [value getValue:&range];
//        [self.GZTextString addAttribute:NSForegroundColorAttributeName value:self.userHightColor range:range];
//    }
//    
    // 8.匹配话题##
    NSArray *topicRanges = [self getRanges:@"「.*?」"];
    self.topicRangesArr = topicRanges;
    for (NSValue *value in topicRanges) {
        NSRange range;
        [value getValue:&range];
        [self.GZTextString addAttribute:NSForegroundColorAttributeName value:self.topicHightColor range:range];
    }
    
//    // 9.匹配协议/政策 << >>
//    NSArray *agreementRanges = [self getRanges:@"《([^》]*)》"];
//    self.agreementRangesArr = agreementRanges;
//    for (NSValue *value in agreementRanges) {
//        NSRange range;
//        [value getValue:&range];
//        [self.GZTextString addAttribute:NSForegroundColorAttributeName value:self.agreementHightColor range:range];
//    }
//    
//    // 10.匹配用户自定义的字符串
//    if (self.GZLabelMatchArr.count > 0) {
//        NSArray<NSDictionary *> *userDefineRangeDicts = [self getUserDefineStringsRange];
//        if (userDefineRangeDicts.count > 0) {
//            NSMutableArray *arrM = [NSMutableArray array];
//            for (NSDictionary *dict in userDefineRangeDicts) {
//                NSValue *value = dict[GZRange];
//                [arrM addObject:value];
//                UIColor *color = dict[GZColor];
//                NSRange range;
//                [value getValue:&range];
//                [self.GZTextString addAttribute:NSForegroundColorAttributeName value:color range:range];
//            }
//            self.userDefineRangesArr = [arrM copy];
//        }
//    }
    
    // 11.更新显示，重新绘制
    [self setNeedsDisplay];
}

#pragma mark 点击交互的封装

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 0.记录点击
    self.isSelected = YES;
    
    // 1.获取用户点击的点
    CGPoint selectedPoint = [[touches anyObject]locationInView:self];
    
    // 2.获取该点所在的字符串的range
    self.selectedRange = [self getSelectRange:selectedPoint];
    
    // 3.是否处理了事件
    if (self.selectedRange.length == 0) {
        [super touchesBegan:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.selectedRange.length == 0) {
        [super touchesEnded:touches withEvent:event];
        if ([self.delegate respondsToSelector:@selector(didSelecteNomer)]) {
            
            [self.delegate didSelecteNomer];
        }
        return;
    }
    
    // 0.记录松开
    self.isSelected = NO;
    
    // 2.重新绘制
    [self setNeedsDisplay];
    
    // 3.取出内容
    NSString *selectedString = [[self.GZTextString string] substringWithRange:self.selectedRange];
    
    // 3.回调
    switch (self.ClickStyle) {
        case GZLabelStyleAgreement:{
            __weak typeof(self) weakSelf = self;
            if (self.GZTapOperation) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if (strongSelf.GZTapOperation) {
                    strongSelf.GZTapOperation(strongSelf, GZLabelStyleAgreement, selectedString, strongSelf.selectedRange);
                }
            }
        }
            break;
        case GZLabelStyleLink:{
            __weak typeof(self) weakSelf = self;
            if (self.GZTapOperation) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if (strongSelf.GZTapOperation) {
                    strongSelf.GZTapOperation(strongSelf, GZLabelStyleLink, selectedString, strongSelf.selectedRange);
                }
            }
        }
            break;
        case GZLabelStyleTopic:{
            __weak typeof(self) weakSelf = self;
            if (self.GZTapOperation) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if (strongSelf.GZTapOperation) {
                    strongSelf.GZTapOperation(strongSelf, GZLabelStyleTopic, selectedString, strongSelf.selectedRange);
                }
            }
        }
            break;
        case GZLabelStyleUser:{
            __weak typeof(self) weakSelf = self;
            if (self.GZTapOperation) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if (strongSelf.GZTapOperation) {
                    strongSelf.GZTapOperation(strongSelf, GZLabelStyleUser, selectedString, strongSelf.selectedRange);
                }
            }
        }
            break;
        case GZLabelStyleUserDefine:{
            __weak typeof(self) weakSelf = self;
            if (self.GZTapOperation) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if (strongSelf.GZTapOperation) {
                    strongSelf.GZTapOperation(strongSelf, GZLabelStyleUserDefine, selectedString, strongSelf.selectedRange);
                }
            }
        }
            break;
        case GZLabelStylePhoneNumber:{
            __weak typeof(self) weakSelf = self;
            if (self.GZTapOperation) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if (strongSelf.GZTapOperation) {
                    strongSelf.GZTapOperation(strongSelf, GZLabelStylePhoneNumber, selectedString, strongSelf.selectedRange);
                }
            }
        }
            break;

        default:
            break;
    }
    
    // 4.代理
    if ([self.delegate respondsToSelector:@selector(GZLabel:didSelectedString:forGZLabelStyle:onRange:)]) {
        
        [self.delegate GZLabel:self didSelectedString:selectedString forGZLabelStyle:self.ClickStyle onRange:self.selectedRange];
    }
    
}

-(NSRange)getSelectRange:(CGPoint)selectPoint{
    // 0.如果属性字符串为nil,则不需要判断
    if (self.GZTextString.length == 0) return NSMakeRange(0, 0);
    
    // 1.获取选中点所在的下标值(index)
    NSUInteger index = [self.layout glyphIndexForPoint:selectPoint inTextContainer:self.textContainer];
    
    // 2.判断下标在什么内
    // 2.1.判断是否是一个链接
    for (NSValue *value in self.linkRangesArr) {
        NSRange range;
        [value getValue:&range];
        if (index > range.location && index < range.location + range.length) {
            [self setNeedsDisplay];
            self.ClickStyle = GZLabelStyleLink;
            return range;
        }
    }
    
    // 2.2.判断是否是一个@用户
    for (NSValue *value in self.userRangesArr) {
        NSRange range;
        [value getValue:&range];
        if (index > range.location && index < range.location + range.length) {
            [self setNeedsDisplay];
            self.ClickStyle = GZLabelStyleUser;
            return range;
        }
    }
    
    // 2.3.判断是否是一个#话题#
    for (NSValue *value in self.topicRangesArr) {
        NSRange range;
        [value getValue:&range];
        if (index > range.location && index < range.location + range.length) {
            [self setNeedsDisplay];
            self.ClickStyle = GZLabelStyleTopic;
            return range;
        }
    }
    
    // 2.4.判断是否是一个协议/政策 <<>>
    for (NSValue *value in self.agreementRangesArr) {
        NSRange range;
        [value getValue:&range];
        if (index > range.location && index < range.location + range.length) {
            [self setNeedsDisplay];
            self.ClickStyle = GZLabelStyleAgreement;
            return range;
        }
    }
    
    // 2.5.判断是否是一个用户自定义要匹配的字符串
    for (NSValue *value in self.userDefineRangesArr) {
        NSRange range;
        [value getValue:&range];
        if (index > range.location && index < range.location + range.length) {
            [self setNeedsDisplay];
            self.ClickStyle = GZLabelStyleUserDefine;
            return range;
        }
    }
    // 2.6.判断是否是一个电话号码
    for (NSValue *value in self.PhoneNumberRangesArr) {
        NSRange range;
        [value getValue:&range];
        if (index > range.location && index < range.location + range.length) {
            [self setNeedsDisplay];
            self.ClickStyle = GZLabelStylePhoneNumber;
            return range;
        }
    }
    
    return NSMakeRange(0, 0);
}

#pragma mark 字符串匹配封装

// 查找用户给定的字符串的range
-(NSArray<NSDictionary*> *)getUserDefineStringsRange{
    
    if (self.GZLabelMatchArr.count == 0) return nil;
    
    NSMutableArray<NSDictionary*> *arrM = [NSMutableArray array];
    
    NSString *str = [self.GZTextString string];
    for (NSDictionary *dict in self.GZLabelMatchArr) {
        NSString *subStr = dict[@"string"];
        UIColor *color = dict[@"color"];
        // 没传入字符串
        if (!subStr) return nil;
        
        NSRange range = [str rangeOfString:subStr];
        
        // 没找到
        if (range.length == 0) continue;
        
        NSValue *value = [NSValue valueWithBytes:&range objCType:@encode(NSRange)];
        NSMutableDictionary *aDictM = [NSMutableDictionary dictionary];
        aDictM[GZRange] = value;
        aDictM[GZColor] = color;
        [arrM addObject:[aDictM copy]];
    }
    
    return [arrM copy];
}

-(NSArray *)getRanges:(NSString *)pattern{
    
    // 创建正则表达式对象
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:&error];
    
    return [self getRangesFromResult:regex];
}

-(NSArray *)getLinkRanges{
    // 创建正则表达式
    NSError *error;
    NSDataDetector *detector = [NSDataDetector  dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    return [self getRangesFromResult:detector];
}

-(NSArray *)getPhoneNumberRanges{
    // 创建正则表达式
    NSError *error;
    NSDataDetector *detector = [NSDataDetector  dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    return [self getRangesFromResult:detector];
}

-(NSArray *)getRangesFromResult:(NSRegularExpression *)regex{
    
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:[self.GZTextString string] options:0 range:NSMakeRange(0, self.GZTextString.length)];
    // 2.遍历结果
    NSMutableArray *ranges = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        // 将结构体保存到数组
        // 先用一个变量接受结构体
        NSRange range = result.range;
        NSValue *value = [NSValue valueWithBytes:&range objCType:@encode(NSRange)];
        [ranges addObject:value];
    }
    return ranges;
}


#pragma mark --------------------------------------------------
#pragma mark Extesion

// 如果用户没有设置lineBreak,则所有内容会绘制到同一行中,因此需要主动设置
-(NSMutableAttributedString *)addLineBreak:(NSAttributedString *)attrString{
    
    NSMutableAttributedString *attrStringM = [attrString mutableCopy];
    
    if (attrStringM.length == 0) return attrStringM;
    
    NSRange range = NSMakeRange(0, 0);
    NSMutableDictionary *attributes = [[attrStringM attributesAtIndex:0 effectiveRange:&range] mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [attributes[NSParagraphStyleAttributeName] mutableCopy];
    
    if (paragraphStyle != nil) {
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    else{
        paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
        
        [attrStringM setAttributes:attributes range:range];
    }
    return attrStringM;
}


@end
