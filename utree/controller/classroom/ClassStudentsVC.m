//
//  ClassPersonVCViewController.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassStudentsVC.h"
#import "AutoScaleFrameMain.h"
#import "UTStudentCollectCell.h"
#import "UTStudentTableViewCell.h"
#import "ZBChineseToPinyin.h"
#import "DropDetailVC.h"
#import "UTStudent.h"
#import "AwardVC.h"
@interface ClassStudentsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property int kLineNum;
@property int kLineSpacing ;
@property(nonatomic,strong)UIButton *awardBtn;
@property(nonatomic,strong)NSMutableArray *selectedStudents;

@end

@implementation ClassStudentsVC

static NSString *tableViewCellID =@"tableViewCell";
static NSString *collectionCellID = @"MyCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.view = rootLayout;

    self.view.backgroundColor=[UIColor whiteColor];
    _kLineNum=4;
    _kLineSpacing=8;
    _selectedStudents = [[NSMutableArray alloc]init];
    [self loadData];
    [self initGridLayout];
    [self initTableView];
    [self initAwardBtn];
}

-(void)loadData
{
    _studentList = [CFTool generateStudentsWithCapacity:54];
    
    self.sectionTitleArray = [ZBChineseToPinyin indexWithArray:_studentList Key:@"studentName"];
    self.sortStudentList = [ZBChineseToPinyin sortObjectArray:_studentList Key:@"studentName"];
}


#pragma mark 是否显示九宫格图
-(void)showCollectionView:(BOOL )enable{
    
    if (enable) {
        [_tableView setHidden:YES];
        [_collectionView setHidden:NO];
    }else{
        [_tableView setHidden:NO];
        [_collectionView setHidden:YES];
    }
    [_collectionView reloadData];
    [_tableView reloadData];
}
# pragma mark 切换多选模式
-(void)switchToMultiChoice
{
    _isMultiMode = !_isMultiMode;
    if(!_isMultiMode){
        //反选所有学生
        for (UTStudent *stu in _studentList) {
            [stu cancleSelectMode];
        }
        [_awardBtn setHidden:YES];
    }else{
        for (UTStudent *stu in _studentList) {
            [stu setBeSelected];
        }
        
       [_awardBtn setHidden:NO];
    }
    [_collectionView reloadData];
    [_tableView reloadData];
}

-(void)initAwardBtn
{
    _awardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, [self getAwardBtnYcoord], ScreenWidth, 54)];
    
    [_awardBtn setBackgroundColor:[UIColor_ColorChange colorWithHexString:@"43D27F"]];
    [_awardBtn setTitle:@"奖励所选学生" forState:UIControlStateNormal];
    [_awardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:_awardBtn];
    [_awardBtn setHidden:YES];
    [_awardBtn addTarget:self action:@selector(awardClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 奖励学生按钮
-(void)awardClick:(UIButton *)sender
{
    for (UTStudent *stu in _studentList) {
        stu.selectMode=0;
    }
    [_awardBtn setHidden:YES];
    
    _isMultiMode=NO;
    [_collectionView reloadData];
    [_tableView reloadData];
    
    [self gotoAwardVCWithStuList:_selectedStudents];
    
}

#pragma mark 跳转到奖励页面
-(void)gotoAwardVCWithStuList:(NSArray *)stus
{
    //没有学生，返回
    if (stus.count<1) {
        return;
    }
    AwardVC *awardVC= [[AwardVC alloc]initByPassStuList:stus];
    awardVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:awardVC animated:YES completion:nil];
    
}


#pragma mark 当前九宫格视图是否显示
-(BOOL)isCollectionViewOnShow{
    return ![_collectionView isHidden];
}

//初始化tableview
-(void)initTableView
{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight  - iPhone_Top_NavH - SegmentTitleViewHeight -iPhone_Bottom_NavH) style:UITableViewStylePlain];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.sectionIndexColor = [UIColor myColorWithHexString:@"#676767"];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH, 0);

    [self.view addSubview:_tableView];
    [_tableView setHidden:YES];
    
   
}

-(void)initGridLayout{

    
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

    /**
     注册item和区头视图、区尾视图
     */
    [_collectionView registerClass:[UTStudentCollectCell class] forCellWithReuseIdentifier:collectionCellID];
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
    return _studentList.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UTStudentCollectCell *cell =(UTStudentCollectCell *) [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    UTStudent *student = _studentList[indexPath.row];
    
    [cell setStudentModel:student];
    
    return cell;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UTStudentCollectCell *cell = (UTStudentCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UTStudent *stu = _studentList[indexPath.row];
    if (_isMultiMode) {
        
        stu.selectMode=1;
        [_selectedStudents addObject:stu];
        [cell setStudentModel:stu];
    }else{
        [self gotoAwardVCWithStuList:[NSArray arrayWithObjects:stu, nil]];
    }
   
}
//取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTStudentCollectCell *cell = (UTStudentCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UTStudent *stu = _studentList[indexPath.row];
    if (_isMultiMode) {
        stu.selectMode=2;
        [_selectedStudents removeObject:stu];
        [cell setStudentModel:stu];
    }else{
        [self gotoAwardVCWithStuList:[NSArray arrayWithObjects:stu, nil]];
    }
    
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


#pragma mark tableview code start



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *array = [self.dataSource valueForKey:self.sectionTitleArray[section]];
    
    return [[self.sortStudentList objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 24)];
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%@",self.sectionTitleArray[section]];
    [view addSubview:label];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.frame = CGRectMake(11, 0, 100, 25);
    view.backgroundColor=[UIColor myColorWithHexString:@"#FFF7F7F7"];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

//创建TableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UTStudentTableViewCell *cell =(UTStudentTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UTStudentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableViewCellID];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UTStudent *student = [[_sortStudentList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text=student.studentName;
    cell.scoreLabel.text = [NSString stringWithFormat:@"%ld",student.dropScore];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:student.headImgURL]];
    
    if (student.selectMode==1) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_selected_green"]];
        
    }else if(student.selectMode==2){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_unselected_gray_small"]];
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}

//选中某个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UTStudent *stu = [[_sortStudentList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (_isMultiMode) {
        [stu changeSelectMode];
        [_selectedStudents addObject:stu];
//        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadData];

    }else{
        [self gotoAwardVCWithStuList:[NSArray arrayWithObjects:stu, nil]];
    }
    
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitleArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitleArray[section]; // [self.indexArray objectAtIndex:section]
}

#pragma mark - Getter/Setter
- (void)setStudentList:(NSArray *)arrayWithTableV{
    _studentList = arrayWithTableV;
}



-(CGFloat)getAwardBtnYcoord
{
    //titleview height 30 自身高度54
    CGFloat height =ScreenHeight  - iPhone_Top_NavH - SegmentTitleViewHeight -iPhone_Bottom_NavH  -54;

    return height;
    
}


@end
