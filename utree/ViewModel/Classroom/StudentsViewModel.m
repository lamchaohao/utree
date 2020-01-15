//
//  StudentsViewModel.m
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "StudentsViewModel.h"
#import "UTCache.h"
#import "TeachClassApi.h"
#import "UTClassModel.h"
#import "StudentListApi.h"
#import "ZBChineseToPinyin.h"

@implementation StudentsViewModel
{
    int _sortType;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultMsg=@"当前还未加入学校，请联系学校管理员";
        self.selectedStudentList= [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)setData:(NSArray *)students
{
    if (students) {
        self.studentsModel=[NSMutableArray arrayWithArray:students];
    }else{//nil
        self.studentsModel=[[NSMutableArray alloc]initWithCapacity:0];
    }
    
    [self sortStudentsWithType:_sortType];
}

-(void)sortStudentsWithType:(int)type
{
    _sortType = type;
    if (type>0) {
        [self.studentsModel sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            UTStudent *stu1 = obj1;
            UTStudent *stu2 = obj2;
            if (stu1.dropRecord < stu2.dropRecord) {
    
                return type==1?NSOrderedDescending:NSOrderedAscending;
            }else if (stu1.dropRecord == stu2.dropRecord){
                return NSOrderedSame;
            }else{
                return type==1?NSOrderedAscending:NSOrderedDescending;
            }
        }];
        [self.sectionTitleArray removeAllObjects];
        [self.sectionTitleArray addObject:@"#"];
        [self.sortStudentList removeAllObjects];
        [self.sortStudentList addObject:self.studentsModel];
        [self.delegate reloadDataToView];
    }else{
        self.sectionTitleArray = [ZBChineseToPinyin indexWithArray:self.studentsModel Key:@"studentName"];
        self.sortStudentList = [ZBChineseToPinyin sortObjectArray:self.studentsModel Key:@"studentName"];
        [self.studentsModel removeAllObjects];
        for (NSArray *section in self.sortStudentList) {
            [self.studentsModel addObjectsFromArray:section];
        }
        [self.delegate reloadDataToView];
    }
}

//YES 为网格,NO为列表
- (BOOL)switchToGridView
{
    return [self.delegate changeCollectionView];
}

- (void)switchToMultiChoice
{
    if (self.studentsModel.count<=0) {
        return;
    }
    _isMultiMode = !_isMultiMode;
    if(!_isMultiMode){
        //反选所有学生
        for (UTStudent *stu in _studentsModel) {
            [stu cancleSelectMode];
        }
        [self.delegate showAwardStudentButton:NO];
    }else{
        for (UTStudent *stu in _studentsModel) {
            [stu setBeSelected];
        }
        
       [self.delegate showAwardStudentButton:YES];
    }
}

-(void)endRefreshing
{
    [self.delegate endRefreshing];
}

- (void)afterAwardSuccess:(AwardModel *)model
{
    [self.delegate afterStudentAward:model];
}
@end
