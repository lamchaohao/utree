//
//  MomentCell.h
//  utree
//
//  Created by 科研部 on 2019/8/28.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"
#import "MomentViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MomentCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *posterLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property (nonatomic, strong) PYPhotosView *photosView;

@property(nonatomic,strong)MomentViewModel *viewModel;


@end

NS_ASSUME_NONNULL_END
