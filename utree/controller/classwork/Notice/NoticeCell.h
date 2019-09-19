//
//  NoticeCellTableViewCell.h
//  utree
//
//  Created by 科研部 on 2019/8/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"
#import "NoticeViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)UILabel *posterLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *detailLabel;
@property (nonatomic, strong) PYPhotosView *photosView;

@property(nonatomic,strong)NoticeViewModel *noticeViewModel;


@end

NS_ASSUME_NONNULL_END
