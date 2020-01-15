//
//  UTQuickReplyView.m
//  utree
//
//  Created by 科研部 on 2020/1/8.
//  Copyright © 2020 科研部. All rights reserved.
//

#import "UTQuickReplyView.h"

@interface UTQuickReplyView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *datasource;

@end

@implementation UTQuickReplyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupUI];
    }
    return self;
}

-(void)initData
{
    self.datasource = [[NSMutableArray alloc]init];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];

    //3.2 得到完整的文件名
    NSString *fullPath=[path stringByAppendingPathComponent:@"quick_reply.plist"];
    
    NSArray *quickReplys = [NSArray arrayWithContentsOfFile:fullPath];
    [self.datasource addObjectsFromArray:quickReplys];

}

- (void)onAddedReply:(NSString *)reply
{
    [self.datasource addObject:reply];
    [self.datasource writeToFile:[self getStoreFilePath] atomically:YES];
    [self.tableView reloadData];
}

- (void)onFinishEdit:(NSString *)reply oldIndex:(int)index
{
    [self.datasource replaceObjectAtIndex:index withObject:reply];
    [self.datasource writeToFile:[self getStoreFilePath] atomically:YES];
    [self.tableView reloadData];
}

-(void)setupUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-55) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"quickCell"];
    MyLinearLayout *buttonLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    buttonLayout.frame=CGRectMake(0, 0, self.bounds.size.width, 54);
    
    UIButton *addQuickReplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addQuickReplyBtn.frame = CGRectMake(0, 0, (self.bounds.size.width-2)/2, 55);
    [addQuickReplyBtn setTitle:@"添加常用语" forState:UIControlStateNormal];
    [addQuickReplyBtn setTitleColor:[UIColor myColorWithHexString:@"#43D27F"] forState:UIControlStateNormal];
    [addQuickReplyBtn addTarget:self action:@selector(onAddModeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *divider = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 40)];
    divider.backgroundColor = [UIColor myColorWithHexString:@"#E0E0E0"];
    divider.myTop=5;
    
    UIButton *editQuickReplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editQuickReplyBtn.frame = CGRectMake(0, 0, (self.bounds.size.width-2)/2, 55);
    [editQuickReplyBtn setTitle:@"编辑常用语" forState:UIControlStateNormal];
    [editQuickReplyBtn setTitleColor:[UIColor myColorWithHexString:@"#43D27F"] forState:UIControlStateNormal];
    [editQuickReplyBtn addTarget:self action:@selector(onEditModeClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonLayout addSubview:addQuickReplyBtn];
    [buttonLayout addSubview:divider];
    [buttonLayout addSubview:editQuickReplyBtn];
    buttonLayout.topPos.equalTo(_tableView.bottomPos);
    
    [self addSubview:_tableView];
    [self addSubview:buttonLayout];
}

-(void)onAddModeClick:(id)send
{
    if (self.datasource.count>=20) {
        UIView *toastView = [self toastViewForMessage:@"常用语数量已达上限" title:nil image:nil style:nil];
        toastView.myCenterY=0;
        toastView.myCenterX=0;
        [self showToast:toastView duration:[CSToastManager defaultDuration] position:CSToastPositionCenter completion:nil];
        return ;
    }
    if ([self.delegate respondsToSelector:@selector(onOpenInputDialogToAdd)]) {
        [self.delegate onOpenInputDialogToAdd];
    }

}

-(void)onEditModeClick:(id)send
{
    [self.tableView setEditing:YES animated:YES];
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(0, 0, self.bounds.size.width, 55);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.backgroundColor =[UIColor myColorWithHexString:@"#43D27F"];
    saveButton.topPos.equalTo(_tableView.bottomPos);
    [saveButton addTarget:self action:@selector(onSaveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveButton];
}

-(void)onSaveClick:(id)send
{
    [self.tableView setEditing:NO animated:YES];
    [send removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quickCell"];
    
    [cell.textLabel setText:self.datasource[indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate onReplyClickToSend:self.datasource[indexPath.row]];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED;
{
    return @"删除";
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    // 收回侧滑
//        [tableView setEditing:NO animated:YES];
        [self.delegate onEditReplySentence:self.datasource[indexPath.row] index:(int)indexPath.row];
    }];

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    // 删除cell: 必须要先删除数据源，才能删除cell
        [self.datasource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.datasource writeToFile:[self getStoreFilePath] atomically:YES];
    }];

    return @[deleteAction, editAction];
}

-(NSString *)getStoreFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];

    //3.2 得到完整的文件名
    NSString *fullPath=[path stringByAppendingPathComponent:@"quick_reply.plist"];
    return fullPath;
}

@end
