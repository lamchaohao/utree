//
//  GroupMenuView.m
//  utree
//
//  Created by 科研部 on 2019/8/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "GroupMenuView.h"

@interface GroupMenuView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *groupArray;

@end

@implementation GroupMenuView

static NSString *cellID = @"groupID";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMenu];
    }
    return self;
}

-(void)initMenu
{
    
    
    UIImageView *bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_for_dialog"]];
    bgImg.frame=CGRectMake(13, iPhone_Top_NavH-4, ScreenWidth-26, 272);
    
    
    [self addSubview:bgImg];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [self addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    
    _groupArray = [NSMutableArray arrayWithObjects:@"游戏小组",@"学习小组",@"劳动小组",@"体育小组", nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, iPhone_Top_NavH+10, ScreenWidth-30, 236) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_tableView];
    
    
}

-(void)event:(UITapGestureRecognizer *)gesture
{
//    [self setHidden:YES];
    [self removeFromSuperview];
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

@end
