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
#import "UTCache.h"
#import "MyPublishVC.h"
#import "UTQRScan.h"

@interface MineHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray *icons;
@property(nonatomic,strong) NSArray *itemNames;
@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *accountLabel;
@property(nonatomic,strong)UILabel *schoolLabel;
@property(nonatomic,strong)MyRelativeLayout *topLayout;
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation MineHomeVC

static NSString *CellID = @"mineStaticCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTopLayout];
    [self initStaticTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self reloadHeadData];
}

-(void)initStaticTableView
{
    //mine_icon_publish @"我的发布"
    self.icons = [[NSArray alloc]initWithObjects:@"mine_icon_account",@"mine_icon_teach_class",@"mine_icon_publish",@"mine_icon_qr_scan",@"mine_icon_help",@"mine_icon_setting", nil] ;
    
    self.itemNames = [[NSArray alloc]initWithObjects:@"带领班级",@"任教班级",@"我的发布",@"扫一扫",@"帮助中心",@"设置", nil] ;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -iPhone_StatuBarHeight, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.tableView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadHeadData)];
    
    
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
        case 2:
        {
            MyPublishVC *viewController = [[MyPublishVC alloc]init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
             break;
        case 3:
        {
            UTQRScan *qrVC = [[UTQRScan alloc]init];
            qrVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:qrVC animated:YES];
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
        {

        }
            
            break;
    }
    //选中后不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
    
    return self.topLayout;
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

-(void)reloadHeadData
{
    NSDictionary *personDic=[UTCache readProfile];
    NSString *schoolName = [personDic objectForKey:@"companyName"];
    NSString *teachName = [personDic objectForKey:@"teacherName"];
    NSString *headPicUrl = [personDic objectForKey:@"filePath"];
   
    if (![self isBlankString:schoolName]) {
        [self.schoolLabel setText:schoolName];
    }
    if (![self isBlankString:teachName]) {
        [self.accountLabel setText:teachName];
    }
    if (![self isBlankString:headPicUrl]) {
        [self.headView sd_setImageWithURL:[NSURL URLWithString:headPicUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
        self.headView.layer.cornerRadius=self.headView.frame.size.width/2 ;//裁成圆角
        self.headView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
        self.headView.layer.borderWidth = 0.1f;//边框宽度
    }
    
    [self.schoolLabel sizeToFit];
    [self.accountLabel sizeToFit];
    self.accountLabel.myCenterX=0;
    self.schoolLabel.myCenterX=0;
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
}

-(void)initTopLayout
{
    
    MyRelativeLayout *topLayout = [MyRelativeLayout new];
    
    topLayout.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.275);
    UIImageView *topBgImg = [[UIImageView alloc]initWithFrame:topLayout.frame];
    [topBgImg setImage:[UIImage imageNamed:@"mine_top_bg"]];
    [topLayout addSubview:topBgImg];
    topBgImg.contentMode = UIViewContentModeScaleToFill;
    
    self.headView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default_head"]];
    
    self.headView.myCenterX=0;
    self.headView.myTop=38+iPhone_SNavH;
    self.headView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.headView addGestureRecognizer:singleTap];
    
    
    self.accountLabel = [[UILabel alloc]init];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"请登录" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.accountLabel.attributedText = string;
    self.accountLabel.myCenterX=0;
    self.accountLabel.topPos.equalTo(self.headView.bottomPos).offset(12);
    [self.accountLabel sizeToFit];
    
    self.schoolLabel = [[UILabel alloc]init];
    
    NSMutableAttributedString *schoolStr = [[NSMutableAttributedString alloc] initWithString:@"未加入学校" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.schoolLabel.attributedText = schoolStr;
    self.schoolLabel.myCenterX=0;
    self.schoolLabel.topPos.equalTo(self.accountLabel.bottomPos).offset(8);
    [self.schoolLabel sizeToFit];
    
    [topLayout addSubview:self.headView];
    [topLayout addSubview:self.accountLabel];
    [topLayout addSubview:self.schoolLabel];
    self.topLayout = topLayout;
}

@end
