//
//  ClassGroupVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassGroupVC.h"
#import "GroupCell.h"

@interface ClassGroupVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property int kLineNum;
@property int kLineSpacing ;

@end

@implementation ClassGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _kLineNum=2;
    _kLineSpacing=8;
    
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.view = rootLayout;
    self.view.backgroundColor=[UIColor_ColorChange colorWithHexString:GrayBackgroundColor];
    
    [self initGridView];
    
    
}

-(void)initGridView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /**
     创建collectionView
     */
    CGFloat barHeight = self.tabBarController.tabBar.frame.size.height;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-barHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, barHeight*2.3, 0);
    _collectionView.allowsMultipleSelection = YES;
    //    self.edgesForExtendedLayout=UIRectEdgeNone;

    [_collectionView registerClass:[GroupCell class] forCellWithReuseIdentifier:@"groupCell"];
 
    [self.view addSubview:_collectionView];
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
/**
 分区个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/**
 每个分区item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"groupCell";
    GroupCell *cell =(GroupCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    UTStudent *student = _arrayWithTableV[indexPath.row];
    
//    [cell setStudentModel:student];
    
    
    
    return cell;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld分item",(long)indexPath.item);
//    GroupCell *cell = (GroupCell *)[collectionView cellForItemAtIndexPath:indexPath];
 
}
/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemW = (ScreenWidth-(_kLineNum+1)*_kLineSpacing)/_kLineNum-0.001;
    CGFloat itemH = itemW+itemW*0.137;
    return CGSizeMake(itemW, itemH);
}
/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(4, _kLineSpacing, 4, _kLineSpacing);
}
/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return _kLineSpacing;
}
/**
 分区内cell之间的最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return _kLineSpacing;
}


//取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//    GroupCell * cell = (GroupCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = UIColor_ColorChange.whiteColor;
}

- (void)onRightMenuClick
{
    NSLog(@"hello,onRightMenuClick");
//    [self.view addSubview:self.menuView];
    
    [[[UIApplication sharedApplication]keyWindow] addSubview:self.menuView];
    
    [_menuView setHidden:NO];
}

- (GroupMenuView *)menuView
{
    NSLog(@"hello,menuView create");

    _menuView = [[GroupMenuView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    return _menuView;
}


@end