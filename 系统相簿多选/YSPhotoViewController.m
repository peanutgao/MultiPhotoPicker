//
//  YSPhotoViewController.m
//  系统相簿多选
//
//  Created by Joseph on 15/11/19.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSPhotoViewController.h"
#import "YSPhotoCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YSPhotoBrowserViewController.h"
#import "YSAsset.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define ITEM_MARGIN 2
#define EDGE_MARGIN 10

#define LINE_ITEM_NUMBER 4


static NSString *const photoCVCellReuseID = @"photoCVCellReuseID";

@interface YSPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, YSPhotoCollectionViewCellDelegate>
/*!
 @brief  显示group的所有照片的collectionView
 */
@property (nonatomic, weak) UICollectionView *photosCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/*!
 @brief  相簿中的所有照片Asset集合
 */
@property (nonatomic, strong) NSArray *assetArray;
/*!
 @brief  底部照片操作的toolBar
 */
@property (nonatomic, strong) UIView *actionToolbar;
/*!
 @brief  '预览'按钮
 */
@property (nonatomic, strong) UIButton *preViewBtn;
/*!
 @brief  '完成'按钮
 */
@property (nonatomic, strong) UIButton *doneBtn;
/*!
 @brief  选择信息标签
 */
@property (nonatomic, strong) UILabel *selectedInfoLabel;
/*!
 @brief  已经选中的Asset集合
 */
@property (nonatomic, strong) NSMutableArray *selectedAssetArrayM;
/*!
 @brief  可以选择的最大照片数
 */
@property (nonatomic, assign) NSInteger maxSelectedNo;

@end



@implementation YSPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相机照片";
    self.maxSelectedNo = 5;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupToolbar];
    
    [self.photosCollectionView registerClass:[YSPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoCVCellReuseID];

}


- (void)setupToolbar {
    _selectedInfoLabel = [[UILabel alloc] init];
    CGFloat chooseInfoLabelW = 100;
    CGFloat chooseInfoLabelH = 44;
    CGFloat chooseInfoLabelX = (SCREEN_WIDTH - chooseInfoLabelW) * 0.5;
    CGFloat chooseInfoLabelY = 0;
    _selectedInfoLabel.frame = CGRectMake(chooseInfoLabelX, chooseInfoLabelY, chooseInfoLabelW, chooseInfoLabelH);
    [self updateActionToolbarInfo]; // 设置初始显示为 0/最大选择数
    _selectedInfoLabel.textColor = [UIColor blackColor];
    _selectedInfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.actionToolbar addSubview:_selectedInfoLabel];
    
    
    _preViewBtn = [self creatActionBtnWithX:EDGE_MARGIN
                                      title:@"预览"
                                     action:@selector(previewBtnClicked:)];
    
    CGFloat doneBtnX = SCREEN_WIDTH - EDGE_MARGIN - _preViewBtn.frame.size.width;
    _doneBtn = [self creatActionBtnWithX:doneBtnX
                                   title:@"完成"
                                  action:@selector(doneBtnClicked:)];
}


- (UIButton *)creatActionBtnWithX:(CGFloat)x title:(NSString *)title action:(SEL)action {
    CGFloat preViewBtnX = x;
    CGFloat preViewBtnY = 0;
    CGFloat preViewBtnW = 60;
    CGFloat preViewBtnH = 44;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(preViewBtnX, preViewBtnY, preViewBtnW, preViewBtnH)];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setEnabled:NO];
    
    [self.actionToolbar addSubview:btn];
    
    return btn;
}



#pragma mark - action 

- (void)previewBtnClicked:(UIButton *)previewBtn {
    
    YSPhotoBrowserViewController *photoBrowserVC = [[YSPhotoBrowserViewController alloc] init];
    photoBrowserVC.assetsArray = self.selectedAssetArrayM.copy;
    photoBrowserVC.maxSelectedNo = self.maxSelectedNo;
    
    __weak typeof(self) weakSelf = self;
    photoBrowserVC.photoBrowserVCHandler = ^(NSArray *assetArray){
        [weakSelf handleData:assetArray];
    };
    
    [self showViewController:photoBrowserVC sender:nil];
}


- (void)doneBtnClicked:(UIButton *)previewBtn {
    NSLog(@"%s", __func__);
    
    if (self.photoVCHandler) {
        self.photoVCHandler(self.selectedAssetArrayM.copy);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)handleData:(NSArray *)assetArray {
    __weak typeof(self) weakSelf = self;
    [assetArray enumerateObjectsUsingBlock:^(YSAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index = [weakSelf.assetArray indexOfObject:obj];
        YSAsset *asset = weakSelf.assetArray[index];
        asset.isSelected = obj.isSelected;
        
        // 如果obj不在selectedAssetArrayM数组中, 同时obj是选中的状态, 则添加到selectedAssetArrayM中
        // 如果obj在selectedAssetArrayM数组中, 但是obj是不是选中的状态, 则将obj从selectedAssetArrayM中移除
        if ([weakSelf.selectedAssetArrayM indexOfObject:obj] == NSNotFound && obj.isSelected) {
            [weakSelf.selectedAssetArrayM addObject:asset];
            
        } else if ([weakSelf.selectedAssetArrayM indexOfObject:obj] != NSNotFound && !obj.isSelected) {
            [weakSelf.selectedAssetArrayM removeObject:asset];
        }
        
    }];
    
    [weakSelf.photosCollectionView reloadData];
    [weakSelf updateActionToolbarInfo];

}

#pragma mark - collection datesource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCVCellReuseID
                                                                                forIndexPath:indexPath];
    
    cell.photoCellDelegate = self;
    
    cell.asset = self.assetArray[indexPath.row];
    
    return cell;
}



