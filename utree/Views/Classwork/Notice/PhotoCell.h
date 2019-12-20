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

-(void)deletedPhotoWithImage:(UIImage *)image index:(NSInteger)index;
@end

@interface PhotoCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *mainImageView;

@property(nonatomic,assign) id<DeletePicDelegate>delegate;

@property(nonatomic,assign)NSInteger imageIndex;

-(void)setImageData:(UIImage *)image index:(NSInteger)index;

@end



NS_ASSUME_NONNULL_END
