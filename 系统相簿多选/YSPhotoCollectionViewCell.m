//
//  YSPhotoCollectionViewCell.m
//  系统相簿多选
//
//  Created by Joseph on 15/11/19.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSPhotoCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YSAsset.h"

#define CHECK_BUTTON_WIDTH 28

@interface YSPhotoCollectionViewCell()
/*!
 @brief  缩略图 imageView
 */
@property (nonatomic, weak) UIImageView *thumbImageView;
/*!
 @brief  勾选按钮
 */
@property (nonatomic, weak) UIButton *kCheckButton;

@end

@implementation YSPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupSubviewsLayout];
        
        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    }
    
    return self;
}


- (void)setupSubviews {
    UIImageView *thumbImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:thumbImageView];
    _thumbImageView = thumbImageView;
    
    UIButton *kCheckButton = [[UIButton alloc] init];
    [kCheckButton setAdjustsImageWhenHighlighted:NO];
    [kCheckButton setBackgroundImage:[self getBundleImgWithImageName:@"check_button_normal"] forState:UIControlStateNormal];
    [kCheckButton setBackgroundImage:[self getBundleImgWithImageName:@"check_button_selected"] forState:UIControlStateSelected];
    [kCheckButton addTarget:self action:@selector(changeCheckBtnStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:kCheckButton];
    _kCheckButton = kCheckButton;
}



#pragma mark - 勾选按钮点击操作

- (void)changeCheckBtnStatus:(UIButton *)checkBtn {    
    if (self.photoCellDelegate && [self.photoCellDelegate respondsToSelector:@selector(photoCollectionViewCell:clickCheckBtn:)]) {
        [self.photoCellDelegate photoCollectionViewCell:self clickCheckBtn:checkBtn];
    }
}


- (UIImage *)getBundleImgWithImageName:(NSString *)imgName {
    NSBundle *multiChooseAlbumBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle]  pathForResource:@"YSMultiChooseAlbum"
                                                                                                 ofType:@"bundle"]];
    NSString *normalImgPath = [multiChooseAlbumBundle pathForResource:imgName ofType:@"png"];
    
   return [UIImage imageWithContentsOfFile:normalImgPath];
}


- (void)setupSubviewsLayout {
    _thumbImageView.frame = self.bounds;
    
    CGFloat checkButtonW = CHECK_BUTTON_WIDTH;
    CGFloat checkButtonH = checkButtonW;
    CGFloat checkButtonX = self.bounds.size.width - checkButtonW;   // 位置在cell的最右上角
    CGFloat checkButtonY = 0;
    _kCheckButton.frame = CGRectMake(checkButtonX, checkButtonY, checkButtonW, checkButtonH);
    
}


- (void)setAsset:(YSAsset *)asset {
    _asset = asset;

    _thumbImageView.image = [UIImage imageWithCGImage:[asset.asset thumbnail]];
    _kCheckButton.selected = asset.isSelected;
}

@end
