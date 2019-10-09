//
//  UTStudent.h
//  utree
//
//  Created by 科研部 on 2019/8/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UTStudent : NSObject

@property(nonatomic,strong)NSString *studentName;

@property(nonatomic,strong)NSString *headImgURL;

@property(nonatomic,assign)NSInteger dropScore;

@property(nonatomic,assign)NSInteger selectMode;//0单选模式(hide)，1,选中,2,未选中

@property(nonatomic,assign)NSInteger attendanceMode;//0出勤。1迟到。2早退。3请假

- (instancetype)initWithStuName:(NSString *)stuName andScore:(NSInteger)score;

-(void)changeSelectMode;
-(void)cancleSelectMode;
-(void)setBeSelected;
@end



NS_ASSUME_NONNULL_END
