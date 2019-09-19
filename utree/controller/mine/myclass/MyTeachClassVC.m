//
//  MyTeachClass.m
//  utree
//
//  Created by 科研部 on 2019/9/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MyTeachClassVC.h"
#import "TeachingClassCell.h"
@interface MyTeachClassVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end
static NSString *ID = @"myTeachClassCell";

@implementation MyTeachClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"任教班级";
    [self initView];
}


-(void)initView
{
    self.navigationController.navigationBarHidden=NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView registerClass:[TeachingClassCell class] forCellReuseIdentifier:ID];
    [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeachingClassCell * cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    //    cell setmodel
    TeachClassModel *model = [[TeachClassModel alloc]init];
    model.subjectArray = [NSMutableArray arrayWithObjects:@"语文",@"英语",@"劳动", nil];
    model.teachClassName = @"四年五班";
    [cell setTeachClassModel:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenWidth*0.42;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.showNavWhenDisappear = NO;
    [super viewWillAppear:animated];
    
}


@end
