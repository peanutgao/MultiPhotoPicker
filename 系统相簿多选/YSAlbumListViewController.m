//
//  YSAlbumListViewController.m
//  
//
//  Created by Joseph on 15/11/19.
//
//

#import "YSAlbumListViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YSAlbumListViewCell.h"
#import "YSPhotoViewController.h"

static NSString *const albumCellReuseID = @"albumCellReuseID";

@interface YSAlbumListViewController ()

@property (nonatomic, strong) ALAssetsLibrary *assetslibrary;
@property (nonatomic, strong) NSMutableArray *albumArrayM;
@property (nonatomic, strong) NSMutableArray *photosArrayM;
@end

@implementation YSAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相簿";
    self.tableView.rowHeight = 70;
    
    [self getAssetsGroupData];
    
    [self.tableView registerClass:[YSAlbumListViewCell class] forCellReuseIdentifier:albumCellReuseID];
    
    UIButton *backBtn = [self creakNavBtnWithBackgoundImgName:@"back_btn" action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}


- (UIButton *)creakNavBtnWithBackgoundImgName:(NSString *)imgName action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat checkButtonX = 0;
    CGFloat checkButtonY = 0;
    CGFloat checkButtonW = 25;
    CGFloat checkButtonH = checkButtonW;
    [btn setFrame:CGRectMake(checkButtonX, checkButtonY, checkButtonW, checkButtonH)];
    [btn setAdjustsImageWhenHighlighted:NO];
    [btn setImage:[self getBundleImgWithImageName:[NSString stringWithFormat:@"%@_normal", imgName]]
         forState:UIControlStateNormal];
    [btn setImage:[self getBundleImgWithImageName:[NSString stringWithFormat:@"%@_selected", imgName]]
         forState:UIControlStateSelected];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


- (UIImage *)getBundleImgWithImageName:(NSString *)imgName {
    NSBundle *multiChooseAlbumBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"YSMultiChooseAlbum"
                                                                                                ofType:@"bundle"]];
    NSString *normalImgPath = [multiChooseAlbumBundle pathForResource:imgName ofType:@"png"];
    
    return [UIImage imageWithContentsOfFile:normalImgPath];
}


- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)getAssetsGroupData {
    __weak typeof(self) weakSelf = self;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSBlockOperation *enumOp = [NSBlockOperation blockOperationWithBlock:^{
        [self.assetslibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [weakSelf.albumArrayM insertObject:group atIndex:0];
                NSLog(@"%@", [group valueForProperty:ALAssetsGroupPropertyName]);
            }
            
        } failureBlock:^(NSError *error) {
            NSLog(@"获取相簿失败%@", error);
        }];
    }];
    
    NSBlockOperation *reloadOp = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf.tableView reloadData];
    }];

    [reloadOp addDependency:enumOp];
    [queue addOperation:enumOp];
    [queue addOperation:reloadOp];

}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumArrayM.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ALAssetsGroup *group = self.albumArrayM[indexPath.row];
    
    YSAlbumListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:albumCellReuseID
                                                                forIndexPath:indexPath];
    cell.group = group;
    
    return cell;
}



#pragma mark - Table view delegate method 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ALAssetsGroup *group = self.albumArrayM[indexPath.row];
    
    YSPhotoViewController *photoVC = [[YSPhotoViewController alloc] init];
    photoVC.group = group;
    photoVC.photoVCHandler = ^(NSArray *selectedImgsArray){
        NSLog(@"%@------", selectedImgsArray);
    };
    
    [self.navigationController pushViewController:photoVC animated:YES];
}


#pragma mark - lazy loading

- (ALAssetsLibrary *)assetslibrary {
    if (!_assetslibrary) {
        _assetslibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return _assetslibrary;
}


- (NSMutableArray *)albumArrayM {
    if (!_albumArrayM) {
        _albumArrayM = [NSMutableArray array];
    }
    
    return _albumArrayM;
}


- (NSMutableArray *)photosArrayM {
    if (!_photosArrayM) {
        _photosArrayM = [NSMutableArray array];
    }
    
    return _photosArrayM;
}



#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        self = [super initWithStyle:UITableViewStylePlain];
    }
    
    return self;
}


@end
