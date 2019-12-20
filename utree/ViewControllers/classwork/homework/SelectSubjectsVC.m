//
//  SelectSubjectsVC.m
//  utree
//
//  Created by 科研部 on 2019/11/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SelectSubjectsVC.h"
#import "UTClassModel.h"
#import "PostHomeworkDC.h"
#import "PostHomeworkVC.h"
@interface SelectSubjectsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *classList;
@property(nonatomic,strong)NSMutableArray *subjectList;
@property(nonatomic,strong)NSString *selectedSubjectId;
@property(nonatomic,strong)NSArray<NSDictionary *> *responseData;

//@property(nonatomic,strong)MyRelativeLayout *navBarLayout;
@property(nonatomic,strong)MyRelativeLayout *bottomBarLayout;
@property(nonatomic,strong)UIButton *nextStepBtn;
@property(nonatomic,strong)UIButton *selectAllBtn;
@property(nonatomic,strong)PostHomeworkDC *dataController;


@property(nonatomic,strong)NSMutableDictionary *paramDic;
@property(nonatomic,assign)BOOL isSelectingClass;
@end



@implementation SelectSubjectsVC
static NSString *cellId=@"subjectsClassId";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择科目/班级";
    [self initNaviBar];
    [self initTableView];
    [self loadClassData];
    
}

