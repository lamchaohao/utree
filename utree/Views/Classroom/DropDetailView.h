//
//  DropDetailView.h
//  utree
//
//  Created by 科研部 on 2019/11/6.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropLevelProgressView.h"
#import "DropDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol DropDetailViewResponser <NSObject>

-(void)onCloseButtonPress;

-(void)onChangeDate:(NSInteger)index;

-(void)loadMoreRecords;

@end

@interface DropDetailView : UIView

@property(nonatomic,strong)DropDetailViewModel *viewModel;

@property(nonatomic,strong)DropLevelProgressView *uiProgress;

@property(nonatomic,assign)id<DropDetailViewResponser> responser;

-(void)bindWithViewModel:(DropDetailViewModel *)viewModel;

-(void)refreshDropRecord;

-(void)onLoadFinish;

@end

NS_ASSUME_NONNULL_END
