//
//  MyTeachClass.m
//  utree
//
//  Created by 科研部 on 2019/9/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MyTeachClassVC.h"
#import "TeachingClassCell.h"
#import "MyClassDC.h"
#import "UTClassModel.h"

@interface MyTeachClassVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MyClassDC *dataController;
@property(nonatomic,strong)NSMutableArray *classList;
@property(nonatomic,strong)UIView *headView;
@end
static NSString *ID = @"myTeachClassCell";

@implementation MyTeachClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"任教班级";
    self.classList = [[NSMutableArray alloc]init];
    self.dataController = [[MyClassDC alloc]init];
    [self initView];
}

-(void)loadData
{
    [self.dataController requestTeachClassListWithSuccess:^(UTResult * _Nonnull result) {
        NSArray *classList = result.successResult;
        [self.classList removeAllObjects];
        for (UTClassModel *classModel in classList) {
            TeachClassModel *model = [[TeachClassModel alloc]init];
            model.subjectArray= [classModel.subject componentsSeparatedByString:@"、"];
            model.teachClassName = classModel.className;
            [self.classList addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (self.classList.count==0) {
          self.tableView.tableHeaderView =[self headView];
        }else{
          self.tableView.tableHeaderView = nil;
        }
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
        [self.tableView.mj_header endRefreshing];
        if (self.classList.count==0) {
          self.tableView.tableHeaderView =[self headView];
        }else{
          self.tableView.tableHeaderView = nil;
        }
    }];
}

-(void)initView
{
    self.navigationController.navigationBarHidden=NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView registerClass:[TeachingClassCell class] forCellReuseIdentifier:ID];
    [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.tableHeaderView =[self headView];
    [_tableView.mj_header beginRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeachingClassCell * cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    TeachClassModel *model =[self.classList objectAtIndex:indexPath.row];

    [cell setTeachClassModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classList.count;
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
    self.showNavigationBarImageWhenDisappear = YES;
    [super viewWillAppear:animated];
    
}

-(UIView *)headView
{
    if (!_headView) {
        UIView *rootView = [MyRelativeLayout new];
        rootView.frame = CGRectMake(0, 0, ScreenWidth, 240);
        UILabel *tips = [UILabel new];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        NSString *picPath;
        picPath =[[NSBundle mainBundle] pathForResource:@"pic_not_head_teacher" ofType:@"png"];
        [tips setText:@"你还没有任教班级哦"];
        UIImage *img = [UIImage imageWithContentsOfFile:picPath];
        [imageView setImage:img];
        imageView.myCenterX=0;
        imageView.myCenterY=0;
        [tips sizeToFit];
        tips.textColor = [UIColor myColorWithHexString:@"#666666"];
        tips.font=[UIFont systemFontOfSize:14];
        tips.topPos.equalTo(imageView.bottomPos).offset(20);
        tips.myCenterX =0;
        
        [rootView addSubview:imageView];
        [rootView addSubview:tips];
        _headView = rootView;
    }
    
    return _headView;
}



@end
