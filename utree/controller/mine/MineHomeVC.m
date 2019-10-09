//
//  MineHomeVC.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MineHomeVC.h"
#import "myclass/MyClassListVC.h"
#import "setting/SettingVC.h"
#import "myclass/MyTeachClassVC.h"
#import "MineInfoVC.h"
@interface MineHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray *icons;
@property(nonatomic,strong) NSArray *itemNames;
@end

@implementation MineHomeVC

static NSString *CellID = @"mineStaticCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self initStaticTableView];
    
}


-(void)initStaticTableView
{
    //mine_icon_publish @"我的发布"
    self.icons = [[NSArray alloc]initWithObjects:@"mine_icon_account",@"mine_icon_teach_class",@"mine_icon_publish",@"mine_icon_qr_scan",@"mine_icon_help",@"mine_icon_setting", nil] ;
    
    self.itemNames = [[NSArray alloc]initWithObjects:@"带领班级",@"任教班级",@"我的发布",@"扫一扫",@"帮助中心",@"设置", nil] ;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    tableView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:tableView];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            MyClassListVC *classList = [[MyClassListVC alloc]init];
            
            //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
            classList.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:classList animated:YES];
        }
           
            break;
        case 1:
        {
            MyTeachClassVC *teachClass = [[MyTeachClassVC alloc]init];
            //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
            teachClass.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:teachClass animated:YES];
        }
            break;
        case 5:
        {
            SettingVC *settingVC = [[SettingVC alloc]init];
            //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
            settingVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    [cell.textLabel setText:_itemNames[indexPath.row]];
    [cell.imageView setImage:[UIImage imageNamed:_icons[indexPath.row]]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.icons.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScreenHeight*0.275;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyRelativeLayout *topLayout = [MyRelativeLayout new];
    
    topLayout.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.275);
    UIImageView *topBgImg = [[UIImageView alloc]initWithFrame:topLayout.frame];
    [topBgImg setImage:[UIImage imageNamed:@"mine_top_bg"]];
    [topLayout addSubview:topBgImg];
    topBgImg.contentMode = UIViewContentModeScaleToFill;
    
    UIImageView *headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default_head"]];
    
    headView.myCenterX=0;
    headView.myTop=38;
    headView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [headView addGestureRecognizer:singleTap];
    
    
    UILabel *accountLabel = [[UILabel alloc]init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"杜子藤老师" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    accountLabel.attributedText = string;
    accountLabel.myCenterX=0;
    accountLabel.myTop = 110;
    [accountLabel sizeToFit];
    
    UILabel *schoolLabel = [[UILabel alloc]init];
    
    NSMutableAttributedString *schoolStr = [[NSMutableAttributedString alloc] initWithString:@"所在学校：明德小学" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    schoolLabel.attributedText = schoolStr;
    schoolLabel.myCenterX=0;
    schoolLabel.myTop = 134;
    [schoolLabel sizeToFit];
    
    [topLayout addSubview:headView];
    [topLayout addSubview:accountLabel];
    [topLayout addSubview:schoolLabel];
    return topLayout;
}
//头像点击
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    MineInfoVC *infoVC = [[MineInfoVC alloc]init];
    //注意是UIViewController调用hidesBottomBarWhenPushed而不是UINavigationController
    infoVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:infoVC animated:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}



@end
