//
//  UTAudioButton.h
//  utree
//
//  Created by 科研部 on 2019/12/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UTAudioButton : UIButton

//audio
@property (nonatomic, retain) UIView *voiceBackView;
@property (nonatomic, retain) UILabel *second;
@property (nonatomic, retain) UIImageView *voice;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;//小菊花


- (void)benginLoadVoice;

- (void)didLoadVoice;

-(void)stopPlay;

@end

NS_ASSUME_NONNULL_END
