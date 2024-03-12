//
//  NoticeDownloadVoiceCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeDownloadVoiceCell.h"

@implementation NoticeDownloadVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.voiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 54)];
        self.voiceImageView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.voiceImageView setAllCorner:4];
        [self.contentView addSubview:self.voiceImageView];
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.voiceImageView.frame)+8, 10, DR_SCREEN_WIDTH-103-80,21)];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        titleLabel.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        // 进度标签
        UILabel *speedLable = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-74-100, CGRectGetMaxY(titleLabel.frame)+16,100, 16)];
        speedLable.font = [UIFont systemFontOfSize:11.f];
        speedLable.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:speedLable];
        speedLable.textAlignment = NSTextAlignmentRight;
        _speedLabel = speedLable;
        
        // 文件大小标签
        UILabel *fileSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+16, 150, 16)];
        fileSizeLabel.font = [UIFont systemFontOfSize:11.f];
        fileSizeLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:fileSizeLabel];
        _fileSizeLabel = fileSizeLabel;
        
        self.progressView.frame = CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+8, DR_SCREEN_WIDTH-103-74, 4);
        
        self.downButton.frame = CGRectMake(DR_SCREEN_WIDTH-15-24, 25, 24, 24);
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(103,52, DR_SCREEN_WIDTH-103-80,16)];
        self.timeLabel.font = [UIFont systemFontOfSize:11.f];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.hidden = YES;
        
        self.looktimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-GET_STRWIDTH(@"已观看100%", 11, 16),52,GET_STRWIDTH(@"已观看100%", 11, 16),16)];
        self.looktimeLabel.font = [UIFont systemFontOfSize:11.f];
        self.looktimeLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:self.looktimeLabel];
        self.looktimeLabel.textAlignment = NSTextAlignmentRight;
        self.looktimeLabel.hidden = YES;
    }
    return self;
}


- (void)setModel:(HWDownloadModel *)model
{
    _model = model;
    _choiceImageView.hidden = YES;
    _speedLabel.text = @"";
    _titleLabel.text = model.fileName;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#14151A"];
    [self.voiceImageView sd_setImageWithURL:[NSURL URLWithString:model.videoCover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            if ([imageURL.absoluteString isEqualToString:_model.videoCover]) {
                if (![self getImageFromSand:_model]) {
                    [self saveImage:image url:imageURL.absoluteString];
                }
            }
        }else{
            self.voiceImageView.image =  [self getImageFromSand:model];
        }
    }];
    [self updateViewWithModel:model];
}

- (void)saveImage:(UIImage *)image url:(NSString *)url{
    if ([url isEqualToString:_model.videoCover]) {
        [SXTools saveImage:image withPath:[NSString stringWithFormat:@"%@_%@.%@",_model.vid,[NoticeTools getuserId],[_model.videoCover pathExtension]]];
    }
}

- (UIImage *)getImageFromSand:(HWDownloadModel *)model{
    // 拼接图片名为"currentImage.png"的路径
    
    NSString *pathName = [NSString stringWithFormat:@"%@_%@.%@",_model.vid,[NoticeTools getuserId],[_model.videoCover pathExtension]];

    return [SXTools getImageWith:pathName];
}

// 更新视图
- (void)updateViewWithModel:(HWDownloadModel *)model
{
    self.progressView.progress = model.progress;
    [self reloadLabelWithModel:model];
}

// 刷新标签
- (void)reloadLabelWithModel:(HWDownloadModel *)model
{
    NSString *totalSize = [HWToolBox stringFromByteCount:model.totalFileSize];
    NSString *tmpSize = [HWToolBox stringFromByteCount:model.tmpFileSize];

    if (model.state == HWDownloadStateFinish) {
        _fileSizeLabel.text = [NSString stringWithFormat:@"%@", totalSize];
        
    }else {
        _fileSizeLabel.text = [NSString stringWithFormat:@"%@ / %@", tmpSize, totalSize];
    }
    _fileSizeLabel.hidden = model.totalFileSize == 0;
    

    _speedLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    if (model.state == HWDownloadStateDownloading && model.totalFileSize > 0) {//如果正在下载中，并且存在文件
        if (model.speed > 0) {
            _speedLabel.text = [NSString stringWithFormat:@"%@ / s", [HWToolBox stringFromByteCount:model.speed]];
        }
    }else{
        if (model.state == HWDownloadStateDefault || model.state == HWDownloadStatePaused || model.state == HWDownloadStateError) {
            _speedLabel.text = @"已暂停";
        }else if (model.state == HWDownloadStateFinish){
            _speedLabel.text = @"缓存完成";
        }else if (model.state == HWDownloadStateWaiting){
            _speedLabel.text = @"等待中";
        }
    }
    
    [self refreUI];
    
    switch (model.state) {
        case HWDownloadStateDefault:
            [self.downButton setBackgroundImage:[UIImage imageNamed:@"com_download_default"] forState:UIControlStateNormal];
            break;
            
        case HWDownloadStateDownloading:
            [self.downButton setBackgroundImage:[UIImage imageNamed:@"com_download_default"] forState:UIControlStateNormal];
            break;
   
        case HWDownloadStateWaiting:
            [self.downButton setBackgroundImage:[UIImage imageNamed:@"com_download_waiting"] forState:UIControlStateNormal];
            break;
            
        case HWDownloadStatePaused:
            [self.downButton setBackgroundImage:[UIImage imageNamed:@"com_download_pause"] forState:UIControlStateNormal];
            break;
            
        case HWDownloadStateFinish:
            [self.downButton setBackgroundImage:[UIImage imageNamed:@"com_download_finish"] forState:UIControlStateNormal];
          
            break;
            
        case HWDownloadStateError://已取消状态的失败作为暂停对待
            [self.downButton setBackgroundImage:[UIImage imageNamed:@"com_download_pause"] forState:UIControlStateNormal];
     
            break;
            
        default:
            break;
    }
}

