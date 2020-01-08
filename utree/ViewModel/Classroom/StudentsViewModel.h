//
//  StudentsViewModel.h
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTStudent.h"
NS_ASSUME_NONNULL_BEGIN

@protocol StudentViewModelDelegate <NSObject>
//YES 为网格,no为列表
-(BOOL)changeCollectionView;

-(void)showAwardStudentButton:(BOOL)visible;

-(void)reloadDataToView;

-(void)endRefreshing;

@end

@interface StudentsViewModel : NSObject

@property(nonatomic,strong)NSMutableArray<UTStudent *> *studentsModel;

/** 首字母数组 <NSString>*/
@property (nonatomic, strong) NSMutableArray  *sectionTitleArray;

@property (nonatomic, strong) NSMutableArray  *sortStudentList;

@property (nonatomic, strong) NSMutableArray  *selectedStudentList;

@property(nonatomic,strong)NSString *defaultMsg;

@property(nonatomic,assign) id<StudentViewModelDelegate> viewModelDelegate;

@property(nonatomic,assign)BOOL isMultiMode;

-(void)setData:(NSArray*)students;
//YES--Gridview
-(BOOL)switchToGridView;

-(void)switchToMultiChoice;

-(void)endRefreshing;

-(void)sortStudentsWithType:(int)type;

@property(nonatomic,assign)id<StudentViewModelDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
