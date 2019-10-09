//
//  GroupMenuView.m
//  utree
//
//  Created by 科研部 on 2019/8/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupMenuView.h"
#import "MMAlertView.h"
@interface GroupMenuView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *groupArray;

@end

@implementation GroupMenuView

static NSString *cellID = @"groupID";

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initMenu];
}

-(void)initMenu
{
    
//    self.view.backgroundColor = [UIColor whiteColor];
   //总体背景
//    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgView.backgroundColor=[UIColor clearColor];
    [bgView addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addSubview:bgView];
    
    UIImageView *bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_for_dialog"]];
    bgImg.frame=CGRectMake(13, iPhone_Top_NavH-4, ScreenWidth-26, 272);
    [self.view addSubview:bgImg];
    
    
    _groupArray = [NSMutableArray arrayWithObjects:@"游戏小组",@"学习小组",@"劳动小组",@"体育小组", nil];
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
        cell.textLabel.text=_groupArray[indexPath.row];
        cell.detailTextLabel.text=@"2个小组";
        cell.detailTextLabel.textColor = [UIColor_ColorChange colorWithHexString:SecondTextColor];
        cell.accessoryType=UITableViewCellAccessoryNone;
        if (indexPath.row==1) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupArray.count+2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==_groupArray.count+1) {
        [self showEditPlan];
    }else if(indexPath.row==_groupArray.count){
        [self showCreateNewPlan];
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


-(void)showEditPlan
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
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除当前分组方案" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
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
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"animation complete");
    };
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:@"添加方案" detail:nil placeholder:@"请输入方案名称（10个字符内）" handler:^(NSString *text) {
        NSLog(@"input:%@",text);
    }];
//    alertView.attachedView = self.view;
//    alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
//    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleExtraLight;
    [alertView showWithBlock:completeBlock];
}

@end
