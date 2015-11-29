//
//  YSPhotoViewController.h
//  系统相簿多选
//
//  Created by Joseph on 15/11/19.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup;
typedef void(^PhotoVCHandler)(NSArray *selectedImgsArray);
@interface YSPhotoViewController : UIViewController

@property (nonatomic, strong) ALAssetsGroup *group;

@property (nonatomic, copy) PhotoVCHandler photoVCHandler;
@end
