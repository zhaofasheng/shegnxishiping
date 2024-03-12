//
//  KMImgTag.m
//  NoticeXi
//
//  Created by li lei on 2023/4/16.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "KMImgTag.h"

@implementation KMImgTag

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.nameL = [[UILabel alloc] init];
        self.nameL.font = FOURTHTEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.nameL];
        self.nameL.textAlignment = NSTextAlignmentCenter;
        self.nameL.layer.cornerRadius = 16;
        self.nameL.layer.masksToBounds = YES;
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 6, 20, 20)];
        [self addSubview:self.imgView];
    }
    return self;
}

- (void)setoneImgname:(NSString *)name{
    self.nameL.text = name;
    self.imgView.image = UIImageNamed(@"deletag_img");
    
    self.nameL.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    self.nameL.textColor = [UIColor colorWithHexString:@"#14151A"];
    CGFloat strWidth = GET_STRWIDTH(name, 14, 32);
    CGRect frame = self.frame;
    frame.size = CGSizeMake(strWidth+4+40, 32);
    self.nameL.frame = CGRectMake(0, 0, strWidth+20, 32);
    self.imgView.frame = CGRectMake(CGRectGetMaxX(self.nameL.frame)+4, 6, 20, 20);
    self.frame = frame;
    self.nameL.layer.cornerRadius = self.nameL.frame.size.height/2;
}

- (void)setImg:(NSString *)imgUrl name:(NSString *)name{
    self.nameL.text = name;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    
    CGFloat strWidth = GET_STRWIDTH(name, 14, 32);
    CGRect frame = self.frame;
    frame.size = CGSizeMake(strWidth+6+6+20+2, 32);
    self.nameL.frame = CGRectMake(8+20, 0, strWidth, 32);
    self.frame = frame;
}
@end
