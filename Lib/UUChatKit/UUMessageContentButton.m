//
//  UUMessageContentButton.m
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUMessageContentButton.h"
#import "UUChatCategory.h"

@implementation UUMessageContentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        self.backImageView = [[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.layer.cornerRadius = 5;
        self.backImageView.layer.masksToBounds  = YES;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.backImageView];
        
        //语音
        self.voiceBackView = [[UIView alloc]init];
        [self addSubview:self.voiceBackView];
        self.second = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        self.second.textAlignment = NSTextAlignmentCenter;
        self.second.font = [UIFont systemFontOfSize:14];
        self.voice = [[UIImageView alloc]initWithFrame:CGRectMake(80, 5, 14, 18)];
        self.voice.image = [UIImage uu_imageWithName:@"chat_voice_me_three"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage uu_imageWithName:@"chat_voice_me_one"],
                                      [UIImage uu_imageWithName:@"chat_voice_me_two"],
                                      [UIImage uu_imageWithName:@"chat_voice_me_three"],nil];
        self.voice.animationDuration = 1;
        self.voice.animationRepeatCount = 0;
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicator.center=CGPointMake(80, 15);
        [self.voiceBackView addSubview:self.indicator];
        [self.voiceBackView addSubview:self.voice];
        [self.voiceBackView addSubview:self.second];
        
        self.backImageView.userInteractionEnabled = NO;
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
    _isMyMessage = isMyMessage;
    if (isMyMessage) {
        self.second.frame = CGRectMake(0, 0, 80, 30);
        self.voice.frame= CGRectMake(80, 5, 14, 18);
        self.voice.image = [UIImage uu_imageWithName:@"chat_voice_me_three"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                       [UIImage uu_imageWithName:@"chat_voice_me_one"],
                                       [UIImage uu_imageWithName:@"chat_voice_me_two"],
                                       [UIImage uu_imageWithName:@"chat_voice_me_three"],nil];
        self.backImageView.frame = CGRectMake(5, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(15, 10, 130, 35);
    }else{
        self.second.frame = CGRectMake(20, 0, 50, 30);
        self.voice.frame = CGRectMake(0, 5, 14, 18);
        self.voice.image = [UIImage uu_imageWithName:@"chat_voice_other_three"];
        self.voice.animationImages = [NSArray arrayWithObjects:
        [UIImage uu_imageWithName:@"chat_voice_other_one"],
        [UIImage uu_imageWithName:@"chat_voice_other_two"],
        [UIImage uu_imageWithName:@"chat_voice_other_three"],nil];
        self.backImageView.frame = CGRectMake(15, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(25, 10, 130, 35);
        
    }
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
