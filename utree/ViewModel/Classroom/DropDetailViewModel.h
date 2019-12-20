//
//  DropDetailViewModel.h
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StuTreeModel.h"
#import "StuMedalModel.h"
#import "WrapDropRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DropDetailViewModel : NSObject

@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,strong)NSString *currentLevelStr;//当前级别

@property(nonatomic,strong)StuTreeModel *wrapTreeModel;

@property(nonatomic,strong)NSArray<StuMedalModel *> *medalData;

@property(nonatomic,strong)WrapDropRecordModel *wrapDropRecordModel;

@property(nonatomic,strong)NSMutableArray<NSMutableArray<StuDropRecordModel *> *> *dropRecordList;

@property(nonatomic,strong)NSMutableArray<NSString *> *dateTitleList;

-(void)addDropRecords:(NSArray *)records;

@end

NS_ASSUME_NONNULL_END