#pragma mark - delegate method

// collection View delegate method
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YSPhotoBrowserViewController *photoBrowserVC = [[YSPhotoBrowserViewController alloc] init];
    
    photoBrowserVC.assetsArray = self.assetArray;
    photoBrowserVC.maxSelectedNo = self.maxSelectedNo;
    photoBrowserVC.currentIndexPath = indexPath;
    
    __weak typeof(self) weakSelf = self;
    photoBrowserVC.photoBrowserVCHandler = ^(NSArray *assetArray){
        [weakSelf handleData:assetArray];
    };
    
    [self showViewController:photoBrowserVC sender:nil];
    
}


// YSPhotoCollectionViewCell delegate method
- (void)photoCollectionViewCell:(YSPhotoCollectionViewCell *)cell clickCheckBtn:(UIButton *)checkBtn {
    if (self.selectedAssetArrayM.count >= self.maxSelectedNo && !checkBtn.selected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多只能选择%zd个", self.maxSelectedNo]
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    } else {
        NSIndexPath *indexPath = [self.photosCollectionView indexPathForCell:cell];
        YSAsset *asset = self.assetArray[indexPath.row];
        
        if (!checkBtn.selected) {
            [self.selectedAssetArrayM addObject:asset];
        } else {
            [self.selectedAssetArrayM removeObject:asset];
        }

        asset.isSelected = !asset.isSelected;
        [self.photosCollectionView reloadItemsAtIndexPaths:@[indexPath]];

        // 更新标签
        [self updateActionToolbarInfo];
    }


}

/*!
 @brief  更新ActionToolbar中按钮的状态
 */
- (void)updateActionToolbarInfo {
    self.selectedInfoLabel.text = [NSString stringWithFormat:@"(%zd/%zd)", self.selectedAssetArrayM.count, self.maxSelectedNo];
    _selectedInfoLabel.textColor = (self.selectedAssetArrayM.count == self.maxSelectedNo) ? [UIColor redColor] : [UIColor blackColor];
    _preViewBtn.enabled = self.selectedAssetArrayM.count ? YES : NO;
    _doneBtn.enabled = self.selectedAssetArrayM.count ? YES : NO;
}



#pragma set data

- (void)setGroup:(ALAssetsGroup *)group {
    __block NSMutableArray *assetArrayM = [NSMutableArray array];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {     // 遍历获取缩略图
        if (result) {
            YSAsset *assert = [YSAsset assetWithAsset:result];  // 将 ALAsset 转换成 YSAsset
            [assetArrayM insertObject:assert atIndex:0];
        }

    }];
    
    self.assetArray = assetArrayM.copy;
}



#pragma mark - lazy loading 

- (UICollectionView *)photosCollectionView {
    if (!_photosCollectionView) {
        CGFloat x = 0;
        CGFloat y = 64;
        CGFloat w = SCREEN_WIDTH;
        CGFloat h = SCREEN_HEIGHT - y - self.actionToolbar.bounds.size.height;
        UICollectionView *photosCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(x, y, w, h) collectionViewLayout:self.flowLayout];
       
        photosCollectionView.dataSource = self;
        photosCollectionView.delegate = self;
        photosCollectionView.backgroundColor = [UIColor whiteColor];
       
        [self.view addSubview:photosCollectionView];
        
        _photosCollectionView = photosCollectionView;
    }
    
    return _photosCollectionView;
}


- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat itemWH = (SCREEN_WIDTH - ITEM_MARGIN * (LINE_ITEM_NUMBER + 1)) / LINE_ITEM_NUMBER;
        _flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        _flowLayout.minimumLineSpacing = ITEM_MARGIN;
        _flowLayout.minimumInteritemSpacing = ITEM_MARGIN;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    
    return _flowLayout;
}


- (NSArray *)assetArray {
    if (!_assetArray) {
        _assetArray = [NSArray array];
    }
    
    return _assetArray;
}


- (NSMutableArray *)selectedAssetArrayM {
    if (!_selectedAssetArrayM) {
        _selectedAssetArrayM = [NSMutableArray array];
    }
    
    return _selectedAssetArrayM;
}


- (UIView *)actionToolbar {
    if (!_actionToolbar) {
        _actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                     SCREEN_HEIGHT - 44,
                                                                     SCREEN_WIDTH,
                                                                     44)];
        _actionToolbar.backgroundColor = [UIColor redColor];
        [self.view addSubview:_actionToolbar];
    }
    
    return _actionToolbar;
}


@end







