//
//  SXVideoCommentModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/16.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCommentModel.h"

@implementation SXVideoCommentModel

- (NSMutableArray *)replyArr{
    if (!_replyArr) {
        _replyArr = [[NSMutableArray alloc] init];
    }
    return _replyArr;
}

- (NSMutableArray *)moreReplyArr{
    if (!_moreReplyArr) {
        _moreReplyArr = [[NSMutableArray alloc] init];
    }
    return _moreReplyArr;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"commentId":@"id"};
}

- (void)setCreated_at:(NSString *)created_at{
    _created_at = [SXTools updateTimeForRowWithNoHourAndMin:created_at];
}


- (void)setFrom_user:(NSDictionary *)from_user{
    _from_user = from_user;
    self.fromUserInfo = [SXUserModel mj_objectWithKeyValues:from_user];
}


- (void)setAuth_user:(NSDictionary *)auth_user{
    _auth_user = auth_user;
    self.authUserInfo = [SXUserModel mj_objectWithKeyValues:auth_user];
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.firstAttr = [SXTools getStringWithLineHight:3 string:content];
    self.firstContentHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-56-15 string:content isJiacu:NO];
    
    self.secondAttr = [SXTools getStringWithLineHight:3 string:content];
    self.secondContentHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-88-15 string:content isJiacu:NO];
    
    NSArray * array = [content componentsSeparatedByString:@"\n"];//用换行分割成数组，剔除为空的字符串
    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0;i < array.count; i++) {
        [newArr addObject:array[i]];
    }
    
    NSString *_textContent = [newArr componentsJoinedByString:@"\n"];
    NSString *showText = @"";
    NSString *moreStr = @"   ...查看更多";
    if (content.length) {
        if ([[self getSeparatedLinesFromLabel:_textContent width:DR_SCREEN_WIDTH-56-15 font:FOURTHTEENTEXTFONTSIZE] count]> 2) {
            self.isMoreFiveLines = YES;
            NSArray *array = [self getSeparatedLinesFromLabel:_textContent width:DR_SCREEN_WIDTH-30 font:FOURTHTEENTEXTFONTSIZE];
            NSString *line4String = array[1];
            line4String = [line4String stringByReplacingOccurrencesOfString:@"\n" withString:@""];
          
            CGFloat moreStrWidth = GET_STRWIDTH(moreStr, 14, 20);
            CGFloat linWidth = GET_STRWIDTH(line4String, 14, 20);
            
            if (((linWidth + moreStrWidth) > (DR_SCREEN_WIDTH-56-15)) && line4String.length > 10) {//如果拼接起来大于可显示宽度
                showText = [NSString stringWithFormat:@"%@%@%@", array[0],[line4String substringToIndex:line4String.length-moreStr.length],moreStr];
            }else{
                showText = [NSString stringWithFormat:@"%@%@%@", array[0],line4String,moreStr];
            }
            
            self.fiveAttTextStr = [DDHAttributedMode setString:showText setFont:XGFourthBoldFontSize setLengthString:moreStr beginSize:showText.length-moreStr.length];
            self.fiveTextHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-56-15 string:showText isJiacu:NO];
            
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
    return [NoticeTools getSeparatedLinesFromLabel:text width:width font:font textHeight:self.firstContentHeight];
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


- (void)setTo_user:(NSDictionary *)to_user{
    _to_user = to_user;
    self.toUserInfo = [SXUserModel mj_objectWithKeyValues:to_user];
}

- (void)setReply:(NSDictionary *)reply{
    _reply = reply;
    self.firstReplyModel = [SXVideoCommentModel mj_objectWithKeyValues:reply];
    if (self.firstReplyModel.comment_type.intValue > 1) {
        self.firstReplyModel.content = @"请更新到最新版本";
    }
}

- (void)setComment:(NSDictionary *)comment{
    _comment = comment;
    self.firstCommentModel = [SXVideoCommentModel mj_objectWithKeyValues:comment];
    if (self.firstCommentModel.comment_type.intValue > 1) {
        self.firstCommentModel.content = @"请更新到最新版本";
    }
}

- (void)setTo_series:(NSString *)to_series{
    _to_series = to_series;
    NSArray *arr = [NoticeTools arraryWithJsonString:to_series];
    self.seariesArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in arr) {
        SXPayForVideoModel *model = [SXPayForVideoModel mj_objectWithKeyValues:dic];
        model.series_name = model.name;
        [self.seariesArr addObject:model];
    }
}

//- (void)setTo_series:(NSArray *)to_series{
//    _to_series = to_series;
//    self.seariesArr = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic in to_series) {
//        SXPayForVideoModel *model = [SXPayForVideoModel mj_objectWithKeyValues:dic];
//        model.series_name = model.name;
//        [self.seariesArr addObject:model];
//    }
//}
@end
