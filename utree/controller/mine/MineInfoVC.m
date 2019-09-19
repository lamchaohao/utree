//
//  MineInfoVC.m
//  utree
//
//  Created by 科研部 on 2019/9/17.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MineInfoVC.h"

@interface MineInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *itemNames;
@end

@implementation MineInfoVC
static NSString *CellID = @"fineID";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.showNavWhenDisappear = NO;
    [super viewWillAppear:animated];
    
}
-(void)createView
{
    self.title=@"个人资料";
    self.view.backgroundColor=[UIColor whiteColor];
    _itemNames = [[NSArray alloc]initWithObjects:@"头像",@"昵称", @"所在学校",nil] ;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [self.view addSubview:_tableView];
    _tableView.rowHeight=62;
    self.view.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self showAlertSheet];
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
    
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_head"]];
            cell.accessoryView = imageView;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
           
            break;
        case 1:
            [cell.detailTextLabel setText:@"杜子腾"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 2:
            [cell.detailTextLabel setText:@"明德小学"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        default:
            break;
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

-(void)showAlertSheet
{
    //1.创建Controller

    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"选择头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    /*
     参数说明：
     Title:弹框的标题
     message:弹框的消息内容
     preferredStyle:弹框样式：UIAlertControllerStyleActionSheet
     */
    
    //2.添加按钮动作
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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

@end
