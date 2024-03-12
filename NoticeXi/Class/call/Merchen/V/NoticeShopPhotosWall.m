//
//  NoticeShopPhotosWall.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopPhotosWall.h"
#import "NoticePhotoWallCell.h"
@implementation NoticeShopPhotosWall

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(0,0,frame.size.width, frame.size.height);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticePhotoWallCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = frame.size.height+8;
        self.movieTableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self addSubview:self.movieTableView];
    }
    return self;
}

- (void)setPhotos:(NSMutableArray *)photos{
    _photos = photos;
    if (photos.count) {
        BOOL hasChoice = NO;
        for (NoticeShopDataIdModel *photoM in photos) {
            if (photoM.isChoice == YES) {
                hasChoice = YES;
                break;
            }
        }
        if (!hasChoice) {//如果没有选中的，第一个就是选中的
            NoticeShopDataIdModel *firstM = photos[0];
            firstM.isChoice = YES;
            if (self.choiceUrlBlock) {
                self.choiceUrlBlock(firstM.photo_url);
            }
        }
        [self.movieTableView reloadData];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.photos.count) {
        if (!self.canChoice) {
            NoticeShopDataIdModel *firstM = _photos[indexPath.row];
            NoticePhotoWallCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView         = cell.postImageView;
            item.largeImageURL     = [NSURL URLWithString:firstM.photo_url];

            NSMutableArray *arr = [NSMutableArray new];
            [arr addObject:item];
            YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
            UIView *toView         = [UIApplication sharedApplication].keyWindow;
            [photoView presentFromImageView:cell.postImageView toContainer:toView animated:YES completion:nil];
            return;
        }
        for (NoticeShopDataIdModel *photoM in _photos) {
            photoM.isChoice = NO;
        }
        NoticeShopDataIdModel *firstM = _photos[indexPath.row];
        firstM.isChoice = YES;
        if (self.choiceUrlBlock) {
            self.choiceUrlBlock(firstM.photo_url);
        }
        [self.movieTableView reloadData];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticePhotoWallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.canChoice = self.canChoice;
    cell.height = self.frame.size.height;
    if (indexPath.row < self.photos.count) {
        cell.photoModel = self.photos[indexPath.row];
    }

    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.photos.count;
}
@end
