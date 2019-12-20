//
//  UTClassModel.h
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UTClassModel : NSObject
@property (strong, nonatomic) NSString *classId;

@property(nonatomic,strong) NSNumber *classGrade;

@property(nonatomic,strong) NSNumber *classCode;

@property (strong, nonatomic) NSString *className;

@property (strong, nonatomic) NSString *subjectId;

@property (strong, nonatomic) NSString *subject;

@property (assign, nonatomic) NSNumber *studentCount;

@property (assign, nonatomic) NSNumber *dropCount;

@property (assign, nonatomic) NSNumber *headTeacher;

@property (assign, nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
