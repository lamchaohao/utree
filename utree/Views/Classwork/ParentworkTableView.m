//
//  ParentworkTableView.m
//  utree
//
//  Created by 科研部 on 2019/12/2.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ParentworkTableView.h"
#import "ParentWorkCell.h"
#import "ParentCheckModel.h"
@interface ParentworkTableView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic, strong)UIView *headView;
@end

@implementation ParentworkTableView

- (void)dealloc
{
    self.scrollCallback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isHeaderRefreshed = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-50) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH, 0);
        [self.tableView registerClass:[ParentWorkCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.tableView.frame = self.bounds;
}

-(UIView *)headView
{
    UIView *rootView = [MyRelativeLayout new];
    rootView.frame = CGRectMake(0, 0, ScreenWidth, 240);
    UILabel *tips = [UILabel new];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 169, 119)];
    NSString *picPath;
    if (self.isCheckData) {
        picPath =[[NSBundle mainBundle] pathForResource:@"pic_nobody_checked" ofType:@"png"];
        [tips setText:@"暂无人查看"];
    }else{
        picPath =[[NSBundle mainBundle] pathForResource:@"pic_all_checked" ofType:@"png"];
        [tips setText:@"已全部查看"];
    }
    UIImage *img = [UIImage imageWithContentsOfFile:picPath];
    [imageView setImage:img];
    imageView.myCenterX=0;
    imageView.myCenterY=0;
    [tips sizeToFit];
    tips.textColor = [UIColor myColorWithHexString:@"#666666"];
    tips.font=[UIFont systemFontOfSize:14];
    tips.topPos.equalTo(imageView.bottomPos).offset(20);
    tips.myCenterX =0;
    
    [rootView addSubview:imageView];
    [rootView addSubview:tips];
    return rootView;
}


- (void)setIsNeedHeader:(BOOL)isNeedHeader {
    _isNeedHeader = isNeedHeader;

    if (self.isNeedHeader) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //do something refresh
        }];
    }else {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_header removeFromSuperview];
        self.tableView.mj_header = nil;
    }
}

- (void)setIsNeedFooter:(BOOL)isNeedFooter {
    _isNeedFooter = isNeedFooter;

    __weak typeof(self)weakSelf = self;
    if (self.isNeedFooter) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.dataSource addObject:@"加载更多成功"];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            });
        }];
    }else {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer removeFromSuperview];
        self.tableView.mj_footer = nil;
    }
}

- (void)beginFirstRefresh {
    if (!self.isHeaderRefreshed) {
        [self beginRefreshImmediately];
    }
}

- (void)beginRefreshImmediately {
    if (self.isNeedHeader) {
        [self.tableView.mj_header beginRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isHeaderRefreshed = YES;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (self.dataSource.count==0) {
               self.tableView.tableHeaderView =[self headView];
           }else{
               self.tableView.tableHeaderView = nil;
           }
        });
    }else {
        self.isHeaderRefreshed = YES;
        [self.tableView reloadData];
        if (self.dataSource.count==0) {
            self.tableView.tableHeaderView =[self headView];
        }else{
            self.tableView.tableHeaderView = nil;
        }
    }
    
}

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath {
//    DetailViewController *detailVC = [[DetailViewController alloc] init];
//    detailVC.infoString = self.dataSource[indexPath.row];
//    [self.naviController pushViewController:detailVC animated:YES];

    if (self.lastSelectedIndexPath == indexPath) {
        return;
    }
    if (self.lastSelectedIndexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.lastSelectedIndexPath];
        [cell setSelected:NO animated:NO];
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:NO];
    self.lastSelectedIndexPath = indexPath;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isHeaderRefreshed) {
        return 0;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ParentWorkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       if (cell == nil) {
          cell = [[ParentWorkCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
       }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ParentCheckModel *parent= self.dataSource[indexPath.row];
    [cell setDataToView:parent isCheck:self.isCheckData];
    __weak typeof(self)weakSelf = self;
    cell.bgButtonClicked = ^(ParentCheckModel * _Nonnull model) {
//         [weakSelf selectCellAtIndexPath:indexPath];
        model.remindTime=[NSNumber numberWithInt:2];
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if ([weakSelf.delegate respondsToSelector:@selector(onRemindAgain:)]) {
            [weakSelf.delegate onRemindAgain:model];
        }
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listDidAppear {
    NSLog(@"listDidAppear");
}

- (void)listDidDisappear {
    NSLog(@"listDidDisappear");
}


@end
