//
//  ClassPersonVCViewController.m
//  utree
//
//  Created by 科研部 on 2019/8/7.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassStudentsVC.h"
#import "AutoScaleFrameMain.h"
#import "UTStudentCollectCell.h"
#import "UIColor+ColorChange.h"
#import "DropDetailVC.h"
#import "UTStudent.h"
#import "AwardVC.h"
@interface ClassStudentsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property int kLineNum;
@property int kLineSpacing ;
@property(nonatomic,strong)UIButton *awardBtn;
@end

@implementation ClassStudentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.view = rootLayout;

    self.view.backgroundColor=[UIColor whiteColor];
    _kLineNum=4;
    _kLineSpacing=8;
    
    [self initGridLayout];
    [self initTableView];

}

-(void)showCollectionView:(BOOL )enable{
    
    if (enable) {
        [_tableView setHidden:YES];
        [_collectionView setHidden:NO];
    }else{
        [_tableView setHidden:NO];
        [_collectionView setHidden:YES];
    }
}
# pragma mark 切换多选模式
-(void)switchToMultiChoice
{
    CGFloat barHeight = self.tabBarController.tabBar.frame.size.height;
    _isMultiMode = !_isMultiMode;
    if(!_isMultiMode){
        //反选所有学生
        for (UTStudent *stu in _studentList) {
            stu.selectMode=0;
        }
//        _collectionView.myHeight=ScreenHeight-barHeight;
//        [_awardBtn removeFromSuperview];
        [_awardBtn setHidden:YES];

    }else{
        for (UTStudent *stu in _studentList) {
            stu.selectMode=2;
        }
        
//        _collectionView.myHeight=ScreenHeight-barHeight-54;
       [_awardBtn setHidden:NO];
    }
    [_collectionView reloadData];
    
}

-(void)initAwardBtn
{
    _awardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, [self getAwardBtnYcoord], ScreenWidth, 54)];
    
    [_awardBtn setBackgroundColor:[UIColor_ColorChange colorWithHexString:@"43D27F"]];
    [_awardBtn setTitle:@"奖励所选学生" forState:UIControlStateNormal];
    [_awardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:_awardBtn];
    [_awardBtn setHidden:YES];
    [_awardBtn addTarget:self action:@selector(awardClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 奖励学生按钮
-(void)awardClick:(UIButton *)sender
{
    for (UTStudent *stu in _studentList) {
        stu.selectMode=0;
    }
    [_awardBtn setHidden:YES];
    _isMultiMode=NO;
    [_collectionView reloadData];
    
    NSArray *stus = [_studentList subarrayWithRange:NSMakeRange(0, 4)];
    [self gotoAwardVCWithStuList:stus];
    
    
}

-(void)gotoAwardVCWithStuList:(NSArray *)stus
{
    AwardVC *awardVC= [[AwardVC alloc]initByPassStuList:stus];
    
    awardVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:awardVC animated:YES completion:nil];
}


#pragma mark 当前九宫格视图是否显示
-(BOOL)isCollectionViewOnShow{
    return ![_collectionView isHidden];
}

-(void)initTableView
{
    CGFloat barHeight = self.tabBarController.tabBar.frame.size.height;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-barHeight) style:UITableViewStylePlain];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.sectionIndexColor = [UIColor myColorWithHexString:@"#676767"];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, barHeight*2.3, 0);

//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    [self.view addSubview:_tableView];
    [_tableView setHidden:YES];
    self.dataSource = [[NSMutableDictionary alloc]init];
    
    self.studentList = [self getStudentList];
    
    [self addressBookOrdering:self.studentList];
    
    [self initAwardBtn];
}

