//
//  CommentsPopView.m
//  Douyin
//
//  Created by Tang TianCheng 
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "TCCommentsPopView.h"

#define RGBA(r, g, b,a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]



@interface TCCommentsPopView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) MyCommentView                           *container;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
//当前正在拖拽的是否是tableView
@property (nonatomic, assign) BOOL isDragScrollView;
@property (nonatomic, strong) UIScrollView *scrollerView;
////向下拖拽最后时刻的位移
//@property (nonatomic, assign) CGFloat lastDrapDistance;

@end


@implementation TCCommentsPopView

+ (instancetype)commentsPopViewWithFrame:(CGRect)frame commentBackView:(MyCommentView *)commentBackView withScale:(CGFloat)widthtoheight{
    TCCommentsPopView *view = [[TCCommentsPopView alloc] initWithFrame:frame commentBackView:commentBackView withScale:widthtoheight];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame commentBackView:(MyCommentView *)commentBackView withScale:(CGFloat)widthtoheight{
    self = [super initWithFrame:frame];
    if (self) {
        self.isDragScrollView = NO;
        self.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
        self.tapGestureRecognizer = tapGestureRecognizer;
        tapGestureRecognizer.delegate = self;
        
        [self addGestureRecognizer:tapGestureRecognizer];
        
        self.container  = commentBackView;
        self.container.frame = CGRectMake(0, frame.size.height, frame.size.width, DR_SCREEN_HEIGHT - DR_SCREEN_WIDTH * widthtoheight);
        [self addSubview:self.container];
        [self.container refresUI];
        [self.container setCornerOnTop:20];
        
        //添加拖拽手势
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.container addGestureRecognizer:self.panGestureRecognizer];
        self.panGestureRecognizer.delegate = self;
    }
    return self;
}


#pragma mark - Action

//update method
- (void)showToView:(UIView *)view{
    [self removeFromSuperview];
    [view addSubview:self];
    [self show];
}

- (void)show {
    if (self.showComBlock) {
        self.showComBlock(YES);
    }
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = self.frame.size.height - self.container.frame.size.height;
        self.container.frame = frame;
    }
                     completion:^(BOOL finished) {
    }];
}

- (void)dismiss {
    if (self.showComBlock) {
        self.showComBlock(NO);
    }
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        self.container.frame = frame;
    }
                     completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
//1
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if(gestureRecognizer == self.panGestureRecognizer) {
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if([touchView isKindOfClass:[UIScrollView class]]) {
                self.isDragScrollView = YES;
                self.scrollerView = touchView;
                break;
            } else if(touchView == self.container) {
                self.isDragScrollView = NO;
                break;
            }
            touchView = [touchView nextResponder];
        }
    }
    return YES;
}

//2.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer == self.tapGestureRecognizer) {
        //如果是点击手势
        CGPoint point = [gestureRecognizer locationInView:_container];
        if([_container.layer containsPoint:point] && gestureRecognizer.view == self) {
            return NO;
        }
    } else if(gestureRecognizer == self.panGestureRecognizer){
        //如果是自己加的拖拽手势
        DRLog(@"gestureRecognizerShouldBegin");
    }
    return YES;
}

//3. 是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(gestureRecognizer == self.panGestureRecognizer) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ) {
            if([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]] ) {
                return YES;
            }
        }
    }
    return NO;
}

//拖拽手势
- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取手指的偏移量
    CGPoint transP = [panGestureRecognizer translationInView:self.container];
    if(self.isDragScrollView) {
        //如果当前拖拽的是tableView
        if(self.scrollerView.contentOffset.y <= 0) {
            //如果tableView置于顶端
            if(transP.y > 0) {
                //如果向下拖拽
                self.scrollerView.contentOffset = CGPointMake(0, 0 );
                self.scrollerView.panGestureRecognizer.enabled = NO;
                self.scrollerView.panGestureRecognizer.enabled = YES;
                self.isDragScrollView = NO;
                //向下拖
                self.container.frame = CGRectMake(self.container.frame.origin.x, self.container.frame.origin.y + transP.y, self.container.frame.size.width, self.container.frame.size.height);
                
                if (self.frameBlock) {
                    self.frameBlock(self.container.frame.origin.y);
                }
            } else {
                //如果向上拖拽
            }
        }
    } else {
        if(transP.y > 0) {
            //向下拖
            self.container.frame = CGRectMake(self.container.frame.origin.x, self.container.frame.origin.y + transP.y, self.container.frame.size.width, self.container.frame.size.height);
        } else if(transP.y < 0 && self.container.frame.origin.y > (self.frame.size.height - self.container.frame.size.height)){
            //向上拖
            self.container.frame = CGRectMake(self.container.frame.origin.x, (self.container.frame.origin.y + transP.y) > (self.frame.size.height - self.container.frame.size.height) ? (self.container.frame.origin.y + transP.y) : (self.frame.size.height - self.container.frame.size.height), self.container.frame.size.width, self.container.frame.size.height);
        } else {

        }
        
        if (self.frameBlock) {
            self.frameBlock(self.container.frame.origin.y);
        }
    }

    [panGestureRecognizer setTranslation:CGPointZero inView:self.container];
    if(panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        DRLog(@"transP : %@",NSStringFromCGPoint(transP));
        //速度
        CGFloat velocity = [panGestureRecognizer velocityInView:self.container].y;
        if(velocity > 300 && self.isDragScrollView == NO) {
            //如果是类似往下轻扫的那种
            [self dismiss];
        } else if(velocity < -300 && self.isDragScrollView == NO) {
            //如果是类似往上轻扫的那种
            [self show];
        } else {
            //如果是普通拖拽
            if(self.container.frame.origin.y >= [UIScreen mainScreen].bounds.size.height - self.container.frame.size.height/2) {
                [self dismiss];
            } else {
                [self show];
            }
        }
    }
//    self.lastDrapDistance = transP.y;
}

//点击手势
- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point] && sender.view == self) {
        [self dismiss];
        return;
    }
}



#pragma mark - lazyLoad

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end









