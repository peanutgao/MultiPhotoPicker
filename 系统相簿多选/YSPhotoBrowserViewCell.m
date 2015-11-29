//
//  YSPhotoBrowerViewCell.m
//  系统相簿多选
//
//  Created by Joseph Gao on 15/11/21.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSPhotoBrowserViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YSAsset.h"

@interface YSPhotoBrowserViewCell()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *kcontentScrollView;
@property (nonatomic, strong) UIImageView *kImageView;


@end

@implementation YSPhotoBrowserViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    
    return self;
}


- (void)setupSubViews {
    // contentScrollView
    _kcontentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _kcontentScrollView.delegate = self;
    _kcontentScrollView.maximumZoomScale = 1.5f;
    _kcontentScrollView.minimumZoomScale = 0.5f;
    [self.contentView addSubview:_kcontentScrollView];
    
    // imageView
    _kImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _kImageView.contentMode = UIViewContentModeScaleAspectFit;
//    _imageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0
//                                                  green:arc4random_uniform(256)/255.0
//                                                   blue:arc4random_uniform(256)/255.0
//                                                  alpha:1.0];
    
    [_kcontentScrollView addSubview:_kImageView];
}



#pragma mark - UIScrollView Delegate method
// 返回要缩放的View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _kImageView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf layoutSubviewsFrame];     // 缩放结束后重新布局imageView, 让图片始终显示在中间
    }];
}



#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutSubviewsFrame];
}


- (void)layoutSubviewsFrame {
    // 当图片缩小的时候，让图片在中间
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _kImageView.frame;
    
    // 水平设置中间
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) * 0.5;
    else
        frameToCenter.origin.x = 0;
    
    // 垂直设置中间
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) * 0.5;
    else
        frameToCenter.origin.y = 0;
    
    _kImageView.frame = frameToCenter;
}


- (void)setAssert:(YSAsset *)assert {
    _assert = assert;
    
    ALAssetRepresentation *assetRepresentation = [assert.asset defaultRepresentation];
    _kImageView.image = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage]];
    
    // 重置cell设置,防止循环利用问题
    _kcontentScrollView.zoomScale = 1.0;
    [self layoutSubviewsFrame];
}


@end




