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
#import "CommentVC.h"

@interface AwardVC ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property(nonatomic,strong) UILabel *countLabel;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic, strong) FSPageContentView *pageContentView;
@property(nonatomic, strong) FSSegmentTitleView *titleView;
@property(nonatomic,strong)NSMutableArray *viewControllerArray;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *studentList;
@property(nonatomic,strong)UIButton *commentBtn;
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
    CGRect frame = self.view.bounds;
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.frame = frame;
    self.view = rootLayout;
    
    MyFrameLayout *myTopLL = [MyFrameLayout new];
    myTopLL.myHorzMargin = 0;
    myTopLL.frame = CGRectMake(0, 0, ScreenWidth, 56);
    myTopLL.backgroundColor=[UIColor whiteColor];
    myTopLL.layer.cornerRadius = 11;
    
    _bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(0,0,ScreenWidth,ScreenWidth*0.88+100);
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
    topBackView.frame = CGRectMake(0,0,ScreenWidth-40,56);
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
    
    
    _commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 20)];
    [_commentBtn setTitle:@"文字点评" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor myColorWithHexString:PrimaryColor] forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_commentBtn addTarget:self action:@selector(gotoComment:) forControlEvents:UIControlEventTouchUpInside];
    
    if(_studentList.count==1){
        NSString *title= [NSString stringWithFormat:@"奖励 %@",((UTStudent *)_studentList[0]).studentName,nil];
        [_titleLabel setText:title];
        [stuHomePage addTarget:self action:@selector(gotoStudentPage:) forControlEvents:UIControlEventTouchUpInside];
        [myTopLL addSubview:stuHomePage];
    }else{
        [_titleLabel setText:@"奖励Ta们"];
        _commentBtn.hidden=YES;
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
    UIView *titleBg = [[UIView alloc]initWithFrame:CGRectMake(0, 8, ScreenWidth-40, 50)];
    titleBg.backgroundColor = [UIColor whiteColor];
    titleBg.trailingPos.equalTo(_bgView.trailingPos);
    titleBg.bottomPos.equalTo(_bgView.bottomPos);
    titleBg.layer.cornerRadius = 11;
    
    _titleArray = [NSArray arrayWithObjects:@"学习",@"劳卫",@"文体",nil];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 8, ScreenWidth-40, 30) titles:_titleArray delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:16];
    self.titleView.selectIndex = 0;

    _titleView.trailingPos.equalTo(_bgView.trailingPos);
    _titleView.bottomPos.equalTo(_bgView.bottomPos).offset(10);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:titleBg];
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
    
//    CGFloat contentViewHeight = _commentBtn.isHidden?ScreenWidth*0.88:ScreenWidth*0.88-20;
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth*0.8, ScreenWidth*0.88) childVCs:_viewControllerArray parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    self.pageContentView.topPos.equalTo(_bgView.topPos).offset(_commentBtn.isHidden?60:80);
    self.pageContentView.leftPos.equalTo(_bgView.leftPos).offset(14);
    [self.view addSubview:_pageContentView];
    _commentBtn.topPos.equalTo(_pageContentView.topPos).offset(-20);
    _commentBtn.rightPos.equalTo(_pageContentView.rightPos);
    [self.view addSubview:_commentBtn];
    
    CGFloat height =ScreenWidth*0.88+56+20+50;
    _bgView.frame = CGRectMake(0,0,ScreenWidth,height);

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
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark 跳转到详情页
-(void)gotoStudentPage:(UTStudent *)stu
{
    
    DropDetailVC *detailVC = [[DropDetailVC alloc] init];
    detailVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:detailVC animated:YES completion:nil];
}


#pragma mark 文字点评
-(void)gotoComment:(UIButton *)sender
{
    CommentVC *commentVC = [[CommentVC alloc] initWithStuName:_studentList[0]];
    commentVC.hidesBottomBarWhenPushed=YES;
    commentVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self.navigationController pushViewController:commentVC animated:YES];
    [self presentViewController:commentVC animated:YES completion:nil];
}

@end
