//
//  ClassModel.h
//  utree
//
//  Created by 科研部 on 2019/8/27.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassModel : NSObject

@property (copy, nonatomic) NSString *className;
@property (copy, nonatomic) NSString *subject;
@property (assign, nonatomic) int studentCount;
@property (assign, nonatomic) int dropScore;
@property (copy, nonatomic) NSString *headTeacher;
@property (assign, nonatomic) BOOL isSelected;
- (instancetype)initWithClassName:(NSString *)className subject:(NSString *)subject studentCount:(int) studentCount dropCount:(int) dropCount;
@end

NS_ASSUME_NONNULL_END
