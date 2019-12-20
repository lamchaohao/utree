//
//  ClassViewModel.h
//  utree
//
//  Created by 科研部 on 2019/10/25.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UTClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ClassViewModelDelegate <NSObject>

-(void)onClassListLoadCompeleted:(NSArray<UTClassModel *> *)classModels;

@end

@interface ClassViewModel : NSObject

@property(nonatomic,strong)NSArray<UTClassModel *> *classModel;

@property(nonatomic,assign) id<ClassViewModelDelegate> viewModelDelegate;

-(void)fetchClassListData;

-(void)selectedClass:(NSString *)clazzId className:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
