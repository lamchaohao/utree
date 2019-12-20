//
//  ComplainCommentVC.m
//  utree
//
//  Created by 科研部 on 2019/11/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ComplainCommentVC.h"
#import "MomentCommentDC.h"
@interface ComplainCommentVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *titleForReason;
@property(nonatomic,strong)NSString *selectedReason;
@property(nonatomic,strong)NSString *commentId;
@property(nonatomic,strong)MomentCommentDC *dataController;
@end

@implementation ComplainCommentVC

- (instancetype)initWithCommentId:(NSString *)commentId
{
    self = [super init];
    if (self) {
        self.commentId = commentId;
    }
    return self;
}

static NSString *cellID = @"ComplainCommentVC";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightBar];
    [self initData];
    [self setUpTableView];
}

-(void)setupRightBar
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(requestComplain:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.dataController = [[MomentCommentDC alloc]init];
}


-(void)initData
{
    self.titleForReason = [[NSMutableArray alloc]init];
    [self.titleForReason addObject:@"欺诈"];
    [self.titleForReason addObject:@"诱导行为"];
    [self.titleForReason addObject:@"骚扰"];
    [self.titleForReason addObject:@"违法犯罪"];
    [self.titleForReason addObject:@"不实信息"];
    [self.titleForReason addObject:@"不文明"];
}

-(void)setUpTableView
{
    self.navigationController.navigationBarHidden=NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleForReason.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    [cell.textLabel setText:self.titleForReason[indexPath.row]];
    
    if ([self.titleForReason[indexPath.row] isEqualToString:self.selectedReason]) {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedReason = self.titleForReason[indexPath.row];
    [tableView  reloadData];
}



-(void)requestComplain:(id)sender
{
    if(self.selectedReason){
        [self.dataController complainCommentById:self.commentId andReason:self.selectedReason WithSuccess:^(UTResult * _Nonnull result) {
            [self showAlertMessage:@"" title:@"投诉已提交"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(UTResult * _Nonnull result) {
            [self showAlertMessage:@"" title:result.failureResult];
        }];
    }
}

@end
