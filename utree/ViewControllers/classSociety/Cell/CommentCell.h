//
//  CommentCell.h
//  utree
//
//  Created by 科研部 on 2019/11/21.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentCellViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

@property(nonatomic,strong)UILabel *commentLabel;

@property(nonatomic,strong)UILabel *writerLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIImageView *headView;

@property(nonatomic,strong)CommentCellViewModel *viewModel;

-(void)setCellViewModel:(CommentCellViewModel *)viewModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withViewModel:(CommentCellViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
