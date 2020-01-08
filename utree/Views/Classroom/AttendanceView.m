//
//  AttendanceView.m
//  utree
//
//  Created by 科研部 on 2019/10/31.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AttendanceView.h"
#import "SJDateConvertTool.h"
#import "UTAttendanceCell.h"
@interface AttendanceView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,assign)int kLineSpacing;
@property(nonatomic,assign)int kLineNum ;
@end

@implementation AttendanceView
static NSString *CellID = @"attendanceId";
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.orientation = MyOrientation_Vert;
        _kLineNum=4;
        _kLineSpacing=8;
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.orientation = MyOrientation_Vert;
        _kLineNum=4;
        _kLineSpacing=8;
        [self initView];
    }
    return self;
}

-(void)initView
{
     self.insetsPaddingFromSafeArea=UIRectEdgeAll;
    self.backgroundColor = [UIColor whiteColor];
    [self initDateView];
    [self initCollectionView];
}

-(void)initDateView
{

    MyLinearLayout *dateLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    dateLayout.frame = CGRectMake(0, 0, ScreenWidth, 40);

    UILabel *dateTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 30)];
    UILabel *operTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    NSString *date = [SJDateConvertTool getThePresentTimeWithDateDisplayType:DateDisplayType_Custom customTypeString:@"MM月dd日"];
    NSString *titleTip = @"点击记录 weekday 的考勤";
    NSString *todayStr = [titleTip stringByReplacingOccurrencesOfString:@"weekday" withString:date];


    dateTipLabel.adjustsFontSizeToFitWidth = YES;
    [dateTipLabel setText:todayStr];
    [dateTipLabel setFont:[UIFont systemFontOfSize:13]];
    [dateTipLabel setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
    dateTipLabel.myLeft = dateTipLabel.myTop=17;
    [dateTipLabel sizeToFit];

    operTipLabel.adjustsFontSizeToFitWidth =YES;
    [operTipLabel setText:@"（点击头像可切换考勤状态）"];
    [operTipLabel setFont:[UIFont systemFontOfSize:11]];
    [operTipLabel setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
    operTipLabel.myLeft =2;
    operTipLabel.myTop=10;
    operTipLabel.bottomPos.equalTo(dateTipLabel.bottomPos);
    [operTipLabel sizeToFit];

    [dateLayout addSubview:dateTipLabel];
    [dateLayout addSubview:operTipLabel];
    [self addSubview:dateLayout];
}

-(void)bindWithViewModel:(AttendanceViewModel *)viewModel
{
    self.viewModel = viewModel;
    [self.collectionView reloadData];
}


-(void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-iPhone_Bottom_NavH) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    _collectionView.allowsMultipleSelection = YES;
    //    self.edgesForExtendedLayout=UIRectEdgeNone;
    [_collectionView registerClass:[UTAttendanceCell class] forCellWithReuseIdentifier:CellID];
    
    [self addSubview:_collectionView];
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
    return self.viewModel.studentList.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UTAttendanceCell *cell =(UTAttendanceCell *) [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    UTStudent *student = self.viewModel.studentList[indexPath.row];
    
    [cell setStudentModel:student];
    
    return cell;
}


/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UTAttendanceCell *cell = (UTAttendanceCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UTAttendanceCell *cell =(UTAttendanceCell *) [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UTAttendanceCell alloc]init];
        
    }
    
    UTStudent *stu = self.viewModel.studentList[indexPath.row];
    stu.attendanceMode ++;
    [cell setStudentModel:stu];
    
    [_collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]];
    
}
//取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTAttendanceCell *cell =(UTAttendanceCell *) [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    if (cell==nil) {
        cell = (UTAttendanceCell *)[collectionView cellForItemAtIndexPath:indexPath];
    }

    UTStudent *stu = self.viewModel.studentList[indexPath.row];
    stu.attendanceMode ++;
    [cell setStudentModel:stu];
    [_collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]];
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


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
