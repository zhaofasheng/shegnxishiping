//
//  YoungPoint.h
//  YoungTag
//
//  Created by 赵小二 on 2017/5/23.
//  Copyright © 2017年 赵小二. All rights reserved.
//

#ifndef sphereTagCloud_DBPoint_h
#define sphereTagCloud_DBPoint_h
#import <UIKit/UIKit.h>

struct YoungPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct YoungPoint YoungPoint;


struct YoungPoint YoungPointMake(CGFloat x, CGFloat y, CGFloat z) {
    struct YoungPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

#endif
