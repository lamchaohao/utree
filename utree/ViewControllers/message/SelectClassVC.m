//
//  SelectClassVC.m
//  utree
//
//  Created by 科研部 on 2019/10/22.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "SelectClassVC.h"
#import "UTClassModel.h"
#import "ContactDC.h"
@interface SelectClassVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *classList;
@property(nonatomic,assign)NSInteger lastSelectedIndex;
@property(nonatomic,strong)ContactDC *dataController;

@end

@implementation SelectClassVC
static NSString *CellID = @"classId";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadClassData];
}

-(void)createView
{
    self.dataController = [[ContactDC alloc]init];
    self.title=@"选择班级";
    self.view.backgroundColor=[UIColor whiteColor];
    _classList = [[NSMutableArray alloc]init] ;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [self.view addSubview:_tableView];
    _tableView.rowHeight=62;
    self.view.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    
}


-(void)loadClassData
{
    [self.dataController requestClassListWithSuccess:^(UTResult * _Nonnull result) {
        [self.classList addObjectsFromArray:result.successResult];
        [self.tableView reloadData];
    } failure:^(UTResult * _Nonnull result) {
        [self.view makeToast:result.failureResult];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    ((UTClassModel *)[_classList objectAtIndex:_lastSelectedIndex]).isSelected=NO;
//    ((UTClassModel *)_classList[indexPath.row]).isSelected=YES;
//    _lastSelectedIndex =indexPath.row;
//    [tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.selectedBlock) {
        NSLog(@"推出后仍然执行");
        UTClassModel *model = [_classList objectAtIndex:indexPath.row];
        self.selectedBlock(model.classId, model.className);
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    UTClassModel *classModel = [self.classList objectAtIndex:indexPath.row];
    if(classModel){
        [cell.textLabel setText:classModel.className];
    }
    
    if (classModel.isSelected) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_selected_round"]];
    }else{
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_unselect_round"]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _classList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



@end
