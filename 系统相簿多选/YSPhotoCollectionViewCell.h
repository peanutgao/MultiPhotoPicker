//
//  YSPhotoCollectionViewCell.h
//  系统相簿多选
//
//  Created by Joseph on 15/11/19.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSAsset;
@class YSPhotoCollectionViewCell;

@protocol YSPhotoCollectionViewCellDelegate <NSObject>

- (void)photoCollectionViewCell:(YSPhotoCollectionViewCell *)cell clickCheckBtn:(UIButton *)checkBtn;

@end


@interface YSPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) YSAsset *asset;

@property (nonatomic, weak) id<YSPhotoCollectionViewCellDelegate> photoCellDelegate;

@end
