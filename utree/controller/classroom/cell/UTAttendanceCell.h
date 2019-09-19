//
//  UTAttendanceCell.h
//  utree
//
//  Created by 科研部 on 2019/9/18.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBPaddingLabel.h"
#import "UTStudent.h"
NS_ASSUME_NONNULL_BEGIN

@interface UTAttendanceCell : UICollectionViewCell
@property(strong,atomic)UIImageView *headView;
@property(strong,atomic)UILabel *nameLabel;
@property(strong,atomic)UILabel *attendanceStatuLabel;
//@property(nonatomic,strong)NSString *studentName;

//@property(nonatomic,strong)NSData *thumbnailImageData;

//@property(nonatomic,assign)NSInteger dropScore;


@property (nonatomic, strong) UTStudent *studentModel;
@property (nonatomic, strong) UIImageView *selectedModeImg;
@end

NS_ASSUME_NONNULL_END
