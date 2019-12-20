//
//  ClassViewModel.m
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "ClassViewModel.h"
#import "TeachClassApi.h"
#import "UTCache.h"
@implementation ClassViewModel

-(void)fetchClassListData
{
    TeachClassApi *api = [[TeachClassApi alloc]init];
    [api startWithValidateBlock:^(SuccessMsg * _Nonnull successMsg) {
        NSArray *classArray = [UTClassModel mj_objectArrayWithKeyValuesArray:successMsg.responseData];
        for (UTClassModel *clazz in classArray) {
            //如果班级id与选中的id一致
            if([clazz.classId isEqualToString:[UTCache readClassId]])
            {
                [clazz setIsSelected:YES];
                break;
            }
        }
        self.classModel =classArray;
        [self.viewModelDelegate onClassListLoadCompeleted:classArray];
    } onFailure:^(FailureMsg * _Nonnull message) {
        [self.viewModelDelegate onClassListLoadCompeleted:nil];
//        self.viewModelDelegate
    }];
    
}


-(void)selectedClass:(NSString *)clazzId className:(NSString *)className
{
    for (UTClassModel *clazz in self.classModel) {
        clazz.isSelected=NO;
    }
    if(![[UTCache readClassId] isEqualToString:clazzId]){
        [UTCache saveClassId:clazzId className:className];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ClazzChangedNotifycationName object:nil];
    }
    
}

@end
