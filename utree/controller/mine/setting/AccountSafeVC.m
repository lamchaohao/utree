//
//  AccountSafeVC.m
//  utree
//
//  Created by 科研部 on 2019/9/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "PhoneNumStateVC.h"
#import "AccountSafeVC.h"
#import "PasswordVC.h"
@interface AccountSafeVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *itemNames;

@end

@implementation AccountSafeVC
static NSString *CellID = @"fineID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self initView];
}

-(void)initView
{
    self.title=@"账户与安全";

    _itemNames = [[NSArray alloc]initWithObjects:@"手机",@"修改密码", nil] ;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [self.view addSubview:_tableView];
    _tableView.rowHeight=62;
    self.view.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0)
    {
        PhoneNumStateVC *accountVC = [[PhoneNumStateVC alloc]init];
        //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController

        [self pushIntoWithoutNavChange:accountVC];
        
    }
    else{
        PasswordVC *pswVC = [[PasswordVC alloc]init];
        //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
        [self pushIntoWithoutNavChange:pswVC];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: CellID];
    }
    [cell.textLabel setText:_itemNames[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row==0) {
        [cell.detailTextLabel setText:@"137***112"];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemNames.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return ScreenWidth*0.15;
//}




@end
