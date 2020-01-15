//
//  DropDetailView.m
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DropDetailView.h"
#import "DropLevelView.h"
#import "MedalView.h"
#import "MMAlertView.h"

@interface DropDetailView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) MyRelativeLayout *treeLayout;
@property(nonatomic,strong) MyFrameLayout *recordLayout;
@property(nonatomic,strong)UILabel *totalLabel;
@property float treeRatio;
@property float recordRatio;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)DropLevelView *levelView;
@property(nonatomic,strong)UIButton *dateButton;
@property(nonatomic,readwrite)NSInteger dateIndex;
@end

@implementation DropDetailView
{
    CGFloat _oldY;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    _treeRatio=0.596;
    _recordRatio=0.404;
    _dateIndex = 2;
    [self createTreeLayout];
    [self createDetailRecordLayout];
    
    self.backgroundColor = [UIColor whiteColor];
}

-(void)createTreeLayout
{
    _treeLayout = [MyRelativeLayout new];
    _treeLayout.insetsPaddingFromSafeArea = ~UIRectEdgeBottom;  //为了防止拉到底部时iPhoneX设备的抖动发生，不能将底部安全区叠加到padding中去。
    _treeLayout.myWidth=ScreenWidth;
   
    _treeLayout.myHeight=ScreenHeight*_treeRatio;
    
    _treeLayout.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UIImageView *treeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_tree"]];
    [_treeLayout setBackgroundImage:[UIImage imageNamed:@"tree_bg"]];
    
    treeImg.myCenter=CGPointMake(0, 0);
    [_treeLayout addSubview:treeImg];
    
    [self addSubview:_treeLayout];
    
    UIButton *closeButton = [[UIButton alloc]init];
    [closeButton setImage:[UIImage imageNamed:@"ic_close_X"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(finishVC:) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.myMargin=MyLayoutPos.safeAreaMargin;
    closeButton.myTop=0;
    closeButton.myLeft=10;
    [_treeLayout addSubview:closeButton];
    
    UIButton *cupBtn = [[UIButton alloc]init];
    [cupBtn setImage:[UIImage imageNamed:@"img_cup"] forState:UIControlStateNormal];
    [cupBtn sizeToFit];
    cupBtn.leftPos.equalTo(treeImg.rightPos).offset(38);
    cupBtn.topPos.equalTo(treeImg.topPos).offset(102);
    [cupBtn addTarget:self action:@selector(showMedalView:) forControlEvents:UIControlEventTouchUpInside];
    [_treeLayout addSubview:cupBtn];
    
    UILabel *cupTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 18)];
    cupTitle.textColor=[UIColor whiteColor];
    cupTitle.font = [UIFont boldSystemFontOfSize:12];
    cupTitle.text=@"TA的勋章";
    cupTitle.leftPos.equalTo(cupBtn.leftPos).offset(-4);
    cupTitle.bottomPos.equalTo(cupBtn.topPos).offset(5);
    [cupTitle sizeToFit];
    [_treeLayout addSubview:cupTitle];
    
    _uiProgress = [[DropLevelProgressView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-28*2, 5)];
    _uiProgress.myLeft=_uiProgress.myRight=18;
    _uiProgress.topPos.equalTo(treeImg.bottomPos).offset(12);
    [_treeLayout addSubview:_uiProgress];
    
    self.levelView = [[DropLevelView alloc]initWithFrame:CGRectMake(0, 0, 90, 48)];
    self.levelView.topPos.equalTo(cupBtn.bottomPos).offset(15);
    self.levelView.leftPos.equalTo(treeImg.rightPos).offset(0);
    [_treeLayout addSubview:self.levelView];
    
    
    UIView *totalBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 35)];
    totalBg.backgroundColor = [UIColor myColorWithHexString:@"#F8F8F8"];
    totalBg.layer.cornerRadius = 15;
    totalBg.rightPos.equalTo(_treeLayout.rightPos).offset(-22);
    totalBg.topPos.equalTo(closeButton.topPos).offset(-5);
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 35)];
    self.totalLabel.font = [UIFont systemFontOfSize:12];
    self.totalLabel.textColor = [UIColor myColorWithHexString:@"#FF39AEE9"];
    self.totalLabel.text = [NSString stringWithFormat:@"积累%d滴",1688];
    self.totalLabel.textAlignment=NSTextAlignmentRight;
    self.totalLabel.rightPos.equalTo(_treeLayout.rightPos).offset(0);
    self.totalLabel.topPos.equalTo(closeButton.topPos).offset(-5);
    UIImageView *dropIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 19)];
    [dropIcon setImage:[UIImage imageNamed:@"level_drop"]];
    dropIcon.rightPos.equalTo(totalBg.leftPos).offset(-20);
    dropIcon.centerYPos.equalTo(totalBg.centerYPos);
    
    [_treeLayout addSubview:totalBg];
    [_treeLayout addSubview:dropIcon];
    [_treeLayout addSubview:self.totalLabel];
}

