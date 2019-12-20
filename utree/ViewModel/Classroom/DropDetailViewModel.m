//
//  DropDetailViewModel.m
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DropDetailViewModel.h"

@implementation DropDetailViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dropRecordList = [[NSMutableArray alloc]init];
        self.dateTitleList =[[NSMutableArray alloc]init];
    }
    return self;
}

-(CGFloat)progress
{
    return self.wrapTreeModel.tree.dropNow.floatValue/self.wrapTreeModel.thisMax.floatValue;
}

-(NSString *)currentLevelStr
{
    return [NSString stringWithFormat:@"%d/%d",self.wrapTreeModel.tree.treeLevel.intValue,self.wrapTreeModel.levelMax.intValue];
}

- (void)addDropRecords:(NSArray *)records
{
    [self.dropRecordList addObjectsFromArray:records];
}

@end
