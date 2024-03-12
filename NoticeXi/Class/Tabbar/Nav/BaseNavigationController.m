
#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([self.viewControllers count] > 0) {
		viewController.hidesBottomBarWhenPushed = YES;
        
	}
	[super pushViewController:viewController animated:animated];

}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGETHEMCOLORNOTICATION" object:nil];
}


@end
