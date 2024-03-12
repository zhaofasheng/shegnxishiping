//
//  Card.m
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XLCardCell.h"
#import "XLCardModel.h"

@interface XLCardCell ()


@end

@implementation XLCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
 
    self.backgroundColor = [UIColor redColor];

}


@end
