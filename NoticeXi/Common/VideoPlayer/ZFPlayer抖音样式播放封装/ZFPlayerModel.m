
#import "ZFPlayerModel.h"
#import "ZFPlayer.h"

@implementation ZFPlayerModel

- (instancetype)init {
    if(self = [super init]) {
        self.useDownAndPlay = YES;
        self.isAutoPlay = YES;
        self.videoGravity = AVLayerVideoGravityResizeAspect;
        self.isAutoPauseWhenBackGround = YES;
    }
    return self;
}

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [UIImage imageNamed:@"AnimationNormalPlaceHolder"];
    }
    return _placeholderImage;
}
@end
