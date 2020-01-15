//
//  EditCommentVCViewController.m
//  utree
//
//  Created by 科研部 on 2019/11/8.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "EditCommentVC.h"
#import "CommentDC.h"
@interface EditCommentVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *commentList;
@property(nonatomic,strong)CommentDC *dataController;
@end

@implementation EditCommentVC
static NSString *cellID= @"commentId";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    [self initView];
}

-(void)initView
{
    self.title = @"编辑点评语";
    
    self.dataController = [[CommentDC alloc]init];
    NSArray *temp = [self.dataController requestCommentList];
    self.commentList = [[NSMutableArray alloc]initWithArray:temp];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, iPhone_Top_NavH, ScreenWidth, ScreenHeight-iPhone_Top_NavH) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource=self;
    self.tableView.delegate = self;
    self.tableView.editing = YES;  //设置可编辑

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell.textLabel setText:[self.commentList objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//delegate代理方法，实现此方法，可以设置UITableViewCell增加或删除功能，如果不实现此方法，默认都是删除样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tobeDelete = [self.commentList objectAtIndex:indexPath.row];
    [self.commentList removeObjectAtIndex:indexPath.row];
    [self.dataController deleteComment:tobeDelete];
    if ([self.sender respondsToSelector:@selector(onDeleteComment:)]) {
        [self.sender onDeleteComment:tobeDelete];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];//删除行

}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED;
{
    return @"删除";
}

@end
