//
//  SchoolInfoVC.m
//  utree
//
//  Created by 科研部 on 2019/10/14.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SchoolInfoVC.h"
#import "RxWebViewController.h"
@interface SchoolInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SchoolInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight  - iPhone_Top_NavH - SegmentTitleViewHeight -iPhone_Bottom_NavH) style:UITableViewStyleGrouped];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH, 0);

    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

//创建TableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       
    if (cell == nil) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableId"];
    }
    
    cell.textLabel.text=@"教务处";
    cell.detailTextLabel.text=@"全体教师研讨会召开";
    
    return cell;
}

//选中某个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"https://www.qq.com"]];
    
    [self.navigationController pushViewController:webViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
