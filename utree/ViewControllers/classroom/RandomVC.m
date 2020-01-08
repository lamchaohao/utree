//
//  RandomVC.m
//  utree
//
//  Created by 科研部 on 2019/8/19.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "RandomVC.h"
#import "UIColor+ColorChange.h"
#import "UTStudent.h"
#import "UTStudentCollectCell.h"
#import "ClassStudentsDC.h"
#import "AwardVC.h"
@interface RandomVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(assign,atomic) int countPerson;
@property(atomic,strong) UILabel *countLabel;
@property(atomic,strong) UILabel *titleLabel;
@property(atomic,strong) UIButton *startRandomBtn;
@property(atomic,strong)UIView *mainView;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *studentList;
@property(nonatomic,strong)NSMutableArray *chosenStudents;
@property(nonatomic,strong)UIButton *startBtn;
@property(nonatomic,strong)UIButton *resetBtn;
@property int kLineNum;
@property int kLineSpacing ;
@property(nonatomic,strong)ClassStudentsDC *dataController;
@end

@implementation RandomVC
static NSString *cellID = @"collectionID";

- (void)viewDidLoad {
    _kLineNum=3;
    _kLineSpacing=8;
    [super viewDidLoad];
    [self fetchStudentList];
    
}

-(void)fetchStudentList
{
    self.chosenStudents = [[NSMutableArray alloc]init];
    self.dataController = [[ClassStudentsDC alloc]init];
    BOOL hasShowView = NO;
    self.studentList = [self.dataController readStudentDataInCacheFromCurrentClassId];
    if (self.studentList.count>0) {
        [self showView];
        hasShowView = YES;
    }
    [self.dataController requestStudentListWithSuccess:^(UTResult * _Nonnull result) {
        self.studentList = result.successResult;
        if (!hasShowView) {
            [self showView];
        }
    } failure:^(UTResult * _Nonnull result) {
        [self showToastView:result.failureResult];
    }];
}

-(void)showView
{
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    self.view = rootLayout;
    
    MyFrameLayout *myTopLL = [MyFrameLayout new];
    myTopLL.frame = CGRectMake(0,0,ScreenWidth-40,50);
    myTopLL.myHorzMargin = 0;
    
    self.mainView = [MyFrameLayout new];
    self.mainView.frame = CGRectMake(0,0,ScreenWidth,(450*ScreenHeight/iPhone6H));
    self.mainView.backgroundColor = [UIColor myColorWithHexString:@"#FAFAFA"];
    self.mainView.layer.cornerRadius = 11;
    [self.view addSubview:self.mainView];
    self.mainView.myLeft=self.mainView.myRight=20;
    self.mainView.myCenterY=0;

    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_titleLabel setText:@"请选择人数"];
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
    
    self.resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 20)];
    self.resetBtn.myRight=20;
    self.resetBtn.myTop=20;
    [self.resetBtn setWrapContentSize:YES];
    [self.resetBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.resetBtn setTitleColor:[UIColor_ColorChange colorWithHexString:PrimaryColor] forState:UIControlStateNormal];
    [self.resetBtn setTitleColor:[UIColor_ColorChange colorWithHexString:@"#CCCCCC"] forState:UIControlStateDisabled];
    [self.resetBtn setTitle:@"重新抽选" forState:UIControlStateNormal];
    [self.resetBtn setTitle:@"重新抽选" forState:UIControlStateDisabled];
    [self.resetBtn addTarget:self action:@selector(resetRandom:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetBtn setEnabled:NO];
    [myTopLL addSubview:topBackView];
    [myTopLL addSubview:_titleLabel];
    [myTopLL addSubview:self.resetBtn];
    [self.mainView addSubview:myTopLL];

    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(19, 20, 30, 30)];
    closeBtn.myLeft=closeBtn.myTop=20;
    [closeBtn setImage:[UIImage imageNamed:@"ic_close_black"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closedialog:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mainView addSubview:closeBtn];
    
    MyFrameLayout *mycenterLL = [MyFrameLayout new];
    mycenterLL.frame =CGRectMake(0, 0, ScreenWidth*0.8,(497*ScreenHeight/iPhone6H)*0.72);
    mycenterLL.myCenterY=mycenterLL.myCenterX=0;
    mycenterLL.tag=12800;
    
    _countLabel = [UILabel new];
    [_countLabel setFont:[UIFont systemFontOfSize:83]];
    _countPerson=1;
    [_countLabel setText:@"1"];
    [_countLabel setWrapContentSize:YES];
    _countLabel.myCenterY=_countLabel.myCenterX=0;
    
    UIButton *minusBtn = [[UIButton alloc]init];
    [minusBtn setImage:[UIImage imageNamed:@"btn_minus"] forState:UIControlStateNormal];
    [minusBtn sizeToFit];
    [minusBtn addTarget:self action:@selector(minusCount:) forControlEvents:UIControlEventTouchUpInside];
    minusBtn.myCenterY=0;
    minusBtn.leftPos.equalTo(_countLabel.rightPos).offset(44);
    
    UIButton *addsBtn = [[UIButton alloc]init];
    [addsBtn setImage:[UIImage imageNamed:@"btn_add"] forState:UIControlStateNormal];
    [addsBtn addTarget:self action:@selector(addsCount:) forControlEvents:UIControlEventTouchUpInside];
    [addsBtn sizeToFit];
    addsBtn.myCenterY=0;
    addsBtn.rightPos.equalTo(_countLabel.leftPos).offset(44);

    [mycenterLL addSubview:minusBtn];
    [mycenterLL addSubview:_countLabel];
    [mycenterLL addSubview:addsBtn];
    [self.mainView addSubview:mycenterLL];
    [self initGridView];
    
    self.startBtn = [[UIButton alloc]init];
    [self.startBtn setTitle:@"开始抽选" forState:UIControlStateNormal];
    [self.startBtn sizeToFit];
    self.startBtn.myHeight=70;
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"bg_round_conner"] forState:UIControlStateNormal];
    self.startBtn.myCenterX=0;
    self.startBtn.myLeft=self.startBtn.myRight=23;
    self.startBtn.bottomPos.equalTo(self.mainView.bottomPos).offset(5);
    [self.startBtn addTarget:self action:@selector(startRandom:) forControlEvents:UIControlEventTouchUpInside];
    [rootLayout addSubview:self.startBtn];
}

