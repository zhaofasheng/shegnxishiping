//
//  SXDownVideoheaderView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXDownVideoheaderView.h"

@implementation SXDownVideoheaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 200,40)];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textColor =[UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:label];
        _mainTitleLabel = label;
    }
    return self;
}



@end
