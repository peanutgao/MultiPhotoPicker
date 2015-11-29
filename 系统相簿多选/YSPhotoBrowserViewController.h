//
//  YSPhotoBrowserViewController.h
//  系统相簿多选
//
//  Created by Joseph Gao on 15/11/21.
//  Copyright © 2015年 Joseph. All rights reserved.
//
/*
    照片浏览器
 */

#import <UIKit/UIKit.h>

typedef void(^PhotoBrowserVCHandler)(NSArray *assetArray);

@interface YSPhotoBrowserViewController : UIViewController

/*!
 @brief  显示照片的集合
 */
//@property (nonatomic, strong) NSArray *photosArray;
/*!
 @brief  asset实例集合
 */
@property (nonatomic, strong) NSArray *assetsArray;
/*!
 @brief  可以选择的最大照片数
 */
@property (nonatomic, assign) NSInteger maxSelectedNo;
/*!
 @brief  当前显示的索引
 */
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
/*!
 @brief  返回按钮数据回调
 */
@property (nonatomic, copy) PhotoBrowserVCHandler photoBrowserVCHandler;

@end
