//
//  ParentDataVC.m
//  utree
//
//  Created by 科研部 on 2019/10/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ParentDataVC.h"
#import "UTParent.h"
#import "ContactDC.h"
@interface ParentDataVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *itemNames;
@property(nonatomic,strong)UTParent *parent;
@end

@implementation ParentDataVC
static NSString *CellID = @"dataID";

- (instancetype)initWithParent:(UTParent *)parent
{
    self = [super init];
    if (self) {
        self.parent = parent;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadParentData];
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

-(void)loadParentData
{
    ContactDC *dataController = [[ContactDC alloc]init];
    [dataController requestParentDataByParentId:self.parent.parentId WithSuccess:^(UTResult * _Nonnull result) {
        self.parent = result.successResult;
        [self.tableView reloadData];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default_head"]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.parent.picPath] placeholderImage:[UIImage imageNamed:@"default_head"]];
            cell.accessoryView = imageView;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
            [cell.detailTextLabel setText:self.parent.parentName];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 2:
            [cell.detailTextLabel setText:self.parent.phone];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 3:
        {
            NSString *relationStr = @"";
            for (int index=0; index<self.parent.studentList.count; index++) {
                UTStudent *stu = self.parent.studentList[index];
                relationStr = [relationStr stringByAppendingFormat:@"%@", stu.studentName];
                if (index!=self.parent.studentList.count-1) {
                    relationStr = [relationStr stringByAppendingFormat:@"%@", @"|"];
                }else{
                    relationStr = [relationStr stringByAppendingFormat:@"%@", @"家长"];
                }
            }
            [cell.detailTextLabel setText:relationStr];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            
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
