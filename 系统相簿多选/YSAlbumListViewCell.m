//
//  YSAlbumListViewCell.m
//  系统相簿多选
//
//  Created by Joseph on 15/11/19.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSAlbumListViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface YSAlbumListViewCell()

@property (nonatomic, weak) UIImageView *kImageView;    // icon view
@property (nonatomic, weak) UILabel *kTitleLabel;       // 标题
@property (nonatomic, weak) UILabel *kDetailLabel;      // 描述,(指相簿中相片数目)


@end

@implementation YSAlbumListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
        [self setupSubviewsLayout];
        // 显示箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}


- (void)setupSubviews {
    UIImageView *kImageView = [[UIImageView alloc] init];
    kImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:kImageView];
    _kImageView = kImageView;
    
    UILabel *kTitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:kTitleLabel];
    _kTitleLabel = kTitleLabel;
    
    UILabel *kDetailLabel= [[UILabel alloc] init];
    [self.contentView addSubview:kDetailLabel];
    _kDetailLabel = kDetailLabel;
    
//    _kImageView.backgroundColor = [UIColor redColor];
//    _kTitleLabel.backgroundColor = [UIColor yellowColor];
//    _kDetailLabel.backgroundColor = [UIColor blueColor];
}


- (void)setupSubviewsLayout {
    CGFloat margin = 5;
    
    CGFloat wh = 60;
    _kImageView.frame = CGRectMake(margin * 2, margin, wh, wh);
    
    CGFloat kTitleLabelX = CGRectGetMaxX(_kImageView.frame) + margin * 2;
    CGFloat kTitleLabelY = _kImageView.frame.origin.y + margin;
    CGFloat kTitleLabelW = self.frame.size.width - kTitleLabelX;
    CGFloat kTitleLabelH = 20;
    _kTitleLabel.frame = CGRectMake(kTitleLabelX, kTitleLabelY, kTitleLabelW, kTitleLabelH);
    
    CGFloat kDetailLabelX = _kTitleLabel.frame.origin.x;
    CGFloat kDetailLabelY = CGRectGetMaxY(_kTitleLabel.frame) + margin;
    CGFloat kDetailLabelW = _kTitleLabel.frame.size.width;
    CGFloat kDetailLabelH = 15;
    _kDetailLabel.frame = CGRectMake(kDetailLabelX, kDetailLabelY, kDetailLabelW, kDetailLabelH);

    
}


- (void)setGroup:(ALAssetsGroup *)group {
    _group = group;
    
    _kImageView.image = [UIImage imageWithCGImage:[group posterImage]];
    _kTitleLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    _kDetailLabel.text = [NSString stringWithFormat:@"%zd", [group numberOfAssets]];
    
}

@end



