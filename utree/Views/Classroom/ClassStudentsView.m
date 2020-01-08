//
//  ClassStudentsView.m
//  utree
//
//  Created by 科研部 on 2019/10/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassStudentsView.h"
#import "UTStudentCollectCell.h"
#import "UTStudentTableViewCell.h"
#import "UTStudent.h"
@interface ClassStudentsView()<UICollectionViewDelegate,UICollectionViewDataSource,
UITableViewDelegate,UITableViewDataSource,StudentViewModelDelegate>
@property int kLineNum;
@property int kLineSpacing ;
@property(nonatomic,strong)UIButton *awardBtn;
@end

@implementation ClassStudentsView

static NSString *collectionCellID=@"stuCollectionCellId";
static NSString *tableViewCellID =@"studentTableViewCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _kLineNum=4;
        _kLineSpacing=8;
        self.backgroundColor = [UIColor whiteColor];
        [self initGridLayout];
        [self initTableView];
        [self initDefaultPage];
        [self initAwardBtn];
    }
    return self;
}

-(void)initDefaultPage
{
    self.defaultLayout = [MyRelativeLayout new];
    self.defaultLayout.frame=self.frame;
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"pic_default" ofType:@"png"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
    UIImage *image = [UIImage sd_imageWithGIFData:imgData];
    self.defaultImgView = [[UIImageView alloc]initWithImage:image];
    self.defaultImgView.frame = CGRectMake(0, 0, 188, 194);
    self.defaultImgView.centerYPos.equalTo(self.centerYPos).offset(-90);
    self.defaultImgView.myCenterX=0;
    
    
    self.tipsLabel = [UILabel new];
    [self.tipsLabel setText:@"当前还未加入学校，请联系学校管理员"];
    [self.tipsLabel setFont:[UIFont systemFontOfSize:15]];
    self.tipsLabel.textColor = [UIColor myColorWithHexString:@"#808080"];
    [self.tipsLabel sizeToFit];
    self.tipsLabel.myCenterX=0;
    self.tipsLabel.topPos.equalTo(self.defaultImgView.bottomPos).offset(25);
    
    [self.defaultLayout addSubview:self.defaultImgView];
    [self.defaultLayout addSubview:self.tipsLabel];
//    self.defaultLayout
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onDefaultClick:)];
    [self.defaultLayout addGestureRecognizer:tapGesture];
    [self addSubview:self.defaultLayout];
}

-(void)initAwardBtn
{
    _awardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];
    
    [_awardBtn setBackgroundColor:[UIColor_ColorChange colorWithHexString:@"43D27F"]];
    [_awardBtn setTitle:@"奖励所选学生" forState:UIControlStateNormal];
    [_awardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _awardBtn.myTop=[self getAwardBtnYcoord];
    [self addSubview:_awardBtn];
    [_awardBtn setHidden:YES];
    [_awardBtn addTarget:self action:@selector(awardClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"awardBtnFrame= %@",NSStringFromCGRect(_awardBtn.frame));
    NSLog(@"height=%f,%d",ScreenHeight,iPhone_Bottom_NavH);
    
}

-(void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, [self getAwardBtnYcoord]+54) style:UITableViewStylePlain];
    _tableView.sectionIndexColor = [UIColor myColorWithHexString:@"#676767"];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH, 0);
    _tableView.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    _tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
 
     self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
     [self addSubview:_tableView];
     [_tableView setHidden:YES];
}

-(void)loadNewData
{
    [self.responser onLoadNewData];
}

- (void)endRefreshing
{
    if(self.viewModel.studentsModel.count<=0){
        [self.defaultLayout setHidden:NO];
        [self.tipsLabel setText:self.viewModel.defaultMsg];
        [self.tipsLabel sizeToFit];
    }
    [self.tableView.mj_header endRefreshing];
    [self.collectionView.mj_header endRefreshing];
}


-(void)initGridLayout{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH*2, 0);
    _collectionView.allowsMultipleSelection = YES;
    
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    _collectionView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    [_collectionView registerClass:[UTStudentCollectCell class] forCellWithReuseIdentifier:collectionCellID];
    _collectionView.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       //Call this Block When enter the refresh status automatically
        
    }];
    // Set the callback（Once you enter the refresh status，then call the action of target，that is call [self loadNewData]）
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
       
    [self addSubview:_collectionView];
}


-(CGFloat)getAwardBtnYcoord
{
    //titleview height 30 自身高度54
    CGFloat height =ScreenHeight  - iPhone_Top_NavH - SegmentTitleViewHeight -iPhone_Bottom_NavH  -54;
    return height;
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
    return self.viewModel.studentsModel.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UTStudentCollectCell *cell =(UTStudentCollectCell *) [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    UTStudent *student = self.viewModel.studentsModel[indexPath.row];
    
    [cell setStudentModel:student];
    
    return cell;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UTStudent *stu = self.viewModel.studentsModel[indexPath.row];
    [self changeSelectStudentStatus:stu selected:YES fromTableView:NO];
}
//取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTStudent *stu = self.viewModel.studentsModel[indexPath.row];
    [self changeSelectStudentStatus:stu selected:NO fromTableView:NO];
    
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
    
    return self.viewModel.sectionTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.viewModel.sortStudentList objectAtIndex:section] count];
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
    label.text = [NSString stringWithFormat:@"%@",self.viewModel.sectionTitleArray[section]];
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
    UTStudent *student = [[self.viewModel.sortStudentList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [cell setDataToView:student];
    
    return cell;
}

//选中某个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UTStudent *stu = [[self.viewModel.sortStudentList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self changeSelectStudentStatus:stu selected:YES fromTableView:YES];
    //选中后不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.viewModel.sectionTitleArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.viewModel.sectionTitleArray[section]; // [self.indexArray objectAtIndex:section]
}

-(void)changeSelectStudentStatus:(UTStudent *)stu selected:(BOOL)selected fromTableView:(BOOL)from
{
    if (self.viewModel.isMultiMode) {
       [stu changeSelectMode];
        if (selected) {
            [self.viewModel.selectedStudentList addObject:stu];
        }else{
             [self.viewModel.selectedStudentList removeObject:stu];
        }
        if (from) {
            [self.tableView reloadData];
        }else{
            [self.collectionView reloadData];
        }
       
       }else{
           [self.responser onAwardStudents:[NSArray arrayWithObjects:stu, nil]];
       }
}

-(void)awardClick:(id)sender
{
    [self.responser onAwardStudents:self.viewModel.selectedStudentList];
}

-(BOOL)changeCollectionView
{
    if (self.viewModel.studentsModel.count>0) {
        if (_collectionView.hidden) {
               [_tableView setHidden:YES];
               [_collectionView setHidden:NO];
           }else{
               [_tableView setHidden:NO];
               [_collectionView setHidden:YES];
        }
    }
    [self reloadDataToView];
    return [_tableView isHidden];
}

-(void)bindWithViewModel:(StudentsViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.viewModel.delegate=self;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self reloadDataToView];
}

-(void)onDefaultClick:(id)sender
{
    [self loadNewData];
}

-(void)reloadDataToView
{
    if (self.viewModel.studentsModel.count>0) {
        [_collectionView reloadData];
        [_tableView reloadData];
        [self.defaultLayout setHidden:YES];
    }else{
        [self.defaultLayout setHidden:NO];
        [self.tipsLabel setText:self.viewModel.defaultMsg];
        [self.tipsLabel sizeToFit];
    }
    
}

-(void)showAwardStudentButton:(BOOL)visible
{
    
    [_awardBtn setHidden:!visible];
    [_collectionView reloadData];
    [_tableView reloadData];
}

@end
