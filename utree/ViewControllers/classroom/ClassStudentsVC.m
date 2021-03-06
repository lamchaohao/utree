//
//  ClassPersonVCViewController.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassStudentsVC.h"
#import "ClassStudentsDC.h"
#import "ClassStudentsView.h"
#import "StudentsViewModel.h"
#import "AwardVC.h"
@interface ClassStudentsVC ()<ClassStudentsViewResponser,AwardVCDelegate>
@property int kLineNum;
@property int kLineSpacing ;
@property(nonatomic,strong)NSMutableArray *selectedStudents;
@end

@implementation ClassStudentsVC

static NSString *tableViewCellID =@"tableViewCell";
static NSString *collectionCellID = @"MyCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _kLineNum=4;
    _kLineSpacing=8;
    _selectedStudents = [[NSMutableArray alloc]init];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStuData:) name:ClazzChangedNotifycationName object:nil];
    [self loadData];

}


-(void)loadData
{
    self.dataController = [[ClassStudentsDC alloc]init];
    self.viewModel = [[StudentsViewModel alloc]init];
    ClassStudentsView *rootView = [[ClassStudentsView alloc]initWithFrame:self.view.frame];
    self.view = rootView;
    rootView.responser=self;
    [rootView bindWithViewModel:self.viewModel];
    [self.dataController requestStudentListWithSuccess:^(UTResult * _Nonnull result) {
        [self.viewModel setData:result.successResult];
        [self.viewModel endRefreshing];
    } failure:^(UTResult * _Nonnull result) {
        self.viewModel.defaultMsg=result.failureResult;
        [self.viewModel endRefreshing];
        NSLog(@"loadData fail=%@",result.failureResult);
    }];
    
}

- (void)onLoadNewData
{
    [self.dataController requestStudentListWithSuccess:^(UTResult * _Nonnull result) {
        [self.viewModel setData:result.successResult];
        [self.viewModel endRefreshing];
    } failure:^(UTResult * _Nonnull result) {
        NSLog(@"onLoadNewData fail=%@",result.failureResult);
        [self.viewModel setData:[[NSArray alloc]init]];
        self.viewModel.defaultMsg=result.failureResult;
        [self.viewModel endRefreshing];
    }];
}
//1首字母,2 按水滴降序,3水滴升序
- (void)sortStudentByType:(int)type
{
    [self.viewModel sortStudentsWithType:type];
}

-(void)reloadStuData:(NSNotification *) notification
{
    [self onLoadNewData];
}

- (void)onAwardStudents:(NSArray *)students
{
   
    //没有学生，返回
    if (students.count<1) {
        [self.viewModel switchToMultiChoice];
        return;
    }else if (students.count>1){
        [self.viewModel switchToMultiChoice];
    }
    AwardVC *awardVC= [[AwardVC alloc]initByPassStuList:students groupId:nil];
    awardVC.vcDelegate = self;
    awardVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    awardVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:awardVC animated:YES completion:nil];
    
}


#pragma mark 是否显示九宫格图
-(BOOL)switchToGridView{
    return [self.viewModel switchToGridView];
}
# pragma mark 切换多选模式
-(void)switchToMultiChoice
{
    [self.viewModel switchToMultiChoice];
}


#pragma mark AwardVCDelegate
- (void)pushToViewController:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onAwardSuccess:(AwardModel *)model
{
    if (model) {
        [self.viewModel afterAwardSuccess:model];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ClazzChangedNotifycationName object:nil];
}

@end
