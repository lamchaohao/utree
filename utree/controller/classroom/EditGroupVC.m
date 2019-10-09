//
//  EditGroupVC.m
//  utree
//
//  Created by 科研部 on 2019/9/26.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "EditGroupVC.h"
#import "GroupModel.h"
#import "UTStudentCollectCell.h"
#import "UTStudent.h"
#import "MMAlertView.h"
@interface EditGroupVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UIButton *dismissBtn;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong)GroupModel *group;
@property(nonatomic,strong)UITableViewCell *groupNameCell;
@property(nonatomic,strong)UITableViewCell *groupMemberCountCell;
@property int kLineNum;
@property int kLineSpacing ;
@end

@implementation EditGroupVC
static NSString *cellID = @"collectionID";

-(instancetype)initWithGroup:(GroupModel *)group
{
    self = [super init];
    _group = group;
    return self ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _kLineNum=4;
    _kLineSpacing=8;
    
    [self initNaviBar];
    [self initGridView];
    
}

-(void)initNaviBar
{
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
   rootLayout.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
   rootLayout.gravity = MyGravity_Horz_Fill;  //垂直线性布局里面的子视图的宽度和布局视图一致。
   rootLayout.wrapContentWidth = NO;
   rootLayout.wrapContentHeight = NO;
   self.view = rootLayout;
    
    MyRelativeLayout *navBarLayout = [MyRelativeLayout new];
    navBarLayout.frame = CGRectMake(0, 0, ScreenWidth, 64);
    navBarLayout.backgroundColor = [UIColor whiteColor];
    navBarLayout.myTop=iPhone_StatuBarHeight;
    navBarLayout.myLeft=0;
    
    UILabel *navTitle = [[UILabel alloc]init];
    navTitle.myCenterX=0;
    navTitle.myCenterY=0;
    navTitle.textColor = [UIColor blackColor];
    navTitle.font = [UIFont systemFontOfSize:18];
    navTitle.text=@"编辑小组";
    [navTitle sizeToFit];
    
    UIButton *closeButton = [[UIButton alloc]init];
    [closeButton setImage:[UIImage imageNamed:@"ic_close_black"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(finishVC:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.myTop=0;
    closeButton.myLeft=18;
    closeButton.myCenterY=0;
    [navBarLayout addSubview:closeButton];
    [navBarLayout addSubview:navTitle];
    
    [self.view addSubview:navBarLayout];
    
    self.groupNameCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"groupCell"];
    self.groupNameCell.backgroundColor=[UIColor whiteColor];
    
    self.groupNameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.groupNameCell.textLabel.text=@"小组名称";
    [self.groupNameCell.detailTextLabel setText:_group.groupName];
    self.groupNameCell.topPos.equalTo(navBarLayout.bottomPos).offset(10);
    [self.view addSubview:self.groupNameCell];
//    groupNameCell add
    
    _groupMemberCountCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"groupCount"];
    _groupMemberCountCell.backgroundColor=[UIColor whiteColor];
    
    _groupMemberCountCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _groupMemberCountCell.textLabel.text=@"小组人数";
    [_groupMemberCountCell.detailTextLabel setText:[NSString stringWithFormat:@"%lu人",_group.groupMember.count]];
    _groupMemberCountCell.topPos.equalTo(self.groupNameCell.bottomPos).offset(12);
    [self.view addSubview:_groupMemberCountCell];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellClick:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.groupNameCell addGestureRecognizer:tapGesture];
    
}


-(void)initGridView
{
   UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /**
     创建collectionView
     */
    CGFloat barHeight = self.tabBarController.tabBar.frame.size.height;

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenWidth) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, barHeight*2.3, 0);
    _collectionView.allowsMultipleSelection = YES;
    
    [_collectionView registerClass:[UTStudentCollectCell class] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:_collectionView];
    
    _dismissBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 48)];
    _dismissBtn.myLeft=_dismissBtn.myRight=35;
    _dismissBtn.myTop = 18;
    [_dismissBtn setTitle:@"解散小组" forState:UIControlStateNormal];
    [_dismissBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_dismissBtn setBackgroundImage:[UIImage imageNamed:@"bg_red_round_conner"] forState:UIControlStateNormal];
    [_dismissBtn setBackgroundColor:[UIColor myColorWithHexString:@"#FB5B5B"]];
    _dismissBtn.layer.cornerRadius = 24;
    [_dismissBtn addTarget:self action:@selector(dissmissGroupClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _dismissBtn];
}


/**
 分区个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
/**
 每个分区item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _group.groupMember.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UTStudentCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UTStudent *student = _group.groupMember[indexPath.row];
    [cell setStudentModel:student];
    return cell;
}

/*
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
}
//取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemW = (ScreenWidth-(_kLineNum+1)*_kLineSpacing)/_kLineNum-0.001;
    CGFloat itemH = itemW+itemW*0.137;
    return CGSizeMake(itemW, itemH);
}
/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(4, _kLineSpacing, 4, _kLineSpacing);
}
/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return _kLineSpacing;
}
/**
 分区内cell之间的最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return _kLineSpacing;
}

-(void)finishVC:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dissmissGroupClick:(id)sender
{
    MMPopupItemHandler positiveHandler = ^(NSInteger index){
        
    };
    
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeNormal, positiveHandler),
      MMItemMake(@"取消", MMItemTypeHighlight, positiveHandler)];
    
    MMAlertView *dismissAlert = [[MMAlertView alloc]initWithTitle:@"确定解散小组" detail:@"解散后此组学生将被释放" items:items];
    
    [dismissAlert show];
}

-(void)cellClick:(id)sender
{
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
            NSLog(@"animation complete");
        };
        
    MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:@"更改小组名称" detail:nil placeholder:@"请输入小组名称" handler:^(NSString *text) {
        NSLog(@"input:%@",text);
    }];
    UITextField *textView = alertView.inputView;
    textView.text =_group.groupName;
    [alertView showWithBlock:completeBlock];
}

@end