-(void)closedialog:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)minusCount:(UIButton *)sender
{
    _countPerson--;
    if (_countPerson<0) {
        _countPerson=0;
    }
    [_countLabel setText:[NSString stringWithFormat:@"%d",_countPerson]];
    

}
-(void)addsCount:(UIButton *)sender
{
    _countPerson++;
    if (_countPerson>30) {
        _countPerson=30;
    }
    [_countLabel setText:[NSString stringWithFormat:@"%d",_countPerson]];
}

#pragma mark 重新抽选
-(void)resetRandom:(id)sender
{
    [self.chosenStudents removeAllObjects];
    [self randomGenerateStu];
}

#pragma mark 开始抽选
-(void)startRandom:(UIButton *)sender
{
    for (UIView *view in [self.mainView subviews]) {
        if(view.tag==12800){//myCenterLL
            NSLog(@"class--%@",[view class]);
            [view removeFromSuperview];
            
            [self randomGenerateStu];
            [self.startBtn setTitle:@"发送奖励" forState:UIControlStateNormal];
            [self.startBtn addTarget:self action:@selector(startAwardVC:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [_titleLabel setText:@"随机抽选"];
}

-(void)randomGenerateStu
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    long sumPerson = self.studentList.count;
    while (dic.count!=self.countPerson) {
        
        int position = arc4random()%sumPerson;
        if (position>=0&&position<sumPerson) {
            UTStudent *chosenOne = [self.studentList objectAtIndex:position];
            [dic setObject:chosenOne forKey:chosenOne.studentId];
        }
    }
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.chosenStudents addObject:obj];
    }];
    
    [self.resetBtn setEnabled:YES];
    [_collectionView setHidden:NO];
    [_collectionView reloadData];
}

#pragma mark 奖励他们
-(void)startAwardVC:(UIButton *)sender
{
    //没有学生，返回
    if (_chosenStudents.count<1) {
        return;
    }
    AwardVC *awardVC= [[AwardVC alloc]initByPassStuList:_chosenStudents groupId:nil];
    awardVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:awardVC animated:NO completion:nil];
    
}

-(void)initGridView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth*0.8,CGRectGetHeight(self.mainView.frame)*0.7) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor myColorWithHexString:@"#FAFAFA"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.myCenterY=1;
    _collectionView.myLeft=_collectionView.myRight=12;
    [_collectionView registerClass:[UTStudentCollectCell class] forCellWithReuseIdentifier:cellID];
    [self.mainView addSubview:_collectionView];
    [_collectionView setHidden:YES];
    
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
    return self.chosenStudents.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UTStudentCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UTStudent *student = self.chosenStudents[indexPath.row];
    [cell setStudentModel:student];
    return cell;
}

/**
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
    CGFloat itemW = (CGRectGetWidth(collectionView.frame)-(_kLineNum+1)*_kLineSpacing)/_kLineNum-0.001;
    CGFloat itemH = itemW*(1+0.137);
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

@end
