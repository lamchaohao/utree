//
//  AwardListVC.m
//  utree
//
//  Created by 科研部 on 2019/9/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AwardListVC.h"
#import "AwardItemCell.h"

@interface AwardListVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property int kLineNum;
@property int kLineSpacing ;
@end

@implementation AwardListVC
static NSString *cellID = @"collectionID";
- (void)viewDidLoad {
    [super viewDidLoad];
    _kLineNum=4;
    _kLineSpacing=8;
    [self loadData];
    [self initGridView];
    self.view.backgroundColor=[UIColor myColorWithHexString:@"#FAFAFA"];
    
}

-(void)loadData
{
    
    _awardItemArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<12; i++) {
        [_awardItemArray addObject:@"学习有劲"];
    }
    
    
}

-(void)initGridView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /**
     创建collectionView
     */
    CGFloat barHeight = self.tabBarController.tabBar.frame.size.height;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth*0.8,ScreenWidth*0.88) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, barHeight*2.3, 0);
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.myCenterY=1;
    _collectionView.myLeft=_collectionView.myRight=41;
    //    self.edgesForExtendedLayout=UIRectEdgeNone;
    /**
     注册item和区头视图、区尾视图
     */
    [_collectionView registerClass:[AwardItemCell class] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:_collectionView];
}


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
    return _awardItemArray.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AwardItemCell *cell =(AwardItemCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    UTStudent *student = _arrayWithTableV[indexPath.row];
    
//    [cell setStudentModel:student];
    return cell;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
}
//取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



@end
