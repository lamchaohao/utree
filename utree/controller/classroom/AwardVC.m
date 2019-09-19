//
//  AwardVC.m
//  utree
//
//  Created by 科研部 on 2019/9/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AwardVC.h"
#import "FSScrollContentView.h"
#import "AwardListVC.h"
#import "UTStudent.h"
#import "DropDetailVC.h"

@interface AwardVC ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property(atomic,strong) UILabel *countLabel;
@property(atomic,strong) UILabel *titleLabel;
@property(atomic,strong) UIView *bgView;
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property(nonatomic,strong)NSMutableArray *viewControllerArray;
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong)NSArray *studentList;
@end

@implementation AwardVC

-(instancetype)initByPassStuList:(NSArray *)stuList
{
    self = [super init];
    if (self) {
        _studentList= stuList;
    }
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self showView];
    
}

-(void)showView
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    self.view = rootLayout;
    rootLayout.backgroundColor=[UIColor blackColor];
    MyFrameLayout *myTopLL = [MyFrameLayout new];
    myTopLL.myHorzMargin = 0;
    myTopLL.frame = CGRectMake(0, 0, ScreenWidth, 55);
    myTopLL.backgroundColor=[UIColor whiteColor];
    myTopLL.layer.cornerRadius = 11;
    
    _bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(19.3,110.4,ScreenWidth,490.8);
    _bgView.backgroundColor = [UIColor myColorWithHexString:@"#FAFAFA"];
    _bgView.layer.cornerRadius = 11;
    [self.view addSubview:_bgView];
    _bgView.myLeft= _bgView.myRight=20;
    _bgView.myCenterY=0;
    [_bgView addSubview:myTopLL];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    
    
    [_titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [_titleLabel setTextColor:[UIColor blackColor]];
    _titleLabel.myTop = 20;
    _titleLabel.myCenterX = 0;            //水平居中,如果不等于0则会产生居中偏移
    [_titleLabel setWrapContentSize:YES];
    
    UIView *topBackView = [[UIView alloc] init];
    topBackView.frame = CGRectMake(19.3,110.4,ScreenWidth-40,55.2);
    topBackView.backgroundColor = [UIColor whiteColor];
    topBackView.layer.cornerRadius = 11;
    topBackView.myWidth=ScreenWidth-40;
    [myTopLL addSubview:topBackView];
    [myTopLL addSubview:_titleLabel];
    
    UIButton *stuHomePage = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    stuHomePage.myRight=20;
    stuHomePage.myTop=20;
    [stuHomePage setWrapContentSize:YES];
    [stuHomePage.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [stuHomePage setTitleColor:[UIColor_ColorChange colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [stuHomePage setTitle:@"主页" forState:UIControlStateNormal];
    
    if(_studentList.count==1){
        NSString *title= [NSString stringWithFormat:@"奖励 %@",((UTStudent *)_studentList[0]).studentName,nil];
        [_titleLabel setText:title];
        [stuHomePage addTarget:self action:@selector(gotoStudentPage:) forControlEvents:UIControlEventTouchUpInside];
        [myTopLL addSubview:stuHomePage];
    }else{
        [_titleLabel setText:@"奖励Ta们"];
    }
    
   
   
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(19, 20, 30, 30)];
    closeBtn.myLeft=closeBtn.myTop=20;
    [closeBtn setImage:[UIImage imageNamed:@"ic_close_black"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closedialog:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bgView addSubview:closeBtn];
    
    [self initPageView];
}


-(void)initPageView
{
    _titleArray = [NSArray arrayWithObjects:@"学习",@"劳卫",@"文体",@"品德",@"实践",@"实践2",@"实践3",@"品德2",@"品德3", nil];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 8, ScreenWidth-40, 30) titles:_titleArray delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:16];
    self.titleView.selectIndex = 0;

    _titleView.trailingPos.equalTo(_bgView.trailingPos);
    _titleView.bottomPos.equalTo(_bgView.bottomPos).offset(10);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:_titleView];
    
    [self initScrollView];
}

-(void)initScrollView{
    
    _viewControllerArray = [[NSMutableArray alloc]init];
    for (int i =0; i<_titleArray.count;i++)
    {
        AwardListVC *listVC= [[AwardListVC alloc]init];
        [_viewControllerArray addObject:listVC];
    }
    
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth*0.8, ScreenWidth*1.0) childVCs:_viewControllerArray parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    //    self.pageContentView.myTop = 40;
    //    self.pageContentView.myLeading = 0;
    NSLog(@"initScrollView,controllerArray.count=%ld",_viewControllerArray.count);
    self.pageContentView.topPos.equalTo(_bgView.topPos).offset(60);
    self.pageContentView.leftPos.equalTo(_bgView.leftPos).offset(14);
    [self.view addSubview:_pageContentView];
    
}


- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
    
    
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    //    self.title = @[@"个人",@"小组"][endIndex];
}

-(void)closedialog:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 跳转到详情页
-(void)gotoStudentPage:(UTStudent *)stu
{
    NSLog(@"gotoStudentPage");
    DropDetailVC *detailVC = [[DropDetailVC alloc] init];
    [self presentViewController:detailVC animated:YES completion:nil];
}


@end
