//
//  MomentDetailVC.h
//  utree
//
//  Created by 科研部 on 2019/11/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "BaseSecondVC.h"
#import "MomentViewModel.h"
#import <ZFPlayer/ZFPlayer.h>
NS_ASSUME_NONNULL_BEGIN

@protocol SchollCircleDetailDelegate <NSObject>

-(void)deleteMoment:(MomentModel *)moment;

@end

@interface MomentDetailVC : BaseSecondVC


@property(nonatomic,strong)MomentViewModel *momentViewModel;

@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, copy) void(^detailVCPopCallback)(void);

@property (nonatomic, copy) void(^detailVCPlayCallback)(void);

- (instancetype)initWithViewModel:(MomentViewModel *)viewModel;

@property(nonatomic,assign)id<SchollCircleDetailDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
