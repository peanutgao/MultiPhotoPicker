//
//  YSAssert.m
//  系统相簿多选
//
//  Created by Joseph Gao on 15/11/22.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSAsset.h"

@implementation YSAsset

- (instancetype)initWithAsset:(ALAsset *)asset {
    if (self = [super init]) {
        _asset = asset;
        _isSelected = NO;
    }
    
    return self;
}


+ (instancetype)assetWithAsset:(ALAsset *)asset {
    return [[YSAsset alloc] initWithAsset:asset];
}

@end
