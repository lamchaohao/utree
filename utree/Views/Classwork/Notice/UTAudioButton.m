//
//  UTAudioButton.m
//  utree
//
//  Created by 科研部 on 2019/12/30.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "UTAudioButton.h"

@implementation UTAudioButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"bg_audio_record"] forState:UIControlStateNormal];
//        [self setTitle:@"语音'" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor myColorWithHexString:@"#028CC3"] forState:UIControlStateNormal];
        //语音
        self.voiceBackView = [[UIView alloc]init];
        [self addSubview:self.voiceBackView];
        self.second = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 80, 30)];
        self.second.textAlignment = NSTextAlignmentCenter;
        [self.second setText:@"语音"];
        self.second.font = [UIFont systemFontOfSize:14];
        self.voice = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 14, 18)];
        self.voice.image = [UIImage imageNamed:@"chat_voice_other_three"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"chat_voice_other_one"],
                                      [UIImage imageNamed:@"chat_voice_other_two"],
                                      [UIImage imageNamed:@"chat_voice_other_three"],nil];
        self.voice.animationDuration = 1;
        self.voice.animationRepeatCount = 0;
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicator.center=CGPointMake(40, 15);
        [self.voiceBackView addSubview:self.indicator];
        [self.voiceBackView addSubview:self.voice];
        [self.voiceBackView addSubview:self.second];
        
        self.voiceBackView.userInteractionEnabled = NO;
        self.second.userInteractionEnabled = NO;
        self.voice.userInteractionEnabled = NO;
        
        self.second.backgroundColor = [UIColor clearColor];
        self.voice.backgroundColor = [UIColor clearColor];
        self.voiceBackView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)benginLoadVoice
{
    self.voice.hidden = YES;
    [self.indicator startAnimating];
}
- (void)didLoadVoice
{
    self.voice.hidden = NO;
    [self.indicator stopAnimating];
    [self.voice startAnimating];
}
-(void)stopPlay
{
//    if(self.voice.isAnimating){
        [self.voice stopAnimating];
//    }
}

- (void)setIsMyMessage:(BOOL)isMyMessage
{
       self.second.frame = CGRectMake(20, 0, 50, 30);
       self.voice.frame = CGRectMake(0, 5, 14, 18);
       self.voice.image = [UIImage imageNamed:@"chat_voice_other_three"];
       self.voice.animationImages = [NSArray arrayWithObjects:
       [UIImage imageNamed:@"chat_voice_other_one"],
       [UIImage imageNamed:@"chat_voice_other_two"],
       [UIImage imageNamed:@"chat_voice_other_three"],nil];
       self.voiceBackView.frame = CGRectMake(25, 10, 130, 35);
       
}
//添加
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.titleLabel.text;
}
@end
