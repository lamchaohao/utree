//
//  DropLevelProgressView.m
//  utree
//
//  Created by 科研部 on 2019/9/20.
//  Copyright © 2019 科研部. All rights reserved.
//

#import "DropLevelProgressView.h"

@implementation DropLevelProgressView

- (instancetype)initWithFrame:(CGRect)frame andProgress:(CGFloat)progress
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCustomViewandProgress:progress];
        
    }
    return self;
    
}

-(void)createCustomViewandProgress:(CGFloat)progress
{
    if (progress>1) {
        progress/=100;
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 18)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text=@"本学期任务进度：";
    
    
    CGRect parentFrame = self.frame;
    UIView *mainProgress = [[UIView alloc]init];
    mainProgress.frame = CGRectMake(0, 40, parentFrame.size.width, 10);
    mainProgress.backgroundColor = [UIColor myColorWithHexString:@"#ADECED"];
    
    UIView *progressView = [[UIView alloc]init];
    progressView.frame = CGRectMake(0, 40, parentFrame.size.width*progress, 10);
    progressView.backgroundColor = [UIColor myColorWithHexString:@"#3CB3EE"];
    
    mainProgress.layer.cornerRadius = 4.5;
    progressView.layer.cornerRadius = 4.5;
    
    [self addSubview:titleLabel];
    [self addSubview:mainProgress];
    [self addSubview:progressView];
    
    UIImageView *indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pb_drop_indicator"]];
    indicatorView.frame=CGRectMake(parentFrame.size.width*progress-5, 37, 12, 14);
    
    UILabel *currentScoreLabel = [[UILabel alloc]init];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pb_drop_score_rect"]];
    [currentScoreLabel setBackgroundColor:color];
    int progressInt = (int)100*progress/2; //总进度200
    [currentScoreLabel setText:[NSString stringWithFormat:@"%d",progressInt]];
    currentScoreLabel.frame=CGRectMake(parentFrame.size.width*progress-9, 20, 20, 17);
    currentScoreLabel.textAlignment = NSTextAlignmentCenter;
    currentScoreLabel.textColor = [UIColor whiteColor];
    currentScoreLabel.font = [UIFont systemFontOfSize:9];
    
    [self addSubview:indicatorView];
    [self addSubview:currentScoreLabel];
    
    
    for (int progs=0; progs<=200; progs+=40) {
        UILabel *startPoint=[[UILabel alloc]init];
        
        startPoint.frame = CGRectMake(parentFrame.size.width*progs/100/2, parentFrame.size.height-2, 12, 12);
        if (progs==200) {
            startPoint.frame=CGRectMake(parentFrame.size.width*progs/100/2-12, parentFrame.size.height-2, 12, 12);
        }
        startPoint.textColor= [UIColor whiteColor];
        startPoint.font =[UIFont systemFontOfSize:12];
        [startPoint setText:[NSString stringWithFormat:@"%d",progs]];
        [startPoint sizeToFit];
        [self addSubview:startPoint];
    }

}

@end
