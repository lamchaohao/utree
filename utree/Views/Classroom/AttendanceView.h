//
//  AttendanceView.h
//  utree
//
//  Created by 科研部 on 2019/10/31.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "AttendanceViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceView : MyLinearLayout

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)AttendanceViewModel *viewModel;

-(void)bindWithViewModel:(AttendanceViewModel *)viewModel;


@end

NS_ASSUME_NONNULL_END
