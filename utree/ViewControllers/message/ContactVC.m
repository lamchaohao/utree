//
//  ContactVC.m
//  utree
//
//  Created by 科研部 on 2019/10/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ContactVC.h"
#import "UTStudentTableViewCell.h"
#import "ZBChineseToPinyin.h"
#import "SelectClassVC.h"
#import "ContactDC.h"
#import "UTCache.h"
#import "UUParentChatVC.h"

@interface ContactVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableViewCell *classCell;
@property(nonatomic,strong)ContactDC *dataController;
@property(nonatomic,strong)NSString *classId;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)NSString *className;
@end

@implementation ContactVC
static NSString *tableViewCellID =@"tableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.classId = [UTCache readClassId];
    self.className = [UTCache readClassName];
    self.dataController = [[ContactDC alloc]init];
    [self initTableView];
}

-(NSMutableArray *)addFakeData
{
    NSMutableArray *fakeDatas = [[NSMutableArray alloc]init];
    NSArray *parentAccounts = [NSArray arrayWithObjects:@"15740638061472660",@"25740671999455221",@"35741315680210787",@"556289560812949",@"65740635256461378",@"85724284004950383",@"15693771165596690", nil];
    NSArray *parentNames = [NSArray arrayWithObjects:@"warw",@"晓红",@"超豪老师",@"大肥雅",@"享培",@"二狗子",@"乐乐", nil];
    NSString *img9=@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2851238468,2653826075&fm=26&gp=0.jpg";
    NSString *img10 = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3240215558,3264545876&fm=26&gp=0.jpg";
    NSString *img11=@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3390282514,1409134585&fm=26&gp=0.jpg";
    NSString *img12=@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3047739253,1622211647&fm=26&gp=0.jpg";
    NSString *img13=@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3053536160,220854969&fm=26&gp=0.jpg";
    NSArray *imgs = [NSArray arrayWithObjects:img9,img10,img11,img12,img13, nil];
    for (int i=0; i<parentAccounts.count; i++) {
        UTParent *parent = [[UTParent alloc]init];
        parent.parentId = parentAccounts[i];
        parent.parentName=parentNames[i];
        parent.studentName = @"某某某";
        parent.picPath=[imgs objectAtIndex:i%imgs.count];
        [fakeDatas addObject:parent];
    }
    return fakeDatas;
}


-(void)loadData
{
    
    [self.dataController requestParentListByClassId:self.classId WithSuccess:^(UTResult * _Nonnull result) {
        NSMutableArray *parentList = [[NSMutableArray alloc]init];
        NSArray<UTParent *> *data = result.successResult;
        [parentList addObjectsFromArray:data];
        [parentList addObjectsFromArray:[self addFakeData]];//添加假数据
        self.sectionTitleArray = [ZBChineseToPinyin indexWithArray:parentList Key:@"parentName"];
        self.sortParentList = [ZBChineseToPinyin sortObjectArray:parentList Key:@"parentName"];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (self.sectionTitleArray.count==0) {
          self.tableView.tableHeaderView =[self headView];
        }else{
          self.tableView.tableHeaderView = nil;
        }
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
        [self.tableView.mj_header endRefreshing];
        if (self.sectionTitleArray.count==0) {
          self.tableView.tableHeaderView =[self headView];
        }else{
          self.tableView.tableHeaderView = nil;
        }
    }];
    
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
        [tips setText:@"暂无联系人"];
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

//初始化tableview
-(void)initTableView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initClassSwitch];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight-60) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.sectionIndexColor = [UIColor myColorWithHexString:@"#676767"];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH, 0);
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.view addSubview:_tableView];
    self.tableView.tableHeaderView =[self headView];
    [_tableView.mj_header beginRefreshing];
    
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *array = [self.dataSource valueForKey:self.sectionTitleArray[section]];
    
    return [[self.sortParentList objectAtIndex:section] count];
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
    ParentCell *cell =(ParentCell*) [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ParentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableViewCellID];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    UTParent *parent = [[_sortParentList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [cell setDataToView:parent];
    
    return cell;
}

//选中某个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //选中后不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    UTParent *parent = [[_sortParentList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UUParentChatVC *vc= [[UUParentChatVC alloc]initWithParent:parent];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitleArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitleArray[section];
}

- (void)initClassSwitch
{
    
    self.classCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"classCell"];
    self.classCell.frame =CGRectMake(0, 0, ScreenWidth, 62);
    self.classCell.backgroundColor=[UIColor whiteColor];
    
    self.classCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.classCell.textLabel.text=@"切换班级";
    [self.classCell.detailTextLabel setText:self.className];
    [self.view addSubview:self.classCell];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellClick:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.classCell addGestureRecognizer:tapGesture];
    
}

-(void)cellClick:(id)sender
{
    SelectClassVC *classVC = [[SelectClassVC alloc]init];
    [classVC setSelectedBlock:^(NSString * _Nonnull classId, NSString * _Nonnull className) {
        self.classId = classId;
        self.className = className;
        [self.classCell.detailTextLabel setText:self.className];
        [self loadData];
    }];
    [self.navigationController pushViewController:classVC animated:YES];
}


@end
