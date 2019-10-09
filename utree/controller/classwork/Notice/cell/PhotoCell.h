//
//  PhotoCell.h
//  utree
//
//  Created by 科研部 on 2019/9/29.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DeletePicDelegate <NSObject>
- (void)deletedPhoto:(UIImage *)image;
@end

@interface PhotoCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *mainImageView;
@property(nonatomic,weak) id<DeletePicDelegate>delegate;


@end



NS_ASSUME_NONNULL_END
