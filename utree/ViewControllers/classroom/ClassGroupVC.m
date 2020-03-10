//
//  ClassGroupVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassGroupVC.h"
#import "GroupCell.h"
#import "UTStudent.h"
#import "GroupManagerDC.h"
#import "MMAlertView.h"
#import "SelectStudentGroupVC.h"

@interface ClassGroupVC ()<UICollectionViewDelegate,UICollectionViewDataSource,SelectStudentDelegate,GroupViewControllerDelegate>
@property int kLineNum;
@property int kLineSpacing ;
@property(nonatomic,strong)NSArray<GroupModel *> *groupList;
@property(nonatomic,strong)UILabel *currentPlanLabel;
@property(nonatomic,strong)GroupManagerDC *dataController;
@end

@implementation ClassGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _kLineNum=2;
    _kLineSpacing=8;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGroupData:) name:GroupPlanChangedNotifyName object:nil];
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.view = rootLayout;
    self.view.backgroundColor=[UIColor_ColorChange colorWithHexString:GrayBackgroundColor];
    self.dataController = [[GroupManagerDC alloc]init];
    
    [self createTitlepart];
    [self initGridView];
    
    [self reloadGroupData:nil];
}

-(void)reloadGroupData:(id)sender
{
    NSString *planName = [NSString stringWithFormat:@"当前方案为: %@",[self.dataController getCurrentPlanName] ];
    [_currentPlanLabel setText:planName];
    [self.dataController requestGroupListByClassId:[self.dataController getCurrentClassId] planId:[self.dataController getCurrentPlanId] WithSuccess:^(UTResult * _Nonnull result) {
        self.groupList = result.successResult;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
        [self.collectionView.mj_header endRefreshing];
    }];
    
}

-(void)createTitlepart
{
    self.view.backgroundColor = [UIColor myColorWithHexString:@"#FFF7F7F7"];
    _currentPlanLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 17, ScreenWidth-8, 20)];
    [_currentPlanLabel setText:@"当前方案为:unknow"];
    _currentPlanLabel.backgroundColor = [UIColor myColorWithHexString:@"#FFF7F7F7"];
    [_currentPlanLabel setFont:[UIFont systemFontOfSize:13]];
    [_currentPlanLabel setTextColor:[UIColor myColorWithHexString:SecondTextColor]];
    _currentPlanLabel.myLeft=17;
    [self.view addSubview:_currentPlanLabel];
}

-(void)initGridView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /**
     创建collectionView
     */
    CGFloat barHeight = self.tabBarController.tabBar.frame.size.height;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 28, ScreenWidth,ScreenHeight-barHeight-20) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, barHeight*2.3, 0);
    
    [_collectionView registerClass:[GroupCell class] forCellWithReuseIdentifier:@"groupCell"];
 
    [self.view addSubview:_collectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadGroupData:)];
       
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
    return _groupList.count+1;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"groupCell";
    GroupCell *cell =(GroupCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  
    if(indexPath.row==_groupList.count){
        [cell loadAddAction];
    }else{
        GroupModel *model = [_groupList objectAtIndex:indexPath.row];
        [cell loadData:model];
    }
    
    return cell;
}


/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==_groupList.count){
        [self showAddGroupDialog];
    }else{
        GroupModel *model = [_groupList objectAtIndex:indexPath.row];
        GroupDetailVC *detail = [[GroupDetailVC alloc]initWithGroup:model];
        detail.modalPresentationStyle = UIModalPresentationOverFullScreen;
        detail.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        detail.delegate=self;
        [self presentViewController:detail animated:YES completion:nil];
    }
    
}
/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemW = (ScreenWidth-(_kLineNum+1)*_kLineSpacing)/_kLineNum-0.001;
    CGFloat itemH = 0.3*ScreenWidth;
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
    [self presentViewController:self.menuView animated:NO completion:nil];
}

- (GroupMenuView *)menuView
{
    _menuView = [[GroupMenuView alloc]init];
    _menuView.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    _menuView = [[GroupMenuView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    return _menuView;
}

-(NSArray *)simulateData
{
 
    NSMutableArray *groups = [NSMutableArray arrayWithCapacity:12];
    for (int i=0; i<2; i++) {
        GroupModel *groupModel = [[GroupModel alloc]init];
        groupModel.studentDos = [NSMutableArray arrayWithArray:[CFTool generateStudentsWithCapacity:10+i]];
        groupModel.groupName=[NSString stringWithFormat:@"小组%d",i];
        groupModel.groupId =[NSString stringWithFormat:@"18834224%d",i];
        [groups addObject:groupModel];
    }
    
    return groups;
    
}

-(void)showAddGroupDialog
{
    MMAlertView *editView = [[MMAlertView alloc]initWithInputTitle:@"添加小组" detail:@"" placeholder:@"请输入小组名称" handler:^(NSString *text) {
        if (text.length>0) {
            [self toAddMemberForGroupName:text];
        }else{
            [self.view makeToast:@"小组名称不合规范"];
        }
    }];
    [editView show];
}

-(void)toAddMemberForGroupName:(NSString *)groupName
{
    SelectStudentGroupVC *memberVC = [[SelectStudentGroupVC alloc]initWithGroupName:groupName];
    memberVC.hidesBottomBarWhenPushed=YES;
    memberVC.delegate = self;
    [self.navigationController pushViewController:memberVC animated:YES];
}

- (void)onSelectedStuSuccess
{
    [self reloadGroupData:nil];
}

- (void)pushToViewController:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:GroupPlanChangedNotifyName object:nil];
}

@end
