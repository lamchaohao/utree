//
//  EditGroupView.m
//  utree
//
//  Created by 科研部 on 2019/11/5.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "EditGroupView.h"
#import "GroupModel.h"
#import "UTStudentCollectCell.h"
#import "UTStudent.h"
#import "MMAlertView.h"

@interface EditGroupView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UIButton *dismissBtn;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong)GroupModel *groupModel;
@property(nonatomic,strong)UITableViewCell *groupNameCell;
@property(nonatomic,strong)UITableViewCell *groupMemberCountCell;
@property int kLineNum;
@property int kLineSpacing ;
@end

@implementation EditGroupView
static NSString *cellID = @"stuCellId";

- (instancetype)initWithFrame:(CGRect)frame groupModel:(GroupModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        _kLineNum=4;
        _kLineSpacing=8;
        self.backgroundColor = [UIColor myColorWithHexString:@"#F7F7F7"];
        self.groupModel =model;
        [self initNaviBar];
        [self initGridView];
    }
    return self;
}

-(void)bindViewModel:(GroupModel *)groupModel
{
    self.groupModel = groupModel;
}

-(void)initNaviBar
{
    self.wrapContentWidth = NO;
    self.wrapContentHeight = NO;
    
    
    self.groupNameCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"groupCell"];
    _groupNameCell.myWidth=ScreenWidth;
    self.groupNameCell.backgroundColor=[UIColor whiteColor];
    
    self.groupNameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.groupNameCell.textLabel.text=@"小组名称";
    [self.groupNameCell.detailTextLabel setText:self.groupModel.groupName];
//    self.groupNameCell.topPos.equalTo(navBarLayout.bottomPos).offset(10);
    self.groupNameCell.myTop=iPhone_Top_NavH+10;
    [self addSubview:self.groupNameCell];
//    groupNameCell add
    
    _groupMemberCountCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"groupCount"];
    _groupMemberCountCell.myWidth=ScreenWidth;
    _groupMemberCountCell.backgroundColor=[UIColor whiteColor];
    
    _groupMemberCountCell.accessoryType = UITableViewCellAccessoryNone;
    _groupMemberCountCell.textLabel.text=@"小组人数";
    [_groupMemberCountCell.detailTextLabel setText:[NSString stringWithFormat:@"%lu人",self.groupModel.studentDos.count]];
    _groupMemberCountCell.topPos.equalTo(self.groupNameCell.bottomPos).offset(12);
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellClick:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.groupNameCell addGestureRecognizer:tapGesture];
    [self addSubview:self.groupMemberCountCell];
}


-(void)initGridView
{
    
    _dismissBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 48)];
    _dismissBtn.myLeft=_dismissBtn.myRight=35;
    _dismissBtn.bottomPos.equalTo(self.bottomPos).offset(12);
    
    [_dismissBtn setTitle:@"解散小组" forState:UIControlStateNormal];
    [_dismissBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dismissBtn setBackgroundColor:[UIColor myColorWithHexString:@"#FB5B5B"]];
    _dismissBtn.layer.cornerRadius = 24;
    [_dismissBtn addTarget:self action:@selector(dissmissGroupClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: _dismissBtn];
    
   UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenWidth*1.0) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, iPhone_Bottom_NavH, 0);
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.bottomPos.equalTo(self.dismissBtn.topPos).offset(8);
    [_collectionView registerClass:[UTStudentCollectCell class] forCellWithReuseIdentifier:cellID];
    self.collectionView.topPos.equalTo(self.groupMemberCountCell.bottomPos).offset(12);
    [self addSubview:_collectionView];
    
    _collectionView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshGroupData)];
    
    
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
    return self.groupModel.studentDos.count+1;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UTStudentCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.row==0) {
        //ic_edit_round
        [cell.headView setImage:[UIImage imageNamed:@"ic_edit_round"]];
        cell.nameLabel.text =@"编辑";
        [cell.selectedModeImg setHidden:YES];
        [cell.rectView setHidden:YES];
        [cell.scoreLabel setHidden:YES];
    }else{
        UTStudent *student = self.groupModel.studentDos[indexPath.row-1];
        [cell setStudentModel:student];
    }
    
    return cell;
}

/*
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0){
        [self.responser onEditPress];
    }
    
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
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.responser onCloseViewController];
}

-(void)refreshGroupData
{
    [self.responser onRequestRefresh];
}

-(void)onLoadDataFinish
{
    [self.collectionView reloadData];
    [self.groupNameCell.detailTextLabel setText:self.groupModel.groupName];
    [self.groupMemberCountCell.detailTextLabel setText:[NSString stringWithFormat:@"%lu人",self.groupModel.studentDos.count]];
    [self.collectionView.mj_header endRefreshing];
}

-(void)dissmissGroupClick:(id)sender
{
    MMPopupItemHandler positiveHandler = ^(NSInteger index){
        [self.responser onDeleteGroup];
    };
    MMPopupItemHandler nagativeHandler = ^(NSInteger index){
        
    };
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeNormal, positiveHandler),
      MMItemMake(@"取消", MMItemTypeHighlight, nagativeHandler)];
    
    MMAlertView *dismissAlert = [[MMAlertView alloc]initWithTitle:@"确定解散小组" detail:@"解散后此组学生将被释放" items:items];
    
    [dismissAlert show];
}

-(void)cellClick:(id)sender
{
  
    MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:@"更改小组名称" detail:nil placeholder:@"请输入小组名称" handler:^(NSString *text) {
        [self.responser onRenameGroup:text];
    }];
    UITextField *textView = alertView.inputView;
    textView.text =self.groupModel.groupName;
    [alertView show];
}


@end
