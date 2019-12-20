//
//  ParentDataVC.m
//  utree
//
//  Created by 科研部 on 2019/10/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ParentDataVC.h"

@interface ParentDataVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *itemNames;

@end

@implementation ParentDataVC
static NSString *CellID = @"dataID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

-(void)createView
{
    self.title=@"个人信息";
    self.view.backgroundColor=[UIColor whiteColor];
    _itemNames = [[NSArray alloc]initWithObjects:@"头像",@"姓名", @"手机号",@"身份",nil] ;
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
            [cell.detailTextLabel setText:@"13631808080"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 3:
            [cell.detailTextLabel setText:@"杜械妈妈"];
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


@end