-(void)initNaviBar
{
    MyRelativeLayout *relativeLayout = [MyRelativeLayout new];
    relativeLayout.frame = self.view.frame;
    self.view = relativeLayout;
    self.view.backgroundColor=[UIColor myColorWithHexString:@"#F7F7F7"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    MyRelativeLayout *navBarLayout = [MyRelativeLayout new];
//    navBarLayout.frame = CGRectMake(0, 0, ScreenWidth, 64);
//    navBarLayout.backgroundColor = [UIColor whiteColor];
//    navBarLayout.myTop=iPhone_StatuBarHeight;
//    navBarLayout.myLeft=0;
//
//    UILabel *navTitle = [[UILabel alloc]init];
//    navTitle.myCenterX=0;
//    navTitle.myCenterY=0;
//    navTitle.textColor = [UIColor blackColor];
//    navTitle.font = [UIFont boldSystemFontOfSize:20];
//
//    [navTitle sizeToFit];
//
//    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
//    [closeButton setImage:[UIImage imageNamed:@"ic_close_black"] forState:UIControlStateNormal];
//    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//    [closeButton sizeToFit];
//    [closeButton addTarget:self action:@selector(finishVC:) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.myTop=0;
//    closeButton.myLeft=18;
//    closeButton.myCenterY=0;
//
//    [navBarLayout addSubview:closeButton];
//    [navBarLayout addSubview:navTitle];
//    self.navBarLayout = navBarLayout;
//    [self.view addSubview:self.navBarLayout];
    
    MyRelativeLayout *bottomBar = [MyRelativeLayout new];
    bottomBar.frame = CGRectMake(0, 0, ScreenWidth, 58);
    bottomBar.backgroundColor = [UIColor whiteColor];
    bottomBar.bottomPos.equalTo(self.view.bottomPos).offset(iPhone_Safe_BottomNavH);
    bottomBar.myLeft=0;

    UIButton *selectAllBtn = [[UIButton alloc]init];
    selectAllBtn.frame = CGRectMake(0, 0, 130, 50);
    selectAllBtn.backgroundColor = [UIColor clearColor];
    //设置button正常状态下的图片
    [selectAllBtn setImage:[UIImage imageNamed:@"ic_unselect_round"] forState:UIControlStateNormal];
    //设置button高亮状态下的图片
    [selectAllBtn setImage:[UIImage imageNamed:@"ic_selected_round"] forState:UIControlStateHighlighted];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    //button标题的偏移量，这个偏移量是相对于图片的
     [selectAllBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,selectAllBtn.imageView.image.size.width, 0, 0)];
//    {top, left, bottom, right}
     [selectAllBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    //设置button正常状态下的标题颜色
    [selectAllBtn setTitleColor:[UIColor myColorWithHexString:@"#808080"] forState:UIControlStateNormal];
    //设置button高亮状态下的标题颜色
    [selectAllBtn setTitleColor:[UIColor myColorWithHexString:PrimaryColor] forState:UIControlStateHighlighted];
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectAllBtn addTarget:self action:@selector(dealWithSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    selectAllBtn.myLeft=12;
    selectAllBtn.myCenterY=0;
    self.selectAllBtn = selectAllBtn;
    
    UIButton *nextStepBtn = [[UIButton alloc]init];
    nextStepBtn.frame = CGRectMake(0, 0, 120, 42);
    [nextStepBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [nextStepBtn setTitle:@"发布作业(1/3)" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextStepBtn.backgroundColor = [UIColor myColorWithHexString:PrimaryColor];
    nextStepBtn.layer.cornerRadius = 5;
    nextStepBtn.myCenterY = 0;
    nextStepBtn.rightPos.equalTo(bottomBar.rightPos).offset(18);
    [nextStepBtn addTarget:self action:@selector(onNextClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nextStepBtn = nextStepBtn;
//    [bottomBar addSubview:self.selectAllBtn];
    [bottomBar addSubview:nextStepBtn];
    self.bottomBarLayout = bottomBar;
    [self.view addSubview:self.bottomBarLayout];
}

-(void)loadClassData
{
    self.dataController = [[PostHomeworkDC alloc]init];
    self.classList = [[NSMutableArray alloc]init];
    [self.dataController requestClassAndSubjectsWithSuccess:^(UTResult * _Nonnull result) {
        
        
        self.responseData = result.successResult;
        NSMutableDictionary *classListDic = [[NSMutableDictionary alloc]init];
        
        for (NSDictionary *classSubjectDic in self.responseData) {
             NSArray *classListModel = [UTClassModel mj_objectArrayWithKeyValuesArray:[classSubjectDic objectForKey:@"classDoList"]];
            
            for (UTClassModel *classModel in classListModel) {
                classModel.subject= [classSubjectDic objectForKey:@"subjectName"];
                classModel.subjectId=[classSubjectDic objectForKey:@"teacherSubjectId"];
                [classListDic setObject:classModel forKey:classModel.subjectId];
            }

        }
        for (UTClassModel *classModel in [classListDic allValues]) {
            NSLog(@"class %@, subjectName %@",classModel.classGrade,classModel.subject);
        }
        [self.classList addObjectsFromArray:[classListDic allValues]];
        [self.tableView reloadData];
    } failure:^(UTResult * _Nonnull result) {
        [self showAlertMessage:@"" title:result.failureResult];
    }];
}

-(void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 400) style:UITableViewStyleGrouped];
    _tableView.myTop=iPhone_Top_NavH;
    _tableView.bottomPos.equalTo(self.bottomBarLayout.topPos);
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _classList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    UTClassModel *classModel = [self.classList objectAtIndex:indexPath.row];
    if (_isSelectingClass) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%d年(%d)班",classModel.classGrade.intValue,classModel.classCode.intValue]];
    }else{
        [cell.textLabel setText:classModel.subject];
        
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (classModel.isSelected) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_selected_round"]];
    }else{
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_unselect_round"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     UTClassModel *classModel = [self.classList objectAtIndex:indexPath.row];
    [classModel setIsSelected:!classModel.isSelected];
    if(!classModel.isSelected){
        [self.selectAllBtn setImage:[UIImage imageNamed:@"ic_unselect_round"] forState:UIControlStateNormal];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if (!_isSelectingClass) {
         [self onSelectedSubjectClick:classModel];
    }
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isSelectingClass) {
        return @"可见班级:";
    }
    return @"选择科目";
    
}


-(void)dealWithSelectAll:(id)sender
{
    [self.selectAllBtn setImage:[UIImage imageNamed:@"ic_selected_round"] forState:UIControlStateNormal];
    for (UTClassModel *model in self.classList) {
        model.isSelected = YES;
    }
    [self.tableView reloadData];
    
}


-(void)finishVC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//选择了科目
-(void)onSelectedSubjectClick:(UTClassModel *)classModel
{
    [self.bottomBarLayout addSubview:self.selectAllBtn];
    _isSelectingClass=YES;
    _selectedSubjectId = classModel.subjectId;
    [self.classList removeAllObjects];
    for (NSDictionary *classSubjectDic in self.responseData){
        NSString *subjectId=[classSubjectDic objectForKey:@"teacherSubjectId"];
        if ([subjectId isEqualToString:_selectedSubjectId]) {
            NSArray *classListModel = [UTClassModel mj_objectArrayWithKeyValuesArray:[classSubjectDic objectForKey:@"classDoList"]];
            
            for (UTClassModel *classModel in classListModel) {
                classModel.subject= [classSubjectDic objectForKey:@"subjectName"];
                classModel.subjectId=[classSubjectDic objectForKey:@"teacherSubjectId"];
                [self.classList addObject:classModel];
            }
        }
    }
    
    [self.tableView reloadData];
    [self.nextStepBtn setTitle:@"发布作业(2/3)" forState:UIControlStateNormal];
    
}

-(void)onNextClick:(id)sender
{
    if (_isSelectingClass) {
        NSMutableArray *selectedClassIdList = [[NSMutableArray alloc]init];
        for (UTClassModel *classModel in self.classList) {
            if(classModel.isSelected){
                [selectedClassIdList addObject:classModel.classId];
            }
        }
        if (selectedClassIdList.count==0) {
            [self.view makeToast:@"请选择班级"];
        }else{
             
            PostHomeworkVC *postTaskVC = [[PostHomeworkVC alloc]initWithSubjectId:_selectedSubjectId classIdList:selectedClassIdList];
            postTaskVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:postTaskVC animated:YES completion:nil];
           [self.navigationController popViewControllerAnimated:NO];
        }
        
    }else{
        [self.view makeToast:@"请选择科目"];
    }
    
    
}

@end
