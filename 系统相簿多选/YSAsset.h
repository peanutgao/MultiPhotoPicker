//
//  YSAssert.h
//  系统相簿多选
//
//  Created by Joseph Gao on 15/11/22.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;

@interface YSAsset : NSObject

@property (nonatomic, strong) ALAsset *asset;
/*!
 @brief  是否已经被选择
 */
@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWithAsset:(ALAsset *)asset;
+ (instancetype)assetWithAsset:(ALAsset *)asset;

@end
