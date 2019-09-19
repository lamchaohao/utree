//
//  ListStudentVC.m
//  utree
//
//  Created by 科研部 on 2019/8/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ListStudentVC.h"
#import "UTStudent.h"
#import "UIColor+ColorChange.h"
@interface ListStudentVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ListStudentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.sectionIndexColor = [UIColor myColorWithHexString:@"#FF676767"];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    [self.view addSubview:_tableView];
    self.dataSource = [[NSMutableDictionary alloc]init];

    self.arrayWithTableV = [self getStudentList];
    
    [self addressBookOrdering:self.arrayWithTableV];
}


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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *array = [self.dataSource valueForKey:self.sectionTitleArray[indexPath.section]];
    UTStudent *student = array[indexPath.row];
    NSString *name =student.studentName;
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    name = [name stringByTrimmingCharactersInSet:set];
    
    cell.textLabel.text=name;
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
    UTStudent *student = array[indexPath.row];
//    NSString *name = dic[@"name"];
//    NSArray *phones = dic[@"phones"];
    NSLog(@"备注:%@,scroe:%ld",student.studentName,student.dropScore);

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitleArray;
}

#pragma mark - Getter/Setter
- (void)setArrayWithTableV:(NSArray *)arrayWithTableV{
    _arrayWithTableV = arrayWithTableV;
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
    
//    for (int index=0; index<_sectionTitleArray.count; index++) {
//        int minIndex = index;
//    
//        for (int insideIndex = index; insideIndex<_sectionTitleArray.count; insideIndex++) {
//            if (_sectionTitleArray[insideIndex]<_sectionTitleArray[minIndex]) {
//                minIndex = insideIndex;
//            }
//        }
//        NSString *temp = _sectionTitleArray[minIndex];
//        [_sectionTitleArray replaceObjectAtIndex:minIndex withObject:_sectionTitleArray[index]];
//        [_sectionTitleArray replaceObjectAtIndex:index withObject:temp];
//
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
    
    for (int index = 0; index<_sectionTitleArray.count; index++) {
        NSLog(@"sectionTitleArray i=%d,%@ ",index+65,[_sectionTitleArray objectAtIndex:index]);

    }
   
    return _sectionTitleArray;
}


@end