-(void)createDetailRecordLayout
{
    _recordLayout = [MyFrameLayout new];
//    linearLayout.topPos.equalTo(_treeLayout.bottomPos).offset(-14);
    _recordLayout.myTop=ScreenHeight*_treeRatio-14;
    _recordLayout.wrapContentHeight = YES;
    _recordLayout.myHeight=ScreenHeight*_recordRatio;
    _recordLayout.myWidth=ScreenWidth;
    _recordLayout.layer.cornerRadius=17;
    _recordLayout.backgroundColor = [UIColor whiteColor];
    
    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dateButton.frame = CGRectMake(0, 0, 92, 33);
    [_dateButton setTitle:@"本周" forState:UIControlStateNormal];
    _dateButton.myTop=_dateButton.myLeft=22;
    _dateButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    _dateButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _dateButton.layer.cornerRadius = 6;
    _dateButton.layer.borderColor=[UIColor myColorWithHexString:@"#FFB3B3B3"].CGColor;
    _dateButton.layer.borderWidth=1;
    [_dateButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    
    [_dateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - _dateButton.imageView.image.size.width, 0, _dateButton.imageView.image.size.width)];
    [_dateButton setImageEdgeInsets:UIEdgeInsetsMake(0, _dateButton.titleLabel.bounds.size.width+36, 0, -_dateButton.titleLabel.bounds.size.width)];
    [_dateButton addTarget:self action:@selector(openSelectDateView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_recordLayout addSubview:_dateButton];
    _recordLayout.myCenterX=0;
     UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    
    [_recordLayout addGestureRecognizer:pan];
    _recordLayout.userInteractionEnabled = YES;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth,_recordLayout.frame.size.height-50) style:UITableViewStylePlain];
    _tableView.myCenterX=0;
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.myVertMargin = 0;
    _tableView.myTop = 60;
    [_recordLayout addSubview:_tableView];
    
    [self addSubview:_recordLayout];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self setUpTableView];
    self.tableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecords)];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.dropRecordList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.dropRecordList objectAtIndex:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"nomorecell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.imageView setImage:[UIImage imageNamed:@"drop_green_cell"]];
    
    if(self.viewModel.dropRecordList.count>0){
        StuDropRecordModel *record = [[self.viewModel.dropRecordList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
           
       [cell.textLabel setText:record.recordDescription];
       UILabel *timeLabel = [UILabel new];
       [timeLabel setText:[record getHourAndMinute]];
       timeLabel.font= [UIFont systemFontOfSize:12];
       [timeLabel sizeToFit];
       cell.accessoryView =timeLabel;
       cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section>=self.viewModel.dateTitleList.count) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 24)];
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%@",
                  [self.viewModel.dateTitleList objectAtIndex:section]];
    [view addSubview:label];
    label.textColor = [UIColor myColorWithHexString:@"#666666"];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.frame = CGRectMake(11, 0, 100, 25);
    [label sizeToFit];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}



- (void)dragAction:(UIPanGestureRecognizer *)pan
{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        //记录原始的坐标
        _oldY = _recordLayout.frame.origin.y;

    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [pan translationInView:self.recordLayout];
        CGFloat y = point.y + _oldY-14;//y等于原来的高度加上滑动的距离
//        NSLog(@"deltaY=%f, y=%f",point.y,y);
        
        self.recordLayout.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight-y);
//        _tableView.frame =CGRectMake(0, y, ScreenWidth, ScreenHight-y);
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat y = self.recordLayout.frame.origin.y;
        if (y > ScreenHeight*_treeRatio-14) {
            
            y = ScreenHeight*_treeRatio-14;;
            self.recordLayout.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight-y);
        }else if(y<100){
            y=100;
            self.recordLayout.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight-y);
        }
       
    }
}

