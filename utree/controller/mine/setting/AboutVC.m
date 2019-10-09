//
//  AboutVC.m
//  utree
//
//  Created by 科研部 on 2019/9/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray *itemNames;

@end

@implementation AboutVC
static NSString *CellID = @"staticCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initStaticTableView];
    
}


-(void)initStaticTableView
{
  
    
    _itemNames = [[NSArray alloc]initWithObjects:@"检查更新",@"版本介绍", nil] ;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    tableView.rowHeight=62;
    
    [self.view addSubview:tableView];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    [cell.textLabel setText:_itemNames[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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



//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScreenHeight*0.32;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyRelativeLayout *topLayout = [MyRelativeLayout new];
    
    topLayout.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.32);
    topLayout.backgroundColor=[UIColor whiteColor];
    
    UIImageView *headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_icon"]];
    
    headView.myCenterX=0;
    headView.myTop=38;
    
    UILabel *accountLabel = [[UILabel alloc]init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"优树成长" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:28],NSForegroundColorAttributeName: [UIColor blackColor]}];
    accountLabel.attributedText = string;
    accountLabel.myCenterX=0;
    accountLabel.myTop = 131;
    [accountLabel sizeToFit];
    
    UILabel *schoolLabel = [[UILabel alloc]init];
    
    NSMutableAttributedString *schoolStr = [[NSMutableAttributedString alloc] initWithString:@"Version：2.0" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17],NSForegroundColorAttributeName: [UIColor blackColor]}];
    schoolLabel.attributedText = schoolStr;
    schoolLabel.myCenterX=0;
    schoolLabel.myTop = 175;
    [schoolLabel sizeToFit];
    
    [topLayout addSubview:headView];
    [topLayout addSubview:accountLabel];
    [topLayout addSubview:schoolLabel];
    return topLayout;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}



@end
