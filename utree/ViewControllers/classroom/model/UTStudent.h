//
//  UTStudent.h
//  utree
//
//  Created by 科研部 on 2019/8/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileObject.h"
#import "UTClassModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UTStudent : NSObject

@property(nonatomic,strong)NSString *studentId;

@property(nonatomic,strong)NSNumber *gender;

@property(nonatomic,strong)NSString *birthDay;

@property(nonatomic,strong)NSString *studentName;

@property(nonatomic,assign)NSInteger dropRecord;

@property(nonatomic,strong)FileObject *fileDo;

@property(nonatomic,assign)NSInteger selectMode;//0单选模式(hide)，1,选中,2,未选中

@property(nonatomic,assign)NSInteger attendanceMode;//0出勤。1迟到。2早退。3请假

@property(nonatomic,strong)NSNumber *studentStatus; //0在校，1毕业，2休学，3退学

@property(nonatomic,strong)UTClassModel *classDo;

- (instancetype)initWithStuName:(NSString *)stuName andScore:(NSInteger)score;

-(void)changeSelectMode;
-(void)cancleSelectMode;
-(void)setBeSelected;
@end



NS_ASSUME_NONNULL_END
