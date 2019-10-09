//
//  GroupDetailVC.m
//  utree
//
//  Created by 科研部 on 2019/9/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupDetailVC.h"
#import "EditGroupVC.h"
#import "UTStudent.h"
#import "UTStudentCollectCell.h"
@interface GroupDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UILabel *countLabel;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIButton *awardBtn;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *studentList;
@property(nonatomic,strong)GroupModel *group;
@property int kLineNum;
@property int kLineSpacing ;
@end

@implementation GroupDetailVC
-(instancetype)initWithGroup:(GroupModel *)group
{
    self = [super init];
    _group = group;
    return self;
}

- (void)viewDidLoad {
    _kLineNum=4;
    _kLineSpacing=8;
    [super viewDidLoad];
    [self createView];
}
static NSString *cellID = @"collectionID";


- (void)createView
{
    CGRect frame = self.view.bounds;
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.frame = frame;
    self.view = rootLayout;
    
    MyFrameLayout *myTopLL = [MyFrameLayout new];
    myTopLL.myHorzMargin = 0;
    myTopLL.frame = CGRectMake(0, 0, ScreenWidth, 55);
    myTopLL.backgroundColor=[UIColor whiteColor];
    myTopLL.layer.cornerRadius = 11;
    
    _bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(0,0,ScreenWidth,460);
    _bgView.backgroundColor = [UIColor myColorWithHexString:@"#FAFAFA"];
    _bgView.layer.cornerRadius = 11;
    [self.view addSubview:_bgView];
    _bgView.myLeft= _bgView.myRight=20;
    _bgView.myCenterY=0;
    [_bgView addSubview:myTopLL];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    _titleLabel.myTop = 20;
    _titleLabel.myCenterX = 0;            //水平居中,如果不等于0则会产生居中偏移
    [_titleLabel setWrapContentSize:YES];
    
    UIView *topBackView = [[UIView alloc] init];
    topBackView.frame = CGRectMake(19.3,110.4,ScreenWidth-40,55.2);
    topBackView.backgroundColor = [UIColor whiteColor];
    topBackView.layer.cornerRadius = 11;
    topBackView.myWidth=ScreenWidth-40;
    [myTopLL addSubview:topBackView];
    [myTopLL addSubview:_titleLabel];
    
    UIButton *stuHomePage = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    stuHomePage.myRight=20;
    stuHomePage.myTop=20;
    [stuHomePage setWrapContentSize:YES];
    [stuHomePage.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [stuHomePage setTitleColor:[UIColor_ColorChange colorWithHexString:PrimaryColor] forState:UIControlStateNormal];
    [stuHomePage setTitle:@"编辑小组" forState:UIControlStateNormal];
    [stuHomePage addTarget:self action:@selector(gotoEditGroup:) forControlEvents:UIControlEventTouchUpInside];

    [_titleLabel setText:_group.groupName];

    [myTopLL addSubview:stuHomePage];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(19, 20, 30, 30)];
    closeBtn.myLeft=closeBtn.myTop=20;
    [closeBtn setImage:[UIImage imageNamed:@"ic_close_black"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closedialog:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bgView addSubview:closeBtn];
    
    [self loadMainView];
    
}

-(void)loadMainView
{
    [self initGridView];
    
    self.awardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 8, ScreenWidth-48,47) ];
    [self.awardBtn setTitle:@"奖励TA们" forState:UIControlStateNormal];
    [self.awardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.awardBtn setBackgroundColor:[UIColor myColorWithHexString:PrimaryColor]];
    _awardBtn.layer.cornerRadius = 24;

    _awardBtn.trailingPos.equalTo(_bgView.trailingPos).offset(22);
    _awardBtn.leadingPos.equalTo(_bgView.leadingPos).offset(22);
    _awardBtn.topPos.equalTo(_collectionView.bottomPos).offset(10);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:_awardBtn];
    
}


-(void)initGridView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /**
     创建collectionView
     */
    CGFloat barHeight = self.tabBarController.tabBar.frame.size.height;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth*0.8,ScreenWidth*0.8) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor myColorWithHexString:@"#FAFAFA"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, barHeight*1.7, 0);
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.myCenterY=1;
    _collectionView.myLeft=_collectionView.myRight=38;
    [_collectionView registerClass:[UTStudentCollectCell class] forCellWithReuseIdentifier:cellID];
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
    return _group.groupMember.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UTStudentCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UTStudent *student = _group.groupMember[indexPath.row];
    [cell setStudentModel:student];
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


//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

-(void)closedialog:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)gotoEditGroup:(id)sender
{
    EditGroupVC *editVC = [[EditGroupVC alloc] initWithGroup:_group];
    editVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:editVC animated:YES completion:nil];
}

@end
