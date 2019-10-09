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
    
    self.headImgURL = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2997599414,2721860663&fm=26&gp=0.jpg";
    
    return self;
}

-(void)changeSelectMode
{
    if (_selectMode==1) {
        _selectMode=2;
    }else if(_selectMode==2){
        _selectMode=1;
    }
}
-(void)cancleSelectMode
{
    _selectMode=0;
}
-(void)setBeSelected
{
    _selectMode = 2;
}
@end
