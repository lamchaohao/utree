//
//  GroupMenuView.m
//  utree
//
//  Created by 科研部 on 2019/8/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupMenuView.h"
#import "MMAlertView.h"
#import "GroupPlanDC.h"
#import "GroupPlanModel.h"
#import "UTCache.h"
@interface GroupMenuView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray<GroupPlanModel *> *groupArray;
@property(nonatomic,strong)GroupPlanDC *dataController;
@property(nonatomic,strong)NSDictionary *groupPlanCacheDic;
@end

@implementation GroupMenuView

static NSString *cellID = @"groupID";

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.dataController = [[GroupPlanDC alloc]init];
    [self loadData];
    [self initMenu];
}

-(void)loadData
{
    [self.dataController requestGroupPlanListWithSuccess:^(UTResult * _Nonnull result) {
        self.groupArray = result.successResult;
        self.groupPlanCacheDic = [UTCache readGroupPlanCache];
        [self.tableView reloadData];
        [self notifyPlanChanged];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}

-(void)initMenu
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgView.backgroundColor=[UIColor clearColor];
    [bgView addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addSubview:bgView];
    
    UIImageView *bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_for_dialog"]];
    bgImg.frame=CGRectMake(13, iPhone_Top_NavH-4, ScreenWidth-26, 272);
    [self.view addSubview:bgImg];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, iPhone_Top_NavH+10, ScreenWidth-30, 236) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
}


-(void)event:(UITapGestureRecognizer *)gesture
{
    [self dismissViewControllerAnimated:NO completion:nil];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                      reuseIdentifier: cellID];
    }
    if (indexPath.row==_groupArray.count) {
        cell.textLabel.text=@"添加方案";
        cell.detailTextLabel.text=nil;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.row==_groupArray.count+1){
        cell.textLabel.text=@"编辑方案";
        cell.detailTextLabel.text=nil;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else{
        GroupPlanModel *planModel= [_groupArray objectAtIndex:indexPath.row];
        cell.textLabel.text=planModel.planName;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%d个小组",planModel.groupCount];
        cell.detailTextLabel.textColor = [UIColor_ColorChange colorWithHexString:SecondTextColor];
        cell.accessoryType=UITableViewCellAccessoryNone;
        NSString *planId = [self.groupPlanCacheDic objectForKey:@"groupPlanId"];
        if ([planModel.planId isEqualToString:planId]) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count+2;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==_groupArray.count+1) {
        [self showEditPlanMenu];
    }else if(indexPath.row==_groupArray.count){
        [self showCreateNewPlan];
    }else{
        GroupPlanModel *planModel= [_groupArray objectAtIndex:indexPath.row];
        [UTCache saveGroupPlanId:planModel.planId planName:planModel.planName];
        self.groupPlanCacheDic = [UTCache readGroupPlanCache];
        [self notifyPlanChanged];
        [tableView reloadData];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==_groupArray.count) {
        return 52;
    }else if(indexPath.row==_groupArray.count+1){
        return 52;
    }
    return 71;
}

-(void)notifyPlanChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GroupPlanChangedNotifyName object:nil];
}


-(void)showEditPlanMenu
{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    /*
     参数说明：
     Title:弹框的标题
     message:弹框的消息内容
     preferredStyle:弹框样式：UIAlertControllerStyleActionSheet
     */
    
    //2.添加按钮动作
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"修改当前方案名称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showEditPlanName];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除当前分组方案" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self showDeleteDialog];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    //3.添加动作
    [alertSheet addAction:action1];
    [alertSheet addAction:action2];
    [alertSheet addAction:cancel];
    
    //4.显示sheet
    [self presentViewController:alertSheet animated:YES completion:nil];
    
}


-(void)showCreateNewPlan
{
    MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:@"添加方案" detail:nil placeholder:@"请输入方案名称（10个字符内）"
        handler:^(NSString *text) {
            [self.dataController requestAddGroupPlanFromName:text WithSuccess:^(UTResult * _Nonnull result) {
                [self.view makeToast:result.successResult];
                [self loadData];
            } failure:^(UTResult * _Nonnull result) {
                [self.view makeToast:result.failureResult];
            }];
    }];
    [alertView show];
}

-(void)showEditPlanName{
    NSDictionary *dic = [UTCache readGroupPlanCache];

    MMAlertView *editView = [[MMAlertView alloc]initWithInputTitle:@"修改方案名称" textTobeEdit:[dic objectForKey:@"planName"] placeholder:@"请输入方案名称（10个字符内）" handler:^(NSString *text)
    {
        [self.dataController editPlanName:text planId:[dic objectForKey:@"groupPlanId"] WithSuccess:^(UTResult * _Nonnull result) {
            [self loadData];
        } failure:^(UTResult * _Nonnull result) {
            [self.view makeToast:result.failureResult];
        }];
    }];
    [editView show];
}

-(void)showDeleteDialog
{
    NSDictionary *dic = [UTCache readGroupPlanCache];

       MMPopupItemHandler block = ^(NSInteger index){
           [self.view makeToast:@"已取消"];
       };
       MMPopupItemHandler deleteBlock = ^(NSInteger index){
           [self.dataController deletePlanByPlanId:[dic objectForKey:@"groupPlanId"] WithSuccess:^(UTResult * _Nonnull result) {
               [self loadData];
           } failure:^(UTResult * _Nonnull result) {
               [self.view makeToast:result.failureResult];
           }];
       };
       //MMAlertView
       NSArray *items =
     @[MMItemMake(@"确定", MMItemTypeNormal, deleteBlock),
       MMItemMake(@"取消", MMItemTypeHighlight, block)];
    
    MMAlertView *deleteDialog = [[MMAlertView alloc]initWithTitle:@"删除分组" detail:@"" items:items];
    [deleteDialog show];
    
}



@end
