//
//  SXVideosModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideosModel.h"

@implementation SXVideosModel


- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.nomerHeight = GET_STRHEIGHT(title, 13, (DR_SCREEN_WIDTH-15)/2-18);
    if (self.nomerHeight > 36) {
        self.nomerHeight = 36;
    }
    
    self.titleHeight = [SXTools getHeightWithLineHight:3 font:16 width:DR_SCREEN_WIDTH-30 string:title isJiacu:YES];
    self.titleAttStr = [NoticeTools getStringWithLineHight:3 string:title];
}

- (void)setIntroduce:(NSString *)introduce{
    _introduce = introduce;
    self.introHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-30 string:introduce isJiacu:NO];
    self.introAttStr = [SXTools getStringWithLineHight:3 string:introduce];
}

- (void)setSeries_info:(NSDictionary *)series_info{
    _series_info = series_info;
    self.searModel = [SXPayForVideoModel mj_objectWithKeyValues:series_info];
}

- (void)setUser_info:(NSDictionary *)user_info{
    _user_info = user_info;
    self.userModel = [SXUserModel mj_objectWithKeyValues:user_info];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"vid":@"id"};
}

- (void)setTextContent:(NSString *)textContent {
 
    NSArray * array = [textContent componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0;i < array.count; i++) {
        [newArr addObject:array[i]];
    }
    
    _textContent = [newArr componentsJoinedByString:@"\n"];
    
    self.textHeight = [self getSpaceLabelHeight:_textContent withFont:FIFTHTEENTEXTFONTSIZE withWidth:DR_SCREEN_WIDTH-30];
    NSString *moreStr = @"...   展开";
    if (textContent.length) {
        self.allTextAttStr = [self setLabelSpacewithValue:_textContent withFont:FIFTHTEENTEXTFONTSIZE];
        
        if ([[self getSeparatedLinesFromLabel:_textContent width:DR_SCREEN_WIDTH-30 font:FIFTHTEENTEXTFONTSIZE] count]> 2) {
            self.isMoreFiveLines = YES;
            NSArray *array = [self getSeparatedLinesFromLabel:_textContent width:DR_SCREEN_WIDTH-30 font:FIFTHTEENTEXTFONTSIZE];
            NSString *line4String = array[1];
            line4String = [line4String stringByReplacingOccurrencesOfString:@"\n" withString:@""];
          
            CGFloat moreStrWidth = GET_STRWIDTH(moreStr, 15, 20);
            CGFloat linWidth = GET_STRWIDTH(line4String, 15, 20);
            
            if (((linWidth + moreStrWidth) > (DR_SCREEN_WIDTH-30)) && line4String.length > 5) {//如果拼接起来大于可显示宽度
                self.showText = [NSString stringWithFormat:@"%@%@%@", array[0],[line4String substringToIndex:line4String.length-moreStr.length],moreStr];
            }else{
                self.showText = [NSString stringWithFormat:@"%@%@%@", array[0],line4String,moreStr];
            }
            
            self.fiveAttTextStr = [DDHAttributedMode setString:self.showText setFont:XGFifthBoldFontSize setLengthString:moreStr beginSize:self.showText.length-moreStr.length];
            
        }else{
            self.isMoreFiveLines = NO;
        }
    }
}


//返回文案
-(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3;//设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
    };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    return attributeStr;
}

//获取label上每一行的文字
- (NSArray *)getSeparatedLinesFromLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{

    return [NoticeTools getSeparatedLinesFromLabel:text width:width font:font textHeight:self.textHeight];
}

//获取指定文字间距和行间距的文案高度
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
    };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
