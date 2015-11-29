//
//  YSPhotoPickerController.m
//  系统相簿多选
//
//  Created by Joseph Gao on 15/11/21.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSPhotoPickerController.h"
#import "YSAlbumListViewController.h"

@interface YSPhotoPickerController ()

@end

@implementation YSPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (instancetype)init {
    YSAlbumListViewController *albumListVC = [[YSAlbumListViewController alloc] init];
    
    return [super initWithRootViewController:albumListVC];
}


@end
