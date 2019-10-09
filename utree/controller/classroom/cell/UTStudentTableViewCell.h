//
//  UTStudentTableViewCell.h
//  utree
//
//  Created by 科研部 on 2019/9/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBPaddingLabel.h"
#import "UTStudent.h"

NS_ASSUME_NONNULL_BEGIN

@interface UTStudentTableViewCell : UITableViewCell
@property(strong,atomic)ZBPaddingLabel *scoreLabel;
@property (nonatomic, strong) UTStudent *studentModel;

@end

NS_ASSUME_NONNULL_END
