//
//  SXShopSayListModel.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayListModel.h"

@implementation SXShopSayListModel

- (void)setContent:(NSString *)content{
    _content = content;
    self.attStr = [SXTools getStringWithLineHight:3 string:content];
    self.contentHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-50 string:content isJiacu:NO];
    if (content && content.length) {
        if (self.contentHeight < 36) {
            self.contentHeight = 36;
        }
    }
}

@end