-(void)initGridLayout{

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /**
     创建collectionView
     */
    CGFloat barHeight = self.tabBarController.tabBar.frame.size.height;

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-barHeight) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor_ColorChange colorWithHexString:@"#F7F7F7"];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, barHeight*2.3, 0);
    _collectionView.allowsMultipleSelection = YES;
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    /**
     注册item和区头视图、区尾视图
     */
    [_collectionView registerClass:[UTStudentCollectCell class] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyCollectionViewHeaderView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MyCollectionViewFooterView"];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
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
    return _studentList.count;
}
/**
 创建cell
 */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MyCollectionViewCell";
    UTStudentCollectCell *cell =(UTStudentCollectCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UTStudent *student = _studentList[indexPath.row];
    
    [cell setStudentModel:student];
    
    return cell;
}
/**
 创建区头视图和区尾视图
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyCollectionViewHeaderView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor yellowColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:headerView.bounds];
        titleLabel.text = [NSString stringWithFormat:@"第%ld个分区的区头",indexPath.section];
        [headerView addSubview:titleLabel];
        return headerView;
    }else if(kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MyCollectionViewFooterView" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor blueColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:footerView.bounds];
        titleLabel.text = [NSString stringWithFormat:@"第%ld个分区的区尾",indexPath.section];
        [footerView addSubview:titleLabel];
        return footerView;
    }
    return nil;
    
    
}
/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UTStudentCollectCell *cell = (UTStudentCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UTStudent *stu = _studentList[indexPath.row];
    if (_isMultiMode) {
        
        stu.selectMode=1;
        [cell setStudentModel:stu];
    }else{
        [self gotoAwardVCWithStuList:[NSArray arrayWithObjects:stu, nil]];
    }
   
}
//取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTStudentCollectCell *cell = (UTStudentCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UTStudent *stu = _studentList[indexPath.row];
    if (_isMultiMode) {
        stu.selectMode=2;
        [cell setStudentModel:stu];
    }else{
        [self gotoAwardVCWithStuList:[NSArray arrayWithObjects:stu, nil]];
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
/**
 区头大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 0);
}
/**
 区尾大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




#pragma mark tableview code start
-(NSArray *)getStudentList
{
    NSMutableArray *students = [[NSMutableArray alloc]init];
    NSArray *firstName = [[NSArray alloc]initWithObjects:@"王",@"赵",@"钱",@"孙",@"李",@"林",@"蓝",@"江",@"冯",@"郭",@"胡",nil];
    NSArray *secondWordName = [[NSArray alloc]initWithObjects:@"风",@"雪",@"护",@"布",@"楷",@"度",@"振",@"中",@"英",@"奋",@"山",@"民", nil];
    for (int startIndex=0; startIndex<40; startIndex++) {
        char c = (char)(startIndex+65);
        int sencondIndex = arc4random() % 12;
        int thirdIndex = arc4random() % 12;
        NSString *name =[NSString stringWithFormat:@"%c",c];
        NSString *catName = [NSString stringWithFormat:@"%@%@",name,@"联名"];
        if(startIndex>26){
            int dela = startIndex%11;
            
            NSString *firName= [firstName objectAtIndex:dela];
            
            catName =[NSString stringWithFormat:@"%@%@%@",firName,[secondWordName objectAtIndex:sencondIndex],[secondWordName objectAtIndex:thirdIndex]];
        }
        
        UTStudent *stu= [[UTStudent alloc]initWithStuName:catName andScore:239];
        [students addObject:stu];
    }
    
    return students;
}


//获取某个字符串或者汉字的首字母.
- (NSString *)firstCharactorWithString:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    if (pinYin.length == 0) {
        return @"#";
    }
    unichar c = [pinYin characterAtIndex:0];
    if (c <'A'|| c >'Z'){
        return @"#";
    }
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([[pinYin substringToIndex:1] rangeOfCharacterFromSet:notDigits].location == NSNotFound){
        // 是数字
        return @"#";
    }
    if ([[pinYin substringToIndex:1] isEqual:@"_"]) {
        return @"#";
    }
    return [pinYin substringToIndex:1];
}

#pragma mark - 通讯录排序
- (void)addressBookOrdering:(NSArray *)array{
    
    [self.sectionTitleArray removeAllObjects];
    [self.dataSource removeAllObjects];
    //赋初值 A~Z #
    for (int i = 65; i < 91; i ++) {
        char c = (char)i;
        NSMutableArray *array = [NSMutableArray array];
        NSString *key = [NSString stringWithFormat:@"%c",c];
        [self.dataSource setObject:array forKey:key];
    }
    
    [self.dataSource setObject:[NSMutableArray array] forKey:@"#"];
    
    //遍历联系人信息
    for (UTStudent *student in array) {
        //备注名
        NSString *name = [NSString stringWithFormat:@"%@",student.studentName];
        
        //获取首字母
        NSString *key = [self firstCharactorWithString:name];
        
        NSMutableArray *stuArray = self.dataSource[key];
        
        [stuArray addObject:student];
        
        //保存联系人信息
        [self.dataSource setObject:stuArray forKey:key];
    }
    //删除多余的(数目为0的索引)分类
    for (NSString *key in self.dataSource.allKeys) {
        NSArray *array = self.dataSource[key];
        if (array.count == 0) {
            [self.dataSource removeObjectForKey:key];
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dataSource valueForKey:self.sectionTitleArray[section]];
    
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 24)];
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%@",self.sectionTitleArray[section]];
    [view addSubview:label];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.frame = CGRectMake(11, 0, 100, 25);
    view.backgroundColor=[UIColor myColorWithHexString:@"#FFF7F7F7"];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableViewCell"];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    NSArray *array = [self.dataSource valueForKey:self.sectionTitleArray[indexPath.section]];
    UTStudent *student = array[indexPath.row];
    NSString *name =student.studentName;
//    cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld",student.dropScore];
    
    cell.textLabel.text=name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",student.dropScore];
    id image = student.thumbnailImageData;
    if ([image isKindOfClass:[UIImage class]]) {
        cell.imageView.image = image;
    } else{
        cell.imageView.image = [UIImage imageWithData:image];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [self.dataSource valueForKey:self.sectionTitleArray[indexPath.section]];
    UTStudent *stu = array[indexPath.row];
    if (_isMultiMode) {
        stu.selectMode=1;
//        [cell setStudentModel:stu];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationMiddle];
    }else{
        [self gotoAwardVCWithStuList:[NSArray arrayWithObjects:stu, nil]];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.dataSource valueForKey:self.sectionTitleArray[indexPath.section]];
    UTStudent *stu = array[indexPath.row];
    if (_isMultiMode) {
        stu.selectMode=2;
        //        [cell setStudentModel:stu];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationMiddle];
    }else{
        [self gotoAwardVCWithStuList:[NSArray arrayWithObjects:stu, nil]];
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitleArray;
}

#pragma mark - Getter/Setter
- (void)setStudentList:(NSArray *)arrayWithTableV{
    _studentList = arrayWithTableV;
}
- (void)setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
}
- (NSMutableArray *)sectionTitleArray {
    _sectionTitleArray = [[self.dataSource allKeys] mutableCopy];
    
    //    for (int i = 0; i < _sectionTitleArray.count; i++) {
    //        for (long j = _sectionTitleArray.count - 1; j > i; j--) {
    //
    //            if (_sectionTitleArray[i] > _sectionTitleArray[j]) {
    //                NSString *temp = _sectionTitleArray[i];
    //                [_sectionTitleArray replaceObjectAtIndex:i withObject:_sectionTitleArray[j]];
    //                [_sectionTitleArray replaceObjectAtIndex:j withObject:temp];
    //            }
    //        }
    //    }
    //

    if (_sectionTitleArray.count<=0) {
        return nil;
    }
    NSString *current = @"";
    for (int index = 0; index<_sectionTitleArray.count-1; index++) {
        current = _sectionTitleArray[index+1];
        int preIndex = index ;
        while (preIndex>=0&&current<_sectionTitleArray[preIndex]) {
            [_sectionTitleArray replaceObjectAtIndex:(preIndex+1) withObject:_sectionTitleArray[preIndex]];
            preIndex--;
        }
        
        [_sectionTitleArray replaceObjectAtIndex:(preIndex+1) withObject:current];
    }
    
    
    [_sectionTitleArray removeObject:@"#"];
    [_sectionTitleArray addObject:@"#"];
    
//    for (int index = 0; index<_sectionTitleArray.count; index++) {
//        NSLog(@"sectionTitleArray i=%d,%@ ",index+65,[_sectionTitleArray objectAtIndex:index]);
//        
//    }
    
    return _sectionTitleArray;
}

-(CGFloat)getAwardBtnYcoord
{
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    

    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    //titleview height 30 自身高度54
    CGFloat height =ScreenHeight - statusRect.size.height - navRect.size.height - 30 -54 -tabBarHeight ;

    NSLog(@"getAwardBtnYcoord = %f",height);
    
    return height;
    
}

@end
