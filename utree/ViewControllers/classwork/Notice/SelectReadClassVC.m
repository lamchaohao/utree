//
//  SelectReadClassVC.m
//  utree
//
//  Created by 科研部 on 2019/11/15.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SelectReadClassVC.h"
#import "PostNoticeDC.h"
#import "UTClassModel.h"
@interface SelectReadClassVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *classList;

@property(nonatomic,strong)MyRelativeLayout *navBarLayout;
@property(nonatomic,strong)MyRelativeLayout *bottomBarLayout;
@property(nonatomic,strong)PostNoticeDC *dataController;

@property(nonatomic,strong)UIButton *selectAllBtn;

@property(nonatomic,strong)NSMutableDictionary *paramDic;
@end

@implementation SelectReadClassVC
static NSString *cellId = @"classCellId";

- (instancetype)initWithParams:(NSMutableDictionary *)dic
{
    self = [super init];
    if (self) {
        self.paramDic = dic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBar];
    [self loadClassData];
}

-(void)initNaviBar
{
    MyRelativeLayout *relativeLayout = [MyRelativeLayout new];
    relativeLayout.frame = self.view.frame;
    self.view = relativeLayout;
    self.view.backgroundColor=[UIColor myColorWithHexString:@"#F7F7F7"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    MyRelativeLayout *navBarLayout = [MyRelativeLayout new];
    navBarLayout.frame = CGRectMake(0, 0, ScreenWidth, 64);
    navBarLayout.backgroundColor = [UIColor whiteColor];
    navBarLayout.myTop=iPhone_StatuBarHeight;
    navBarLayout.myLeft=0;
    
    UILabel *navTitle = [[UILabel alloc]init];
    navTitle.myCenterX=0;
    navTitle.myCenterY=0;
    navTitle.textColor = [UIColor blackColor];
    navTitle.font = [UIFont boldSystemFontOfSize:20];
    navTitle.text=@"选择可见班级";
    [navTitle sizeToFit];
    
    UIButton *closeButton = [[UIButton alloc]init];
    [closeButton setImage:[UIImage imageNamed:@"ic_close_black"] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(finishVC:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.myTop=0;
    closeButton.myLeft=18;
    closeButton.myCenterY=0;
    
    [navBarLayout addSubview:closeButton];
    [navBarLayout addSubview:navTitle];
    self.navBarLayout = navBarLayout;
    [self.view addSubview:self.navBarLayout];
    
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
    [nextStepBtn setTitle:@"发布通知(1/2)" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextStepBtn.backgroundColor = [UIColor myColorWithHexString:PrimaryColor];
    nextStepBtn.layer.cornerRadius = 5;
    nextStepBtn.myCenterY = 0;
    nextStepBtn.rightPos.equalTo(bottomBar.rightPos).offset(18);
    [nextStepBtn addTarget:self action:@selector(postToServer:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomBar addSubview:self.selectAllBtn];
    [bottomBar addSubview:nextStepBtn];
    self.bottomBarLayout = bottomBar;
    [self.view addSubview:self.bottomBarLayout];
}

-(void)loadClassData
{
    self.dataController = [[PostNoticeDC alloc]init];
    
    [self.dataController requestClassListWithSuccess:^(UTResult * _Nonnull result) {
        
        self.classList = result.successResult;
        [self initTableView];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}

-(void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 400) style:UITableViewStyleGrouped];
    _tableView.topPos.equalTo(self.navBarLayout.bottomPos);
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
    UTClassModel *classModel = [self.classList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setText:[NSString stringWithFormat:@"%d年(%d)班",classModel.classGrade.intValue,classModel.classCode.intValue]];
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
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"可见班级:";
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

-(void)postToServer:(id)sender
{
    
    
    
    NSString *title = [self.paramDic objectForKey:@"title"];
    NSString *content = [self.paramDic objectForKey:@"content"];
    
    NSMutableArray *selectedClassArray = [[NSMutableArray alloc]init];
    for (UTClassModel *model in self.classList) {
        if(model.isSelected){
             [selectedClassArray addObject:model];
        }
    }
    if (selectedClassArray.count==0) {
        [self showToastView:@"没选择任何班级"];
    }else{
        NSMutableArray *classIdArray=[[NSMutableArray alloc]init];
        for (int i=0;i<selectedClassArray.count;i++) {
            UTClassModel *model = selectedClassArray[i];
            [classIdArray addObject:model.classId];
        }
        [self.paramDic setObject:classIdArray forKey:@"classIds"];
        [self.dataController publishNoticeToServerWithTopic:title content:content enclosureDic:self.paramDic WithSuccess:^(UTResult * _Nonnull result) {
            [self showToastView:@"发布成功"];
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:PostWorkNotifyName object:nil];
            }];
        } failure:^(UTResult * _Nonnull result) {
            
            [self showAlertMessage:@"错误" title:result.failureResult];
        }];
    }
    
    
}


@end
