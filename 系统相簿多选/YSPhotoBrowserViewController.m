//
//  YSPhotoBrowserViewController.m
//  系统相簿多选
//
//  Created by Joseph Gao on 15/11/21.
//  Copyright © 2015年 Joseph. All rights reserved.
//

#import "YSPhotoBrowserViewController.h"
#import "YSPhotoBrowserViewCell.h"
#import "YSAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static NSString *const kPhotoBrowserViewCellReuseID = @"kPhotoBrowserViewCellReuseID";

@interface YSPhotoBrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

/*!
 @brief  导航栏返回按钮
 */
@property (nonatomic, strong) UIButton *backButton;
/*!
 @brief  头部已经选择照片
 */
@property (nonatomic, strong) UILabel *selectedInfoLabel;
/*!
 @brief  选择按钮
 */
@property (nonatomic, strong) UIButton *checkButton;

/*!
 @brief  显示照片的collectionView
 */
@property (nonatomic, weak) UICollectionView *photoCollectionView;
/*!
 @brief  底部操作按钮视图
 */
@property (nonatomic, weak) UIView *footActionView;
/*!
 @brief  发送按钮
 */
@property (nonatomic, weak) UIButton *sendButton;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/*!
 @brief  已经选中的数目
 */
@property (nonatomic, assign) NSInteger selectedNo;

//@property (nonatomic, strong) NSMutableArray *assetsArrayM;


@end

@implementation YSPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
    [self updateActionToolbarInfo];
    
    [self.photoCollectionView registerClass:[YSPhotoBrowserViewCell class] forCellWithReuseIdentifier:kPhotoBrowserViewCellReuseID];
}


/*!
 @brief  在页面布局完成后显示指定indePath的图片
 */
- (void)viewDidLayoutSubviews {
    [self.photoCollectionView scrollToItemAtIndexPath:self.currentIndexPath
                                     atScrollPosition:UICollectionViewScrollPositionNone
                                             animated:NO];
}



#pragma mark - setup UI

- (void)setupNavBar {
    // titleView
    _selectedInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    _selectedInfoLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _selectedInfoLabel;
    
    // selectButton
    _checkButton = [self creakNavBtnWithBackgoundImgName:@"check_button" action:@selector(selectPhoto:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_checkButton];
    
    // back button
    _backButton = [self creakNavBtnWithBackgoundImgName:@"back_btn" action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
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



#pragma mark - action

- (void)goBack {
    if (self.photoBrowserVCHandler) {
        self.photoBrowserVCHandler(self.assetsArray);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)selectPhoto:(UIButton *)checkBtn {
    NSIndexPath *indexPath = [[self.photoCollectionView indexPathsForVisibleItems] firstObject];
    YSAsset *asset = self.assetsArray[indexPath.item];
    
    if (!asset.isSelected && (self.selectedNo == self.maxSelectedNo)) {
        UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多只能选择%zd张照片", self.maxSelectedNo]
                                                             message:nil
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles: nil];
        [allertView show];
        
        return;
    }
    
    checkBtn.selected = !checkBtn.selected;
    if (!checkBtn.selected) {
        self.selectedNo--;
    } else {
        self.selectedNo++;
    }
    
    asset.isSelected = checkBtn.selected;
    
    [self updateActionToolbarInfo];
}


- (void)updateActionToolbarInfo {
    _selectedInfoLabel.text = [NSString stringWithFormat:@"(%zd/%zd)", self.selectedNo, self.maxSelectedNo];
    _selectedInfoLabel.textColor = (self.selectedNo == self.maxSelectedNo) ? [UIColor redColor] : [UIColor blackColor];
}



#pragma mark - collectionView date source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSPhotoBrowserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoBrowserViewCellReuseID
                                                                             forIndexPath:indexPath];
    
    cell.assert = self.assetsArray[indexPath.item];
    
    return cell;
}



#pragma mark - collectionView delegate method 

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    YSAsset *asset = self.assetsArray[indexPath.item];
    self.checkButton.selected = asset.isSelected;
}



#pragma mark - lazy loading

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
    }
    
    return _flowLayout;
}


- (UICollectionView *)photoCollectionView {
    if (!_photoCollectionView) {
        UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                                   collectionViewLayout:self.flowLayout];
        photoCollectionView.delegate = self;
        photoCollectionView.dataSource = self;
        photoCollectionView.showsHorizontalScrollIndicator = NO;
        photoCollectionView.pagingEnabled = YES;
        
        [self.view addSubview:photoCollectionView];
        
        _photoCollectionView = photoCollectionView;
    }
    
    return _photoCollectionView;
}


#pragma mark - 

- (void)setAssetsArray:(NSArray *)assetsArray {
    _assetsArray = assetsArray;
    
    __weak typeof(self) weakSelf = self;
    [assetsArray enumerateObjectsUsingBlock:^(YSAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            weakSelf.selectedNo++;
        }
    }];
}




@end










