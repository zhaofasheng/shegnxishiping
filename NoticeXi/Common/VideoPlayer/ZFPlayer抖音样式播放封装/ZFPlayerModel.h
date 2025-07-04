
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>



@interface ZFPlayerModel : NSObject
@property (nonatomic, assign) BOOL isFirstAlloc;
/** 进入后台是否自动暂停播放 */
@property (nonatomic, assign) BOOL isAutoPauseWhenBackGround;

/** 是否自动播放 默认为YES*/
@property (nonatomic, assign) BOOL isAutoPlay;
/** 是否要使用边下边播 */
@property (nonatomic, assign) BOOL useDownAndPlay;

/** 视频的填充模式 */
@property (nonatomic, strong) AVLayerVideoGravity videoGravity;

///** 资源ID ,没有可不理会,这个主要是为了视频之前下载的视频,因为链接地址加了动画剧集ID(属于最初没想好,自作自受,给自己挖了坑) **/
//@property (nonatomic, strong) NSString *resourceID;

//是否是竖屏
@property (nonatomic, assign) BOOL screen;
/** 视频标题 */
@property (nonatomic, copy  ) NSString     *title;
/** 作者名 */
@property (nonatomic, copy) NSString *artist;
/** 视频URL */
@property (nonatomic, strong) NSURL        *videoURL;
/** 视频封面本地图片 */
@property (nonatomic, strong) UIImage      *placeholderImage;
/** 播放器View的父视图（非cell播放使用这个）*/
@property (nonatomic, weak  ) UIView       *fatherView;

/**
 * 视频封面网络图片url
 * 如果和本地图片同时设置，则忽略本地图片，显示网络图片
 */
@property (nonatomic, copy  ) NSString     *placeholderImageURLString;
/**
 * 视频分辨率字典, 分辨率标题与该分辨率对应的视频URL.
 * 例如: @{@"高清" : @"https://xx/xx-hd.mp4", @"标清" : @"https://xx/xx-sd.mp4"}
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *resolutionDic;
/** 从xx秒开始播放视频(默认0) */
@property (nonatomic, assign) NSInteger    seekTime;
// cell播放视频，以下属性必须设置值
@property (nonatomic, strong) UIScrollView *scrollView;
/** cell所在的indexPath */
@property (nonatomic, strong) NSIndexPath  *indexPath;
/**
 * cell上播放必须指定
 * 播放器View的父视图tag（根据tag值在cell里查找playerView加到哪里)
 */
@property (nonatomic, assign) NSInteger    fatherViewTag;

@end