//刷新UI
- (void)refreUI{
    self.progressView.hidden = NO;
    self.fileSizeLabel.frame = CGRectMake(103, 47, 150, 16);
    self.speedLabel.frame = CGRectMake(DR_SCREEN_WIDTH-74-100, CGRectGetMaxY(self.titleLabel.frame)+16,100, 16);
    self.downButton.hidden = NO;
    self.timeLabel.hidden = YES;
    self.speedLabel.textAlignment = NSTextAlignmentRight;
    self.fileSizeLabel.textAlignment = NSTextAlignmentLeft;
    self.looktimeLabel.hidden = YES;
    if (_model.state == HWDownloadStateFinish) {
        self.progressView.hidden = YES;
        //完成后速度的显示成文件大小
        self.speedLabel.hidden = NO;
        self.downButton.hidden = YES;
        self.fileSizeLabel.textAlignment = NSTextAlignmentRight;
        self.fileSizeLabel.frame = CGRectMake(DR_SCREEN_WIDTH-80, 13, 60, 16);
        self.speedLabel.frame = CGRectMake(103, 33, self.titleLabel.frame.size.width, 17);
        self.speedLabel.textAlignment = NSTextAlignmentLeft;
        self.speedLabel.text = _model.nickName;
        self.timeLabel.hidden = NO;
        self.timeLabel.text = [self getMMSSFromSS:_model.video_len];
        
        
        if ([self.currentPlayId isEqualToString:_model.vid]) {
            _titleLabel.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
            self.choiceImageView.hidden = NO;
        }
        
        NSInteger lookTime = [SXTools getSaveCurrentPlayTime:_model.vid];
        if (lookTime > 0 && _model.video_len.intValue) {
            self.looktimeLabel.hidden = NO;
            if (_model.video_len.intValue) {
                self.looktimeLabel.text = [NSString stringWithFormat:@"已观看%.f%%",((CGFloat)(lookTime/_model.video_len.floatValue))*100];
            }else{
                self.looktimeLabel.text = [NSString stringWithFormat:@"已观看%lds",lookTime];
            }
        }
    }
}

- (UIImageView *)choiceImageView{
    if (!_choiceImageView) {
        _choiceImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(56/2, 15, 24, 24)];
        _choiceImageView.image = UIImageNamed(@"sxcurrentplay_img");
        [self.voiceImageView addSubview:_choiceImageView];
        _choiceImageView.hidden = YES;
    }
    return _choiceImageView;
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@:%@%@",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"00",str_second.intValue?str_second:@"00"];
    }else{
        if(str_minute.intValue){
            return [NSString stringWithFormat:@"%@:%@",str_minute.intValue?str_minute:@"00",str_second.intValue?str_second:@"00"];
        }else{
            return [NSString stringWithFormat:@"00:%@",str_second.intValue?str_second:@"00"];
        }
    }
}


/** 下载进度条 */
- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 39, DR_SCREEN_WIDTH-20-70, 4)];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"#F0F1F5"];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [self.contentView addSubview:_progressView];
    }
    return _progressView;
}


/** 下载按钮 */
- (UIButton *)downButton
{
    if (!_downButton){
        _downButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-70, 0, 70, 74)];
        [_downButton addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_downButton];
        _downButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [_downButton setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    }
    return _downButton;
}

- (void)downClick{
    
    if (_model.state == HWDownloadStateDefault || _model.state == HWDownloadStatePaused || _model.state == HWDownloadStateError) {
        // 点击默认、暂停、失败状态，调用开始下载
        [[HWDownloadManager shareManager] startDownloadTask:_model];
        
    }else if (_model.state == HWDownloadStateDownloading || _model.state == HWDownloadStateWaiting) {
        // 点击正在下载、等待状态，调用暂停下载
        [[HWDownloadManager shareManager] pauseDownloadTask:_model];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
