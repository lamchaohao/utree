//
//  MedalProgressView.m
//  utree
//
//  Created by 科研部 on 2019/10/11.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "MedalProgressView.h"

@implementation MedalProgressView

- (instancetype)initWithFrame:(CGRect)frame andProgress:(CGFloat)progress
{
    self = [super initWithFrame:frame];
    if (progress>1) {
        progress/=100;
    }
    self.progress = progress;
    if (self) {
        [self createCustomView];
    }
    return self;
}

-(void)createCustomView
{
    
    CGRect parentFrame = self.frame;

    self.totalProgressView = [[UIView alloc]init];
    self.totalProgressView.frame = CGRectMake(0, 0, parentFrame.size.width, 10);
    self.totalProgressView.backgroundColor = [UIColor myColorWithHexString:@"#E6EBF0"];
    
    self.progressView = [[UIView alloc]init];
    self.progressView.frame = CGRectMake(0, 0, parentFrame.size.width*self.progress, 8);
    self.progressView.backgroundColor = [UIColor myColorWithHexString:@"#FFA150"];
    
    self.totalProgressView.layer.cornerRadius = 4.5;
    self.progressView.layer.cornerRadius = 4.5;
    
    self.bottomLabel = [UILabel new];
    self.bottomLabel.font = [UIFont systemFontOfSize:10];
    self.bottomLabel.textColor = [UIColor whiteColor];
    [self.bottomLabel setText:@"20/20"];
    [self.bottomLabel sizeToFit];
    self.bottomLabel.topPos.equalTo(self.totalProgressView.bottomPos).offset(6);
    self.bottomLabel.myCenterX=0;
    
    [self addSubview:_totalProgressView];
    [self addSubview:_progressView];
    [self addSubview:_bottomLabel];
}

- (void)setProgressForView:(CGFloat)progress
{
    if (progress>1) {
        progress/=100;
    }
    self.progress = progress;
    self.progressView.frame = CGRectMake(0, 40, self.frame.size.width*self.progress, 10);
    int currentPrgs = (int)20*progress;
    [self.bottomLabel setText: [NSString stringWithFormat:@"%d/20",currentPrgs]];

}

@end
