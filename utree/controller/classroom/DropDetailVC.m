//
//  DropDetailVC.m
//  utree
//
//  Created by 科研部 on 2019/8/9.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DropDetailVC.h"
#import "MyLayout.h"
#import "AutoScaleFrameMain.h"
@interface DropDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property MyRelativeLayout *treeLayout;
@property MyFrameLayout *recordLayout;
@property float treeRatio;
@property float recordRatio;
@property UITableView *tableView;
@end

@implementation DropDetailVC
{
    CGFloat _oldY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView
{
    _treeRatio=0.596;
    _recordRatio=0.404;
    [self createTreeLayout];
    [self createDetailRecordLayout];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    [self.view addSubview:_treeLayout];
    
    UIButton *closeButton = [[UIButton alloc]init];
    [closeButton setImage:[UIImage imageNamed:@"ic_close_X"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(finishVC:) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.myMargin=MyLayoutPos.safeAreaMargin;
    closeButton.myTop=closeButton.myLeft=20;
    [_treeLayout addSubview:closeButton];
    
    UIButton *cupBtn = [[UIButton alloc]init];
    [cupBtn setImage:[UIImage imageNamed:@"img_cup"] forState:UIControlStateNormal];
    [cupBtn sizeToFit];
    cupBtn.rightPos.equalTo(_treeLayout.rightPos).offset(38);
    cupBtn.topPos.equalTo(treeImg.topPos).offset(102);
    [_treeLayout addSubview:cupBtn];
    
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
    
    UILabel *label = [[UILabel alloc]init];
    [label setText:@"本周情况"];
    label.myTop=label.myLeft=22;
    [label sizeToFit];
    
    [_recordLayout addSubview:label];
    _recordLayout.myCenterX=0;
     UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    
    [_recordLayout addGestureRecognizer:pan];
    _recordLayout.userInteractionEnabled = YES;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth,_recordLayout.frame.size.height-50) style:UITableViewStylePlain];
    _tableView.myCenterX=0;

    _tableView.myVertMargin = 0;
    _tableView.myTop = 60;
    [_recordLayout addSubview:_tableView];

    
    
    [self.view addSubview:_recordLayout];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self setUpTableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
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
    [cell.textLabel setText:@"学习(上课回答积极) 语文李婷老师奖励2滴 07:27"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}


- (void)dragAction:(UIPanGestureRecognizer *)pan
{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        //记录原始的坐标
        _oldY = _recordLayout.frame.origin.y;
//    NSLog(@"_oldY=%f,%f,%f,%f",_recordLayout.frame.origin.x,_recordLayout.frame.origin.y,_recordLayout.frame.size.height,_recordLayout.frame.size.height);
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

-(void)finishVC:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end