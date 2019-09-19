//
//  UTStudent.m
//  utree
//
//  Created by 科研部 on 2019/8/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTStudent.h"

@implementation UTStudent


- (instancetype)initWithStuName:(NSString *)stuName andScore:(NSInteger)score
{
    self.studentName=stuName;
    
    self.dropScore = score;
    
    self.thumbnailImageData = UIImagePNGRepresentation([UIImage imageNamed:@"head_boy"]);
    
    return self;
}


@end
