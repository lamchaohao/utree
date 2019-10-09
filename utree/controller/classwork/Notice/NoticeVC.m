//
//  NoticeVC.m
//  utree
//
//  Created by 科研部 on 2019/8/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "NoticeVC.h"
#import "NoticeCell.h"
#import "NoticeModel.h"
#import "NoticeViewModel.h"
@interface NoticeVC ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *noticeArray;      //数据模型
@property (nonatomic,strong) NSMutableArray *noticeFrameArray; //ViewModel(包含cell子控件的Frame)
@end

@implementation NoticeVC

static NSString *CellID = @"noticeCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    [self loadNewData];
}

-(void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-iPhone_Top_NavH-iPhone_Bottom_NavH-SegmentTitleViewHeight) style:UITableViewStylePlain];
    [_tableView registerClass:[NoticeCell class] forCellReuseIdentifier:CellID];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    [self.view addSubview:_tableView];

}

- (void)loadNewData{
    //模拟增加数据
    for (NoticeModel *notice in self.noticeArray) {
        NoticeViewModel *noticeVM = [[NoticeViewModel alloc] init];
        noticeVM.notice = notice;
        [_noticeFrameArray addObject:noticeVM];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    
    
}


- (NSMutableArray *)noticeArray{
    if (!_noticeArray) {
        _noticeArray = [NSMutableArray array];
        _noticeArray = [self getNoticeList];
    }
    return _noticeArray;
}

- (NSMutableArray *)noticeFrameArray{
    if (!_noticeFrameArray) {
        _noticeFrameArray = [NSMutableArray array];
        //数据模型 => ViewModel(包含cell子控件的Frame)
        for (NoticeModel *notice in self.noticeArray) {
            NoticeViewModel *noticeVM = [[NoticeViewModel alloc] init];
            [noticeVM setNotice:notice];
            [self.noticeFrameArray addObject:noticeVM];
        }
    }
    return _noticeFrameArray;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];

    [cell setNoticeViewModel:self.noticeFrameArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noticeArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeViewModel *noticeVM = self.noticeFrameArray[indexPath.row];
    return noticeVM.cellHeight;

}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(NSMutableArray *)getNoticeList
{
    NSMutableArray *photoArray = [NSMutableArray array];
    [photoArray addObject:@"http://www.chinadaily.com.cn/dfpd/fj/attachement/jpg/site1/20100303/000d6005bf420cf851ab1a.jpg"];
    [photoArray addObject:@"http://img1.7wsh.net/2016/7/29/20160729135555832.jpg"];
    [photoArray addObject:@"http://photocdn.sohu.com/20120621/Img346235766.jpg"];
    [photoArray addObject:@"http://images1.wenming.cn/web_wenming/syjj/dfcz/201203/W020120309310739151237.jpg"];
    [photoArray addObject:@"http://photocdn.sohu.com/20150802/Img418002033.jpg"];
    [photoArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1567398602986&di=54f91bfd8733261f37fef64f892d6d27&imgtype=0&src=http%3A%2F%2Ffiles.eduuu.com%2Fimg%2F2011%2F06%2F20%2F181333_4dff1d4de6e55.jpg"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<12; i++) {
        NoticeModel *model = nil;
        if (i%2==0) {
            model = [[NoticeModel alloc]initWithPosterName:@"王刚老师" time:@"刚刚" title:@"明天上课带计算机" detail:@"9月15日上午，记者联系到钱飞时，他和队友为了凌晨的一起火灾刚从灭火救援一线归队，正准备出发去基层消防大队蹲点检查。钱飞是杭州市消防救援支队政治处的一名干事，今年是他加入消防队伍的第18个年头；他的爱人则是滨江公安分局的一名民警，平时工作也非常忙。“开完会后，陪女儿吃了顿食堂饭，后来就让她坐上同事的顺风车回家，我继续回单位值班。”"];
        }else{
            model = [[NoticeModel alloc]initWithPosterName:@"李逵老师" time:@"昨天" title:@"乘电梯“私奔”到月球？想得真美！" detail:@"一直以来，人类进入太空都要依靠飞船火箭。"];
        }
        
        [model setPhotoUrls:photoArray];
        [arr addObject:model];
    }
    return arr;
}

@end
