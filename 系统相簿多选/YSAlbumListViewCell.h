//
//  YSAlbumListViewCell.h
//  系统相簿多选
//
//  Created by Joseph on 15/11/19.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup;

@interface YSAlbumListViewCell : UITableViewCell

/*!
 @brief  cell的group
 */
@property (nonatomic, strong) ALAssetsGroup *group;

@end
