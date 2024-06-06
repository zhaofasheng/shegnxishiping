//
//  KMTag.m
//  KMTag
//
//  Created by chavez on 2017/7/13.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "KMTag.h"

@implementation KMTag

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setupWithColorText:(NSString *)text{
    self.text = text;
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
    self.font = [UIFont systemFontOfSize:14];
    UIFont* font = self.font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    CGRect frame = self.frame;
    self.layer.cornerRadius = 16;
    self.layer.masksToBounds = YES;
    NSArray *arr = @[@"#E4DDFD",@"#E7F6A7",@"#F8F0A1"];
    self.backgroundColor = [UIColor colorWithHexString:arr[arc4random()%3]];
    frame.size = CGSizeMake(size.width + 20, 32);
    self.frame = frame;
    self.layer.shouldRasterize = YES;
}

- (void)setupWithText:(NSString*)text {

    NSString *showText = text;
    if (text.length > 10) {
        showText = [NSString stringWithFormat:@"%@...",[text substringToIndex:10]];
    }
    
    
    self.layer.masksToBounds = YES;
    self.text = showText;
    self.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
    self.font = [UIFont systemFontOfSize:14];
    UIFont* font = self.font;
    CGSize size = [showText sizeWithAttributes:@{NSFontAttributeName: font}];
    CGRect frame = self.frame;
    self.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    
    frame.size = CGSizeMake((NSInteger)size.width + 20, 32);
    
    self.frame = frame;
    [self setAllCorner:self.frame.size.height/2];
}

- (void)setupCousTumeWithText:(NSString *)text{
    self.text = text;
    self.textColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:1];
    self.font = [UIFont systemFontOfSize:15];
    UIFont* font = self.font;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    CGRect frame = self.frame;
    frame.size = CGSizeMake((NSInteger)size.width + 40, 32);
    self.frame = frame;
    self.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
    [self setAllCorner:4];
}

@end
