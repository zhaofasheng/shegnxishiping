//
//  KMTag.h
//  KMTag
//
//  Created by chavez on 2017/7/13.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMTag : UILabel
@property (nonatomic, assign) BOOL isChoice;
- (void)setupWithColorText:(NSString*)text;
- (void)setupWithText:(NSString*)text;

- (void)setupCousTumeWithText:(NSString*)text;

@end
