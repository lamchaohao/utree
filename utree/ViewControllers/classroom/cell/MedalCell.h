//
//  MedalCell.h
//  utree
//
//  Created by 科研部 on 2019/10/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedalProgressView.h"
NS_ASSUME_NONNULL_BEGIN

@interface MedalCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *medalImgView;
@property(nonatomic,strong)MedalProgressView *medalProgressView;
@property(nonatomic,strong)UIImageView *medalMaskView;

-(void)setDataToviewWithMedalImagePath:(NSString *)medalPath progress:(CGFloat)prg needMask:(BOOL)mask;
@end

NS_ASSUME_NONNULL_END
