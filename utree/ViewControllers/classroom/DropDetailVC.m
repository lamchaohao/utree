//
//  DropDetailVC.m
//  utree
//
//  Created by 科研部 on 2019/8/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DropDetailVC.h"
#import "DropDetailDC.h"
#import "DropDetailView.h"
#import "StuTreeModel.h"
#import "SJDateConvertTool.h"
@interface DropDetailVC ()<DropDetailViewResponser>
@property(nonatomic,strong)DropDetailDC *dataController;
@property(nonatomic,strong)NSString *studentId;
@property(nonatomic,strong)DropDetailViewModel *viewModel;
@property(nonatomic,strong)DropDetailView *mainView;
@property(nonatomic,assign)NSNumber *dateType;
@end

@implementation DropDetailVC

- (instancetype)initWithStudentId:(NSString *)stuId
{
    self = [super init];
    if (self) {
        self.dateType = [NSNumber numberWithLong:2];
        self.studentId = stuId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;//隐藏bar
    self.mainView= [[DropDetailView alloc]initWithFrame:self.view.bounds];
    self.mainView.responser = self;
    [self.view addSubview:self.mainView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
}

-(void)initData
{
    self.viewModel = [[DropDetailViewModel alloc]init];
    self.dataController = [[DropDetailDC alloc]init];
    //获取树形态信息
    [self.dataController requestStudentTreeData:self.studentId WithSuccess:^(UTResult * _Nonnull result) {
        self.viewModel.wrapTreeModel = result.successResult;
        [self.mainView bindWithViewModel:self.viewModel];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
    //获取勋章信息
    [self.dataController requestMedalData:self.studentId WithSuccess:^(UTResult * _Nonnull result) {
        self.viewModel.medalData = result.successResult;
        
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
    
    //获取水滴记录信息
    [self.dataController requestDropRecordFirst:self.studentId dateZone:self.dateType WithSuccess:^(UTResult * _Nonnull result) {
        self.viewModel.wrapDropRecordModel = result.successResult;
        [self handlerRecordList];
        
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
    
}

- (void)onChangeDate:(NSInteger)index
{
    self.dateType= [NSNumber numberWithLong:index];
    
    //获取水滴记录信息
    [self.dataController requestDropRecordFirst:self.studentId dateZone:[NSNumber numberWithLong:index] WithSuccess:^(UTResult * _Nonnull result) {
        [self.viewModel.dropRecordList removeAllObjects];
        [self.viewModel.dateTitleList removeAllObjects];
        self.viewModel.wrapDropRecordModel = result.successResult;
        if ( !self.viewModel.wrapDropRecordModel.list
            ||self.viewModel.wrapDropRecordModel.list.count==0) {
            //无水滴记录也需要刷新
            [self.mainView refreshDropRecord];
            return ;
        }
        
        [self handlerRecordList];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}

#pragma mark load more data
-(void)loadMoreRecords
{
    //上一次加载更多的时候list为空，故[self.viewModel.wrapDropRecordModel.list lastObject]为空
    StuDropRecordModel *lastRecord=[self.viewModel.wrapDropRecordModel.list lastObject];
    if (!lastRecord) {
        [self.mainView onLoadFinish];
        return;
    }
    [self.dataController requestMoreDropRecordWithStuId:self.studentId dateZone:self.dateType lastDropId:lastRecord.dropId limit:[NSNumber numberWithLong:20] WithSuccess:^(UTResult * _Nonnull result) {
        [self.mainView onLoadFinish];
        WrapDropRecordModel *wrapResult =result.successResult;
        if (wrapResult.list) {
            self.viewModel.wrapDropRecordModel = wrapResult;
            [self handlerRecordList];
            
        }else{
            NSLog(@"result.list==nil");
        }
        
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
        [self.mainView onLoadFinish];
    }];
}

-(void)handlerRecordList
{
    
    NSArray *recordList = self.viewModel.wrapDropRecordModel.list;//新数据
    NSMutableArray *dateSections = [[NSMutableArray alloc]initWithArray:self.viewModel.dropRecordList];
    [self.viewModel.dropRecordList removeAllObjects];
    for (long i=0; i<recordList.count; i++) {
        StuDropRecordModel *record =[recordList objectAtIndex:i];
        BOOL didHasSuchDate = NO;
        for (NSMutableArray *byDateArray in dateSections) {
            if(byDateArray.count>0)
            {
                
                StuDropRecordModel *model =[byDateArray objectAtIndex:0];
                //比较数组里面是否已经存在该日期的数据,如有则分为一组
//                model.createTime
                if ([[model getRecordDate] isEqualToString:[record getRecordDate]]) {
                    didHasSuchDate = YES;
                    [byDateArray addObject:record];
                    NSLog(@"byDateArray.count %ld",byDateArray.count);
                    break;
                }
            }
            
        }
        //如果还没有对应的日期，则新建一个
        if (!didHasSuchDate) {
            NSMutableArray *suchDateArray = [[NSMutableArray alloc]init];
            [suchDateArray addObject:record];
            [dateSections addObject:suchDateArray];
            [self.viewModel.dateTitleList addObject:[record getRecordDate]];
            NSLog(@"create dateSection.count %ld,date=%@",dateSections.count,[record getRecordDate]);
            
        }
        
    }
    
    NSLog(@"dateSection.count %ld",dateSections.count);
    [self.viewModel addDropRecords:dateSections];
    [self.mainView refreshDropRecord];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

- (void)onCloseButtonPress
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
