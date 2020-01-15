//
//  AwardVC.m
//  utree
//
//  Created by 科研部 on 2019/9/12.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AwardVC.h"
#import "FSScrollContentView.h"
#import "AwardListView.h"
#import "UTStudent.h"
#import "DropDetailVC.h"
#import "CommentVC.h"
#import "AwardDC.h"
#import "AwardResultView.h"
#import "TYTabPagerView.h"
@interface AwardVC ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate,AwardResponser,TYTabPagerViewDataSource, TYTabPagerViewDelegate>

@property(nonatomic,strong) UILabel *countLabel;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *bgView;
//@property(nonatomic,strong) FSPageContentView *pageContentView;
//@property(nonatomic,strong) FSSegmentTitleView *titleView;
//@property(nonatomic,strong)NSMutableArray *viewControllerArray;
@property(nonatomic,strong)AwardDC *dataController;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *studentList;
@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,strong)NSMutableDictionary *awardItemsDic;
@property (nonatomic, weak) TYTabPagerView *pageContentView;

@end

@implementation AwardVC

-(instancetype)initByPassStuList:(NSArray *)stuList groupId:(NSString *)groupId
{
    self = [super init];
    if (self) {
        _studentList= stuList;
        if (groupId) {
            _groupId = groupId;
        }
        
    }
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self loadAwardItemData];

}


-(void)loadAwardItemData
{
    self.dataController = [[AwardDC alloc]init];
    BOOL hasInitView = NO;
    self.awardItemsDic = [self.dataController requestAwardItemsFromCache];
    if (self.awardItemsDic.count>0) {
        [self initView];
        hasInitView = YES;
    }
    
    [self.dataController requestAwardItemsWithSuccess:^(UTResult * _Nonnull result) {
        self.awardItemsDic = result.successResult;
        if (!hasInitView) {
            [self initView];
        }
        
    } failure:^(UTResult * _Nonnull result) {
         [self showToastView:result.failureResult];
    }];
}


-(void)initView
{
    CGRect frame = self.view.bounds;
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.frame = frame;
    self.view = rootLayout;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closedialog:)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgView.backgroundColor=[UIColor clearColor];
    [bgView addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addSubview:bgView];
    
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
    [self initScrollView];
}


-(void)initPageView
{
    UIView *titleBg = [[UIView alloc]initWithFrame:CGRectMake(0, 8, ScreenWidth-40, 50)];
    titleBg.backgroundColor = [UIColor whiteColor];
    titleBg.trailingPos.equalTo(_bgView.trailingPos);
    titleBg.bottomPos.equalTo(_bgView.bottomPos);
    titleBg.layer.cornerRadius = 11;
    [self.view addSubview:titleBg];
    _titleArray = [NSArray arrayWithObjects:@"学习",@"劳卫",@"文体",@"品德",@"实践",nil];
    
    TYTabPagerView *pagerView = [[TYTabPagerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth*0.8, ScreenWidth*0.88+30) andTitles:_titleArray];
    pagerView.tabBar.frame = CGRectMake(0, 8, ScreenWidth-40, 30);
    pagerView.tabBar.trailingPos.equalTo(_bgView.trailingPos);
    pagerView.tabBar.bottomPos.equalTo(_bgView.bottomPos).offset(10);
    
    pagerView.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    pagerView.tabBar.layout.normalTextColor = [UIColor myColorWithHexString:@"#666666"];
    pagerView.tabBar.layout.normalTextFont =[UIFont systemFontOfSize:16];
    pagerView.tabBar.layout.selectedTextColor =[UIColor myColorWithHexString:PrimaryColor];
    pagerView.tabBar.layout.selectedTextFont =[UIFont systemFontOfSize:16];
    pagerView.tabBar.progressView.backgroundColor= [UIColor myColorWithHexString:PrimaryColor];
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [self.view addSubview:pagerView];
    
    _pageContentView = pagerView;
    
    [_pageContentView scrollToViewAtIndex:0 animate:YES];
    [_pageContentView reloadData];
    
}



-(void)initScrollView{

    self.pageContentView.topPos.equalTo(_bgView.topPos).offset(_commentBtn.isHidden?60:80);
    self.pageContentView.leftPos.equalTo(_bgView.leftPos).offset(14);
    _commentBtn.topPos.equalTo(_pageContentView.topPos).offset(-20);
    _commentBtn.rightPos.equalTo(_pageContentView.rightPos);
    [self.view addSubview:_commentBtn];
    
    CGFloat height =ScreenWidth*0.88+56+20+50;
    _bgView.frame = CGRectMake(0,0,ScreenWidth,height);

}

- (NSInteger)numberOfViewsInTabPagerView {
    return _titleArray.count;
}

- (UIView *)tabPagerView:(TYTabPagerView *)tabPagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
//    UIView *view = [_viewControllerArray objectAtIndex:index] ;
    long i = index +1;
    NSArray *items = [self.awardItemsDic objectForKey:[NSString stringWithFormat:@"%ld",i]];
    AwardListView *listVC= [[AwardListView alloc]initWithAwardData:items];
    
    listVC.responser = self;
    return listVC;
}

- (NSString *)tabPagerView:(TYTabPagerView *)tabPagerView titleForIndex:(NSInteger)index {
    NSString *title = _titleArray[index];
    return title;
}



-(void)closedialog:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 跳转到详情页
-(void)gotoStudentPage:(id)sender
{
    
    UTStudent *stu = [_studentList objectAtIndex:0];
    DropDetailVC *detailVC = [[DropDetailVC alloc] initWithStudentId:stu.studentId];
//    detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:detailVC animated:YES completion:nil];
    detailVC.hidesBottomBarWhenPushed=YES;
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.vcDelegate pushToViewController:detailVC];
    
}


#pragma mark 文字点评
-(void)gotoComment:(UIButton *)sender
{
    CommentVC *commentVC = [[CommentVC alloc] initWithStuName:_studentList[0]];
    commentVC.hidesBottomBarWhenPushed=YES;
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.vcDelegate pushToViewController:commentVC];
    
}

- (void)onAwardItemClick:(AwardModel *)model
{
    
    if (_groupId) {
        [self.dataController requestAwardGroupId:_groupId awardId:model.excitationId WithSuccess:^(UTResult * _Nonnull result) {
            [self showAwardResultView:model];
        } failure:^(UTResult * _Nonnull result) {
            [self showToastView:result.failureResult];
        }];
    }else{
        [self.dataController requestAwardStudents:_studentList awardId:model.excitationId WithSuccess:^(UTResult * _Nonnull result) {
            [self showAwardResultView:model];
        } failure:^(UTResult * _Nonnull result) {
            [self showToastView:result.failureResult];
        }];
    }
    
}

-(void)showAwardResultView:(AwardModel *)model
{
    if (_groupId||_studentList.count>1) {
        AwardResultView *resultView = [[AwardResultView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) stuNum:[NSString stringWithFormat:@"%ld",_studentList.count]];
        [resultView showView];
        if ([self.vcDelegate respondsToSelector:@selector(onAwardSuccess:)]) {
            [self.vcDelegate onAwardSuccess:model];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UTStudent *stu = [_studentList objectAtIndex:0];
        AwardResultView *resultView = [[AwardResultView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) stuName:stu.studentName score:model.dropPoint.stringValue];
        [resultView showView];
        if ([self.vcDelegate respondsToSelector:@selector(onAwardSuccess:)]) {
            [self.vcDelegate onAwardSuccess:model];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}





@end
