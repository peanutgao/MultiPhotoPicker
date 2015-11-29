//
//  ViewController.m
//  系统相簿多选
//
//  Created by Joseph on 15/11/19.
//  Copyright (c) 2015年 Joseph. All rights reserved.
//

#import "ViewController.h"
#import "YSPhotoPickerController.h"
#import "YSAlbumListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)choosePhotos:(id)sender {
//    YSAlbumListViewController *albumListVC = [[YSAlbumListViewController alloc] init];
//    [self presentViewController:albumListVC animated:YES completion:nil];

    YSPhotoPickerController *photoPickerVC = [[YSPhotoPickerController alloc] init];
    [self presentViewController:photoPickerVC animated:YES completion:nil];
    
}

@end
