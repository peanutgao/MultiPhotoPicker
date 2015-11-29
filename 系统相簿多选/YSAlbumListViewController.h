//
//  YSAlbumListViewController.h
//  
//
//  Created by Joseph on 15/11/19.
//
//

#import <UIKit/UIKit.h>

typedef void(^AlbumListVCHandler)(NSArray *selectedImgsArray);

@interface YSAlbumListViewController : UITableViewController

@property (nonatomic, copy) AlbumListVCHandler albumListVCHandler;

@end