-(void)openSelectDateView:(id)sender
{
    
    MMPopupItem *todayItem = MMItemMake(@"今天", _dateIndex==1?MMItemTypeHighlight:MMItemTypeNormal, ^(NSInteger index) {
        self.dateIndex = 1;
        [self.dateButton setTitle:@"今天" forState:UIControlStateNormal];
        [self onSelectDatePress:self.dateIndex];
    });
    MMPopupItem *weekItem = MMItemMake(@"本周", _dateIndex==2?MMItemTypeHighlight:MMItemTypeNormal, ^(NSInteger index) {
        self.dateIndex = 2;
        [self.dateButton setTitle:@"本周" forState:UIControlStateNormal];
        [self onSelectDatePress:self.dateIndex];
    });
    MMPopupItem *lastWeekItem = MMItemMake(@"上周", _dateIndex==3?MMItemTypeHighlight:MMItemTypeNormal, ^(NSInteger index) {
          self.dateIndex = 3;
          [self.dateButton setTitle:@"上周" forState:UIControlStateNormal];
          [self onSelectDatePress:self.dateIndex];
      });
    MMPopupItem *monthItem = MMItemMake(@"本月", _dateIndex==4?MMItemTypeHighlight:MMItemTypeNormal, ^(NSInteger index) {
        self.dateIndex = 4;
        [self.dateButton setTitle:@"本月" forState:UIControlStateNormal];
        [self onSelectDatePress:self.dateIndex];
    });
    MMPopupItem *ternItem = MMItemMake(@"上月", _dateIndex==5?MMItemTypeHighlight:MMItemTypeNormal, ^(NSInteger index) {
        self.dateIndex = 5;
        [self.dateButton setTitle:@"上月" forState:UIControlStateNormal];
        [self onSelectDatePress:self.dateIndex];
    });
    MMPopupItem *lastTernItem = MMItemMake(@"本学期", _dateIndex==6?MMItemTypeHighlight:MMItemTypeNormal, ^(NSInteger index) {
        self.dateIndex = 6;
        [self.dateButton setTitle:@"本学期" forState:UIControlStateNormal];
        [self onSelectDatePress:self.dateIndex];
    });
    NSArray *itemArray = [NSArray arrayWithObjects:todayItem,weekItem,lastWeekItem,monthItem,ternItem,lastTernItem, nil];
    MMAlertView *alertView = [[MMAlertView alloc]initWithTitle:@"选择时间范围" detail:@"" items:itemArray];
    [alertView show];
}

-(void)onSelectDatePress:(NSInteger)index
{
    
    [self.responser onChangeDate:index];
}

-(void)showMedalView:(id)sender
{
    MedalView *medalView = [[MedalView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [medalView setMedalData:self.viewModel.medalData];
    [medalView showAlert];
}

-(void)setNoDataViewEnable:(BOOL)enable
{
    if (enable) {
        self.tableView.tableHeaderView =[self headView];
    }else{
        self.tableView.tableHeaderView = nil;
    }
}

-(UIView *)headView
{
    UIView *rootView = [MyRelativeLayout new];
    rootView.frame = CGRectMake(0, 0, ScreenWidth, 240);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 169, 119)];
    NSString *picPath =[[NSBundle mainBundle] pathForResource:@"pic_no_drop_records" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:picPath];
    [imageView setImage:img];
    imageView.myCenterX=0;
    imageView.myCenterY=0;
    
    UILabel *tips = [UILabel new];
    [tips setText:@"暂无水滴记录"];
    [tips sizeToFit];
    tips.textColor = [UIColor myColorWithHexString:@"#666666"];
    tips.font=[UIFont systemFontOfSize:14];
    tips.topPos.equalTo(imageView.bottomPos).offset(20);
    tips.myCenterX =0;
    
    [rootView addSubview:imageView];
    [rootView addSubview:tips];
    return rootView;
}

-(void)finishVC:(UIButton *)sender{
    [self.responser onCloseButtonPress];
}

-(void)bindWithViewModel:(DropDetailViewModel *)viewModel
{
    
    self.viewModel = viewModel;
    [self.uiProgress setProgress:self.viewModel.progress andMaxValue:self.viewModel.wrapTreeModel.thisMax.floatValue];
    self.totalLabel.text = [NSString stringWithFormat:@"积累%d滴",self.viewModel.wrapTreeModel.tree.dropNow.intValue];
    [self.levelView setScoreLabelText:self.viewModel.currentLevelStr];
    if (self.viewModel.dropRecordList.count==0) {
        [self setNoDataViewEnable:YES];
    }else{
        [self setNoDataViewEnable:NO];
    }
}

-(void)loadMoreRecords
{
    [self.responser loadMoreRecords];
}

-(void)refreshDropRecord
{
    [self.tableView reloadData];
    if (self.viewModel.dropRecordList.count==0) {
        [self setNoDataViewEnable:YES];
    }else{
        [self setNoDataViewEnable:NO];
    }
}

-(void)onLoadFinish
{
    [self.tableView.mj_footer endRefreshing];
}


@end
