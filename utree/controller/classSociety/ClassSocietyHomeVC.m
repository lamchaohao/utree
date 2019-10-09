//
//  ClassSocietyHomeVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassSocietyHomeVC.h"
#import "MomentCell.h"
#import "Moment.h"

@interface ClassSocietyHomeVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *momentViewModels; //ViewModel(包含cell子控件的Frame)
@property(nonatomic,strong)UITableView *tableView;
@end
static NSString *CellID = @"societyCell";

@implementation ClassSocietyHomeVC
static const CGFloat MJDuration = 4.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self loadNewData];
}


- (void)loadNewData{
    //模拟增加数据
    _momentViewModels = [NSMutableArray array];
    for (Moment *moment in self.dataSource) {
        MomentViewModel *momentVM = [[MomentViewModel alloc] init];
        [momentVM setMomentModel:moment] ;
        [_momentViewModels addObject:momentVM];
    }
//    [self.tableView reloadData];
    //    [self.tableView.mj_header endRefreshing];
    // 2.模拟4秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        NSLog(@"%s",__func__);
        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.mj_header endRefreshing];
    });
    
}

-(void)initTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-iPhone_Top_NavH-iPhone_Bottom_NavH) style:UITableViewStylePlain];
    [_tableView registerClass:[MomentCell class] forCellReuseIdentifier:CellID];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    // Set the callback（一Once you enter the refresh status，then call the action of target，that is call [self loadNewData]）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // Set the ordinary state of animated images
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"header_refresh_dot" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    UIImage *image = [UIImage sd_imageWithGIFData:gifData];
    [header setImages:[NSArray arrayWithObject:image] forState:MJRefreshStateIdle];
    [header setImages:[NSArray arrayWithObject:image] forState:MJRefreshStatePulling];
    [header setImages:[NSArray arrayWithObject:image] forState:MJRefreshStateRefreshing];
    // Hide the time
    header.lastUpdatedTimeLabel.hidden = YES;
    // Hide the status
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];

    [self.view addSubview:_tableView];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        _dataSource = [self getMomentList];
    }
    return _dataSource;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    [cell setViewModel:_momentViewModels[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _momentViewModels.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MomentViewModel *vm = self.momentViewModels[indexPath.row];
    return vm.cellHeight;
}

-(NSMutableArray *)getMomentList
{
    NSMutableArray *photoArray = [NSMutableArray array];
    [photoArray addObject:@"http://www.chinadaily.com.cn/dfpd/fj/attachement/jpg/site1/20100303/000d6005bf420cf851ab1a.jpg"];
    [photoArray addObject:@"http://img1.7wsh.net/2016/7/29/20160729135555832.jpg"];
    [photoArray addObject:@"http://photocdn.sohu.com/20120621/Img346235766.jpg"];
    [photoArray addObject:@"http://images1.wenming.cn/web_wenming/syjj/dfcz/201203/W020120309310739151237.jpg"];
    [photoArray addObject:@"http://photocdn.sohu.com/20150802/Img418002033.jpg"];
//    [photoArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1567398602986&di=54f91bfd8733261f37fef64f892d6d27&imgtype=0&src=http%3A%2F%2Ffiles.eduuu.com%2Fimg%2F2011%2F06%2F20%2F181333_4dff1d4de6e55.jpg"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<12; i++) {
        Moment *model = [[Moment alloc]initWithAuthorName:@"小倩老师" time:@"一个小时前" content:@"“当时总队正在召集各个支队开一个视频调度会，是关于中秋小长假的消防安全情况的，会议持续了近一个小时。我用眼睛余光注意到了门口角落站着一个小女孩，一直站在那儿，站累了就蹲下，蹲累了就坐下，然后又站起来，一直没离开过那个区域。她不吵不闹，就静静地看着还在开会的爸爸。那是同事钱飞的女儿，今年7周岁多一点。看到这一幕的李斌，内心很受触动，他想起了自己的儿子。“因为岗位特殊，消防员平时与家人聚少离多，像中秋节原本团圆的日子，但也只能默默坚守岗位，想起家人，确实挺不是滋味的。” " photos:photoArray];

        [arr addObject:model];
    }
    
    return arr;
}

@end
